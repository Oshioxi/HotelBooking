package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.annotation.CurrentUser;
import com.hotelbooking.hotelbooking.model.Booking;
import com.hotelbooking.hotelbooking.model.User;
import com.hotelbooking.hotelbooking.service.BookingService;
import com.hotelbooking.hotelbooking.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user")
@CrossOrigin(origins = "*")
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private BookingService bookingService;

    @GetMapping("/me")
    public ResponseEntity<User> getCurrentUser(@CurrentUser Long userId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(userService.getUserById(userId));
    }

    @PutMapping("/profile")
    public ResponseEntity<User> updateProfile(@CurrentUser Long userId, @RequestBody User user) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(userService.updateUser(userId, user));
    }

    @GetMapping("/bookings")
    public ResponseEntity<List<Booking>> getMyBookings(@CurrentUser Long userId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(bookingService.getBookingsByUser(userId));
    }

    @GetMapping("/bookings/{id}")
    public ResponseEntity<Booking> getMyBooking(@PathVariable Long id, @CurrentUser Long userId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        Booking booking = bookingService.getBookingById(id);
        if (!booking.getUserId().equals(userId)) {
            return ResponseEntity.status(403).build();
        }
        return ResponseEntity.ok(booking);
    }

    @PutMapping("/bookings/{id}/cancel")
    public ResponseEntity<Booking> cancelMyBooking(@PathVariable Long id, @CurrentUser Long userId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(bookingService.cancelBooking(id, userId));
    }

    @PutMapping("/change-password")
    public ResponseEntity<Map<String, String>> changePassword(
            @CurrentUser Long userId,
            @RequestBody Map<String, String> request) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        String oldPassword = request.get("oldPassword");
        String newPassword = request.get("newPassword");
        userService.changePassword(userId, oldPassword, newPassword);
        return ResponseEntity.ok(Map.of("message", "Password changed successfully"));
    }
}

