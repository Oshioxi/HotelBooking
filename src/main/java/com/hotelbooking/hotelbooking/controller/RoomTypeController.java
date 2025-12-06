package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.dto.RoomRequest;
import com.hotelbooking.hotelbooking.model.RoomType;
import com.hotelbooking.hotelbooking.service.RoomTypeService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/room-types")
@CrossOrigin(origins = "*")
public class RoomTypeController {
    @Autowired
    private RoomTypeService roomTypeService;

    @GetMapping
    public ResponseEntity<List<RoomType>> getAllRoomTypes() {
        return ResponseEntity.ok(roomTypeService.getAllRoomTypes());
    }

    @GetMapping("/{id}")
    public ResponseEntity<RoomType> getRoomTypeById(@PathVariable Long id) {
        return ResponseEntity.ok(roomTypeService.getRoomTypeById(id));
    }

    @GetMapping("/hotel/{hotelId}")
    public ResponseEntity<List<RoomType>> getRoomTypesByHotel(@PathVariable Long hotelId) {
        return ResponseEntity.ok(roomTypeService.getRoomTypesByHotel(hotelId));
    }

    @GetMapping("/pending")
    public ResponseEntity<List<RoomType>> getPendingRoomTypes() {
        return ResponseEntity.ok(roomTypeService.getPendingRoomTypes());
    }

    @PostMapping
    public ResponseEntity<RoomType> createRoomType(@Valid @RequestBody RoomRequest request) {
        return ResponseEntity.ok(roomTypeService.createRoomType(request));
    }

    @PutMapping("/{id}")
    public ResponseEntity<RoomType> updateRoomType(@PathVariable Long id, @Valid @RequestBody RoomRequest request) {
        return ResponseEntity.ok(roomTypeService.updateRoomType(id, request));
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<RoomType> approveRoomType(@PathVariable Long id) {
        return ResponseEntity.ok(roomTypeService.approveRoomType(id));
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<RoomType> rejectRoomType(@PathVariable Long id, @RequestBody Map<String, String> request) {
        return ResponseEntity.ok(roomTypeService.rejectRoomType(id, request.get("reason")));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteRoomType(@PathVariable Long id) {
        roomTypeService.deleteRoomType(id);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/search")
    public ResponseEntity<List<RoomType>> searchRoomTypes(
            @RequestParam(required = false) String city,
            @RequestParam(required = false) BigDecimal minPrice,
            @RequestParam(required = false) BigDecimal maxPrice,
            @RequestParam(required = false) Integer guests,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkInDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate checkOutDate,
            @RequestParam(required = false) List<String> amenities) {
        if (checkInDate != null && checkOutDate != null) {
            return ResponseEntity.ok(roomTypeService.searchRoomTypesWithDates(
                city, minPrice, maxPrice, guests, checkInDate, checkOutDate, amenities));
        } else {
            return ResponseEntity.ok(roomTypeService.searchRoomTypes(city, minPrice, maxPrice, guests));
        }
    }
}

