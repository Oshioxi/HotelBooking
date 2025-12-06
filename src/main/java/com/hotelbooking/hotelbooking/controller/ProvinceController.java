package com.hotelbooking.hotelbooking.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@RestController
@RequestMapping("/api/provinces")
@CrossOrigin(origins = "*")
public class ProvinceController {
    
    private static final String PROVINCES_API_BASE = "https://provinces.open-api.vn/api/v2";
    
    private RestTemplate getRestTemplate() {
        return new RestTemplate();
    }
    
    /**
     * Get all provinces
     */
    @GetMapping
    public ResponseEntity<?> getAllProvinces() {
        try {
            // API v2 endpoint: GET /api/v2/ returns all provinces
            String url = PROVINCES_API_BASE + "/";
            Object response = getRestTemplate().getForObject(url, Object.class);
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body(Map.of("error", "Failed to fetch provinces: " + e.getMessage()));
        }
    }
    
    /**
     * Get wards by province code
     * API v2: Use /p/{code}?depth=2 to get province with nested wards
     */
    @GetMapping("/{provinceCode}/wards")
    public ResponseEntity<?> getWardsByProvince(@PathVariable String provinceCode) {
        try {
            // API v2 endpoint: /p/{code}?depth=2 returns province with nested wards
            String url = PROVINCES_API_BASE + "/p/" + provinceCode + "?depth=2";
            System.out.println("Fetching wards from URL: " + url);
            
            RestTemplate restTemplate = getRestTemplate();
            Object response = restTemplate.getForObject(url, Object.class);
            
            if (response == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                    .body(Map.of("error", "No province found for code: " + provinceCode));
            }
            
            // Extract wards from province object
            if (response instanceof Map) {
                @SuppressWarnings("unchecked")
                Map<String, Object> provinceMap = (Map<String, Object>) response;
                Object wards = provinceMap.get("wards");
                
                if (wards == null) {
                    return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(Map.of("error", "No wards found for province code: " + provinceCode));
                }
                
                System.out.println("Wards found: " + (wards instanceof java.util.List ? 
                    ((java.util.List<?>) wards).size() : "unknown") + " items");
                return ResponseEntity.ok(wards);
            }
            
            // If response is not a Map, return as is
            return ResponseEntity.ok(response);
            
        } catch (RestClientException e) {
            System.err.println("RestClientException: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of(
                    "error", "Failed to fetch wards from external API",
                    "message", e.getMessage(),
                    "provinceCode", provinceCode
                ));
        } catch (Exception e) {
            System.err.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(Map.of(
                    "error", "Unexpected error while fetching wards",
                    "message", e.getMessage(),
                    "type", e.getClass().getName()
                ));
        }
    }
}

