package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.model.RoomTypeImage;
import com.hotelbooking.hotelbooking.repository.RoomTypeImageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/room-types/{roomTypeId}/images")
@CrossOrigin(origins = "*")
public class RoomTypeImageController {
    
    @Autowired
    private RoomTypeImageRepository roomTypeImageRepository;
    
    @GetMapping
    public ResponseEntity<List<RoomTypeImage>> getRoomTypeImages(@PathVariable Long roomTypeId) {
        return ResponseEntity.ok(roomTypeImageRepository.findByRoomTypeIdOrderByDisplayOrderAsc(roomTypeId));
    }
    
    @PostMapping
    public ResponseEntity<Map<String, Object>> addRoomTypeImage(
            @PathVariable Long roomTypeId,
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
            List<RoomTypeImage> existingImages = roomTypeImageRepository.findByRoomTypeIdOrderByDisplayOrderAsc(roomTypeId);
            existingImages.forEach(img -> {
                if (img.getIsPrimary() != null && img.getIsPrimary()) {
                    img.setIsPrimary(false);
                    roomTypeImageRepository.save(img);
                }
            });
        }
        
        RoomTypeImage roomTypeImage = new RoomTypeImage();
        roomTypeImage.setRoomTypeId(roomTypeId);
        roomTypeImage.setImageUrl(imageUrl);
        roomTypeImage.setAltText(altText);
        roomTypeImage.setIsPrimary(isPrimary);
        roomTypeImage.setDisplayOrder(displayOrder);
        
        RoomTypeImage saved = roomTypeImageRepository.save(roomTypeImage);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", saved);
        
        return ResponseEntity.ok(response);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<Map<String, Object>> updateRoomTypeImage(
            @PathVariable Long roomTypeId,
            @PathVariable Long id,
            @RequestBody Map<String, Object> request) {
        
        RoomTypeImage roomTypeImage = roomTypeImageRepository.findById(id)
                .orElse(null);
        
        if (roomTypeImage == null || !roomTypeImage.getRoomTypeId().equals(roomTypeId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Room type image not found");
            return ResponseEntity.badRequest().body(error);
        }
        
        if (request.containsKey("imageUrl")) {
            roomTypeImage.setImageUrl((String) request.get("imageUrl"));
        }
        if (request.containsKey("altText")) {
            roomTypeImage.setAltText((String) request.get("altText"));
        }
        if (request.containsKey("isPrimary")) {
            Boolean isPrimary = Boolean.valueOf(request.get("isPrimary").toString());
            // If setting as primary, unset other primary images
            if (isPrimary) {
                List<RoomTypeImage> existingImages = roomTypeImageRepository.findByRoomTypeIdOrderByDisplayOrderAsc(roomTypeId);
                existingImages.forEach(img -> {
                    if (!img.getId().equals(id) && img.getIsPrimary() != null && img.getIsPrimary()) {
                        img.setIsPrimary(false);
                        roomTypeImageRepository.save(img);
                    }
                });
            }
            roomTypeImage.setIsPrimary(isPrimary);
        }
        if (request.containsKey("displayOrder")) {
            roomTypeImage.setDisplayOrder(Integer.valueOf(request.get("displayOrder").toString()));
        }
        
        RoomTypeImage saved = roomTypeImageRepository.save(roomTypeImage);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("data", saved);
        
        return ResponseEntity.ok(response);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Map<String, Object>> deleteRoomTypeImage(
            @PathVariable Long roomTypeId,
            @PathVariable Long id) {
        
        RoomTypeImage roomTypeImage = roomTypeImageRepository.findById(id)
                .orElse(null);
        
        if (roomTypeImage == null || !roomTypeImage.getRoomTypeId().equals(roomTypeId)) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Room type image not found");
            return ResponseEntity.badRequest().body(error);
        }
        
        roomTypeImageRepository.deleteById(id);
        
        Map<String, Object> response = new HashMap<>();
        response.put("success", true);
        response.put("message", "Image deleted successfully");
        
        return ResponseEntity.ok(response);
    }
}


