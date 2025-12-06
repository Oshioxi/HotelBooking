package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.Booking;
import com.hotelbooking.hotelbooking.model.Booking.BookingStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<Booking> findByUserId(Long userId);
    List<Booking> findByRoomTypeId(Long roomTypeId);
    List<Booking> findByBookingStatus(BookingStatus status);
    
    @Query("SELECT b FROM Booking b WHERE b.roomTypeId = :roomTypeId " +
           "AND b.bookingStatus != 'CANCELLED' " +
           "AND ((b.checkInDate <= :checkOutDate AND b.checkOutDate >= :checkInDate))")
    List<Booking> findOverlappingBookings(
        @Param("roomTypeId") Long roomTypeId,
        @Param("checkInDate") LocalDate checkInDate,
        @Param("checkOutDate") LocalDate checkOutDate
    );
    
    @Query("SELECT b FROM Booking b WHERE b.roomTypeId IN " +
           "(SELECT r.id FROM RoomType r WHERE r.hotelId IN " +
           "(SELECT h.id FROM Hotel h WHERE h.ownerId = :ownerId))")
    List<Booking> findByOwnerId(@Param("ownerId") Long ownerId);
    
    @Query("SELECT b FROM Booking b WHERE b.roomTypeId IN " +
           "(SELECT r.id FROM RoomType r WHERE r.hotelId = :hotelId)")
    List<Booking> findByHotelId(@Param("hotelId") Long hotelId);
}

