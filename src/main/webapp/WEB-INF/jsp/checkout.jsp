<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tavelo - Checkout</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
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

    <jsp:include page="components/header.jsp" />

    <main class="main">
        <div class="site-breadcrumb" style="background: url(${pageContext.request.contextPath}/assets/img/breadcrumb/05.jpg)">
            <div class="container">
                <h2 class="breadcrumb-title">Thanh toán</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Thanh toán</li>
                </ul>
            </div>
        </div>

        <div class="checkout-area py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-8">
                        <div class="booking-widget">
                            <h4 class="booking-widget-title">Thông tin đặt phòng</h4>
                            <div id="bookingInfo" class="booking-details">
                                <div class="text-center py-5">
                                    <div class="spinner-border" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                    <p class="mt-3">Đang tải thông tin đặt phòng...</p>
                                </div>
                            </div>
                        </div>

                        <div class="booking-widget mt-4">
                            <h4 class="booking-widget-title">Phương thức thanh toán</h4>
                            <div class="booking-payment-area">
                                <ul class="nav nav-pills mb-3" id="paymentMethodTab" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link active" id="online-tab" data-bs-toggle="pill" data-bs-target="#online" type="button" role="tab">
                                            <i class="far fa-credit-card me-2"></i>Thanh toán trực tuyến
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link" id="cod-tab" data-bs-toggle="pill" data-bs-target="#cod" type="button" role="tab">
                                            <i class="far fa-money-bill me-2"></i>Thanh toán khi nhận phòng (COD)
                                        </a>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <a class="nav-link" id="athotel-tab" data-bs-toggle="pill" data-bs-target="#athotel" type="button" role="tab">
                                            <i class="far fa-building me-2"></i>Thanh toán tại khách sạn
                                        </a>
                                    </li>
                                </ul>
                                <div class="tab-content" id="paymentMethodTabContent">
                                    <div class="tab-pane fade show active" id="online" role="tabpanel">
                                        <div class="alert alert-info">
                                            <i class="far fa-info-circle"></i> Thanh toán trực tuyến sẽ được xử lý ngay lập tức. Booking của bạn sẽ được xác nhận sau khi thanh toán thành công.
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="cod" role="tabpanel">
                                        <div class="alert alert-warning">
                                            <i class="far fa-exclamation-triangle"></i> Với phương thức COD, bạn sẽ thanh toán khi đến nhận phòng. Booking của bạn sẽ ở trạng thái chờ xác nhận.
                                        </div>
                                    </div>
                                    <div class="tab-pane fade" id="athotel" role="tabpanel">
                                        <div class="alert alert-warning">
                                            <i class="far fa-exclamation-triangle"></i> Với phương thức thanh toán tại khách sạn, bạn sẽ thanh toán khi check-in. Booking của bạn sẽ ở trạng thái chờ xác nhận.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-4">
                        <div class="booking-summary">
                            <h4 class="mb-30">Tóm tắt đặt phòng</h4>
                            <div id="bookingSummary" class="booking-info-summary">
                                <div class="text-center py-3">
                                    <div class="spinner-border spinner-border-sm" role="status"></div>
                                </div>
                            </div>
                            <div class="booking-order-info mt-4">
                                <div class="booking-pay-info">
                                    <h5>Thanh toán</h5>
                                    <ul id="paymentSummary">
                                        <li>Tổng tiền: <span id="totalAmount">-</span></li>
                                    </ul>
                                </div>
                                <div class="text-end mt-40">
                                    <button type="button" class="theme-btn d-block w-100" id="processPaymentBtn">
                                        <span class="far fa-credit-card me-2"></span>Xác nhận thanh toán
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="components/footer.jsp" />

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
    <script src="${pageContext.request.contextPath}/assets/js/checkout.js"></script>
</body>
</html>





