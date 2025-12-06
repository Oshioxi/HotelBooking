package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.annotation.CurrentUser;
import com.hotelbooking.hotelbooking.dto.FavoriteRequest;
import com.hotelbooking.hotelbooking.model.Favorite;
import com.hotelbooking.hotelbooking.service.FavoriteService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user/favorites")
@CrossOrigin(origins = "*")
public class FavoriteController {
    @Autowired
    private FavoriteService favoriteService;

    @GetMapping
    public ResponseEntity<List<Map<String, Object>>> getMyFavorites(@CurrentUser Long userId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(favoriteService.getUserFavorites(userId));
    }

    @PostMapping
    public ResponseEntity<Map<String, Object>> addFavorite(
            @CurrentUser Long userId,
            @Valid @RequestBody FavoriteRequest request) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        Favorite favorite = favoriteService.addFavorite(userId, request);
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Added to favorites successfully");
        response.put("favorite", favorite);
        return ResponseEntity.ok(response);
    }

    @DeleteMapping("/hotel/{hotelId}")
    public ResponseEntity<Map<String, String>> removeFavoriteHotel(
            @CurrentUser Long userId,
            @PathVariable Long hotelId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        favoriteService.removeFavorite(userId, hotelId, null);
        return ResponseEntity.ok(Map.of("message", "Removed from favorites successfully"));
    }

    @DeleteMapping("/room-type/{roomTypeId}")
    public ResponseEntity<Map<String, String>> removeFavoriteRoomType(
            @CurrentUser Long userId,
            @PathVariable Long roomTypeId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        favoriteService.removeFavorite(userId, null, roomTypeId);
        return ResponseEntity.ok(Map.of("message", "Removed from favorites successfully"));
    }

    @GetMapping("/check/hotel/{hotelId}")
    public ResponseEntity<Map<String, Boolean>> checkHotelFavorite(
            @CurrentUser Long userId,
            @PathVariable Long hotelId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        boolean isFavorite = favoriteService.isFavorite(userId, hotelId, null);
        return ResponseEntity.ok(Map.of("isFavorite", isFavorite));
    }

    @GetMapping("/check/room-type/{roomTypeId}")
    public ResponseEntity<Map<String, Boolean>> checkRoomTypeFavorite(
            @CurrentUser Long userId,
            @PathVariable Long roomTypeId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        boolean isFavorite = favoriteService.isFavorite(userId, null, roomTypeId);
        return ResponseEntity.ok(Map.of("isFavorite", isFavorite));
    }

    @GetMapping("/count")
    public ResponseEntity<Map<String, Long>> getFavoriteCount(@CurrentUser Long userId) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        long count = favoriteService.getFavoriteCount(userId);
        return ResponseEntity.ok(Map.of("count", count));
    }
}


