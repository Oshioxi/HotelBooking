<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="user.bookings_history"/></title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
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
                <h2 class="breadcrumb-title"><spring:message code="user.bookings_history"/></h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/"><spring:message code="common.home"/></a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard"><spring:message code="common.dashboard"/></a></li>
                    <li class="active"><spring:message code="user.bookings_history"/></li>
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
                                <h4 id="sidebarFullName">Loading...</h4>
                                <p id="sidebarEmail">Loading...</p>
                            </div>
                            <ul class="user-profile-sidebar-list" id="sidebarMenu">
                                <li><a href="${pageContext.request.contextPath}/dashboard"><i class="far fa-gauge-high"></i> <spring:message code="common.dashboard"/></a></li>
                                <!-- Menu will be populated by JavaScript based on user role -->
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-9">
                        <div class="user-profile-card">
                            <h4 class="user-profile-card-title"><spring:message code="user.my_booking_history"/></h4>
                            <div class="table-responsive">
                                <table class="table table-hover" id="bookingsTable">
                                    <thead>
                                        <tr>
                                            <th><spring:message code="user.booking_id"/></th>
                                            <th><spring:message code="user.room"/></th>
                                            <th><spring:message code="user.check_in"/></th>
                                            <th><spring:message code="user.check_out"/></th>
                                            <th><spring:message code="user.guests"/></th>
                                            <th><spring:message code="user.total_price"/></th>
                                            <th><spring:message code="common.status"/></th>
                                            <th><spring:message code="common.actions"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="8" class="text-center"><spring:message code="common.loading"/></td>
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
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script>
        // Messages for JavaScript
        const messages = {
            noBookingsFound: '<spring:message code="user.no_bookings_found" javaScriptEscape="true" text="Không tìm thấy booking nào"/>',
            cancel: '<spring:message code="common.cancel" javaScriptEscape="true" text="Hủy"/>',
            confirmCancelBooking: '<spring:message code="user.confirm_cancel_booking" javaScriptEscape="true" text="Bạn có chắc chắn muốn hủy booking này?"/>',
            bookingCancelledSuccess: '<spring:message code="user.booking_cancelled_success" javaScriptEscape="true" text="Hủy booking thành công"/>',
            errorCancellingBooking: '<spring:message code="user.error_cancelling_booking" javaScriptEscape="true" text="Lỗi khi hủy booking"/>',
            errorLoadingBookings: '<spring:message code="user.error_loading_bookings" javaScriptEscape="true" text="Lỗi khi tải danh sách booking"/>'
        };
        
        document.addEventListener('DOMContentLoaded', async function() {
            // Hide preloader
            const preloader = document.querySelector('.preloader');
            if (preloader) {
                preloader.style.display = 'none';
            }
            
            if (!HotelBookingAPI.TokenManager.getToken()) {
                window.location.href = '/login';
                return;
            }
            
            try {
                // Load current user info from API
                const user = await HotelBookingAPI.UserAPI.getCurrentUser();
                
                // Update sidebar info
                const sidebarFullName = document.getElementById('sidebarFullName');
                const sidebarEmail = document.getElementById('sidebarEmail');
                if (sidebarFullName) sidebarFullName.textContent = user.fullName || user.username || 'User';
                if (sidebarEmail) sidebarEmail.textContent = user.email || '';
                
                // Update localStorage with latest info
                HotelBookingAPI.TokenManager.setUserInfo(user);
                
                // Load sidebar menu based on user role
                const userRole = HotelBookingAPI.TokenManager.getUserRole();
                loadSidebarMenu(userRole, '/profile-booking-history');
            } catch (error) {
                console.error('Error loading user info:', error);
            }
            
            await loadBookings();
        });

        function loadSidebarMenu(role, currentPage) {
            const menuContainer = document.getElementById('sidebarMenu');
            if (!menuContainer) return;

            const path = window.location.pathname;
            const isActive = (pagePath) => {
                if (!pagePath) return false;
                return currentPage.includes(pagePath) || path.includes(pagePath);
            };
            
            const menuItem = (href, icon, text, active) => {
                const absoluteHref = href.startsWith('/') ? href : '/' + href;
                const activeClass = active ? ' class="active"' : '';
                return `<li><a${activeClass} href="${absoluteHref}"><i class="${icon}"></i> ${text}</a></li>`;
            };

            let menuHTML = '';

            if (role === 'ADMIN') {
                menuHTML += menuItem('/dashboard', 'far fa-gauge-high', 'Dashboard', isActive('/dashboard') && !isActive('/admin/'));
                menuHTML += menuItem('/user/profile', 'far fa-user', 'My Profile', isActive('/user/profile'));
                menuHTML += menuItem('/admin/users', 'far fa-users', 'User Management', isActive('/admin/users'));
                menuHTML += menuItem('/admin/rooms', 'far fa-door-open', 'Room Management', isActive('/admin/rooms'));
                menuHTML += menuItem('/admin/bookings', 'far fa-shopping-bag', 'Booking Management', isActive('/admin/bookings'));
                menuHTML += menuItem('/admin/hotels', 'far fa-building', 'Hotel Management', isActive('/admin/hotels'));
            } else if (role === 'HOTEL_OWNER') {
                menuHTML += menuItem('/dashboard', 'far fa-gauge-high', 'Dashboard', isActive('/dashboard') && !isActive('/owner/'));
                menuHTML += menuItem('/user/profile', 'far fa-user', 'My Profile', isActive('/user/profile'));
                menuHTML += menuItem('/owner/hotels', 'far fa-building', 'My Hotels', isActive('/owner/hotels'));
                menuHTML += menuItem('/owner/rooms', 'far fa-door-open', 'My Rooms', isActive('/owner/rooms'));
                menuHTML += menuItem('/owner/bookings', 'far fa-shopping-bag', 'My Bookings', isActive('/owner/bookings'));
            } else {
                menuHTML += menuItem('/dashboard', 'far fa-gauge-high', 'Dashboard', isActive('/dashboard'));
                menuHTML += menuItem('/user/profile', 'far fa-user', 'My Profile', isActive('/user/profile'));
                menuHTML += menuItem('/profile-booking', 'far fa-shopping-bag', 'My Booking', isActive('/profile-booking'));
                menuHTML += menuItem('/profile-booking-history', 'far fa-clipboard-list', 'Booking History', isActive('/profile-booking-history'));
            }

            menuHTML += `<li><a href="#" onclick="logout()"><i class="far fa-sign-out"></i> Logout</a></li>`;

            menuContainer.innerHTML = menuHTML;
        }

        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                HotelBookingAPI.TokenManager.clear();
                window.location.href = '/index';
            }
        }
        
        // Make functions global
        window.logout = logout;

        async function loadBookings() {
            try {
                const bookings = await HotelBookingAPI.UserAPI.getMyBookings();
                // Load room type details for each booking
                const bookingsWithDetails = await Promise.all(bookings.map(async (booking) => {
                    try {
                        if (booking.roomTypeId) {
                            const roomType = await HotelBookingAPI.RoomTypeAPI.getById(booking.roomTypeId);
                            booking.roomType = roomType;
                        }
                    } catch (error) {
                        console.error(`Error loading room type for booking ${booking.id}:`, error);
                        booking.roomType = null;
                    }
                    return booking;
                }));
                displayBookings(bookingsWithDetails);
            } catch (error) {
                console.error('Error loading bookings:', error);
                const tbody = document.querySelector('#bookingsTable tbody');
                if (tbody) {
                    tbody.innerHTML = '<tr><td colspan="8" class="text-center text-danger">' + 
                        (messages.errorLoadingBookings || 'Error loading bookings') + ': ' + (error.message || 'Unknown error') + '</td></tr>';
                }
            }
        }

        function displayBookings(bookings) {
            const tbody = document.querySelector('#bookingsTable tbody');
            if (!tbody) return;
            
            if (!bookings || bookings.length === 0) {
                tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">' + (messages.noBookingsFound || 'No bookings found') + '</td></tr>';
                return;
            }

            let html = '';
            bookings.forEach(booking => {
                const statusClass = {
                    'PENDING': 'badge-warning',
                    'CONFIRMED': 'badge-success',
                    'CANCELLED': 'badge-danger',
                    'COMPLETED': 'badge-primary'
                }[booking.bookingStatus] || 'badge-secondary';
                
                const statusText = {
                    'PENDING': 'Chờ xác nhận',
                    'CONFIRMED': 'Đã xác nhận',
                    'CANCELLED': 'Đã hủy',
                    'COMPLETED': 'Hoàn thành'
                }[booking.bookingStatus] || booking.bookingStatus || 'N/A';
                
                const canCancel = booking.bookingStatus === 'PENDING' || booking.bookingStatus === 'CONFIRMED';
                const roomName = booking.roomType?.name || 'N/A';
                
                html += `
                    <tr>
                        <td><strong>#${booking.id}</strong></td>
                        <td>${roomName}</td>
                        <td>${HotelBookingAPI.Utils.formatDate(booking.checkInDate)}</td>
                        <td>${HotelBookingAPI.Utils.formatDate(booking.checkOutDate)}</td>
                        <td>${booking.numberOfGuests || 1}</td>
                        <td>${HotelBookingAPI.Utils.formatCurrency(booking.totalPrice || 0)}</td>
                        <td><span class="badge ${statusClass}">${statusText}</span></td>
                        <td>
                            <a href="/hotel-booking?id=${booking.id}" class="btn btn-sm btn-primary me-2">
                                <i class="far fa-eye"></i> Xem
                            </a>
                            ${canCancel ? `
                                <button class="btn btn-sm btn-danger" onclick="cancelBooking(${booking.id})">
                                    <i class="far fa-times"></i> ${messages.cancel || 'Hủy'}
                                </button>
                            ` : ''}
                        </td>
                    </tr>
                `;
            });
            tbody.innerHTML = html;
        }

        async function cancelBooking(id) {
            if (!confirm(messages.confirmCancelBooking || 'Bạn có chắc chắn muốn hủy booking này?')) return;
            try {
                await HotelBookingAPI.UserAPI.cancelMyBooking(id);
                alert(messages.bookingCancelledSuccess || 'Hủy booking thành công');
                await loadBookings();
            } catch (error) {
                console.error('Error cancelling booking:', error);
                alert((messages.errorCancellingBooking || 'Lỗi khi hủy booking') + ': ' + (error.message || 'Unknown error'));
            }
        }
        
        // Make cancelBooking global
        window.cancelBooking = cancelBooking;
    </script>
</body>
</html>

