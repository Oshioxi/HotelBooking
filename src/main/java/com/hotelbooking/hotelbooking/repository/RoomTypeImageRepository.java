package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.RoomTypeImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface RoomTypeImageRepository extends JpaRepository<RoomTypeImage, Long> {
    List<RoomTypeImage> findByRoomTypeId(Long roomTypeId);
    List<RoomTypeImage> findByRoomTypeIdOrderByDisplayOrderAsc(Long roomTypeId);
    Optional<RoomTypeImage> findByRoomTypeIdAndIsPrimaryTrue(Long roomTypeId);
    void deleteByRoomTypeId(Long roomTypeId);
}

