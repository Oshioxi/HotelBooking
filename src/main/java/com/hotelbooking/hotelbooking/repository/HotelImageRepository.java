package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.HotelImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface HotelImageRepository extends JpaRepository<HotelImage, Long> {
    List<HotelImage> findByHotelId(Long hotelId);
    List<HotelImage> findByHotelIdOrderByDisplayOrderAsc(Long hotelId);
    Optional<HotelImage> findByHotelIdAndIsPrimaryTrue(Long hotelId);
    void deleteByHotelId(Long hotelId);
}

