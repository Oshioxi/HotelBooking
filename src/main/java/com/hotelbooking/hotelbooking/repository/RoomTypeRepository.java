package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.RoomType;
import com.hotelbooking.hotelbooking.model.RoomType.RoomTypeStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface RoomTypeRepository extends JpaRepository<RoomType, Long> {
    List<RoomType> findByHotelId(Long hotelId);
    List<RoomType> findByStatus(RoomTypeStatus status);
    List<RoomType> findByHotelIdAndStatus(Long hotelId, RoomTypeStatus status);
    
    @Query("SELECT r FROM RoomType r " +
           "WHERE r.status = 'APPROVED' " +
           "AND (:city IS NULL OR r.hotelId IN (SELECT h.id FROM Hotel h WHERE LOWER(h.city) = LOWER(:city))) " +
           "AND r.pricePerNight BETWEEN :minPrice AND :maxPrice " +
           "AND r.maxOccupancy >= :guests")
    List<RoomType> searchAvailableRoomTypes(
        @Param("city") String city,
        @Param("minPrice") BigDecimal minPrice,
        @Param("maxPrice") BigDecimal maxPrice,
        @Param("guests") Integer guests
    );
    
    @Query("SELECT r FROM RoomType r " +
           "WHERE r.status = 'APPROVED' " +
           "AND (:city IS NULL OR r.hotelId IN (SELECT h.id FROM Hotel h WHERE LOWER(h.city) = LOWER(:city))) " +
           "AND r.pricePerNight BETWEEN :minPrice AND :maxPrice " +
           "AND r.maxOccupancy >= :guests " +
           "AND r.id NOT IN (" +
           "    SELECT DISTINCT b.roomTypeId FROM Booking b " +
           "    WHERE b.bookingStatus != 'CANCELLED' " +
           "    AND ((b.checkInDate <= :checkOutDate AND b.checkOutDate >= :checkInDate))" +
           ")")
    List<RoomType> searchAvailableRoomTypesWithDates(
        @Param("city") String city,
        @Param("minPrice") BigDecimal minPrice,
        @Param("maxPrice") BigDecimal maxPrice,
        @Param("guests") Integer guests,
        @Param("checkInDate") LocalDate checkInDate,
        @Param("checkOutDate") LocalDate checkOutDate
    );
}

