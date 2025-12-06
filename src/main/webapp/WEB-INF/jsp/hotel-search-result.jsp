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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom.css">

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
                <h2 class="breadcrumb-title" id="resultsTitle">Search Results</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Hotel Search</li>
                </ul>
            </div>
        </div>
        <!-- breadcrumb end -->


        <!-- search area -->
        <div class="search-area search-common">
            <div class="container">
                <div class="search-wrapper">
                    <!-- hotel search -->
                    <div class="search-box hotel-search">
                        <div class="search-form">
                            <form id="searchForm" action="#">
                                <div class="hotel-search-wrapper">
                                    <div class="row g-3">
                                        <div class="col-lg-3 col-md-6">
                                            <div class="form-group">
                                                <label><i class="far fa-map-marker-alt"></i> Destination</label>
                                                <div class="form-group-icon">
                                                    <input type="text" name="destination" class="form-control"
                                                        value="" placeholder="Enter destination">
                                                </div>
                                                <p class="destination-location"></p>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6">
                                            <div class="form-group">
                                                <label><i class="far fa-calendar-check"></i> Check In</label>
                                                <div class="form-group-icon">
                                                    <input type="text" name="journey-date"
                                                        class="form-control date-picker journey-date" placeholder="Select date">
                                                </div>
                                                <p class="journey-day-name"></p>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6">
                                            <div class="form-group">
                                                <label><i class="far fa-calendar-times"></i> Check Out</label>
                                                <div class="form-group-icon">
                                                    <input type="text" name="return-date"
                                                        class="form-control date-picker return-date" placeholder="Select date">
                                                </div>
                                                <p class="return-day-name"></p>
                                            </div>
                                        </div>
                                        <div class="col-lg-3 col-md-6">
                                            <div class="form-group dropdown passenger-box">
                                                <div class="passenger-class">
                                                    <label><i class="far fa-users"></i> Guests</label>
                                                    <div class="form-group-icon">
                                                        <div class="passenger-total">
                                                            <span class="passenger-total-amount">2</span>
                                                            <span>Guests</span>
                                                            <div class="passenger-qty">
                                                                <button type="button" class="minus-btn guest-minus-btn"><i
                                                                        class="far fa-minus"></i></button>
                                                                <input type="hidden" name="totalGuests" class="passenger-total-amount-input" value="2">
                                                                <button type="button" class="plus-btn guest-plus-btn"><i
                                                                        class="far fa-plus"></i></button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="search-btn-wrapper">
                                        <button type="submit" class="theme-btn search-now-btn">
                                            <i class="far fa-search"></i>
                                            <span>Search Now</span>
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    <!-- hotel search end -->
                </div>
            </div>
        </div>
        <!-- search area end -->


        <!-- hotel grid -->
        <div class="hotel-grid py-120">
            <div class="container">
                <div class="row">
                    <!-- hotel booking sidebar -->
                    <div class="col-lg-4 col-xl-4 mb-4">
                        <div class="booking-sidebar">
                            <div class="booking-item">
                                <h4 class="booking-title">Facilities</h4>
                                <div class="facility" id="facilitiesContainer">
                                    <!-- Facilities will be loaded dynamically from room amenities -->
                                    <div class="text-muted small">Loading facilities...</div>
                                </div>
                            </div>
                            <div class="booking-item">
                                <h4 class="booking-title">Hotel Price</h4>
                                <div class="hotel-price">
                                    <div class="price-range-slider">
                                        <div class="price-range-info">
                                            <label for="priceRange1">Price:</label>
                                            <input type="text" class="priceRange" id="priceRange1" readonly>
                                        </div>
                                        <div id="price-range1" class="price-range slider"></div>
                                    </div>
                                </div>
                            </div>
                            <div class="booking-item">
                                <h4 class="booking-title">Hotel Star</h4>
                                <div class="hotel-star" id="hotelStarContainer">
                                    <!-- Hotel stars will be populated dynamically from hotel ratings -->
                                </div>
                            </div>
                            <div class="booking-item">
                                <h4 class="booking-title">Review Score</h4>
                                <div class="review-score" id="reviewScoreContainer">
                                    <!-- Review scores will be populated dynamically from reviews ratings -->
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- hotel booking grid -->
                    <div class="col-lg-8 col-xl-8">
                        <div class="col-md-12">
                            <div class="booking-sort">
                                <h5 id="resultsCount">Loading...</h5>
                                <div class="booking-sort-list-grid">
                                    <a class="booking-sort-grid active" href="${pageContext.request.contextPath}/hotel-search-result"><i
                                            class="far fa-grid-2"></i></a>
                                    <a class="booking-sort-list" href="${pageContext.request.contextPath}/hotel-search-result"><i
                                            class="far fa-list-ul"></i></a>
                                </div>
                                <div class="col-md-3 booking-sort-box">
                                    <select class="select">
                                        <option value="1">Sort By Default</option>
                                        <option value="2">Sort By Popular</option>
                                        <option value="3">Sort By Low Price</option>
                                        <option value="4">Sort By High Price</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="row" id="hotelsContainer">
                            <!-- Hotels will be loaded here by JavaScript -->
                            <div class="col-12 text-center py-5">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading hotels...</span>
                                </div>
                                <p class="mt-3 text-muted">Đang tải danh sách khách sạn...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- hotel grid end -->

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
    <script src="${pageContext.request.contextPath}/assets/js/currency-config.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/hotel-search.js"></script>

</body>
</html>
