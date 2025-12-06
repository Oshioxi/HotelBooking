package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.Hotel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotelRepository extends JpaRepository<Hotel, Long> {
    List<Hotel> findByOwnerId(Long ownerId);
    List<Hotel> findByCity(String city);
    List<Hotel> findByStatus(Hotel.HotelStatus status);
    List<Hotel> findByCityAndStatus(String city, Hotel.HotelStatus status);
    
    @Query("SELECT DISTINCT h.city FROM Hotel h WHERE h.status = 'APPROVED' ORDER BY h.city ASC")
    List<String> findDistinctCitiesByStatus();
}

