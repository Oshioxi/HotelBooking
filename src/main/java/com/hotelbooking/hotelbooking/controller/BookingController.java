package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.annotation.CurrentUser;
import com.hotelbooking.hotelbooking.dto.BookingRequest;
import com.hotelbooking.hotelbooking.model.Booking;
import com.hotelbooking.hotelbooking.service.BookingService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bookings")
@CrossOrigin(origins = "*")
public class BookingController {
    @Autowired
    private BookingService bookingService;

    @GetMapping
    public ResponseEntity<List<Booking>> getAllBookings() {
        return ResponseEntity.ok(bookingService.getAllBookings());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Booking> getBookingById(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.getBookingById(id));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Booking>> getBookingsByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(bookingService.getBookingsByUser(userId));
    }

    @GetMapping("/room-type/{roomTypeId}")
    public ResponseEntity<List<Booking>> getBookingsByRoomType(@PathVariable Long roomTypeId) {
        return ResponseEntity.ok(bookingService.getBookingsByRoomType(roomTypeId));
    }

    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<List<Booking>> getBookingsByHotel(@PathVariable Long hotelId) {
        return ResponseEntity.ok(bookingService.getBookingsByHotel(hotelId));
    }

    @PostMapping
    public ResponseEntity<Booking> createBooking(
            @CurrentUser Long userId,
            @Valid @RequestBody BookingRequest request) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(bookingService.createBooking(userId, request));
    }

    @PutMapping("/{id}/cancel")
    public ResponseEntity<Booking> cancelBooking(
            @PathVariable Long id,
            @RequestParam Long userId) {
        return ResponseEntity.ok(bookingService.cancelBooking(id, userId));
    }

    @PutMapping("/{id}/confirm")
    public ResponseEntity<Booking> confirmBooking(@PathVariable Long id) {
        return ResponseEntity.ok(bookingService.confirmBooking(id));
    }
}

