package com.hotelbooking.hotelbooking.service;

import com.hotelbooking.hotelbooking.dto.PaymentRequest;
import com.hotelbooking.hotelbooking.exception.BadRequestException;
import com.hotelbooking.hotelbooking.exception.ResourceNotFoundException;
import com.hotelbooking.hotelbooking.model.Booking;
import com.hotelbooking.hotelbooking.model.Payment;
import com.hotelbooking.hotelbooking.model.Payment.PaymentMethod;
import com.hotelbooking.hotelbooking.model.Payment.PaymentStatus;
import com.hotelbooking.hotelbooking.repository.BookingRepository;
import com.hotelbooking.hotelbooking.repository.PaymentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class PaymentService {
    @Autowired
    private PaymentRepository paymentRepository;
    
    @Autowired
    private BookingRepository bookingRepository;

    public List<Payment> getAllPayments() {
        return paymentRepository.findAll();
    }

    public Payment getPaymentById(Long id) {
        return paymentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Payment not found with id: " + id));
    }

    public List<Payment> getPaymentsByBookingId(Long bookingId) {
        return paymentRepository.findByBookingId(bookingId);
    }

    public Payment getLatestPaymentByBookingId(Long bookingId) {
        return paymentRepository.findFirstByBookingIdOrderByCreatedAtDesc(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("No payment found for booking id: " + bookingId));
    }

    @Transactional
    public Payment createPayment(Long bookingId, PaymentMethod paymentMethod) {
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found with id: " + bookingId));

        // Check if there's already a paid payment for this booking
        List<Payment> existingPayments = paymentRepository.findByBookingId(bookingId);
        boolean hasPaidPayment = existingPayments.stream()
                .anyMatch(p -> p.getPaymentStatus() == PaymentStatus.PAID);
        
        if (hasPaidPayment) {
            throw new BadRequestException("This booking already has a paid payment");
        }

        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setPaymentMethod(paymentMethod);
        payment.setAmount(booking.getTotalPrice());
        payment.setPaymentStatus(PaymentStatus.PENDING);
        
        // Generate transaction ID if not provided
        if (paymentMethod == PaymentMethod.ONLINE || paymentMethod == PaymentMethod.CREDIT_CARD 
                || paymentMethod == PaymentMethod.DEBIT_CARD || paymentMethod == PaymentMethod.PAYPAL) {
            payment.setTransactionId("TXN-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }

        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment processPayment(PaymentRequest request) {
        // Get the latest payment for this booking
        Payment payment = getLatestPaymentByBookingId(request.getBookingId());
        
        if (payment.getPaymentStatus() == PaymentStatus.PAID) {
            throw new BadRequestException("Payment has already been processed");
        }

        if (request.getTransactionId() != null && !request.getTransactionId().isEmpty()) {
            payment.setTransactionId(request.getTransactionId());
        }

        if (request.getNotes() != null && !request.getNotes().isEmpty()) {
            payment.setNotes(request.getNotes());
        }

        // Process payment based on method
        if (request.getPaymentMethod() == PaymentMethod.ONLINE || 
            request.getPaymentMethod() == PaymentMethod.CREDIT_CARD ||
            request.getPaymentMethod() == PaymentMethod.DEBIT_CARD ||
            request.getPaymentMethod() == PaymentMethod.PAYPAL) {
            // Simulate payment processing - in real app, integrate with payment gateway
            payment.setPaymentStatus(PaymentStatus.PAID);
            payment.setPaymentDate(LocalDateTime.now());
            
            // Update booking status to CONFIRMED
            Booking booking = bookingRepository.findById(payment.getBookingId())
                    .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
            if (booking.getBookingStatus() == Booking.BookingStatus.PENDING) {
                booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
                bookingRepository.save(booking);
            }
        } else if (request.getPaymentMethod() == PaymentMethod.COD || 
                   request.getPaymentMethod() == PaymentMethod.AT_HOTEL) {
            // For COD and AT_HOTEL, keep as PENDING until confirmed manually
            payment.setPaymentStatus(PaymentStatus.PENDING);
        }

        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment confirmPayment(Long paymentId) {
        Payment payment = getPaymentById(paymentId);
        
        if (payment.getPaymentStatus() == PaymentStatus.PAID) {
            throw new BadRequestException("Payment is already confirmed");
        }

        payment.setPaymentStatus(PaymentStatus.PAID);
        payment.setPaymentDate(LocalDateTime.now());

        // Update booking status to CONFIRMED
        Booking booking = bookingRepository.findById(payment.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
        if (booking.getBookingStatus() == Booking.BookingStatus.PENDING) {
            booking.setBookingStatus(Booking.BookingStatus.CONFIRMED);
            bookingRepository.save(booking);
        }

        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment markPaymentAsFailed(Long paymentId, String reason) {
        Payment payment = getPaymentById(paymentId);
        
        if (payment.getPaymentStatus() == PaymentStatus.PAID) {
            throw new BadRequestException("Cannot mark paid payment as failed");
        }

        payment.setPaymentStatus(PaymentStatus.FAILED);
        if (reason != null && !reason.isEmpty()) {
            payment.setNotes((payment.getNotes() != null ? payment.getNotes() + "\n" : "") + 
                           "Failed: " + reason);
        }

        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment refundPayment(Long paymentId, String reason) {
        Payment payment = getPaymentById(paymentId);
        
        if (payment.getPaymentStatus() != PaymentStatus.PAID) {
            throw new BadRequestException("Only paid payments can be refunded");
        }

        payment.setPaymentStatus(PaymentStatus.REFUNDED);
        payment.setRefundDate(LocalDateTime.now());
        payment.setRefundReason(reason);

        // Update booking status to CANCELLED
        Booking booking = bookingRepository.findById(payment.getBookingId())
                .orElseThrow(() -> new ResourceNotFoundException("Booking not found"));
        if (booking.getBookingStatus() != Booking.BookingStatus.CANCELLED) {
            booking.setBookingStatus(Booking.BookingStatus.CANCELLED);
            bookingRepository.save(booking);
        }

        return paymentRepository.save(payment);
    }

    @Transactional
    public Payment cancelPayment(Long paymentId) {
        Payment payment = getPaymentById(paymentId);
        
        if (payment.getPaymentStatus() == PaymentStatus.PAID) {
            throw new BadRequestException("Cannot cancel paid payment. Use refund instead.");
        }

        payment.setPaymentStatus(PaymentStatus.CANCELLED);
        return paymentRepository.save(payment);
    }
}

