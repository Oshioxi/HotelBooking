package com.hotelbooking.hotelbooking.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    private static final Logger log = LoggerFactory.getLogger(EmailService.class);

    @Autowired(required = false)
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:noreply@hotelbooking.com}")
    private String fromEmail;

    @Value("${app.base-url:http://localhost:8081}")
    private String baseUrl;

    public void sendPasswordResetEmail(String toEmail, String resetToken, String fullName) {
        if (mailSender == null) {
            log.warn("JavaMailSender not configured. Email sending is disabled.");
            log.info("Password reset token for {}: {}", toEmail, resetToken);
            log.info("Reset URL: {}/reset-password?token={}", baseUrl, resetToken);
            return;
        }

        try {
            String resetUrl = baseUrl + "/reset-password?token=" + resetToken;
            
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("Reset Your Password - Hotel Booking");
            
            String emailBody = String.format(
                "Hello %s,\n\n" +
                "You have requested to reset your password for your Hotel Booking account.\n\n" +
                "Please click on the following link to reset your password:\n" +
                "%s\n\n" +
                "This link will expire in 1 hour.\n\n" +
                "If you did not request this password reset, please ignore this email.\n\n" +
                "Best regards,\n" +
                "Hotel Booking Team",
                fullName != null ? fullName : "User",
                resetUrl
            );
            
            message.setText(emailBody);
            
            mailSender.send(message);
            log.info("Password reset email sent successfully to: {}", toEmail);
        } catch (Exception e) {
            log.error("Error sending password reset email to: {}", toEmail, e);
            throw new RuntimeException("Failed to send email: " + e.getMessage());
        }
    }
}


