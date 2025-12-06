package com.hotelbooking.hotelbooking.dto;

import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import java.math.BigDecimal;

public class HotelRequest {
    @NotNull(message = "Owner ID is required")
    @Positive(message = "Owner ID must be positive")
    private Long ownerId;
    
    @NotBlank(message = "Hotel name is required")
    @jakarta.validation.constraints.Size(max = 200, message = "Hotel name must not exceed 200 characters")
    private String name;
    
    @NotBlank(message = "Address is required")
    private String address;
    
    @NotBlank(message = "City is required")
    @jakarta.validation.constraints.Size(max = 100, message = "City must not exceed 100 characters")
    private String city;
    
    @NotBlank(message = "Country is required")
    @jakarta.validation.constraints.Size(max = 100, message = "Country must not exceed 100 characters")
    private String country;
    
    private String description;
    
    @DecimalMin(value = "0.0", message = "Rating must be at least 0.0")
    @DecimalMax(value = "5.0", message = "Rating must be at most 5.0")
    private BigDecimal rating;

    public HotelRequest() {}

    public Long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public void setRating(BigDecimal rating) {
        this.rating = rating;
    }
}

