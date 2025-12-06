package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.model.RoomTypeAmenity;
import com.hotelbooking.hotelbooking.repository.RoomTypeAmenityRepository;
import com.hotelbooking.hotelbooking.repository.AmenityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/room-types/{roomTypeId}/amenities")
@CrossOrigin(origins = "*")
public class RoomTypeAmenityController {
    
    @Autowired
    private RoomTypeAmenityRepository roomTypeAmenityRepository;
    
    @Autowired
    private AmenityRepository amenityRepository;
    
    @GetMapping
    public ResponseEntity<List<RoomTypeAmenity>> getRoomTypeAmenities(@PathVariable Long roomTypeId) {
        return ResponseEntity.ok(roomTypeAmenityRepository.findByRoomTypeId(roomTypeId));
    }
    
    @PostMapping
    public ResponseEntity<Map<String, Object>> addRoomTypeAmenity(
            @PathVariable Long roomTypeId,
            @RequestBody Map<String, Long> request) {
        
        Long amenityId = request.get("amenityId");
        
        if (amenityId == null) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Amenity ID is required");
            return ResponseEntity.badRequest().body(error);
        }
        
        // Check if amenity exists
        if (!amenityRepository.existsById(amenityId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Amenity not found");
            return ResponseEntity.badRequest().body(error);
        }
        
        // Check if already exists
        if (roomTypeAmenityRepository.existsByRoomTypeIdAndAmenityId(roomTypeId, amenityId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Amenity already added to this room type");
            return ResponseEntity.badRequest().body(error);
        }
        
        RoomTypeAmenity roomTypeAmenity = new RoomTypeAmenity();
        roomTypeAmenity.setRoomTypeId(roomTypeId);
        roomTypeAmenity.setAmenityId(amenityId);
        
        RoomTypeAmenity saved = roomTypeAmenityRepository.save(roomTypeAmenity);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", saved);
        
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> removeRoomTypeAmenity(
            @PathVariable Long roomTypeId,
            @PathVariable Long id) {
        
        RoomTypeAmenity roomTypeAmenity = roomTypeAmenityRepository.findById(id)
                .orElse(null);
        
        if (roomTypeAmenity == null || !roomTypeAmenity.getRoomTypeId().equals(roomTypeId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Room type amenity not found");
            return ResponseEntity.badRequest().body(error);
        }
        
        roomTypeAmenityRepository.deleteById(id);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Amenity removed successfully");
        
        return ResponseEntity.ok(response);
    }
}


