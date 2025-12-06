package com.hotelbooking.hotelbooking.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtUtil {
    @Value("${jwt.secret:mySecretKeyForJWTTokenGenerationAndValidationShouldBeLongEnough}")
    private String secret;

    @Value("${jwt.expiration:86400000}")
    private Long expiration;

    private SecretKey getSigningKey() {
        try {
            if (secret == null || secret.isEmpty()) {
                throw new IllegalStateException("JWT secret is not configured");
            }
            // Ensure secret is at least 32 bytes for HS256
            byte[] keyBytes = secret.getBytes();
            if (keyBytes.length < 32) {
                // Pad or repeat the secret to meet minimum length requirement
                byte[] paddedKey = new byte[32];
                System.arraycopy(keyBytes, 0, paddedKey, 0, Math.min(keyBytes.length, 32));
                for (int i = keyBytes.length; i < 32; i++) {
                    paddedKey[i] = keyBytes[i % keyBytes.length];
                }
                return Keys.hmacShaKeyFor(paddedKey);
            }
            return Keys.hmacShaKeyFor(keyBytes);
        } catch (Exception e) {
            throw new IllegalStateException("Failed to create signing key: " + e.getMessage(), e);
        }
    }

    public String extractUsername(String token) {
        try {
            return extractClaim(token, Claims::getSubject);
        } catch (Exception e) {
            return null;
        }
    }

    public Date extractExpiration(String token) {
        try {
            return extractClaim(token, Claims::getExpiration);
        } catch (Exception e) {
            return null;
        }
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        try {
            final Claims claims = extractAllClaims(token);
            if (claims == null) {
                return null;
            }
            return claimsResolver.apply(claims);
        } catch (Exception e) {
            return null;
        }
    }

    private Claims extractAllClaims(String token) {
        try {
            if (token == null || token.isEmpty()) {
                return null;
            }
            return Jwts.parser()
                    .verifyWith(getSigningKey())
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (Exception e) {
            // Return null instead of throwing exception to allow graceful handling
            return null;
        }
    }

    private Boolean isTokenExpired(String token) {
        try {
            Date expiration = extractExpiration(token);
            if (expiration == null) {
                return true;
            }
            return expiration.before(new Date());
        } catch (Exception e) {
            return true;
        }
    }

    public String generateToken(String username, Long userId, String role, String email, String fullName) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", userId);
        claims.put("role", role);
        claims.put("email", email);
        claims.put("fullName", fullName);
        return createToken(claims, username);
    }

    private String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
                .claims(claims)
                .subject(subject)
                .issuedAt(new Date(System.currentTimeMillis()))
                .expiration(new Date(System.currentTimeMillis() + expiration))
                .signWith(getSigningKey())
                .compact();
    }

    public Boolean validateToken(String token, String username) {
        try {
            final String extractedUsername = extractUsername(token);
            if (extractedUsername == null) {
                return false;
            }
            return (extractedUsername.equals(username) && !isTokenExpired(token));
        } catch (Exception e) {
            return false;
        }
    }

    public Long extractUserId(String token) {
        try {
            return extractClaim(token, claims -> {
                Object userId = claims.get("userId");
                if (userId == null) return null;
                if (userId instanceof Integer) {
                    return ((Integer) userId).longValue();
                }
                if (userId instanceof Long) {
                    return (Long) userId;
                }
                return Long.valueOf(userId.toString());
            });
        } catch (Exception e) {
            return null;
        }
    }

    public String extractRole(String token) {
        try {
            return extractClaim(token, claims -> {
                Object role = claims.get("role");
                return role != null ? role.toString() : null;
            });
        } catch (Exception e) {
            return null;
        }
    }

    public String extractEmail(String token) {
        try {
            return extractClaim(token, claims -> {
                Object email = claims.get("email");
                return email != null ? email.toString() : null;
            });
        } catch (Exception e) {
            return null;
        }
    }

    public String extractFullName(String token) {
        try {
            return extractClaim(token, claims -> {
                Object fullName = claims.get("fullName");
                return fullName != null ? fullName.toString() : null;
            });
        } catch (Exception e) {
            return null;
        }
    }
}

