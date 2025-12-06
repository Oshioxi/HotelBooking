package com.hotelbooking.hotelbooking.service;

import com.hotelbooking.hotelbooking.dto.BookingRequest;
import com.hotelbooking.hotelbooking.exception.BadRequestException;
import com.hotelbooking.hotelbooking.exception.ResourceNotFoundException;
import com.hotelbooking.hotelbooking.model.Booking;
import com.hotelbooking.hotelbooking.model.Booking.BookingStatus;
import com.hotelbooking.hotelbooking.model.RoomType;
import com.hotelbooking.hotelbooking.repository.BookingRepository;
import com.hotelbooking.hotelbooking.repository.RoomTypeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.List;

@Service
@Transactional
public class BookingService {
    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private RoomTypeRepository roomTypeRepository;

    public List<Booking> getAllBookings() {
        return bookingRepository.findAll();
    }

    public Booking getBookingById(Long id) {
        return bookingRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
    }

    public List<Booking> getBookingsByUser(Long userId) {
        return bookingRepository.findByUserId(userId);
    }

    public List<Booking> getBookingsByRoomType(Long roomTypeId) {
        return bookingRepository.findByRoomTypeId(roomTypeId);
    }

    public List<Booking> getBookingsByOwner(Long ownerId) {
        return bookingRepository.findByOwnerId(ownerId);
    }

    public List<Booking> getBookingsByHotel(Long hotelId) {
        return bookingRepository.findByHotelId(hotelId);
    }

    public Booking createBooking(Long userId, BookingRequest request) {
        RoomType roomType = roomTypeRepository.findById(request.getRoomTypeId())
                .orElseThrow(() -> new ResourceNotFoundException("Room type not found"));

        if (roomType.getStatus() != RoomType.RoomTypeStatus.APPROVED) {
            throw new BadRequestException("Room type is not available for booking");
        }

        // Validate dates
        LocalDate today = LocalDate.now();
        if (request.getCheckInDate().isAfter(request.getCheckOutDate()) || 
            request.getCheckInDate().isBefore(today)) {
            throw new BadRequestException("Invalid date range: Check-in date must be today or in the future, and check-out date must be after check-in date");
        }

        // Check if guests exceed max occupancy per room
        int maxTotalGuests = roomType.getMaxOccupancy() * request.getNumberOfRooms();
        if (request.getNumberOfGuests() > maxTotalGuests) {
            throw new BadRequestException("Number of guests exceeds room capacity");
        }

        // Check availability
        List<Booking> overlappingBookings = bookingRepository.findOverlappingBookings(
                request.getRoomTypeId(), request.getCheckInDate(), request.getCheckOutDate());

        // Calculate total booked rooms for the date range
        int bookedRooms = overlappingBookings.stream()
                .filter(b -> b.getBookingStatus() != BookingStatus.CANCELLED)
                .mapToInt(b -> b.getNumberOfRooms() != null ? b.getNumberOfRooms() : 1)
                .sum();

        int availableRooms = roomType.getTotalRooms() - bookedRooms;
        if (request.getNumberOfRooms() > availableRooms) {
            throw new BadRequestException("Not enough rooms available for the selected dates");
        }

        // Calculate total price
        long nights = ChronoUnit.DAYS.between(request.getCheckInDate(), request.getCheckOutDate());
        BigDecimal totalPrice = roomType.getPricePerNight()
                .multiply(BigDecimal.valueOf(nights))
                .multiply(BigDecimal.valueOf(request.getNumberOfRooms()));

        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setRoomTypeId(request.getRoomTypeId());
        booking.setCheckInDate(request.getCheckInDate());
        booking.setCheckOutDate(request.getCheckOutDate());
        booking.setNumberOfGuests(request.getNumberOfGuests());
        booking.setNumberOfRooms(request.getNumberOfRooms());
        booking.setTotalPrice(totalPrice);
        booking.setGuestName(request.getGuestName());
        booking.setGuestEmail(request.getGuestEmail());
        booking.setGuestPhone(request.getGuestPhone());
        booking.setSpecialRequests(request.getSpecialRequests());

        return bookingRepository.save(booking);
    }

    public Booking cancelBooking(Long id, Long userId) {
        Booking booking = getBookingById(id);
        
        if (!booking.getUserId().equals(userId)) {
            throw new BadRequestException("You can only cancel your own bookings");
        }

        if (booking.getBookingStatus() == BookingStatus.CANCELLED) {
            throw new BadRequestException("Booking is already cancelled");
        }

        if (booking.getBookingStatus() == BookingStatus.COMPLETED) {
            throw new BadRequestException("Cannot cancel completed booking");
        }

        booking.setBookingStatus(BookingStatus.CANCELLED);
        // Payment status is now handled in Payment entity separately

        return bookingRepository.save(booking);
    }

    public Booking confirmBooking(Long id) {
        Booking booking = getBookingById(id);
        booking.setBookingStatus(BookingStatus.CONFIRMED);
        return bookingRepository.save(booking);
    }
}

