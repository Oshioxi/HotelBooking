<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">


<!-- Mirrored from live.themewild.com/tavelo/dashboard.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 28 Aug 2025 08:31:01 GMT -->
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


    <!-- Header Container -->
    <jsp:include page="components/header.jsp" />



    <main class="main">

        <!-- breadcrumb -->
        <div class="site-breadcrumb" style="background: url(${pageContext.request.contextPath}/assets/img/breadcrumb/01.jpg)">
            <div class="container">
                <h2 class="breadcrumb-title">Dashboard</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Dashboard</li>
                </ul>
            </div>
        </div>
        <!-- breadcrumb end -->


        <!-- user-dashboard -->
        <div class="user-profile py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3">
                        <jsp:include page="components/sidebar.jsp" />
                    </div>
                    <div class="col-lg-9">
                        <div class="user-profile-wrapper">
                            <div class="row">
                                <div class="col-md-6 col-lg-3">
                                    <div class="dashboard-widget dashboard-widget-color-1">
                                        <div class="dashboard-widget-info">
                                            <h1 id="totalBookings">0</h1>
                                            <span>Total Bookings</span>
                                        </div>
                                        <div class="dashboard-widget-icon">
                                            <i class="fal fa-shopping-bag"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3">
                                    <div class="dashboard-widget dashboard-widget-color-2">
                                        <div class="dashboard-widget-info">
                                            <h1 id="pendingRooms">0</h1>
                                            <span id="pendingLabel">Pending Rooms</span>
                                        </div>
                                        <div class="dashboard-widget-icon">
                                            <i class="fal fa-loader"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3">
                                    <div class="dashboard-widget dashboard-widget-color-3">
                                        <div class="dashboard-widget-info">
                                            <h1 id="totalRevenue">$0</h1>
                                            <span id="revenueLabel">Total Revenue</span>
                                        </div>
                                        <div class="dashboard-widget-icon">
                                            <i class="fal fa-sack-dollar"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3" id="totalUsersWidget">
                                    <div class="dashboard-widget dashboard-widget-color-4">
                                        <div class="dashboard-widget-info">
                                            <h1 id="totalUsers">0</h1>
                                            <span>Total Users</span>
                                        </div>
                                        <div class="dashboard-widget-icon">
                                            <i class="fal fa-users"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3" id="occupancyWidget" style="display: none;">
                                    <div class="dashboard-widget dashboard-widget-color-4">
                                        <div class="dashboard-widget-info">
                                            <h1 id="occupancyRate">0%</h1>
                                            <span>Occupancy Rate</span>
                                        </div>
                                        <div class="dashboard-widget-icon">
                                            <i class="fal fa-chart-line"></i>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 col-lg-3" id="cancellationWidget" style="display: none;">
                                    <div class="dashboard-widget dashboard-widget-color-5">
                                        <div class="dashboard-widget-info">
                                            <h1 id="cancellationRate">0%</h1>
                                            <span>Cancellation Rate</span>
                                        </div>
                                        <div class="dashboard-widget-icon">
                                            <i class="fal fa-times-circle"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="user-profile-card">
                                        <h4 class="user-profile-card-title">Sales Chart</h4>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div id="chart"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12">
                                    <div class="user-profile-card profile-booking">
                                        <h4 class="user-profile-card-title">Recent Bookings</h4>
                                        <div class="table-responsive">
                                            <table class="table text-nowrap" id="recentBookingsTable">
                                                <thead>
                                                    <tr>
                                                        <th>No</th>
                                                        <th>Booking ID</th>
                                                        <th>Room</th>
                                                        <th>Check-in Date</th>
                                                        <th>Total Price</th>
                                                        <th>Status</th>
                                                        <th>Action</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td colspan="7" class="text-center text-muted">Loading...</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-12" id="pendingRoomsSection">
                                    <div class="user-profile-card">
                                        <h4 class="user-profile-card-title">Pending Rooms Approval</h4>
                                        <div id="pendingRoomsList">
                                            <p class="text-muted">Loading...</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- user-dashboard end -->

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
    <script src="${pageContext.request.contextPath}/assets/js/apexcharts.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>

</body>


<!-- Mirrored from live.themewild.com/tavelo/dashboard.html by HTTrack Website Copier/3.x [XR&CO'2014], Thu, 28 Aug 2025 08:31:02 GMT -->
</html>
