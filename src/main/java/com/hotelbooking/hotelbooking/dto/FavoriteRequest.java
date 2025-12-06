package com.hotelbooking.hotelbooking.dto;

import jakarta.validation.constraints.NotNull;

public class FavoriteRequest {
    private Long hotelId;
    
    private Long roomTypeId;

    public FavoriteRequest() {}

    public FavoriteRequest(Long hotelId, Long roomTypeId) {
        this.hotelId = hotelId;
        this.roomTypeId = roomTypeId;
    }

    public Long getHotelId() {
        return hotelId;
    }

    public void setHotelId(Long hotelId) {
        this.hotelId = hotelId;
    }

    public Long getRoomTypeId() {
        return roomTypeId;
    }

    public void setRoomTypeId(Long roomTypeId) {
        this.roomTypeId = roomTypeId;
    }
}


