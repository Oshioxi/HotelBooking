package com.hotelbooking.hotelbooking.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import java.time.LocalDate;

public class BookingRequest {
    @NotNull(message = "Room type ID is required")
    @Positive(message = "Room type ID must be positive")
    private Long roomTypeId;
    
    @NotNull(message = "Check-in date is required")
    private LocalDate checkInDate;
    
    @NotNull(message = "Check-out date is required")
    private LocalDate checkOutDate;
    
    @NotNull(message = "Number of guests is required")
    @Min(value = 1, message = "Number of guests must be at least 1")
    private Integer numberOfGuests;
    
    @NotNull(message = "Number of rooms is required")
    @Min(value = 1, message = "Number of rooms must be at least 1")
    private Integer numberOfRooms = 1;
    
    @NotBlank(message = "Guest name is required")
    @jakarta.validation.constraints.Size(max = 100, message = "Guest name must not exceed 100 characters")
    private String guestName;
    
    @NotBlank(message = "Guest email is required")
    @Email(message = "Guest email should be valid")
    @jakarta.validation.constraints.Size(max = 100, message = "Guest email must not exceed 100 characters")
    private String guestEmail;
    
    @NotBlank(message = "Guest phone is required")
    @jakarta.validation.constraints.Size(max = 20, message = "Guest phone must not exceed 20 characters")
    private String guestPhone;
    
    private String specialRequests;

    public BookingRequest() {}

    public Long getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(Long roomTypeId) {
        this.roomTypeId = roomTypeId;
    }

    public LocalDate getCheckInDate() {
        return checkInDate;
    }

    public void setCheckInDate(LocalDate checkInDate) {
        this.checkInDate = checkInDate;
    }

    public LocalDate getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(LocalDate checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public Integer getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(Integer numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
    }

    public Integer getNumberOfRooms() {
        return numberOfRooms;
    }

    public void setNumberOfRooms(Integer numberOfRooms) {
        this.numberOfRooms = numberOfRooms;
    }

    public String getGuestName() {
        return guestName;
    }

    public void setGuestName(String guestName) {
        this.guestName = guestName;
    }

    public String getGuestEmail() {
        return guestEmail;
    }

    public void setGuestEmail(String guestEmail) {
        this.guestEmail = guestEmail;
    }

    public String getGuestPhone() {
        return guestPhone;
    }

    public void setGuestPhone(String guestPhone) {
        this.guestPhone = guestPhone;
    }

    public String getSpecialRequests() {
        return specialRequests;
    }

    public void setSpecialRequests(String specialRequests) {
        this.specialRequests = specialRequests;
    }
}

