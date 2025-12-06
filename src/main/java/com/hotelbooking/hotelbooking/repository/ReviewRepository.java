package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.Review;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {
    Optional<Review> findByBookingId(Long bookingId);
    List<Review> findByHotelId(Long hotelId);
    List<Review> findByRoomTypeId(Long roomTypeId);
    List<Review> findByUserId(Long userId);
    List<Review> findByHotelIdOrderByCreatedAtDesc(Long hotelId);
    List<Review> findByRoomTypeIdOrderByCreatedAtDesc(Long roomTypeId);
    
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.hotelId = :hotelId")
    Double getAverageRatingByHotelId(@Param("hotelId") Long hotelId);
    
    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.roomTypeId = :roomTypeId")
    Double getAverageRatingByRoomTypeId(@Param("roomTypeId") Long roomTypeId);
}

