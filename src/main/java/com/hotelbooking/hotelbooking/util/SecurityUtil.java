package com.hotelbooking.hotelbooking.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class SecurityUtil {

    /**
     * Get current authenticated username from SecurityContext
     */
    public static String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getName();
        }
        return null;
    }

    /**
     * Check if user is authenticated
     */
    public static boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.isAuthenticated() 
            && !authentication.getName().equals("anonymousUser");
    }

    /**
     * Check if user has specific role
     */
    public static boolean hasRole(String role) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            return authentication.getAuthorities().stream()
                .anyMatch(authority -> authority.getAuthority().equals("ROLE_" + role));
        }
        return false;
    }

    /**
     * Check if user is admin
     */
    public static boolean isAdmin() {
        return hasRole("ADMIN");
    }

    /**
     * Check if user is hotel owner
     */
    public static boolean isHotelOwner() {
        return hasRole("HOTEL_OWNER");
    }

    /**
     * Check if user is regular user
     */
    public static boolean isUser() {
        return hasRole("USER");
    }
}

