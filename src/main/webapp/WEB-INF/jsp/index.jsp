<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">


<!-- Mirrored from live.themewild.com/tavelo/ by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 28 Aug 2025 08:29:09 GMT -->
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


    <!-- Header -->
    <jsp:include page="components/header.jsp" />



    <main class="main">

        <!-- hero area -->
        <div class="hero-section">
            <div class="hero-single" style="background: url(${pageContext.request.contextPath}/assets/img/hero/hero-1.jpg)">
                <div class="container">
                    <div class="row align-items-center">
                        <div class="col-lg-12 mx-auto">
                            <div class="hero-content text-center">
                                <div class="hero-content-wrapper">
                                <h1 class="hero-title">Find Your Perfect Hotel</h1>
                                <p>Discover amazing hotels and book your stay with the best prices</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- hero area end -->


        <!-- search area -->
        <div class="search-area">
            <div class="container">
                <div class="search-wrapper">
                    <!-- search header -->
                    <div class="search-header">
                        <div class="search-nav">
                            <ul class="nav nav-pills" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="pills-tab-2" data-bs-toggle="pill"
                                        data-bs-target="#pills-2" type="button" role="tab" aria-controls="pills-2"
                                        aria-selected="true"><i class="far fa-hotel"></i>Hotels</button>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <!-- search header end -->

                    <!-- tab content -->
                    <div class="tab-content" id="pills-tabContent">
                        <!-- Hotels tab -->
                        <div class="tab-pane fade show active" id="pills-2" role="tabpanel" aria-labelledby="pills-tab-2"
                            tabindex="0">
                            <div class="hotel-search">
                                <div class="search-form">
                                    <form id="hotelSearchForm" action="${pageContext.request.contextPath}/hotel-search-result" method="get">
                                        <div class="hotel-search-wrapper">
                                            <div class="row g-3">
                                                <div class="col-lg-3 col-md-6">
                                                    <div class="form-group" style="position: relative;">
                                                        <label><i class="far fa-map-marker-alt"></i> Destination</label>
                                                        <div class="form-group-icon">
                                                            <input type="text" name="city" id="searchCity" class="form-control"
                                                                placeholder="Tìm khách sạn hoặc thành phố..." required autocomplete="off">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-3 col-md-6">
                                                    <div class="form-group">
                                                        <label><i class="far fa-calendar-check"></i> Check In</label>
                                                        <div class="form-group-icon">
                                                            <input type="date" name="checkIn" id="searchCheckIn"
                                                                class="form-control date-picker journey-date" required>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-3 col-md-6">
                                                    <div class="form-group">
                                                        <label><i class="far fa-calendar-times"></i> Check Out</label>
                                                        <div class="form-group-icon">
                                                            <input type="date" name="checkOut" id="searchCheckOut"
                                                                class="form-control date-picker return-date" required>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-3 col-md-6">
                                                    <div class="form-group dropdown passenger-box">
                                                        <div class="passenger-class">
                                                            <label><i class="far fa-users"></i> Guests</label>
                                                            <div class="form-group-icon">
                                                                <div class="passenger-total">
                                                                    <span class="passenger-total-amount" id="searchGuests">2</span>
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
                        </div>
                    </div>
                    <!-- tab content end -->
                </div>
            </div>
        </div>
        <!-- search area end -->


        <!-- about-area -->
        <div class="about-area py-120">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <div class="about-left wow fadeInLeft" data-wow-delay=".25s">
                            <div class="about-img">
                                <div class="row">
                                    <div class="col-6">
                                        <img class="img-1" src="${pageContext.request.contextPath}/assets/img/about/01.jpg" alt="">
                                    </div>
                                    <div class="col-6">
                                        <img class="img-2" src="${pageContext.request.contextPath}/assets/img/about/02.jpg" alt="">
                                    </div>
                                </div>
                            </div>
                            <div class="about-experience">
                                <h5>30<span>+</span></h5>
                                <p>Years Of Experience</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="about-right wow fadeInUp" data-wow-delay=".25s">
                            <div class="site-heading mb-3">
                                <span class="site-title-tagline"><i class="far fa-hotel"></i> About Us</span>
                                <h2 class="site-title">We Are The World <span>Best Hotel Booking</span> Platform
                                </h2>
                            </div>
                            <p class="about-text">Discover and book the perfect hotel for your stay. We offer a wide selection of hotels worldwide with the best prices and excellent customer service. Whether you're traveling for business or leisure, find your ideal accommodation with us.</p>
                            <div class="about-content">
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="about-item">
                                            <div class="icon">
                                                <img src="${pageContext.request.contextPath}/assets/img/icon/deal.svg" alt="">
                                            </div>
                                            <div class="content">
                                                <h6>Get Your Best Deals</h6>
                                                <p>Take a look at our up of the round shows</p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="about-item">
                                            <div class="icon">
                                                <img src="${pageContext.request.contextPath}/assets/img/icon/booking.svg" alt="">
                                            </div>
                                            <div class="content">
                                                <h6>Easy To Booking</h6>
                                                <p>Take a look at our up of the round shows</p>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <a href="${pageContext.request.contextPath}/about" class="theme-btn">Discover More <i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- about-area end -->


        <!-- feature area -->
        <div class="feature-area pb-120">
            <div class="container">
                <div class="feature-wrapper">
                    <div class="row g-4">
                        <div class="col-lg-6 col-xl-4">
                            <div class="wow fadeInLeft" data-wow-delay=".25s">
                                <div class="site-heading mb-3">
                                    <span class="site-title-tagline"><i class="far fa-hotel"></i> Features</span>
                                    <h2 class="site-title">Let's Check Our <span>Awesome</span> Features</h2>
                                </div>
                                <p>
                                    Our hotel booking platform offers the best features to make your travel experience seamless. From easy search and booking to secure payments and 24/7 customer support, we ensure you have everything you need for a perfect stay.
                                </p>
                                <a href="${pageContext.request.contextPath}/contact" class="theme-btn mt-30">Learn More <i
                                        class="fas fa-arrow-circle-right"></i></a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-xl-4">
                            <div class="feature-img wow fadeInUp" data-wow-delay=".25s">
                                <img src="${pageContext.request.contextPath}/assets/img/feature/01.jpg" alt="">
                            </div>
                        </div>
                        <div class="col-lg-6 col-xl-4">
                            <div class="wow fadeInRight" data-wow-delay=".25s">
                                <div class="feature-item">
                                    <div class="feature-icon">
                                        <img src="${pageContext.request.contextPath}/assets/img/icon/world.svg" alt="">
                                    </div>
                                    <div class="feature-content">
                                        <h4 class="feature-title">Worldwide Coverage</h4>
                                        <p>It is a long established fact that reader will of page when looking at its
                                            layout.</p>
                                    </div>
                                </div>
                                <div class="feature-item mt-20">
                                    <div class="feature-icon">
                                        <img src="${pageContext.request.contextPath}/assets/img/icon/quality.svg" alt="">
                                    </div>
                                    <div class="feature-content">
                                        <h4 class="feature-title">Best Quality Services</h4>
                                        <p>It is a long established fact that reader will of page when looking at its
                                            layout.</p>
                                    </div>
                                </div>
                                <div class="feature-item mt-20">
                                    <div class="feature-icon">
                                        <img src="${pageContext.request.contextPath}/assets/img/icon/support.svg" alt="">
                                    </div>
                                    <div class="feature-content">
                                        <h4 class="feature-title">24/7 Customer Service</h4>
                                        <p>It is a long established fact that reader will of page when looking at its
                                            layout.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- feature area end -->


        <


        <!-- counter area -->
        <!-- <div class="counter-area counter-negative">
            <div class="col-lg-11 col-xl-9">
                <div class="counter-wrap">
                    <div class="row">
                        <div class="col-lg-3 col-sm-6">
                            <div class="counter-box">
                                <div class="icon">
                                    <img src="${pageContext.request.contextPath}/assets/img/icon/booking-confirm.svg" alt="">
                                </div>
                                <div class="counter-content">
                                    <div class="counter-number">
                                        <span class="counter" data-count="+" data-to="120" data-speed="3000">120</span>
                                        <span class="counter-sign">k</span>
                                    </div>
                                    <h6 class="title">Booking Done</h6>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-sm-6">
                            <div class="counter-box">
                                <div class="icon">
                                    <img src="${pageContext.request.contextPath}/assets/img/icon/destination.svg" alt="">
                                </div>
                                <div class="counter-content">
                                    <div class="counter-number">
                                        <span class="counter" data-count="+" data-to="200" data-speed="3000">200</span>
                                        <span class="counter-sign">+</span>
                                    </div>
                                    <h6 class="title">Hotel Destinations</h6>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-sm-6">
                            <div class="counter-box">
                                <div class="icon">
                                    <img src="${pageContext.request.contextPath}/assets/img/icon/rating.svg" alt="">
                                </div>
                                <div class="counter-content">
                                    <div class="counter-number">
                                        <span class="counter" data-count="+" data-to="40" data-speed="3000">40</span>
                                        <span class="counter-sign">k</span>
                                    </div>
                                    <h6 class="title">Happy Clients</h6>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-3 col-sm-6">
                            <div class="counter-box">
                                <div class="icon">
                                    <img src="${pageContext.request.contextPath}/assets/img/icon/partner.svg" alt="">
                                </div>
                                <div class="counter-content">
                                    <div class="counter-number">
                                        <span class="counter" data-count="+" data-to="180" data-speed="3000">180</span>
                                        <span class="counter-sign">+</span>
                                    </div>
                                    <h6 class="title">Our Partners</h6>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div> -->
        <!-- counter area end -->


        <!-- hotel area -->
        <div class="hotel-area bg pt-80 pb-80">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 mx-auto wow fadeInDown" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="site-heading text-center">
                            <span class="site-title-tagline"><i class="far fa-plane"></i> Hotel</span>
                            <h2 class="site-title">Our Most Popular Hotels</h2>
                        </div>
                    </div>
                </div>
                <div class="row" id="featuredRooms">
                    <!-- Featured rooms will be loaded here by JavaScript from API -->
                    <div class="col-12 text-center">
                        <p class="text-muted">Loading featured rooms...</p>
                    </div>
                </div>
            </div>
        </div>
        <!-- hotel area end -->


        <!-- video-area -->
        <div class="video-area py-120">
            <div class="container-fluid pe-0 p-lg-0">
                <div class="col-lg-10 ms-lg-auto">
                    <div class="row g-4 align-items-center">
                        <div class="col-md-8 col-lg-4 wow fadeInLeft" data-wow-delay=".25s">
                            <div class="site-heading mb-3">
                                <span class="site-title-tagline"><i class="far fa-plane"></i> Our Video</span>
                                <h2 class="site-title">
                                    Let's Check Our <span>Latest Update</span> And Video
                                </h2>
                            </div>
                            <p class="about-text">
                                There are many variations of passages available but the majority have suffered
                                alteration in some form injected humour if you are going to use passage you need sure
                                there
                                isn't anything look even slightly believable.
                            </p>
                            <a href="${pageContext.request.contextPath}/about" class="theme-btn mt-30">Learn More<i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                        <div class="col-lg-8 wow fadeInRight" data-wow-delay=".25s">
                            <div class="video-content" style="background-image: url(${pageContext.request.contextPath}/assets/img/video/01.jpg);">
                                <div class="row align-items-center">
                                    <div class="col-lg-12">
                                        <div class="video-wrapper">
                                            <a class="play-btn popup-youtube"
                                                href="https://www.youtube.com/watch?v=jLS3DrTJrpI">
                                                <i class="fas fa-play"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- video-area end -->


        <!-- banner area -->
        <div class="banner-area bg pt-50 pb-50">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 mx-auto wow fadeInDown" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="site-heading text-center">
                            <span class="site-title-tagline"><i class="far fa-plane"></i> Offers</span>
                            <h2 class="site-title">Let's Check Exclusive Offers</h2>
                        </div>
                    </div>
                </div>
                <div class="banner-slider owl-carousel owl-theme">
                    <div class="banner-item">
                        <div class="banner-img">
                            <img src="${pageContext.request.contextPath}/assets/img/banner/01.jpg" alt="">
                        </div>
                        <div class="banner-content">
                            <h6>Get Upto <span>70%</span> Discount!</h6>
                            <p>It is a long established fact that reader distracted.</p>
                            <a href="${pageContext.request.contextPath}/contact" class="theme-btn">Learn More<i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <div class="banner-item">
                        <div class="banner-img">
                            <img src="${pageContext.request.contextPath}/assets/img/banner/02.jpg" alt="">
                        </div>
                        <div class="banner-content">
                            <h6>Get Upto <span>70%</span> Discount!</h6>
                            <p>It is a long established fact that reader distracted.</p>
                            <a href="${pageContext.request.contextPath}/contact" class="theme-btn">Learn More<i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <div class="banner-item">
                        <div class="banner-img">
                            <img src="${pageContext.request.contextPath}/assets/img/banner/03.jpg" alt="">
                        </div>
                        <div class="banner-content">
                            <h6>Get Upto <span>70%</span> Discount!</h6>
                            <p>It is a long established fact that reader distracted.</p>
                            <a href="${pageContext.request.contextPath}/contact" class="theme-btn">Learn More<i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <div class="banner-item">
                        <div class="banner-img">
                            <img src="${pageContext.request.contextPath}/assets/img/banner/04.jpg" alt="">
                        </div>
                        <div class="banner-content">
                            <h6>Get Upto <span>70%</span> Discount!</h6>
                            <p>It is a long established fact that reader distracted.</p>
                            <a href="${pageContext.request.contextPath}/contact" class="theme-btn">Learn More<i
                                    class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- banner area end -->


        <!-- popular hotels area -->
        <div class="tour-area py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12 mx-auto wow fadeInDown" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="site-heading-inline mb-50">
                            <div>
                                <span class="site-title-tagline"><i class="far fa-hotel"></i> Hotels</span>
                                <h2 class="site-title">Our Most Popular Hotels</h2>
                            </div>
                            <div class="filter-controls">
                                <ul class="filter-btns">
                                    <li class="active" data-filter="*">All Hotels</li>
                                    <li data-filter=".star5">5 Star</li>
                                    <li data-filter=".star4">4 Star</li>
                                    <li data-filter=".star3">3 Star</li>
                                    <li data-filter=".star2">2 Star</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row filter-box" id="popularHotelsContainer">
                    <div class="col-12 text-center">
                        <p class="text-muted">Loading hotels...</p>
                            </div>
                                </div>
                                </div>
                                    </div>
        <!-- popular hotels area end -->


        <!-- cta-area -->
        <div class="cta-area">
            <div class="container">
                <div class="cta-wrapper">
                    <div class="col-md-10 col-lg-8 col-xl-6 mx-auto">
                        <div class="cta-content">
                            <div class="cta-text">
                                <h1>First Booking <span>Get 70%</span> Discount!</h1>
                                <p>It is a long established fact that a reader will be distracted by the readable
                                    content web page editors now use of a page when looking at its layout.</p>
                            </div>
                            <a href="${pageContext.request.contextPath}/contact" class="theme-btn mt-20">Book Now <i class="fas fa-arrow-circle-right"></i></a>
                        </div>
                    </div>
                    <div class="cta-img">
                        <img class="w-100" src="${pageContext.request.contextPath}/assets/img/cta/01.jpg" alt="">
                    </div>
                </div>
            </div>
        </div>
        <!-- cta-area end -->


        <!-- choose area -->
        <div class="choose-area py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 mx-auto wow fadeInDown" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="site-heading text-center">
                            <span class="site-title-tagline"><i class="far fa-plane"></i> Why Choose Us</span>
                            <h2 class="site-title">Discover Beautiful Place With Us</h2>
                        </div>
                    </div>
                </div>
                <div class="row align-items-center">
                    <div class="col-lg-6 wow fadeInLeft" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="choose-item">
                            <span class="count">01</span>
                            <div class="icon">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/safety.svg" alt="">
                            </div>
                            <div class="content">
                                <h4>Safety And Trust</h4>
                                <p>It is a long established fact that a reader will be distracted by the readable
                                    content of a page when looking at its layout.</p>
                            </div>
                        </div>
                        <div class="choose-item">
                            <span class="count">02</span>
                            <div class="icon">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/price.svg" alt="">
                            </div>
                            <div class="content">
                                <h4>100% Price Transparency</h4>
                                <p>It is a long established fact that a reader will be distracted by the readable
                                    content of a page when looking at its layout.</p>
                            </div>
                        </div>
                        <div class="choose-item">
                            <span class="count">03</span>
                            <div class="icon">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/booking-confirm.svg" alt="">
                            </div>
                            <div class="content">
                                <h4>Travel With More Confidence</h4>
                                <p>It is a long established fact that a reader will be distracted by the readable
                                    content of a page when looking at its layout.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6 wow fadeInRight" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="choose-img">
                            <img class="shape" src="${pageContext.request.contextPath}/assets/img/shape/04.png" alt="">
                            <img class="img-1" src="${pageContext.request.contextPath}/assets/img/choose/01.jpg" alt="">
                            <img class="img-2" src="${pageContext.request.contextPath}/assets/img/choose/02.jpg" alt="">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- choose area end -->


        


        <!-- team-area -->
        <div class="team-area py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-6 mx-auto wow fadeInDown" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="site-heading text-center">
                            <span class="site-title-tagline"><i class="far fa-plane"></i> Our Team</span>
                            <h2 class="site-title">Meet With Our Experts Team</h2>
                        </div>
                    </div>
                </div>
                <div class="row g-5">
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="team-item wow fadeInUp" data-wow-duration="1s" data-wow-delay=".25s">
                            <div class="team-img">
                                <img src="${pageContext.request.contextPath}/assets/img/team/01.jpg" alt="thumb">
                            </div>
                            <div class="team-content">
                                <div class="team-bio">
                                    <h5><a href="#">Edna Craig</a></h5>
                                    <span>Head of Design</span>
                                </div>
                                <div class="team-social">
                                    <ul class="team-social-btn">
                                        <li><span><i class="far fa-share-alt"></i></span></li>
                                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                        <li><a href="#"><i class="fab fa-x-twitter"></i></a></li>
                                        <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="team-item wow fadeInUp" data-wow-duration="1s" data-wow-delay=".50s">
                            <div class="team-img">
                                <img src="${pageContext.request.contextPath}/assets/img/team/02.jpg" alt="thumb">
                            </div>
                            <div class="team-content">
                                <div class="team-bio">
                                    <h5><a href="#">Jeffrey Cox</a></h5>
                                    <span>Founder & Director</span>
                                </div>
                                <div class="team-social">
                                    <ul class="team-social-btn">
                                        <li><span><i class="far fa-share-alt"></i></span></li>
                                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                        <li><a href="#"><i class="fab fa-x-twitter"></i></a></li>
                                        <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="team-item wow fadeInUp" data-wow-duration="1s" data-wow-delay=".75s">
                            <div class="team-img">
                                <img src="${pageContext.request.contextPath}/assets/img/team/03.jpg" alt="thumb">
                            </div>
                            <div class="team-content">
                                <div class="team-bio">
                                    <h5><a href="#">Audrey Gadis</a></h5>
                                    <span>Sales Support</span>
                                </div>
                                <div class="team-social">
                                    <ul class="team-social-btn">
                                        <li><span><i class="far fa-share-alt"></i></span></li>
                                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                        <li><a href="#"><i class="fab fa-x-twitter"></i></a></li>
                                        <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-4 col-xl-3">
                        <div class="team-item wow fadeInUp" data-wow-duration="1s" data-wow-delay="1s">
                            <div class="team-img">
                                <img src="${pageContext.request.contextPath}/assets/img/team/04.jpg" alt="thumb">
                            </div>
                            <div class="team-content">
                                <div class="team-bio">
                                    <h5><a href="#">Rodger Garza</a></h5>
                                    <span>Account Manager</span>
                                </div>
                                <div class="team-social">
                                    <ul class="team-social-btn">
                                        <li><span><i class="far fa-share-alt"></i></span></li>
                                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                                        <li><a href="#"><i class="fab fa-x-twitter"></i></a></li>
                                        <li><a href="#"><i class="fab fa-instagram"></i></a></li>
                                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- team-area end -->


        <!-- download area -->
        <div class="download-area pb-120">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-lg-6">
                        <div class="download-img wow fadeInUp" data-wow-duration="1s" data-wow-delay=".25s">
                            <img src="${pageContext.request.contextPath}/assets/img/download/01.png" alt="">
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="download-content wow fadeInDown" data-wow-duration="1s" data-wow-delay=".25s">
                            <div class="site-heading mb-0">
                                <span class="site-title-tagline"><i class="far fa-plane"></i> Download</span>
                                <h2 class="site-title">Tavelo Android and IOS App is Available! Download Now</h2>
                                <p>There are many variations of passages contrary to popular belief available the but
                                    the majority have suffered alteration in some form by injected humour.</p>
                                <ul class="download-feature">
                                    <li><i class="far fa-check"></i> At vero accusamus iusto odio ducimus blanditii</li>
                                    <li><i class="far fa-check"></i> Sed perspiciatis unde omnis iste natu sit
                                        voluptatem</li>
                                    <li><i class="far fa-check"></i> Nor again is anyone who loves pursues desires</li>
                                </ul>
                                <div class="download-link">
                                    <a href="#"><img src="${pageContext.request.contextPath}/assets/img/download/google-play.png" alt=""></a>
                                    <a href="#"><img src="${pageContext.request.contextPath}/assets/img/download/app-store.png" alt=""></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- download area end -->


        <!-- testimonial area -->
        <div class="testimonial-area ts-bg py-120">
            <div class="shadow-text">tavelo</div>
            <div class="container pb-30">
                <div class="row">
                    <div class="col-lg-6 mx-auto wow fadeInDown" data-wow-duration="1s" data-wow-delay=".25s">
                        <div class="site-heading text-center mb-4">
                            <span class="site-title-tagline"><i class="far fa-plane"></i> Testimonials</span>
                            <h2 class="site-title text-white">What Our Customers Are Saying About Us?</h2>
                        </div>
                    </div>
                </div>
                <div class="testimonial-slider owl-carousel owl-theme wow fadeInUp" data-wow-duration="1s"
                    data-wow-delay=".25s">
                    <div class="testimonial-single">
                        <div class="testimonial-content">
                            <div class="testimonial-author-img">
                                <img src="${pageContext.request.contextPath}/assets/img/testimonial/01.jpg" alt="">
                            </div>
                        </div>
                        <div class="testimonial-quote">
                            <span class="count">01</span>
                            <div class="testimonial-author-info">
                                <h4>Diana Carter</h4>
                                <p>Our Clients</p>
                            </div>
                            <p>
                                There are many variations passages of available but to the majority have
                                suffered for the alteration in some form injected humour words which look even slig
                                believable.
                            </p>
                            <div class="testimonial-quote-icon">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/quote.svg" alt="">
                            </div>
                            <div class="testimonial-rate">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-single">
                        <div class="testimonial-content">
                            <div class="testimonial-author-img">
                                <img src="${pageContext.request.contextPath}/assets/img/testimonial/02.jpg" alt="">
                            </div>
                        </div>
                        <div class="testimonial-quote">
                            <span class="count">02</span>
                            <div class="testimonial-author-info">
                                <h4>Brandon Wigfall</h4>
                                <p>Our Clients</p>
                            </div>
                            <p>
                                There are many variations passages of available but to the majority have
                                suffered for the alteration in some form injected humour words which look even slig
                                believable.
                            </p>
                            <div class="testimonial-quote-icon">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/quote.svg" alt="">
                            </div>
                            <div class="testimonial-rate">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-single">
                        <div class="testimonial-content">
                            <div class="testimonial-author-img">
                                <img src="${pageContext.request.contextPath}/assets/img/testimonial/03.jpg" alt="">
                            </div>
                        </div>
                        <div class="testimonial-quote">
                            <span class="count">03</span>
                            <div class="testimonial-author-info">
                                <h4>Sylvia Green</h4>
                                <p>Our Clients</p>
                            </div>
                            <p>
                                There are many variations passages of available but to the majority have
                                suffered for the alteration in some form injected humour words which look even slig
                                believable.
                            </p>
                            <div class="testimonial-quote-icon">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/quote.svg" alt="">
                            </div>
                            <div class="testimonial-rate">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-single">
                        <div class="testimonial-content">
                            <div class="testimonial-author-img">
                                <img src="${pageContext.request.contextPath}/assets/img/testimonial/04.jpg" alt="">
                            </div>
                        </div>
                        <div class="testimonial-quote">
                            <span class="count">04</span>
                            <div class="testimonial-author-info">
                                <h4>Miguel Woodworth</h4>
                                <p>Our Clients</p>
                            </div>
                            <p>
                                There are many variations passages of available but to the majority have
                                suffered for the alteration in some form injected humour words which look even slig
                                believable.
                            </p>
                            <div class="testimonial-quote-icon">
                                <img src="${pageContext.request.contextPath}/assets/img/icon/quote.svg" alt="">
                            </div>
                            <div class="testimonial-rate">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- testimonial area end -->


        


        <!-- partner area -->
        <div class="partner-area">
            <div class="col-lg-8">
                <div class="partner-wrap partner-negative">
                    <div class="col-lg-11 mx-auto">
                        <div class="partner-slider owl-carousel owl-theme">
                            <img src="${pageContext.request.contextPath}/assets/img/partner/01.png" alt="thumb">
                            <img src="${pageContext.request.contextPath}/assets/img/partner/02.png" alt="thumb">
                            <img src="${pageContext.request.contextPath}/assets/img/partner/03.png" alt="thumb">
                            <img src="${pageContext.request.contextPath}/assets/img/partner/04.png" alt="thumb">
                            <img src="${pageContext.request.contextPath}/assets/img/partner/01.png" alt="thumb">
                            <img src="${pageContext.request.contextPath}/assets/img/partner/02.png" alt="thumb">
                            <img src="${pageContext.request.contextPath}/assets/img/partner/03.png" alt="thumb">
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- partner area end -->

    </main>


    <!-- Footer -->
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
    <script src="${pageContext.request.contextPath}/assets/js/index.js"></script>

</body>


<!-- Mirrored from live.themewild.com/tavelo/ by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 28 Aug 2025 08:30:07 GMT -->
</html>

