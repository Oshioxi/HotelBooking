package com.hotelbooking.hotelbooking.service;

import com.hotelbooking.hotelbooking.model.Booking;
import com.hotelbooking.hotelbooking.model.Booking.BookingStatus;
import com.hotelbooking.hotelbooking.model.Payment;
import com.hotelbooking.hotelbooking.model.Payment.PaymentStatus;
import com.hotelbooking.hotelbooking.model.RoomType;
import com.hotelbooking.hotelbooking.repository.BookingRepository;
import com.hotelbooking.hotelbooking.repository.PaymentRepository;
import com.hotelbooking.hotelbooking.repository.RoomTypeRepository;
import com.hotelbooking.hotelbooking.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StatisticsService {
    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private RoomTypeRepository roomTypeRepository;

    @Autowired
    private PaymentRepository paymentRepository;

    @Autowired
    private UserRepository userRepository;

    public Map<String, Object> getAdminStats() {
        Map<String, Object> stats = new HashMap<>();
        
        List<Booking> allBookings = bookingRepository.findAll();
        List<RoomType> pendingRoomTypes = roomTypeRepository.findByStatus(RoomType.RoomTypeStatus.PENDING);
        
        long totalBookings = allBookings.size();
        
        // Calculate revenue from payments
        List<Payment> paidPayments = paymentRepository.findByPaymentStatus(PaymentStatus.PAID);
        BigDecimal totalRevenue = paidPayments.stream()
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        long cancelledBookings = allBookings.stream()
                .filter(b -> b.getBookingStatus() == BookingStatus.CANCELLED)
                .count();
        
        double cancellationRate = totalBookings > 0 
                ? (double) cancelledBookings / totalBookings * 100 
                : 0.0;
        
        stats.put("totalBookings", totalBookings);
        stats.put("totalRevenue", totalRevenue);
        stats.put("pendingRoomTypes", pendingRoomTypes.size());
        stats.put("cancellationRate", cancellationRate);
        
        return stats;
    }

    public Map<String, Object> getOwnerStats(Long ownerId) {
        Map<String, Object> stats = new HashMap<>();
        
        List<Booking> ownerBookings = bookingRepository.findByOwnerId(ownerId);
        
        long totalBookings = ownerBookings.size();
        
        // Calculate revenue from payments for owner's bookings
        List<Long> bookingIds = ownerBookings.stream()
                .map(Booking::getId)
                .toList();
        List<Payment> paidPayments = paymentRepository.findAll().stream()
                .filter(p -> bookingIds.contains(p.getBookingId()) && p.getPaymentStatus() == PaymentStatus.PAID)
                .toList();
        BigDecimal totalRevenue = paidPayments.stream()
                .map(Payment::getAmount)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        
        // Calculate occupancy rate (simplified - would need more complex calculation)
        long confirmedBookings = ownerBookings.stream()
                .filter(b -> b.getBookingStatus() == BookingStatus.CONFIRMED)
                .count();
        
        double occupancyRate = totalBookings > 0 
                ? (double) confirmedBookings / totalBookings * 100 
                : 0.0;
        
        long cancelledBookings = ownerBookings.stream()
                .filter(b -> b.getBookingStatus() == BookingStatus.CANCELLED)
                .count();
        
        double cancellationRate = totalBookings > 0 
                ? (double) cancelledBookings / totalBookings * 100 
                : 0.0;
        
        stats.put("totalBookings", totalBookings);
        stats.put("totalRevenue", totalRevenue);
        stats.put("occupancyRate", BigDecimal.valueOf(occupancyRate).setScale(2, RoundingMode.HALF_UP));
        stats.put("cancellationRate", BigDecimal.valueOf(cancellationRate).setScale(2, RoundingMode.HALF_UP));
        
        return stats;
    }
}

