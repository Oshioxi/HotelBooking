package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.dto.ForgotPasswordRequest;
import com.hotelbooking.hotelbooking.dto.LoginRequest;
import com.hotelbooking.hotelbooking.dto.RegisterRequest;
import com.hotelbooking.hotelbooking.dto.ResetPasswordRequest;
import com.hotelbooking.hotelbooking.service.AuthService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {
    @Autowired
    private AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@Valid @RequestBody LoginRequest request) {
        Map<String, Object> response = authService.login(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/register")
    public ResponseEntity<Map<String, Object>> register(@Valid @RequestBody RegisterRequest request) {
        Map<String, Object> response = authService.register(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<Map<String, Object>> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        authService.forgotPassword(request);
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Password reset email has been sent. Please check your email.");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/reset-password")
    public ResponseEntity<Map<String, Object>> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        authService.resetPassword(request);
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Password has been reset successfully. You can now login with your new password.");
        return ResponseEntity.ok(response);
    }

    @PostMapping("/google")
    public ResponseEntity<Map<String, Object>> googleLogin(@RequestBody Map<String, String> request) {
        String idToken = request.get("idToken");
        if (idToken == null || idToken.isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Google ID token is required");
            return ResponseEntity.badRequest().body(error);
        }
        
        Map<String, Object> response = authService.loginWithGoogle(idToken);
        return ResponseEntity.ok(response);
    }
}

