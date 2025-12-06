package com.hotelbooking.hotelbooking.service;

import com.hotelbooking.hotelbooking.dto.ForgotPasswordRequest;
import com.hotelbooking.hotelbooking.dto.LoginRequest;
import com.hotelbooking.hotelbooking.dto.RegisterRequest;
import com.hotelbooking.hotelbooking.dto.ResetPasswordRequest;
import com.hotelbooking.hotelbooking.exception.BadRequestException;
import com.hotelbooking.hotelbooking.exception.ResourceNotFoundException;
import com.hotelbooking.hotelbooking.model.User;
import com.hotelbooking.hotelbooking.repository.UserRepository;
import com.hotelbooking.hotelbooking.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@Service
@Transactional
public class AuthService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private EmailService emailService;

    @Value("${google.client-id:}")
    private String googleClientId;

    public Map<String, Object> login(LoginRequest request) {
        User user = userRepository.findByUsername(request.getUsername())
                .orElseThrow(() -> new BadRequestException("Invalid username or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BadRequestException("Invalid username or password");
        }

        if (!user.getIsActive()) {
            throw new BadRequestException("Account is deactivated");
        }

        String token = jwtUtil.generateToken(
                user.getUsername(),
                user.getId(),
                user.getRole().name(),
                user.getEmail(),
                user.getFullName()
        );

        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("id", user.getId());
        response.put("username", user.getUsername());
        response.put("email", user.getEmail());
        response.put("fullName", user.getFullName());
        response.put("role", user.getRole().name());

        return response;
    }

    public Map<String, Object> register(RegisterRequest request) {
        if (userRepository.existsByUsername(request.getUsername())) {
            throw new BadRequestException("Username already exists");
        }

        if (userRepository.existsByEmail(request.getEmail())) {
            throw new BadRequestException("Email already exists");
        }

        User user = new User();
        user.setUsername(request.getUsername());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFullName(request.getFullName());
        user.setPhone(request.getPhone());
        user.setRole(request.getRole());

        user = userRepository.save(user);

        String token = jwtUtil.generateToken(
                user.getUsername(),
                user.getId(),
                user.getRole().name(),
                user.getEmail(),
                user.getFullName()
        );

        Map<String, Object> response = new HashMap<>();
        response.put("token", token);
        response.put("id", user.getId());
        response.put("username", user.getUsername());
        response.put("email", user.getEmail());
        response.put("fullName", user.getFullName());
        response.put("role", user.getRole().name());

        return response;
    }

    public void forgotPassword(ForgotPasswordRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResourceNotFoundException("Email not found"));

        if (!user.getIsActive()) {
            throw new BadRequestException("Account is deactivated");
        }

        // Generate reset token
        String resetToken = UUID.randomUUID().toString();
        LocalDateTime expiryTime = LocalDateTime.now().plusHours(1); // Token valid for 1 hour

        user.setResetToken(resetToken);
        user.setResetTokenExpiry(expiryTime);
        userRepository.save(user);

        // Send email with reset link
        emailService.sendPasswordResetEmail(user.getEmail(), resetToken, user.getFullName());
    }

    public void resetPassword(ResetPasswordRequest request) {
        User user = userRepository.findByResetToken(request.getToken())
                .orElseThrow(() -> new BadRequestException("Invalid or expired reset token"));

        // Check if token is expired
        if (user.getResetTokenExpiry() == null || user.getResetTokenExpiry().isBefore(LocalDateTime.now())) {
            // Clear expired token
            user.setResetToken(null);
            user.setResetTokenExpiry(null);
            userRepository.save(user);
            throw new BadRequestException("Reset token has expired. Please request a new one.");
        }

        // Update password
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setResetToken(null);
        user.setResetTokenExpiry(null);
        userRepository.save(user);
    }

    public Map<String, Object> loginWithGoogle(String idToken) {
        try {
            // Verify Google ID token and get user info
            RestTemplate restTemplate = new RestTemplate();
            String url = "https://oauth2.googleapis.com/tokeninfo?id_token=" + idToken;
            
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);
            
            if (!response.getStatusCode().is2xxSuccessful()) {
                throw new BadRequestException("Invalid Google ID token");
            }
            
            // Parse Google response
            Gson gson = new Gson();
            JsonObject googleUser = gson.fromJson(response.getBody(), JsonObject.class);
            
            // Verify audience (client ID)
            if (!googleClientId.isEmpty() && googleUser.has("aud")) {
                String aud = googleUser.get("aud").getAsString();
                if (!aud.equals(googleClientId)) {
                    throw new BadRequestException("Invalid Google client ID");
                }
            }
            
            // Extract user information
            String email = googleUser.get("email").getAsString();
            String name = googleUser.has("name") ? googleUser.get("name").getAsString() : email;
            String picture = googleUser.has("picture") ? googleUser.get("picture").getAsString() : null;
            String googleId = googleUser.get("sub").getAsString();
            
            // Check if user exists by email
            User user = userRepository.findByEmail(email).orElse(null);
            
            if (user == null) {
                // Create new user
                user = new User();
                user.setEmail(email);
                user.setFullName(name);
                // Generate username from email (before @)
                String username = email.substring(0, email.indexOf("@"));
                // Ensure username is unique
                String baseUsername = username;
                int counter = 1;
                while (userRepository.existsByUsername(username)) {
                    username = baseUsername + counter;
                    counter++;
                }
                user.setUsername(username);
                // Set a random password (user won't use it for Google login)
                user.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
                user.setRole(User.Role.USER);
                user.setIsActive(true);
                user = userRepository.save(user);
            } else {
                // User exists, check if account is active
                if (!user.getIsActive()) {
                    throw new BadRequestException("Account is deactivated");
                }
            }
            
            // Generate JWT token
            String token = jwtUtil.generateToken(
                    user.getUsername(),
                    user.getId(),
                    user.getRole().name(),
                    user.getEmail(),
                    user.getFullName()
            );
            
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put("token", token);
            responseMap.put("id", user.getId());
            responseMap.put("username", user.getUsername());
            responseMap.put("email", user.getEmail());
            responseMap.put("fullName", user.getFullName());
            responseMap.put("role", user.getRole().name());
            
            return responseMap;
            
        } catch (Exception e) {
            if (e instanceof BadRequestException) {
                throw e;
            }
            throw new BadRequestException("Failed to authenticate with Google: " + e.getMessage());
        }
    }
}

