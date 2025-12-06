package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.dto.HotelRequest;
import com.hotelbooking.hotelbooking.dto.HotelResponse;
import com.hotelbooking.hotelbooking.model.Hotel;
import com.hotelbooking.hotelbooking.service.HotelService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hotels")
@CrossOrigin(origins = "*")
public class HotelController {
    @Autowired
    private HotelService hotelService;

    @GetMapping
    public ResponseEntity<List<Hotel>> getAllHotels() {
        return ResponseEntity.ok(hotelService.getAllHotels());
    }
    
    @GetMapping("/with-owner")
    public ResponseEntity<List<HotelResponse>> getAllHotelsWithOwner() {
        return ResponseEntity.ok(hotelService.getAllHotelsWithOwner());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Hotel> getHotelById(@PathVariable Long id) {
        return ResponseEntity.ok(hotelService.getHotelById(id));
    }

    @GetMapping("/owner/{ownerId}")
    public ResponseEntity<List<Hotel>> getHotelsByOwner(@PathVariable Long ownerId) {
        return ResponseEntity.ok(hotelService.getHotelsByOwner(ownerId));
    }

    @GetMapping("/pending")
    public ResponseEntity<List<Hotel>> getPendingHotels() {
        return ResponseEntity.ok(hotelService.getPendingHotels());
    }

    @PostMapping
    public ResponseEntity<Hotel> createHotel(@Valid @RequestBody HotelRequest request) {
        return ResponseEntity.ok(hotelService.createHotel(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Hotel> updateHotel(@PathVariable Long id, @Valid @RequestBody HotelRequest request) {
        return ResponseEntity.ok(hotelService.updateHotel(id, request));
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<Hotel> approveHotel(@PathVariable Long id) {
        return ResponseEntity.ok(hotelService.approveHotel(id));
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<Hotel> rejectHotel(@PathVariable Long id, @RequestBody Map<String, String> request) {
        return ResponseEntity.ok(hotelService.rejectHotel(id, request.get("reason")));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteHotel(@PathVariable Long id) {
        hotelService.deleteHotel(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<Hotel>> searchHotels(@RequestParam(required = false) String city) {
        return ResponseEntity.ok(hotelService.searchHotels(city));
    }
    
    @GetMapping("/cities")
    public ResponseEntity<List<String>> getAvailableCities() {
        return ResponseEntity.ok(hotelService.getAvailableCities());
    }
}

