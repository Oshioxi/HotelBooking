package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.HotelAmenity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HotelAmenityRepository extends JpaRepository<HotelAmenity, Long> {
    List<HotelAmenity> findByHotelId(Long hotelId);
    void deleteByHotelId(Long hotelId);
    boolean existsByHotelIdAndAmenityId(Long hotelId, Long amenityId);
}

