package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.model.HotelAmenity;
import com.hotelbooking.hotelbooking.repository.HotelAmenityRepository;
import com.hotelbooking.hotelbooking.repository.AmenityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hotels/{hotelId}/amenities")
@CrossOrigin(origins = "*")
public class HotelAmenityController {
    
    @Autowired
    private HotelAmenityRepository hotelAmenityRepository;
    
    @Autowired
    private AmenityRepository amenityRepository;
    
    @GetMapping
    public ResponseEntity<List<HotelAmenity>> getHotelAmenities(@PathVariable Long hotelId) {
        return ResponseEntity.ok(hotelAmenityRepository.findByHotelId(hotelId));
    }
    
    @PostMapping
    public ResponseEntity<Map<String, Object>> addHotelAmenity(
            @PathVariable Long hotelId,
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
        if (hotelAmenityRepository.existsByHotelIdAndAmenityId(hotelId, amenityId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Amenity already added to this hotel");
            return ResponseEntity.badRequest().body(error);
        }
        
        HotelAmenity hotelAmenity = new HotelAmenity();
        hotelAmenity.setHotelId(hotelId);
        hotelAmenity.setAmenityId(amenityId);
        
        HotelAmenity saved = hotelAmenityRepository.save(hotelAmenity);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", saved);
        
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> removeHotelAmenity(
            @PathVariable Long hotelId,
            @PathVariable Long id) {
        
        HotelAmenity hotelAmenity = hotelAmenityRepository.findById(id)
                .orElse(null);
        
        if (hotelAmenity == null || !hotelAmenity.getHotelId().equals(hotelId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Hotel amenity not found");
            return ResponseEntity.badRequest().body(error);
        }
        
        hotelAmenityRepository.deleteById(id);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Amenity removed successfully");
        
        return ResponseEntity.ok(response);
    }
}

