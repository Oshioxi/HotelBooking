package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.Amenity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AmenityRepository extends JpaRepository<Amenity, Long> {
    List<Amenity> findByCategory(String category);
    Amenity findByName(String name);
}

