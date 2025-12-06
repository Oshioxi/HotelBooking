package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.annotation.CurrentUser;
import com.hotelbooking.hotelbooking.dto.PaymentRequest;
import com.hotelbooking.hotelbooking.model.Booking;
import com.hotelbooking.hotelbooking.model.Payment;
import com.hotelbooking.hotelbooking.service.PaymentService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/payments")
@CrossOrigin(origins = "*")
public class PaymentController {
    @Autowired
    private PaymentService paymentService;

    @GetMapping
    public ResponseEntity<List<Payment>> getAllPayments() {
        return ResponseEntity.ok(paymentService.getAllPayments());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Payment> getPaymentById(@PathVariable Long id) {
        return ResponseEntity.ok(paymentService.getPaymentById(id));
    }

    @GetMapping("/booking/{bookingId}")
    public ResponseEntity<List<Payment>> getPaymentsByBookingId(@PathVariable Long bookingId) {
        return ResponseEntity.ok(paymentService.getPaymentsByBookingId(bookingId));
    }

    @GetMapping("/booking/{bookingId}/latest")
    public ResponseEntity<Payment> getLatestPaymentByBookingId(@PathVariable Long bookingId) {
        return ResponseEntity.ok(paymentService.getLatestPaymentByBookingId(bookingId));
    }

    @PostMapping("/create")
    public ResponseEntity<Payment> createPayment(
            @CurrentUser Long userId,
            @RequestParam Long bookingId,
            @RequestParam Payment.PaymentMethod paymentMethod) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        
        // Verify booking belongs to user
        // This check should be done in service, but for now we'll create payment
        return ResponseEntity.ok(paymentService.createPayment(bookingId, paymentMethod));
    }

    @PostMapping("/process")
    public ResponseEntity<Payment> processPayment(
            @CurrentUser Long userId,
            @Valid @RequestBody PaymentRequest request) {
        if (userId == null) {
            return ResponseEntity.status(401).build();
        }
        return ResponseEntity.ok(paymentService.processPayment(request));
    }

    @PutMapping("/{id}/confirm")
    public ResponseEntity<Payment> confirmPayment(@PathVariable Long id) {
        return ResponseEntity.ok(paymentService.confirmPayment(id));
    }

    @PutMapping("/{id}/fail")
    public ResponseEntity<Payment> markPaymentAsFailed(
            @PathVariable Long id,
            @RequestParam(required = false) String reason) {
        return ResponseEntity.ok(paymentService.markPaymentAsFailed(id, reason));
    }

    @PutMapping("/{id}/refund")
    public ResponseEntity<Payment> refundPayment(
            @PathVariable Long id,
            @RequestParam(required = false) String reason) {
        return ResponseEntity.ok(paymentService.refundPayment(id, reason));
    }

    @PutMapping("/{id}/cancel")
    public ResponseEntity<Payment> cancelPayment(@PathVariable Long id) {
        return ResponseEntity.ok(paymentService.cancelPayment(id));
    }
}





