package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.RoomTypeAmenity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomTypeAmenityRepository extends JpaRepository<RoomTypeAmenity, Long> {
    List<RoomTypeAmenity> findByRoomTypeId(Long roomTypeId);
    void deleteByRoomTypeId(Long roomTypeId);
    boolean existsByRoomTypeIdAndAmenityId(Long roomTypeId, Long amenityId);
}

