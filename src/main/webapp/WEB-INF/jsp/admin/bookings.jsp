<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Booking Management</title>
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
    <div class="preloader">
        <div class="loader">
            <span style="--i:1;"></span><span style="--i:2;"></span><span style="--i:3;"></span>
            <span style="--i:4;"></span><span style="--i:5;"></span><span style="--i:6;"></span>
            <span style="--i:7;"></span><span style="--i:8;"></span><span style="--i:9;"></span>
            <span style="--i:10;"></span><span style="--i:11;"></span><span style="--i:12;"></span>
            <span style="--i:13;"></span><span style="--i:14;"></span><span style="--i:15;"></span>
            <span style="--i:16;"></span><span style="--i:17;"></span><span style="--i:18;"></span>
            <span style="--i:19;"></span><span style="--i:20;"></span>
            <div class="loader-plane"></div>
        </div>
    </div>

    <jsp:include page="../components/header.jsp" />

    <main class="main">
        <div class="site-breadcrumb" style="background: url(${pageContext.request.contextPath}/assets/img/breadcrumb/01.jpg)">
            <div class="container">
                <h2 class="breadcrumb-title">Booking Management</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="active">Bookings</li>
                </ul>
            </div>
        </div>

        <div class="user-profile py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3">
                        <div class="user-profile-sidebar">
                            <div class="user-profile-sidebar-top">
                                <div class="user-profile-img">
                                    <img src="${pageContext.request.contextPath}/assets/img/account/user.jpg" alt="">
                                    <button type="button" class="profile-img-btn"><i class="far fa-camera"></i></button>
                                    <input type="file" class="profile-img-file">
                                </div>
                                <h4 id="userFullName">Loading...</h4>
                                <p id="userEmail">Loading...</p>
                            </div>
                            <ul class="user-profile-sidebar-list" id="sidebarMenu">
                                <!-- Menu will be populated by JavaScript based on user role -->
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-9">
                        <div class="user-profile-card">
                            <h4 class="user-profile-card-title">All Bookings</h4>
                            <div class="table-responsive">
                                <table class="table table-hover" id="bookingsTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Guest Name</th>
                                            <th>Room</th>
                                            <th>Check-in</th>
                                            <th>Check-out</th>
                                            <th>Total Price</th>
                                            <th>Booking Status</th>
                                            <th>Payment</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="9" class="text-center">Loading...</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="../components/footer.jsp" />

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
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', async function() {
            if (!HotelBookingAPI.TokenManager.getToken()) {
                window.location.href = '/login';
                return;
            }
            
            const userRole = HotelBookingAPI.TokenManager.getUserRole();
            if (userRole !== 'ADMIN') {
                window.location.href = '/dashboard';
                return;
            }
            
            // Load sidebar menu and user info
            const userInfo = HotelBookingAPI.TokenManager.getUserInfo();
            const userFullNameEl = document.getElementById('userFullName');
            const userEmailEl = document.getElementById('userEmail');
            if (userFullNameEl) userFullNameEl.textContent = userInfo.fullName || userInfo.username || 'User';
            if (userEmailEl) userEmailEl.textContent = userInfo.email || '';
            loadSidebarMenu(userRole, '/admin/bookings');
            
            await loadBookings();
        });

        async function loadBookings() {
            try {
                const bookings = await HotelBookingAPI.AdminAPI.getAllBookings();
                // Load payment status for each booking
                const bookingsWithPayment = await Promise.all(bookings.map(async (booking) => {
                    try {
                        const payment = await HotelBookingAPI.PaymentAPI.getLatestByBooking(booking.id);
                        return { ...booking, payment: payment };
                    } catch (error) {
                        // No payment found - that's fine for new bookings
                        return { ...booking, payment: null };
                    }
                }));
                displayBookings(bookingsWithPayment);
            } catch (error) {
                console.error('Error loading bookings:', error);
                alert('Error loading bookings: ' + error.message);
            }
        }

        function displayBookings(bookings) {
            const tbody = document.querySelector('#bookingsTable tbody');
            if (bookings.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted">No bookings found</td></tr>';
                return;
            }

            let html = '';
            bookings.forEach(booking => {
                const bookingStatusClass = {
                    'PENDING': 'badge-warning',
                    'CONFIRMED': 'badge-success',
                    'CANCELLED': 'badge-danger',
                    'COMPLETED': 'badge-primary'
                }[booking.bookingStatus] || 'badge-secondary';
                
                // Get payment status and color
                let paymentStatus = 'NO PAYMENT';
                let paymentStatusClass = 'badge-secondary'; // Gray for no payment
                
                if (booking.payment) {
                    const paymentStatusUpper = (booking.payment.paymentStatus || '').toUpperCase();
                    paymentStatus = paymentStatusUpper;
                    
                    // Set color based on payment status
                    switch(paymentStatusUpper) {
                        case 'PAID':
                            paymentStatusClass = 'badge-success'; // Green
                            break;
                        case 'PENDING':
                            paymentStatusClass = 'badge-warning'; // Yellow
                            break;
                        case 'FAILED':
                            paymentStatusClass = 'badge-danger'; // Red
                            break;
                        case 'REFUNDED':
                            paymentStatusClass = 'badge-info'; // Blue
                            break;
                        case 'CANCELLED':
                            paymentStatusClass = 'badge-secondary'; // Gray
                            break;
                        default:
                            paymentStatusClass = 'badge-secondary'; // Gray
                    }
                }
                
                html += '<tr>' +
                    '<td><strong>#' + booking.id + '</strong></td>' +
                    '<td>' + (booking.guestName || 'N/A') + '</td>' +
                    '<td>' + (booking.roomType?.name || 'N/A') + '</td>' +
                    '<td>' + HotelBookingAPI.Utils.formatDate(booking.checkInDate) + '</td>' +
                    '<td>' + HotelBookingAPI.Utils.formatDate(booking.checkOutDate) + '</td>' +
                    '<td>' + HotelBookingAPI.Utils.formatCurrency(booking.totalPrice || 0) + '</td>' +
                    '<td><span class="badge ' + bookingStatusClass + '">' + (booking.bookingStatus || 'N/A') + '</span></td>' +
                    '<td><span class="badge ' + paymentStatusClass + '">' + paymentStatus + '</span></td>' +
                    '<td>' +
                        (booking.bookingStatus === 'PENDING' ? 
                            '<button class="btn btn-sm btn-success" onclick="confirmBooking(' + booking.id + ')">' +
                                '<i class="far fa-check"></i> Confirm' +
                            '</button>' 
                        : '') +
                    '</td>' +
                '</tr>';
            });
            tbody.innerHTML = html;
        }

        async function confirmBooking(id) {
            if (!confirm('Confirm this booking?')) return;
            try {
                await HotelBookingAPI.AdminAPI.confirmBooking(id);
                alert('Booking confirmed successfully');
                await loadBookings();
            } catch (error) {
                alert('Error confirming booking: ' + error.message);
            }
        }
    </script>
</body>
</html>

