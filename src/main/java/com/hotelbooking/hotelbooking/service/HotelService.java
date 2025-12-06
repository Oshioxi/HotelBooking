package com.hotelbooking.hotelbooking.service;

import com.hotelbooking.hotelbooking.dto.HotelRequest;
import com.hotelbooking.hotelbooking.dto.HotelResponse;
import com.hotelbooking.hotelbooking.exception.ResourceNotFoundException;
import com.hotelbooking.hotelbooking.model.Amenity;
import com.hotelbooking.hotelbooking.model.Hotel;
import com.hotelbooking.hotelbooking.model.HotelAmenity;
import com.hotelbooking.hotelbooking.model.HotelImage;
import com.hotelbooking.hotelbooking.model.User;
import com.hotelbooking.hotelbooking.repository.AmenityRepository;
import com.hotelbooking.hotelbooking.repository.HotelAmenityRepository;
import com.hotelbooking.hotelbooking.repository.HotelImageRepository;
import com.hotelbooking.hotelbooking.repository.HotelRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@Transactional
public class HotelService {
    @Autowired
    private HotelRepository hotelRepository;
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private HotelAmenityRepository hotelAmenityRepository;
    
    @Autowired
    private HotelImageRepository hotelImageRepository;
    
    @Autowired
    private AmenityRepository amenityRepository;

    public List<Hotel> getAllHotels() {
        return hotelRepository.findAll();
    }
    
    public List<HotelResponse> getAllHotelsWithOwner() {
        List<Hotel> hotels = hotelRepository.findAll();
        
        // Get all unique owner IDs
        List<Long> ownerIds = hotels.stream()
                .map(Hotel::getOwnerId)
                .filter(id -> id != null)
                .distinct()
                .collect(Collectors.toList());
        
        // Load all owners
        Map<Long, User> ownerMap = ownerIds.stream()
                .collect(Collectors.toMap(
                    id -> id,
                    id -> {
                        try {
                            return userService.getUserById(id);
                        } catch (ResourceNotFoundException e) {
                            return null;
                        }
                    }
                ));
        
        // Load all amenities and images for all hotels
        Map<Long, List<HotelAmenity>> hotelAmenitiesMap = hotels.stream()
                .collect(Collectors.toMap(
                    Hotel::getId,
                    hotel -> hotelAmenityRepository.findByHotelId(hotel.getId())
                ));
        
        Map<Long, List<HotelImage>> hotelImagesMap = hotels.stream()
                .collect(Collectors.toMap(
                    Hotel::getId,
                    hotel -> hotelImageRepository.findByHotelIdOrderByDisplayOrderAsc(hotel.getId())
                ));
        
        // Get all amenity IDs and load amenities
        List<Long> amenityIds = hotelAmenitiesMap.values().stream()
                .flatMap(List::stream)
                .map(HotelAmenity::getAmenityId)
                .distinct()
                .collect(Collectors.toList());
        
        Map<Long, Amenity> amenityMap = amenityIds.stream()
                .collect(Collectors.toMap(
                    id -> id,
                    id -> amenityRepository.findById(id).orElse(null)
                ));
        
        // Map hotels to responses with owner, amenities, and images info
        return hotels.stream()
                .map(hotel -> {
                    HotelResponse response = new HotelResponse(hotel);
                    User owner = ownerMap.get(hotel.getOwnerId());
                    if (owner != null) {
                        response.setOwnerName(owner.getFullName());
                        response.setOwnerEmail(owner.getEmail());
                    }
                    
                    // Set amenities
                    List<HotelAmenity> hotelAmenities = hotelAmenitiesMap.get(hotel.getId());
                    if (hotelAmenities != null) {
                        List<HotelResponse.AmenityInfo> amenities = hotelAmenities.stream()
                                .map(ha -> {
                                    Amenity amenity = amenityMap.get(ha.getAmenityId());
                                    if (amenity != null) {
                                        return new HotelResponse.AmenityInfo(
                                            amenity.getId(),
                                            amenity.getName(),
                                            amenity.getDescription(),
                                            amenity.getIcon(),
                                            amenity.getCategory()
                                        );
                                    }
                                    return null;
                                })
                                .filter(a -> a != null)
                                .collect(Collectors.toList());
                        response.setAmenities(amenities);
                    }
                    
                    // Set images
                    List<HotelImage> hotelImages = hotelImagesMap.get(hotel.getId());
                    if (hotelImages != null) {
                        List<HotelResponse.ImageInfo> images = hotelImages.stream()
                                .map(hi -> new HotelResponse.ImageInfo(
                                    hi.getId(),
                                    hi.getImageUrl(),
                                    hi.getAltText(),
                                    hi.getIsPrimary(),
                                    hi.getDisplayOrder()
                                ))
                                .collect(Collectors.toList());
                        response.setImages(images);
                    }
                    
                    return response;
                })
                .collect(Collectors.toList());
    }

    public Hotel getHotelById(Long id) {
        return hotelRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Hotel not found"));
    }

    public List<Hotel> getHotelsByOwner(Long ownerId) {
        return hotelRepository.findByOwnerId(ownerId);
    }

    public Hotel createHotel(HotelRequest request) {
        Hotel hotel = new Hotel();
        hotel.setOwnerId(request.getOwnerId());
        hotel.setName(request.getName());
        hotel.setAddress(request.getAddress());
        hotel.setCity(request.getCity());
        hotel.setCountry(request.getCountry());
        hotel.setDescription(request.getDescription());
        hotel.setRating(request.getRating() != null ? request.getRating() : BigDecimal.ZERO);
        return hotelRepository.save(hotel);
    }

    public Hotel updateHotel(Long id, HotelRequest request) {
        Hotel hotel = getHotelById(id);
        hotel.setName(request.getName());
        hotel.setAddress(request.getAddress());
        hotel.setCity(request.getCity());
        hotel.setCountry(request.getCountry());
        hotel.setDescription(request.getDescription());
        if (request.getRating() != null) {
            hotel.setRating(request.getRating());
        }
        return hotelRepository.save(hotel);
    }

    public void deleteHotel(Long id) {
        if (!hotelRepository.existsById(id)) {
            throw new ResourceNotFoundException("Hotel not found");
        }
        hotelRepository.deleteById(id);
    }

    public Hotel approveHotel(Long id) {
        Hotel hotel = getHotelById(id);
        hotel.setStatus(Hotel.HotelStatus.APPROVED);
        hotel.setRejectionReason(null);
        return hotelRepository.save(hotel);
    }

    public Hotel rejectHotel(Long id, String reason) {
        Hotel hotel = getHotelById(id);
        hotel.setStatus(Hotel.HotelStatus.REJECTED);
        hotel.setRejectionReason(reason);
        return hotelRepository.save(hotel);
    }

    public List<Hotel> getPendingHotels() {
        return hotelRepository.findByStatus(Hotel.HotelStatus.PENDING);
    }

    public List<Hotel> searchHotels(String city) {
        if (city != null && !city.trim().isEmpty()) {
            return hotelRepository.findByCityAndStatus(city, Hotel.HotelStatus.APPROVED);
        }
        return hotelRepository.findByStatus(Hotel.HotelStatus.APPROVED);
    }
    
    public List<String> getAvailableCities() {
        return hotelRepository.findDistinctCitiesByStatus();
    }
}

