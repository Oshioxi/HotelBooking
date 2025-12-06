package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.model.Amenity;
import com.hotelbooking.hotelbooking.repository.AmenityRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/amenities")
@CrossOrigin(origins = "*")
public class AmenityController {
    
    @Autowired
    private AmenityRepository amenityRepository;
    
    @GetMapping
    public ResponseEntity<List<Amenity>> getAllAmenities() {
        return ResponseEntity.ok(amenityRepository.findAll());
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<Amenity> getAmenityById(@PathVariable Long id) {
        return amenityRepository.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
    
    @GetMapping("/category/{category}")
    public ResponseEntity<List<Amenity>> getAmenitiesByCategory(@PathVariable String category) {
        return ResponseEntity.ok(amenityRepository.findByCategory(category));
    }
}

