<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- meta tags -->
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="keywords" content="">

    <!-- title -->
    <title>Tavelo - Travel Booking</title>

    <!-- favicon -->
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">

    <!-- css -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery.timepicker.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <!-- Custom styles for responsive images -->
    <style>
        /* Responsive image styles */
        .listing-slider .item img,
        .room-img img {
            width: 100%;
            height: auto;
            object-fit: cover;
            display: block;
        }
        
        /* Hotel slider images */
        .listing-slider .item {
            position: relative;
            overflow: hidden;
            border-radius: 12px;
        }
        
        .listing-slider .item img {
            width: 100%;
            height: 500px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        @media (max-width: 768px) {
            .listing-slider .item img {
                height: 300px;
            }
        }
        
        @media (max-width: 576px) {
            .listing-slider .item img {
                height: 250px;
            }
        }
        
        /* Room images */
        .room-img {
            position: relative;
            overflow: hidden;
            border-radius: 12px 0 0 12px;
        }
        
        .room-img img {
            width: 100%;
            min-height: 300px;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        @media (max-width: 992px) {
            .room-img {
                border-radius: 12px 12px 0 0;
                min-height: 250px;
            }
            
            .room-img img {
                min-height: 250px;
            }
        }
        
        @media (max-width: 768px) {
            .room-img img {
                min-height: 200px;
            }
        }
        
        /* Map responsive */
        .contact-map {
            position: relative;
            width: 100%;
            overflow: hidden;
            border-radius: 12px;
        }
        
        .contact-map iframe {
            width: 100%;
            height: 400px;
            border: 0;
            display: block;
        }
        
        @media (max-width: 768px) {
            .contact-map iframe {
                height: 300px;
            }
        }
        
        @media (max-width: 576px) {
            .contact-map iframe {
                height: 250px;
            }
        }
        
        /* Image hover effects */
        .listing-slider .item:hover img,
        .room-img:hover img {
            transform: scale(1.05);
        }
        
        /* Loading placeholder */
        .image-placeholder {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: loading 1.5s infinite;
        }
        
        @keyframes loading {
            0% { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }
        
        
        /* Navigation Tabs (Traveloka Style) */
        .hotel-nav-tabs {
            border-bottom: 2px solid #e0e0e0;
            margin-bottom: 30px;
            margin-top: 30px;
        }
        
        .hotel-nav-tabs .nav-tabs {
            border-bottom: none;
        }
        
        .hotel-nav-tabs .nav-link {
            color: var(--color-dark);
            font-weight: 500;
            padding: 15px 20px;
            border: none;
            border-bottom: 3px solid transparent;
            transition: all 0.3s ease;
        }
        
        .hotel-nav-tabs .nav-link:hover {
            color: var(--theme-color);
            border-bottom-color: rgba(0, 0, 0, 0.1);
        }
        
        .hotel-nav-tabs .nav-link.active {
            color: var(--theme-color);
            border-bottom-color: var(--theme-color);
            background: transparent;
        }
        
        /* Hotel Header (Traveloka Style) */
        .hotel-header-section {
            padding: 20px 0;
        }
        
        .hotel-title-main {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--color-dark);
            margin-bottom: 10px;
        }
        
        .hotel-rating-info {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .hotel-stars {
            color: #ffc107;
        }
        
        .hotel-rating-text {
            color: #666;
            font-size: 14px;
        }
        
        .hotel-location-text {
            color: #666;
            margin: 0;
        }
        
        .hotel-header-right {
            text-align: right;
        }
        
        .hotel-price-box {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
            min-width: 250px;
        }
        
        .hotel-price-label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .hotel-price-amount {
            font-size: 24px;
            font-weight: 700;
            color: var(--theme-color);
            margin-bottom: 15px;
        }
        
        .hotel-select-room-btn {
            width: 100%;
            padding: 12px;
        }
        
        .hotel-rating-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: #fff3cd;
            padding: 10px 20px;
            border-radius: 8px;
            margin-top: 15px;
        }
        
        .rating-score {
            font-size: 24px;
            font-weight: 700;
            color: var(--color-dark);
        }
        
        .rating-label {
            font-size: 16px;
            color: #666;
        }
        
        .rating-type {
            font-weight: 600;
            color: var(--theme-color);
        }
        
        .rating-reviews {
            color: #666;
            font-size: 14px;
        }
        
        /* Section Titles */
        .section-title {
            font-size: 1.5rem;
            font-weight: 600;
            color: var(--color-dark);
        }
        
        .hotel-description-text {
            line-height: 1.8;
            color: #555;
            font-size: 15px;
        }
        
        /* Main Amenities */
        .hotel-main-amenities {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .amenity-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 10px 15px;
            background: #f8f9fa;
            border-radius: 8px;
            font-size: 14px;
        }
        
        .amenity-badge i {
            color: var(--theme-color);
        }
        
        /* Room Search Compact */
        .room-search-compact {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 12px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .hotel-title-main {
                font-size: 1.8rem;
            }
            
            .hotel-header-right {
                width: 100%;
                margin-top: 20px;
            }
            
            .hotel-price-box {
                width: 100%;
            }
        }
    </style>
</head>

<body>
    <!-- preloader -->
    <div class="preloader">
        <div class="loader">
            <span style="--i:1;"></span>
            <span style="--i:2;"></span>
            <span style="--i:3;"></span>
            <span style="--i:4;"></span>
            <span style="--i:5;"></span>
            <span style="--i:6;"></span>
            <span style="--i:7;"></span>
            <span style="--i:8;"></span>
            <span style="--i:9;"></span>
            <span style="--i:10;"></span>
            <span style="--i:11;"></span>
            <span style="--i:12;"></span>
            <span style="--i:13;"></span>
            <span style="--i:14;"></span>
            <span style="--i:15;"></span>
            <span style="--i:16;"></span>
            <span style="--i:17;"></span>
            <span style="--i:18;"></span>
            <span style="--i:19;"></span>
            <span style="--i:20;"></span>
            <div class="loader-plane"></div>
        </div>
    </div>
    <!-- preloader end -->

    <!-- Header Container -->
    <jsp:include page="components/header.jsp" />

    <main class="main">
        <!-- breadcrumb -->
        <div class="site-breadcrumb" style="background: url(${pageContext.request.contextPath}/assets/img/breadcrumb/05.jpg)">
            <div class="container">
                <h2 class="breadcrumb-title">Hotel Single</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Hotel Single</li>
                </ul>
            </div>
        </div>
        <!-- breadcrumb end -->

        <!-- hotel-single -->
        <div class="hotel-single py-120">
            <div class="container">
                <!-- Navigation Tabs (Traveloka Style) -->
                <div class="hotel-nav-tabs">
                    <ul class="nav nav-tabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#overview-tab" type="button" role="tab">
                                Tổng quan
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#rooms-tab" type="button" role="tab">
                                Phòng
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#location-tab" type="button" role="tab">
                                Vị trí
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#amenities-tab" type="button" role="tab">
                                Tiện ích
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" data-bs-toggle="tab" data-bs-target="#policies-tab" type="button" role="tab">
                                Chính sách
                            </button>
                        </li>
                    </ul>
                </div>
                
                <div class="listing-wrapper">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="listing-content">
                                <!-- Tab Content -->
                                <div class="tab-content" id="hotelTabContent">
                                    <!-- Overview Tab -->
                                    <div class="tab-pane fade show active" id="overview-tab" role="tabpanel">
                                        <!-- Hotel Images Slider -->
                                        <div class="listing-slider owl-carousel owl-theme mb-4">
                                            <div class="item image-placeholder">
                                                <img src="${pageContext.request.contextPath}/assets/img/hotel/single-1.jpg" alt="Loading..." loading="lazy">
                                            </div>
                                        </div>
                                        
                                        <!-- Hotel Header (Traveloka Style) -->
                                        <div class="hotel-header-section mb-4">
                                            <div class="d-flex justify-content-between align-items-start flex-wrap">
                                                <div class="hotel-header-left">
                                                    <h1 class="hotel-title-main" id="hotelName">Loading...</h1>
                                                    <div class="hotel-rating-info mb-2">
                                                        <div class="hotel-stars" id="hotelStars"></div>
                                                        <span class="hotel-rating-text" id="hotelRatingText"></span>
                                                    </div>
                                                    <p class="hotel-location-text" id="hotelLocation">
                                                        <i class="far fa-location-dot"></i> Loading...
                                                    </p>
                                                </div>
                                                <div class="hotel-header-right">
                                                    <div class="hotel-price-box" id="hotelPriceBox" style="display: none;">
                                                        <div class="hotel-price-label">Giá/phòng/đêm từ</div>
                                                        <div class="hotel-price-amount" id="hotelPriceAmount">-</div>
                                                        <button class="theme-btn hotel-select-room-btn" onclick="scrollToRooms()">
                                                            Chọn phòng
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="hotel-rating-badge" id="hotelRatingBadge" style="display: none;">
                                                <span class="rating-score" id="ratingScore">0.0</span>
                                                <span class="rating-label">/10</span>
                                                <span class="rating-type" id="ratingType">Xuất sắc</span>
                                                <span class="rating-reviews">(<span id="reviewCount">0</span> đánh giá)</span>
                                            </div>
                                        </div>
                                        
                                        <!-- Main Amenities -->
                                        <div class="hotel-main-amenities mb-4" id="hotelMainAmenities">
                                            <!-- Main amenities will be loaded here -->
                                        </div>
                                        
                                        <!-- Hotel Description -->
                                        <div class="hotel-description-section mb-4">
                                            <h4 class="section-title mb-3">Giới thiệu về khách sạn</h4>
                                            <div id="hotelDescription" class="hotel-description-text">Loading hotel description...</div>
                                        </div>
                                    </div>
                                    
                                    <!-- Rooms Tab -->
                                    <div class="tab-pane fade" id="rooms-tab" role="tabpanel">
                                        <div class="rooms-section">
                                            <h4 class="section-title mb-4">Những phòng còn trống tại <span id="hotelNameInRooms"></span></h4>

                                            <!-- Available Rooms List -->
                                            <div class="listing-hotel-room room-list" id="availableRoomsContainer">
                                                <div class="row" id="availableRoomsList">
                                                    <div class="col-12 text-center text-muted py-5">
                                                        <div class="spinner-border" role="status">
                                                            <span class="visually-hidden">Loading...</span>
                                                        </div>
                                                        <p class="mt-3">Đang tải danh sách phòng...</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Location Tab -->
                                    <div class="tab-pane fade" id="location-tab" role="tabpanel">
                                        <div class="location-section">
                                            <h4 class="section-title mb-4">Vị trí</h4>
                                            <div class="hotel-location-info mb-4">
                                                <p class="hotel-address" id="hotelFullAddress">-</p>
                                                <p class="text-muted"><strong>Thành phố:</strong> <span id="hotelCityInfo">-</span></p>
                                                <p class="text-muted"><strong>Quốc gia:</strong> <span id="hotelCountryInfo">-</span></p>
                                            </div>
                                            <div class="contact-map" id="hotelMap">
                                                <div class="image-placeholder" style="height: 400px; display: flex; align-items: center; justify-content: center;">
                                                    <p class="text-muted">Đang tải bản đồ...</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Amenities Tab -->
                                    <div class="tab-pane fade" id="amenities-tab" role="tabpanel">
                                        <div class="amenities-section">
                                            <h4 class="section-title mb-4">Tất cả tiện ích</h4>
                                            <div class="listing-amenity" id="hotelAllAmenitiesList">
                                                <div class="row">
                                                    <div class="col-12 text-center text-muted">Loading all amenities...</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Policies Tab -->
                                    <div class="tab-pane fade" id="policies-tab" role="tabpanel">
                                        <div class="policies-section">
                                            <h4 class="section-title mb-4">Chính sách và thông tin</h4>
                                            <div id="hotelPolicies">
                                                <div class="row">
                                                    <div class="col-md-6 mb-4">
                                                        <h6><i class="far fa-clock"></i> Thời gian nhận phòng/trả phòng</h6>
                                                        <p><strong>Giờ nhận phòng:</strong> <span id="checkInTime">Từ 14:00</span></p>
                                                        <p><strong>Giờ trả phòng:</strong> <span id="checkOutTime">Trước 12:00</span></p>
                                                    </div>
                                                    <div class="col-md-6 mb-4">
                                                        <h6><i class="far fa-info-circle"></i> Thông tin chung</h6>
                                                        <p><strong>Địa chỉ:</strong> <span id="hotelFullAddress2">-</span></p>
                                                        <p><strong>Thành phố:</strong> <span id="hotelCityInfo2">-</span></p>
                                                        <p><strong>Quốc gia:</strong> <span id="hotelCountryInfo2">-</span></p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- hotel-single end -->
    </main>

    <!-- Footer Container -->
    <jsp:include page="components/footer.jsp" />

    <!-- js -->
    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/modernizr.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/imagesloaded.pkgd.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/isotope.pkgd.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.appear.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/counter-up.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/masonry.pkgd.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/hotel-single.js"></script>
</body>
</html>
