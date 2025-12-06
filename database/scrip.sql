-- ============================================
-- Hotel Booking Database Schema (Redesigned)
-- Bảng: Amenity, Booking, Hotel, HotelAmenity, 
--       HotelImage, Payment, Review, RoomType, 
--       RoomTypeAmenity, RoomTypeImage, User, WishlistItem
-- ============================================

SET FOREIGN_KEY_CHECKS = 0;
-- ============================================
-- 1. USERS TABLE
-- ============================================
CREATE TABLE `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `full_name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) DEFAULT NULL,
  `role` ENUM('ADMIN', 'HOTEL_OWNER', 'USER') NOT NULL DEFAULT 'USER',
  `is_active` TINYINT(1) DEFAULT 1,
  `reset_token` VARCHAR(255) DEFAULT NULL,
  `reset_token_expiry` DATETIME DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_role` (`role`),
  KEY `idx_reset_token` (`reset_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 2. AMENITIES TABLE (Master table)
-- ============================================
CREATE TABLE `amenities` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `icon` VARCHAR(255) DEFAULT NULL COMMENT 'Icon class or image URL',
  `category` VARCHAR(50) DEFAULT NULL COMMENT 'e.g., ROOM, HOTEL, GENERAL',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_amenity_name` (`name`),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 3. HOTELS TABLE
-- ============================================
CREATE TABLE `hotels` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `owner_id` BIGINT NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `address` TEXT NOT NULL,
  `city` VARCHAR(100) NOT NULL,
  `country` VARCHAR(100) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `rating` DECIMAL(3,2) DEFAULT 0.00,
  `status` ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
  `rejection_reason` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_owner` (`owner_id`),
  KEY `idx_city` (`city`),
  KEY `idx_status` (`status`),
  KEY `idx_rating` (`rating`),
  CONSTRAINT `fk_hotels_owner` FOREIGN KEY (`owner_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 4. HOTEL_AMENITIES TABLE (Many-to-Many)
-- ============================================
CREATE TABLE `hotel_amenities` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `hotel_id` BIGINT NOT NULL,
  `amenity_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_hotel_amenity` (`hotel_id`, `amenity_id`),
  KEY `idx_hotel` (`hotel_id`),
  KEY `idx_amenity` (`amenity_id`),
  CONSTRAINT `fk_hotel_amenities_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_hotel_amenities_amenity` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 5. HOTEL_IMAGES TABLE
-- ============================================
CREATE TABLE `hotel_images` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `hotel_id` BIGINT NOT NULL,
  `image_url` VARCHAR(500) NOT NULL,
  `alt_text` VARCHAR(200) DEFAULT NULL,
  `is_primary` TINYINT(1) DEFAULT 0 COMMENT 'Primary image for hotel',
  `display_order` INT DEFAULT 0 COMMENT 'Order for display',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_hotel` (`hotel_id`),
  KEY `idx_primary` (`is_primary`),
  KEY `idx_order` (`display_order`),
  CONSTRAINT `fk_hotel_images_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 6. ROOM_TYPES TABLE (Thay thế Rooms)
-- ============================================
CREATE TABLE `room_types` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `hotel_id` BIGINT NOT NULL,
  `name` VARCHAR(200) NOT NULL,
  `description` TEXT DEFAULT NULL,
  `room_type` VARCHAR(100) NOT NULL COMMENT 'e.g., Deluxe, Suite, Standard',
  `price_per_night` DECIMAL(10,2) NOT NULL,
  `total_rooms` INT NOT NULL DEFAULT 1,
  `max_occupancy` INT NOT NULL DEFAULT 2,
  `status` ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
  `rejection_reason` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_hotel` (`hotel_id`),
  KEY `idx_status` (`status`),
  KEY `idx_price` (`price_per_night`),
  KEY `idx_room_type` (`room_type`),
  CONSTRAINT `fk_room_types_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 7. ROOM_TYPE_AMENITIES TABLE (Many-to-Many)
-- ============================================
CREATE TABLE `room_type_amenities` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `room_type_id` BIGINT NOT NULL,
  `amenity_id` BIGINT NOT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_room_type_amenity` (`room_type_id`, `amenity_id`),
  KEY `idx_room_type` (`room_type_id`),
  KEY `idx_amenity` (`amenity_id`),
  CONSTRAINT `fk_room_type_amenities_room_type` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_room_type_amenities_amenity` FOREIGN KEY (`amenity_id`) REFERENCES `amenities` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 8. ROOM_TYPE_IMAGES TABLE
-- ============================================
CREATE TABLE `room_type_images` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `room_type_id` BIGINT NOT NULL,
  `image_url` VARCHAR(500) NOT NULL,
  `alt_text` VARCHAR(200) DEFAULT NULL,
  `is_primary` TINYINT(1) DEFAULT 0 COMMENT 'Primary image for room type',
  `display_order` INT DEFAULT 0 COMMENT 'Order for display',
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_room_type` (`room_type_id`),
  KEY `idx_primary` (`is_primary`),
  KEY `idx_order` (`display_order`),
  CONSTRAINT `fk_room_type_images_room_type` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 9. BOOKINGS TABLE
-- ============================================
CREATE TABLE `bookings` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `room_type_id` BIGINT NOT NULL,
  `check_in_date` DATE NOT NULL,
  `check_out_date` DATE NOT NULL,
  `number_of_guests` INT NOT NULL DEFAULT 1,
  `number_of_rooms` INT NOT NULL DEFAULT 1,
  `total_price` DECIMAL(10,2) NOT NULL,
  `booking_status` ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
  `guest_name` VARCHAR(100) NOT NULL,
  `guest_email` VARCHAR(100) NOT NULL,
  `guest_phone` VARCHAR(20) NOT NULL,
  `special_requests` TEXT DEFAULT NULL,
  `cancellation_policy` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_room_type` (`room_type_id`),
  KEY `idx_dates` (`check_in_date`, `check_out_date`),
  KEY `idx_status` (`booking_status`),
  CONSTRAINT `fk_bookings_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_bookings_room_type` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 10. PAYMENTS TABLE
-- ============================================
CREATE TABLE `payments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `booking_id` BIGINT NOT NULL,
  `payment_method` ENUM('ONLINE', 'COD', 'AT_HOTEL', 'CREDIT_CARD', 'DEBIT_CARD', 'PAYPAL') NOT NULL,
  `payment_status` ENUM('PENDING', 'PAID', 'FAILED', 'REFUNDED', 'CANCELLED') DEFAULT 'PENDING',
  `amount` DECIMAL(10,2) NOT NULL,
  `transaction_id` VARCHAR(255) DEFAULT NULL COMMENT 'Payment gateway transaction ID',
  `payment_date` DATETIME DEFAULT NULL,
  `refund_date` DATETIME DEFAULT NULL,
  `refund_reason` TEXT DEFAULT NULL,
  `notes` TEXT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_booking` (`booking_id`),
  KEY `idx_status` (`payment_status`),
  KEY `idx_transaction` (`transaction_id`),
  CONSTRAINT `fk_payments_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 11. REVIEWS TABLE
-- ============================================
CREATE TABLE `reviews` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `booking_id` BIGINT NOT NULL,
  `room_type_id` BIGINT NOT NULL,
  `hotel_id` BIGINT NOT NULL,
  `user_id` BIGINT NOT NULL,
  `rating` INT NOT NULL CHECK (`rating` >= 1 AND `rating` <= 5),
  `comment` TEXT DEFAULT NULL,
  `is_verified` TINYINT(1) DEFAULT 0 COMMENT 'Verified booking review',
  `helpful_count` INT DEFAULT 0,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_booking_review` (`booking_id`),
  KEY `idx_room_type` (`room_type_id`),
  KEY `idx_hotel` (`hotel_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_rating` (`rating`),
  CONSTRAINT `fk_reviews_booking` FOREIGN KEY (`booking_id`) REFERENCES `bookings` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_room_type` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- 12. WISHLIST_ITEMS TABLE
-- ============================================
CREATE TABLE `wishlist_items` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `hotel_id` BIGINT DEFAULT NULL,
  `room_type_id` BIGINT DEFAULT NULL,
  `created_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_hotel` (`user_id`, `hotel_id`),
  UNIQUE KEY `uk_user_room_type` (`user_id`, `room_type_id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_hotel` (`hotel_id`),
  KEY `idx_room_type` (`room_type_id`),
  CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wishlist_hotel` FOREIGN KEY (`hotel_id`) REFERENCES `hotels` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_wishlist_room_type` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`) ON DELETE CASCADE,
  -- Ensure either hotel_id or room_type_id is set, but not both
  CONSTRAINT `chk_wishlist_type` CHECK (
    (`hotel_id` IS NOT NULL AND `room_type_id` IS NULL) OR 
    (`hotel_id` IS NULL AND `room_type_id` IS NOT NULL)
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- Insert Sample Amenities
