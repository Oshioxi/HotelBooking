package com.hotelbooking.hotelbooking.service;

import com.hotelbooking.hotelbooking.dto.RoomRequest;
import com.hotelbooking.hotelbooking.exception.BadRequestException;
import com.hotelbooking.hotelbooking.exception.ResourceNotFoundException;
import com.hotelbooking.hotelbooking.model.RoomType;
import com.hotelbooking.hotelbooking.model.RoomType.RoomTypeStatus;
import com.hotelbooking.hotelbooking.repository.RoomTypeRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Service
@Transactional
public class RoomTypeService {
    private static final Logger log = LoggerFactory.getLogger(RoomTypeService.class);
    
    @Autowired
    private RoomTypeRepository roomTypeRepository;

    public List<RoomType> getAllRoomTypes() {
        return roomTypeRepository.findAll();
    }

    public List<RoomType> getRoomTypesByHotel(Long hotelId) {
        return roomTypeRepository.findByHotelId(hotelId);
    }

    public List<RoomType> getPendingRoomTypes() {
        return roomTypeRepository.findByStatus(RoomTypeStatus.PENDING);
    }

    public RoomType getRoomTypeById(Long id) {
        return roomTypeRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Room type not found"));
    }

    public RoomType createRoomType(RoomRequest request) {
        RoomType roomType = new RoomType();
        roomType.setHotelId(request.getHotelId());
        roomType.setName(request.getName());
        roomType.setDescription(request.getDescription());
        roomType.setRoomType(request.getRoomType());
        roomType.setPricePerNight(request.getPricePerNight());
        roomType.setTotalRooms(request.getTotalRooms());
        roomType.setMaxOccupancy(request.getMaxOccupancy());
        roomType.setStatus(RoomTypeStatus.PENDING);

        return roomTypeRepository.save(roomType);
    }

    public RoomType updateRoomType(Long id, RoomRequest request) {
        RoomType roomType = getRoomTypeById(id);

        roomType.setName(request.getName());
        roomType.setDescription(request.getDescription());
        roomType.setRoomType(request.getRoomType());
        roomType.setPricePerNight(request.getPricePerNight());
        roomType.setTotalRooms(request.getTotalRooms());
        roomType.setMaxOccupancy(request.getMaxOccupancy());

        return roomTypeRepository.save(roomType);
    }

    public RoomType approveRoomType(Long id) {
        RoomType roomType = getRoomTypeById(id);
        roomType.setStatus(RoomTypeStatus.APPROVED);
        roomType.setRejectionReason(null);
        return roomTypeRepository.save(roomType);
    }

    public RoomType rejectRoomType(Long id, String reason) {
        RoomType roomType = getRoomTypeById(id);
        roomType.setStatus(RoomTypeStatus.REJECTED);
        roomType.setRejectionReason(reason);
        return roomTypeRepository.save(roomType);
    }

    public void deleteRoomType(Long id) {
        if (!roomTypeRepository.existsById(id)) {
            throw new ResourceNotFoundException("Room type not found");
        }
        roomTypeRepository.deleteById(id);
    }

    public List<RoomType> searchRoomTypes(String city, BigDecimal minPrice, BigDecimal maxPrice, Integer guests) {
        if (minPrice == null) minPrice = BigDecimal.ZERO;
        if (maxPrice == null) maxPrice = new BigDecimal("999999");
        if (guests == null) guests = 1;
        
        log.info("Searching room types: city={}, minPrice={}, maxPrice={}, guests={}", city, minPrice, maxPrice, guests);
        List<RoomType> roomTypes = roomTypeRepository.searchAvailableRoomTypes(city, minPrice, maxPrice, guests);
        log.info("Found {} room types", roomTypes.size());
        
        return roomTypes;
    }

    public List<RoomType> searchRoomTypesWithDates(String city, BigDecimal minPrice, BigDecimal maxPrice, 
                                          Integer guests, LocalDate checkInDate, LocalDate checkOutDate,
                                          List<String> amenities) {
        if (minPrice == null) minPrice = BigDecimal.ZERO;
        if (maxPrice == null) maxPrice = new BigDecimal("999999");
        if (guests == null) guests = 1;
        
        log.info("Searching room types with dates: city={}, minPrice={}, maxPrice={}, guests={}, checkIn={}, checkOut={}, amenities={}", 
            city, minPrice, maxPrice, guests, checkInDate, checkOutDate, amenities);
        
        List<RoomType> roomTypes;
        
        if (checkInDate != null && checkOutDate != null) {
            LocalDate today = LocalDate.now();
            // Check-in must be today or in the future, and check-out must be after check-in
            if (checkInDate.isAfter(checkOutDate) || checkInDate.isBefore(today)) {
                throw new BadRequestException("Invalid date range: Check-in date must be today or in the future, and check-out date must be after check-in date");
            }
            roomTypes = roomTypeRepository.searchAvailableRoomTypesWithDates(
                city, minPrice, maxPrice, guests, checkInDate, checkOutDate);
            log.info("Found {} room types (with date availability check)", roomTypes.size());
        } else {
            roomTypes = roomTypeRepository.searchAvailableRoomTypes(city, minPrice, maxPrice, guests);
            log.info("Found {} room types (without date check)", roomTypes.size());
        }
        
        // Note: Amenity filtering would need to be done via RoomTypeAmenity relationships
        // This is a simplified version - you may want to enhance this with proper amenity filtering
        
        return roomTypes;
    }
}

