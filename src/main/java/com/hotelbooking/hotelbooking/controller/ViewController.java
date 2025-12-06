package com.hotelbooking.hotelbooking.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class ViewController {

    // Public pages
    @GetMapping("/")
    public String index() {
        return "index";
    }

    @GetMapping("/index")
    public String indexPage() {
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @GetMapping("/forgot-password")
    public String forgotPassword() {
        return "forgot-password";
    }

    @GetMapping("/reset-password")
    public String resetPassword() {
        return "reset-password";
    }

    @GetMapping("/hotel-search-result")
    public String hotelSearchResult() {
        return "hotel-search-result";
    }

    @GetMapping("/hotel-single")
    public String hotelSingle() {
        return "hotel-single";
    }

    @GetMapping("/hotel-booking")
    public String hotelBooking() {
        return "hotel-booking";
    }

    @GetMapping("/checkout")
    public String checkout() {
        return "checkout";
    }

    // Dashboard
    @GetMapping("/dashboard")
    public String dashboard() {
        return "dashboard";
    }

    // User pages
    @GetMapping("/user/profile")
    public String userProfile() {
        return "user/profile";
    }

    @GetMapping("/profile-booking")
    public String profileBooking() {
        return "profile-booking";
    }

    @GetMapping("/profile-booking-history")
    public String profileBookingHistory() {
        return "user/bookings-history";
    }

    @GetMapping("/user/change-password")
    public String changePassword() {
        return "user/change-password";
    }

    @GetMapping("/wishlist")
    public String wishlist() {
        return "user/wishlist";
    }

    // Admin pages
    @GetMapping("/admin/users")
    public String adminUsers() {
        return "admin/users";
    }

    @GetMapping("/admin/rooms")
    public String adminRooms() {
        return "admin/rooms";
    }

    @GetMapping("/admin/bookings")
    public String adminBookings() {
        return "admin/bookings";
    }

    @GetMapping("/admin/hotels")
    public String adminHotels() {
        return "admin/hotels";
    }

    // Owner pages
    @GetMapping("/owner/hotels")
    public String ownerHotels() {
        return "owner/hotels";
    }

    @GetMapping("/owner/rooms")
    public String ownerRooms() {
        return "owner/rooms";
    }

    @GetMapping("/owner/bookings")
    public String ownerBookings() {
        return "owner/bookings";
    }

    @GetMapping("/owner/calendar")
    public String ownerCalendar() {
        return "owner/calendar";
    }

    // Contact page
    @GetMapping("/contact")
    public String contact() {
        return "contact";
    }
}

