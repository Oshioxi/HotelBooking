package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.model.HotelImage;
import com.hotelbooking.hotelbooking.repository.HotelImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/hotels/{hotelId}/images")
@CrossOrigin(origins = "*")
public class HotelImageController {
    
    @Autowired
    private HotelImageRepository hotelImageRepository;
    
    @GetMapping
    public ResponseEntity<List<HotelImage>> getHotelImages(@PathVariable Long hotelId) {
        return ResponseEntity.ok(hotelImageRepository.findByHotelIdOrderByDisplayOrderAsc(hotelId));
    }
    
    @PostMapping
    public ResponseEntity<Map<String, Object>> addHotelImage(
            @PathVariable Long hotelId,
            @RequestBody Map<String, Object> request) {
        
        String imageUrl = (String) request.get("imageUrl");
        String altText = (String) request.get("altText");
        Boolean isPrimary = request.get("isPrimary") != null ? 
            Boolean.valueOf(request.get("isPrimary").toString()) : false;
        Integer displayOrder = request.get("displayOrder") != null ? 
            Integer.valueOf(request.get("displayOrder").toString()) : 0;
        
        if (imageUrl == null || imageUrl.trim().isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Image URL is required");
            return ResponseEntity.badRequest().body(error);
        }
        
        // If this is primary, unset other primary images
        if (isPrimary) {
            List<HotelImage> existingPrimary = hotelImageRepository.findByHotelIdOrderByDisplayOrderAsc(hotelId);
            existingPrimary.forEach(img -> {
                if (img.getIsPrimary()) {
                    img.setIsPrimary(false);
                    hotelImageRepository.save(img);
                }
            });
        }
        
        HotelImage hotelImage = new HotelImage();
        hotelImage.setHotelId(hotelId);
        hotelImage.setImageUrl(imageUrl);
        hotelImage.setAltText(altText);
        hotelImage.setIsPrimary(isPrimary);
        hotelImage.setDisplayOrder(displayOrder);
        
        HotelImage saved = hotelImageRepository.save(hotelImage);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", saved);
        
        return ResponseEntity.ok(response);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateHotelImage(
            @PathVariable Long hotelId,
            @PathVariable Long id,
            @RequestBody Map<String, Object> request) {
        
        HotelImage hotelImage = hotelImageRepository.findById(id)
                .orElse(null);
        
        if (hotelImage == null || !hotelImage.getHotelId().equals(hotelId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Hotel image not found");
            return ResponseEntity.badRequest().body(error);
        }
        
        if (request.containsKey("imageUrl")) {
            hotelImage.setImageUrl((String) request.get("imageUrl"));
        }
        if (request.containsKey("altText")) {
            hotelImage.setAltText((String) request.get("altText"));
        }
        if (request.containsKey("isPrimary")) {
            Boolean isPrimary = Boolean.valueOf(request.get("isPrimary").toString());
            // If setting as primary, unset other primary images
            if (isPrimary) {
                List<HotelImage> existingPrimary = hotelImageRepository.findByHotelIdOrderByDisplayOrderAsc(hotelId);
                existingPrimary.forEach(img -> {
                    if (!img.getId().equals(id) && img.getIsPrimary()) {
                        img.setIsPrimary(false);
                        hotelImageRepository.save(img);
                    }
                });
            }
            hotelImage.setIsPrimary(isPrimary);
        }
        if (request.containsKey("displayOrder")) {
            hotelImage.setDisplayOrder(Integer.valueOf(request.get("displayOrder").toString()));
        }
        
        HotelImage saved = hotelImageRepository.save(hotelImage);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", saved);
        
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteHotelImage(
            @PathVariable Long hotelId,
            @PathVariable Long id) {
        
        HotelImage hotelImage = hotelImageRepository.findById(id)
                .orElse(null);
        
        if (hotelImage == null || !hotelImage.getHotelId().equals(hotelId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Hotel image not found");
            return ResponseEntity.badRequest().body(error);
        }
        
        hotelImageRepository.deleteById(id);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Image deleted successfully");
        
        return ResponseEntity.ok(response);
    }
}

