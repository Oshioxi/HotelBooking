package com.hotelbooking.hotelbooking.repository;

import com.hotelbooking.hotelbooking.model.Payment;
import com.hotelbooking.hotelbooking.model.Payment.PaymentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findByBookingId(Long bookingId);
    Optional<Payment> findFirstByBookingIdOrderByCreatedAtDesc(Long bookingId);
    List<Payment> findByPaymentStatus(PaymentStatus status);
    Optional<Payment> findByTransactionId(String transactionId);
}

