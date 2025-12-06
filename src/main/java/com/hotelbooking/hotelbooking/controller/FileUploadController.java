package com.hotelbooking.hotelbooking.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api/upload")
@CrossOrigin(origins = "*")
public class FileUploadController {
    
    @Value("${app.upload.dir:src/main/webapp/assets/img/hotels}")
    private String uploadDir;
    
    @PostMapping("/hotel-image")
    public ResponseEntity<Map<String, Object>> uploadHotelImage(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "hotelId", required = false) Long hotelId) {
        
        Map<String, Object> response = new HashMap<>();
        
        try {
            if (file.isEmpty()) {
                response.put("success", false);
                response.put("message", "File is empty");
                return ResponseEntity.badRequest().body(response);
            }
            
            // Create upload directory if it doesn't exist
            Path uploadPath = Paths.get(uploadDir);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }
            
            // Generate unique filename
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".") 
                ? originalFilename.substring(originalFilename.lastIndexOf(".")) 
                : ".jpg";
            String filename = UUID.randomUUID().toString() + extension;
            
            // Save file
            Path filePath = uploadPath.resolve(filename);
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            
            // Return relative URL
            String imageUrl = "/assets/img/hotels/" + filename;
            
            response.put("success", true);
            response.put("imageUrl", imageUrl);
            response.put("filename", filename);
            
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "Failed to upload file: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
    
    @DeleteMapping("/hotel-image")
    public ResponseEntity<Map<String, Object>> deleteHotelImage(@RequestParam("imageUrl") String imageUrl) {
        Map<String, Object> response = new HashMap<>();
        
        try {
            // Extract filename from URL
            String filename = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
            Path filePath = Paths.get(uploadDir).resolve(filename);
            
            if (Files.exists(filePath)) {
                Files.delete(filePath);
                response.put("success", true);
                response.put("message", "File deleted successfully");
            } else {
                response.put("success", false);
                response.put("message", "File not found");
            }
            
            return ResponseEntity.ok(response);
            
        } catch (IOException e) {
            response.put("success", false);
            response.put("message", "Failed to delete file: " + e.getMessage());
            return ResponseEntity.status(500).body(response);
        }
    }
}

