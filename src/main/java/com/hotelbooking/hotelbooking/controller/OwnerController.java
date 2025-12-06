package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.service.BookingService;
import com.hotelbooking.hotelbooking.service.StatisticsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/owner")
@CrossOrigin(origins = "*")
public class OwnerController {
    @Autowired
    private StatisticsService statisticsService;

    @Autowired
    private BookingService bookingService;

    @GetMapping("/statistics")
    public ResponseEntity<Map<String, Object>> getOwnerStats(@RequestParam Long ownerId) {
        return ResponseEntity.ok(statisticsService.getOwnerStats(ownerId));
    }

    @GetMapping("/calendar")
    public ResponseEntity<List<com.hotelbooking.hotelbooking.model.Booking>> getCalendar(
            @RequestParam Long ownerId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        List<com.hotelbooking.hotelbooking.model.Booking> bookings = bookingService.getBookingsByOwner(ownerId);
        // Filter by date range
        bookings = bookings.stream()
                .filter(b -> !b.getCheckOutDate().isBefore(startDate) && !b.getCheckInDate().isAfter(endDate))
                .toList();
        return ResponseEntity.ok(bookings);
    }
}

