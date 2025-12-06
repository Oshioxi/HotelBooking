package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.Favorite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends JpaRepository<Favorite, Long> {
    // Find all favorites by user
    List<Favorite> findByUserId(Long userId);
    
    // Find favorite by user and hotel
    Optional<Favorite> findByUserIdAndHotelId(Long userId, Long hotelId);
    
    // Find favorite by user and room type
    Optional<Favorite> findByUserIdAndRoomTypeId(Long userId, Long roomTypeId);
    
    // Check if hotel is favorited by user
    boolean existsByUserIdAndHotelId(Long userId, Long hotelId);
    
    // Check if room type is favorited by user
    boolean existsByUserIdAndRoomTypeId(Long userId, Long roomTypeId);
    
    // Count favorites by user
    long countByUserId(Long userId);
    
    // Get all favorite hotels for a user
    @Query("SELECT f.hotelId FROM Favorite f WHERE f.userId = :userId AND f.hotelId IS NOT NULL")
    List<Long> findFavoriteHotelIdsByUserId(@Param("userId") Long userId);
    
    // Get all favorite room types for a user
    @Query("SELECT f.roomTypeId FROM Favorite f WHERE f.userId = :userId AND f.roomTypeId IS NOT NULL")
    List<Long> findFavoriteRoomTypeIdsByUserId(@Param("userId") Long userId);
}


