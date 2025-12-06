package com.hotelbooking.hotelbooking.service;

import com.hotelbooking.hotelbooking.dto.FavoriteRequest;
import com.hotelbooking.hotelbooking.exception.BadRequestException;
import com.hotelbooking.hotelbooking.exception.ResourceNotFoundException;
import com.hotelbooking.hotelbooking.model.Favorite;
import com.hotelbooking.hotelbooking.model.Hotel;
import com.hotelbooking.hotelbooking.model.RoomType;
import com.hotelbooking.hotelbooking.repository.FavoriteRepository;
import com.hotelbooking.hotelbooking.repository.HotelRepository;
import com.hotelbooking.hotelbooking.repository.RoomTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
public class FavoriteService {
    @Autowired
    private FavoriteRepository favoriteRepository;
    
    @Autowired
    private HotelRepository hotelRepository;
    
    @Autowired
    private RoomTypeRepository roomTypeRepository;

    public Favorite addFavorite(Long userId, FavoriteRequest request) {
        // Validate that either hotelId or roomTypeId is provided, but not both
        if (request.getHotelId() == null && request.getRoomTypeId() == null) {
            throw new BadRequestException("Either hotelId or roomTypeId must be provided");
        }
        
        if (request.getHotelId() != null && request.getRoomTypeId() != null) {
            throw new BadRequestException("Cannot favorite both hotel and room type at the same time");
        }

        // Check if already favorited
        if (request.getHotelId() != null) {
            if (favoriteRepository.existsByUserIdAndHotelId(userId, request.getHotelId())) {
                throw new BadRequestException("Hotel is already in your favorites");
            }
            
            // Verify hotel exists
            if (!hotelRepository.existsById(request.getHotelId())) {
                throw new ResourceNotFoundException("Hotel not found");
            }
        }
        
        if (request.getRoomTypeId() != null) {
            if (favoriteRepository.existsByUserIdAndRoomTypeId(userId, request.getRoomTypeId())) {
                throw new BadRequestException("Room type is already in your favorites");
            }
            
            // Verify room type exists
            if (!roomTypeRepository.existsById(request.getRoomTypeId())) {
                throw new ResourceNotFoundException("Room type not found");
            }
        }

        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setHotelId(request.getHotelId());
        favorite.setRoomTypeId(request.getRoomTypeId());

        return favoriteRepository.save(favorite);
    }

    public void removeFavorite(Long userId, Long hotelId, Long roomTypeId) {
        Favorite favorite;
        
        if (hotelId != null) {
            favorite = favoriteRepository.findByUserIdAndHotelId(userId, hotelId)
                    .orElseThrow(() -> new ResourceNotFoundException("Favorite hotel not found"));
        } else if (roomTypeId != null) {
            favorite = favoriteRepository.findByUserIdAndRoomTypeId(userId, roomTypeId)
                    .orElseThrow(() -> new ResourceNotFoundException("Favorite room type not found"));
        } else {
            throw new BadRequestException("Either hotelId or roomTypeId must be provided");
        }

        favoriteRepository.delete(favorite);
    }

    public List<Map<String, Object>> getUserFavorites(Long userId) {
        List<Favorite> favorites = favoriteRepository.findByUserId(userId);
        
        return favorites.stream().map(favorite -> {
            Map<String, Object> favoriteMap = new HashMap<>();
            favoriteMap.put("id", favorite.getId());
            favoriteMap.put("userId", favorite.getUserId());
            favoriteMap.put("hotelId", favorite.getHotelId());
            favoriteMap.put("roomTypeId", favorite.getRoomTypeId());
            favoriteMap.put("createdAt", favorite.getCreatedAt());
            
            // Load hotel or room type details
            if (favorite.getHotelId() != null) {
                Hotel hotel = hotelRepository.findById(favorite.getHotelId()).orElse(null);
                if (hotel != null) {
                    Map<String, Object> hotelMap = new HashMap<>();
                    hotelMap.put("id", hotel.getId());
                    hotelMap.put("name", hotel.getName());
                    hotelMap.put("city", hotel.getCity());
                    hotelMap.put("country", hotel.getCountry());
                    hotelMap.put("address", hotel.getAddress());
                    hotelMap.put("rating", hotel.getRating());
                    hotelMap.put("status", hotel.getStatus());
                    favoriteMap.put("hotel", hotelMap);
                }
            }
            
            if (favorite.getRoomTypeId() != null) {
                RoomType roomType = roomTypeRepository.findById(favorite.getRoomTypeId()).orElse(null);
                if (roomType != null) {
                    Map<String, Object> roomTypeMap = new HashMap<>();
                    roomTypeMap.put("id", roomType.getId());
                    roomTypeMap.put("name", roomType.getName());
                    roomTypeMap.put("roomType", roomType.getRoomType());
                    roomTypeMap.put("pricePerNight", roomType.getPricePerNight());
                    roomTypeMap.put("maxOccupancy", roomType.getMaxOccupancy());
                    roomTypeMap.put("status", roomType.getStatus());
                    favoriteMap.put("roomType", roomTypeMap);
                    
                    // Load hotel info for room type
                    if (roomType.getHotelId() != null) {
                        Hotel hotel = hotelRepository.findById(roomType.getHotelId()).orElse(null);
                        if (hotel != null) {
                            Map<String, Object> hotelMap = new HashMap<>();
                            hotelMap.put("id", hotel.getId());
                            hotelMap.put("name", hotel.getName());
                            hotelMap.put("city", hotel.getCity());
                            hotelMap.put("country", hotel.getCountry());
                            roomTypeMap.put("hotel", hotelMap);
                        }
                    }
                }
            }
            
            return favoriteMap;
        }).collect(Collectors.toList());
    }

    public boolean isFavorite(Long userId, Long hotelId, Long roomTypeId) {
        if (hotelId != null) {
            return favoriteRepository.existsByUserIdAndHotelId(userId, hotelId);
        } else if (roomTypeId != null) {
            return favoriteRepository.existsByUserIdAndRoomTypeId(userId, roomTypeId);
        }
        return false;
    }

    public long getFavoriteCount(Long userId) {
        return favoriteRepository.countByUserId(userId);
    }
}


