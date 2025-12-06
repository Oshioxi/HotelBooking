package com.hotelbooking.hotelbooking.util;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class TokenExtractor {

    @Autowired
    private JwtUtil jwtUtil;

    /**
     * Extract JWT token from Authorization header
     */
    public String extractTokenFromRequest(HttpServletRequest request) {
        final String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            return authHeader.substring(7);
        }
        return null;
    }

    /**
     * Extract userId from request token
     */
    public Long extractUserIdFromRequest(HttpServletRequest request) {
        String token = extractTokenFromRequest(request);
        if (token != null) {
            try {
                return jwtUtil.extractUserId(token);
            } catch (Exception e) {
                return null;
            }
        }
        return null;
    }

    /**
     * Extract username from request token
     */
    public String extractUsernameFromRequest(HttpServletRequest request) {
        String token = extractTokenFromRequest(request);
        if (token != null) {
            try {
                return jwtUtil.extractUsername(token);
            } catch (Exception e) {
                return null;
            }
        }
        return null;
    }

    /**
     * Extract role from request token
     */
    public String extractRoleFromRequest(HttpServletRequest request) {
        String token = extractTokenFromRequest(request);
        if (token != null) {
            try {
                return jwtUtil.extractRole(token);
            } catch (Exception e) {
                return null;
            }
        }
        return null;
    }
}

