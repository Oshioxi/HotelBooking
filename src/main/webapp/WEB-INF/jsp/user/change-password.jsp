<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="user.change_password"/></title>
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
                <h2 class="breadcrumb-title"><spring:message code="user.change_password"/></h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/"><spring:message code="common.home"/></a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard"><spring:message code="common.dashboard"/></a></li>
                    <li class="active"><spring:message code="user.change_password"/></li>
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
                            <h4 class="user-profile-card-title"><spring:message code="user.change_password"/></h4>
                            <form id="changePasswordForm">
                                <div class="row">
                                    <div class="col-md-12 mb-3">
                                        <label><spring:message code="user.current_password"/> *</label>
                                        <input type="password" id="currentPassword" class="form-control" required>
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <label><spring:message code="user.new_password"/> *</label>
                                        <input type="password" id="newPassword" class="form-control" required minlength="6">
                                        <small class="form-text text-muted"><spring:message code="user.password_min_length"/></small>
                                    </div>
                                    <div class="col-md-12 mb-3">
                                        <label><spring:message code="user.confirm_password"/> *</label>
                                        <input type="password" id="confirmPassword" class="form-control" required minlength="6">
                                    </div>
                                    <div class="col-md-12">
                                        <button type="submit" class="theme-btn">
                                            <i class="far fa-key"></i> <spring:message code="user.change_password"/>
                                        </button>
                                        <a href="${pageContext.request.contextPath}/user/profile" class="theme-btn btn-secondary ms-2">
                                            <i class="far fa-arrow-left"></i> <spring:message code="common.back"/>
                                        </a>
                                    </div>
                                </div>
                            </form>
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
    <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.appear.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/counter-up.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script>
        // Messages for JavaScript
        const messages = {
            passwordNotMatch: '<spring:message code="user.password_not_match" javaScriptEscape="true"/>',
            passwordMinLength: '<spring:message code="user.password_min_length" javaScriptEscape="true"/>',
            changing: '<spring:message code="user.changing" javaScriptEscape="true"/>',
            passwordChangedSuccess: '<spring:message code="user.password_changed_success" javaScriptEscape="true"/>',
            errorChangingPassword: '<spring:message code="user.error_changing_password" javaScriptEscape="true"/>'
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
                loadSidebarMenu(userRole, '/user/change-password');
            } catch (error) {
                console.error('Error loading user info:', error);
            }
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

        document.getElementById('changePasswordForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Validate passwords match
            if (newPassword !== confirmPassword) {
                HotelBookingAPI.Utils.showAlert(messages.passwordNotMatch, 'error');
                return;
            }
            
            // Validate password length
            if (newPassword.length < 6) {
                HotelBookingAPI.Utils.showAlert(messages.passwordMinLength, 'error');
                return;
            }
            
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="far fa-spinner fa-spin"></i> ' + messages.changing;
            
            try {
                // Backend expects: oldPassword and newPassword
                const passwordData = {
                    oldPassword: currentPassword,
                    newPassword: newPassword
                };
                
                await HotelBookingAPI.UserAPI.changePassword(passwordData);
                
                HotelBookingAPI.Utils.showAlert(messages.passwordChangedSuccess, 'success');
                
                // Clear form
                document.getElementById('changePasswordForm').reset();
                
                // Optionally redirect to profile after 2 seconds
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/user/profile';
                }, 2000);
            } catch (error) {
                console.error('Error changing password:', error);
                HotelBookingAPI.Utils.showAlert(messages.errorChangingPassword + ': ' + error.message, 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
    </script>
</body>
</html>

