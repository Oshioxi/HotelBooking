package com.hotelbooking.hotelbooking.dto;

import com.hotelbooking.hotelbooking.model.Hotel;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class HotelResponse {
    private Long id;
    private Long ownerId;
    private String ownerName;
    private String ownerEmail;
    private String name;
    private String address;
    private String city;
    private String country;
    private String description;
    private BigDecimal rating;
    private Hotel.HotelStatus status;
    private String rejectionReason;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<AmenityInfo> amenities;
    private List<ImageInfo> images;

    public HotelResponse() {}

    public HotelResponse(Hotel hotel) {
        this.id = hotel.getId();
        this.ownerId = hotel.getOwnerId();
        this.name = hotel.getName();
        this.address = hotel.getAddress();
        this.city = hotel.getCity();
        this.country = hotel.getCountry();
        this.description = hotel.getDescription();
        this.rating = hotel.getRating();
        this.status = hotel.getStatus();
        this.rejectionReason = hotel.getRejectionReason();
        this.createdAt = hotel.getCreatedAt();
        this.updatedAt = hotel.getUpdatedAt();
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Long ownerId) {
        this.ownerId = ownerId;
    }

    public String getOwnerName() {
        return ownerName;
    }

    public void setOwnerName(String ownerName) {
        this.ownerName = ownerName;
    }

    public String getOwnerEmail() {
        return ownerEmail;
    }

    public void setOwnerEmail(String ownerEmail) {
        this.ownerEmail = ownerEmail;
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

    public Hotel.HotelStatus getStatus() {
        return status;
    }

    public void setStatus(Hotel.HotelStatus status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public List<AmenityInfo> getAmenities() {
        return amenities;
    }

    public void setAmenities(List<AmenityInfo> amenities) {
        this.amenities = amenities;
    }

    public List<ImageInfo> getImages() {
        return images;
    }

    public void setImages(List<ImageInfo> images) {
        this.images = images;
    }

    // Inner classes for nested data
    public static class AmenityInfo {
        private Long id;
        private String name;
        private String description;
        private String icon;
        private String category;

        public AmenityInfo() {}

        public AmenityInfo(Long id, String name, String description, String icon, String category) {
            this.id = id;
            this.name = name;
            this.description = description;
            this.icon = icon;
            this.category = category;
        }

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getDescription() {
            return description;
        }

        public void setDescription(String description) {
            this.description = description;
        }

        public String getIcon() {
            return icon;
        }

        public void setIcon(String icon) {
            this.icon = icon;
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }
    }

    public static class ImageInfo {
        private Long id;
        private String imageUrl;
        private String altText;
        private Boolean isPrimary;
        private Integer displayOrder;

        public ImageInfo() {}

        public ImageInfo(Long id, String imageUrl, String altText, Boolean isPrimary, Integer displayOrder) {
            this.id = id;
            this.imageUrl = imageUrl;
            this.altText = altText;
            this.isPrimary = isPrimary;
            this.displayOrder = displayOrder;
        }

        public Long getId() {
            return id;
        }

        public void setId(Long id) {
            this.id = id;
        }

        public String getImageUrl() {
            return imageUrl;
        }

        public void setImageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
        }

        public String getAltText() {
            return altText;
        }

        public void setAltText(String altText) {
            this.altText = altText;
        }

        public Boolean getIsPrimary() {
            return isPrimary;
        }

        public void setIsPrimary(Boolean isPrimary) {
            this.isPrimary = isPrimary;
        }

        public Integer getDisplayOrder() {
            return displayOrder;
        }

        public void setDisplayOrder(Integer displayOrder) {
            this.displayOrder = displayOrder;
        }
    }
}

