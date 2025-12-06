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

    <style>
        .booking-details {
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            margin-top: 20px;
        }
        
        .booking-status-info {
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        
        .booking-widget {
            margin-bottom: 30px;
        }
        
        .fw-bold {
            font-weight: bold;
            color: #333;
        }
        
        .text-muted {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .badge {
            padding: 8px 15px;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .bg-success {
            background-color: #28a745 !important;
        }
        
        .bg-warning {
            background-color: #ffc107 !important;
            color: #000 !important;
        }
        
        .bg-danger {
            background-color: #dc3545 !important;
        }
        
        .bg-info {
            background-color: #17a2b8 !important;
        }
        
        .bg-secondary {
            background-color: #6c757d !important;
        }
        
        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .btn-danger:hover {
            background-color: #c82333;
            border-color: #bd2130;
        }
        
        .btn-danger:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }
        
        #roomImageContainer {
            border-radius: 8px;
            overflow: hidden;
        }
        
        #roomImage {
            width: 100%;
            height: auto;
            object-fit: cover;
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
                <h2 class="breadcrumb-title" id="pageTitle">Hotel Booking</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active" id="pageBreadcrumb">Hotel Booking</li>
                </ul>
            </div>
        </div>
        <!-- breadcrumb end -->


        <!-- hotel booking -->
        <div class="hotel-booking py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8">
                        <!-- Booking Form Section (shown when roomTypeId is provided) -->
                        <div id="bookingFormSection" style="display: none;">
                            <div class="booking-widget">
                                <h4 class="booking-widget-title">Thông tin đặt phòng</h4>
                                <form id="newBookingForm">
                                    <div id="bookingFormError" class="alert alert-danger" style="display: none;"></div>
                                    <div class="row">
                                        <div class="col-lg-6 mb-3">
                                            <div class="form-group">
                                                <label>Check In <span class="text-danger">*</span></label>
                                                <div class="form-group-icon">
                                                    <input type="date" id="bookingCheckIn" name="checkIn" class="form-control" required>
                                                    <i class="fal fa-calendar-days"></i>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <div class="form-group">
                                                <label>Check Out <span class="text-danger">*</span></label>
                                                <div class="form-group-icon">
                                                    <input type="date" id="bookingCheckOut" name="checkOut" class="form-control" required>
                                                    <i class="fal fa-calendar-days"></i>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <div class="form-group">
                                                <label>Số khách <span class="text-danger">*</span></label>
                                                <input type="number" id="bookingGuests" name="guests" class="form-control" min="1" value="2" required>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <div class="form-group">
                                                <label>Số phòng <span class="text-danger">*</span></label>
                                                <input type="number" id="numberOfRooms" name="numberOfRooms" class="form-control" min="1" value="1" required>
                                            </div>
                                        </div>
                                        <div class="col-lg-12 mb-3">
                                            <div class="form-group">
                                                <label>Tên khách <span class="text-danger">*</span></label>
                                                <input type="text" id="guestName" name="guestName" class="form-control" required>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <div class="form-group">
                                                <label>Email <span class="text-danger">*</span></label>
                                                <input type="email" id="guestEmail" name="guestEmail" class="form-control" required>
                                            </div>
                                        </div>
                                        <div class="col-lg-6 mb-3">
                                            <div class="form-group">
                                                <label>Số điện thoại <span class="text-danger">*</span></label>
                                                <input type="text" id="guestPhone" name="guestPhone" class="form-control" required>
                                            </div>
                                        </div>
                                        <div class="col-lg-12 mb-3">
                                            <div class="form-group">
                                                <label>Yêu cầu đặc biệt (tùy chọn)</label>
                                                <textarea id="specialRequests" name="specialRequests" class="form-control" rows="3" placeholder="Nhập yêu cầu đặc biệt nếu có..."></textarea>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="text-end mt-4">
                                        <button type="submit" class="theme-btn" id="submitBookingBtn">
                                            <span class="far fa-arrow-right me-2"></span>Tiếp tục đến thanh toán
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Booking Details Section (shown when bookingId is provided) -->
                        <div id="bookingDetailsSection" style="display: none;">
                        <div class="booking-widget">
                            <h4 class="booking-widget-title">Booking Confirmation</h4>
                            <div class="alert alert-success">
                                <i class="far fa-check-circle"></i> Your booking has been created successfully!
                            </div>
                            <div class="booking-details">
                                <h5>Guest Information</h5>
                                    <div class="row">
                                    <div class="col-lg-6 mb-3">
                                        <p class="text-muted mb-1">Guest Name</p>
                                        <p class="fw-bold" id="displayGuestName">-</p>
                                                </div>
                                    <div class="col-lg-6 mb-3">
                                        <p class="text-muted mb-1">Email</p>
                                        <p class="fw-bold" id="displayGuestEmail">-</p>
                                            </div>
                                    <div class="col-lg-6 mb-3">
                                        <p class="text-muted mb-1">Phone</p>
                                        <p class="fw-bold" id="displayGuestPhone">-</p>
                                        </div>
                                    <div class="col-lg-6 mb-3">
                                        <p class="text-muted mb-1">Number of Guests</p>
                                        <p class="fw-bold" id="displayGuests">-</p>
                                    </div>
                                    <div class="col-lg-6 mb-3" id="displayRoomsContainer" style="display: none;">
                                        <p class="text-muted mb-1">Number of Rooms</p>
                                        <p class="fw-bold" id="displayRooms">-</p>
                                    </div>
                                    <div class="col-lg-12 mb-3" id="displaySpecialRequestsContainer" style="display: none;">
                                        <p class="text-muted mb-1">Special Requests</p>
                                        <p class="fw-bold" id="displaySpecialRequests">-</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="booking-widget">
                            <h4 class="booking-widget-title">Booking Status</h4>
                            <div class="booking-status-info">
                                                <div class="row">
                                    <div class="col-lg-12 mb-3">
                                        <p class="text-muted mb-1">Booking Status</p>
                                        <span class="badge bg-warning" id="displayBookingStatus">-</span>
                                    </div>
                                    <div class="col-lg-12 mb-3" id="paymentInfoSection">
                                        <p class="text-muted mb-1">Payment Information</p>
                                        <p class="fw-bold text-muted">Đang tải thông tin thanh toán...</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="booking-widget" id="cancelBookingSection" style="display: none;">
                            <h4 class="booking-widget-title">Cancel Booking</h4>
                            <p>If you need to cancel this booking, please click the button below:</p>
                            <button type="button" class="btn btn-danger" id="cancelBookingBtn">
                                <i class="far fa-times-circle"></i> Cancel Booking
                            </button>
                        </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <!-- Room Info for Booking Form -->
                        <div id="roomInfoForBooking" style="display: none;">
                            <div class="booking-summary">
                                <h4 class="mb-30">Thông tin phòng</h4>
                                <!-- Content will be loaded by JavaScript -->
                            </div>
                        </div>

                        <!-- Booking Summary (shown when bookingId is provided) -->
                        <div class="booking-summary" id="bookingSummarySection" style="display: none;">
                            <h4 class="mb-30">Booking Summary</h4>
                            <div class="booking-property-img" id="roomImageContainer">
                                <img src="${pageContext.request.contextPath}/assets/img/hotel/02.jpg" alt="" id="roomImage">
                            </div>
                            <div class="booking-property-content">
                                <div class="booking-property-title">
                                    <div>
                                        <h5 id="displayRoomName">Loading...</h5>
                                        <p id="displayHotelLocation"><i class="far fa-map-marker-alt"></i> Loading...</p>
                                    </div>
                                </div>
                                <div class="booking-property-rate" id="hotelRatingSection" style="display: none;">
                                    <span class="badge"><i class="far fa-star"></i> <span id="displayHotelRating">0</span>/5</span>
                                    <span class="rate-type">Rating</span>
                                </div>
                            </div>
                            <div class="booking-info-summary">
                                <h5>Booking Details</h5>
                                <ul>
                                    <li>Booking ID: <span id="displayBookingId">-</span></li>
                                    <li>Check In: <span id="displayCheckIn">-</span></li>
                                    <li>Check Out: <span id="displayCheckOut">-</span></li>
                                    <li>Room Type: <span id="displayRoomType">-</span></li>
                                    <li>Guests: <span id="displayGuestsCount">-</span></li>
                                    <li id="displayRoomsListItem" style="display: none;">Rooms: <span id="displayRoomsCount">-</span></li>
                                    <li>Stay Duration: <span id="displayStayDuration">-</span></li>
                                </ul>
                            </div>
                            <div class="booking-order-info">
                                <div class="booking-pay-info">
                                    <h5>Payment Summary</h5>
                                    <ul>
                                        <li>Price per Night: <span id="displayPricePerNight">-</span></li>
                                        <li>Number of Nights: <span id="displayNumberOfNights">-</span></li>
                                        <li class="order-total">Total Amount: <span id="displayTotalPrice">-</span></li>
                                    </ul>
                                </div>

                                <div class="text-end mt-40">
                                    <a href="${pageContext.request.contextPath}/profile-booking-history" class="theme-btn d-block">View My Bookings<i
                                            class="fas fa-arrow-circle-right"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- hotel booking end -->

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
    <script src="${pageContext.request.contextPath}/assets/js/hotel-booking.js"></script>

</body>
</html>
