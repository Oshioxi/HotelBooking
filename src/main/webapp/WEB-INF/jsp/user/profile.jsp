<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.min.css">
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
                <h2 class="breadcrumb-title">My Profile</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="active">My Profile</li>
                </ul>
            </div>
        </div>

        <div class="user-profile py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3">
                        <jsp:include page="../components/sidebar.jsp" />
                    </div>
                    <div class="col-lg-9">
                        <div class="user-profile-wrapper">
                            <!-- Tabs Navigation -->
                            <ul class="nav nav-tabs mb-4" id="profileTabs" role="tablist">
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link active" id="profile-info-tab" data-bs-toggle="tab" data-bs-target="#profile-info" type="button" role="tab">
                                        <i class="far fa-user"></i> <span id="tabInfoText">Thay đổi thông tin</span>
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="nav-link" id="profile-password-tab" data-bs-toggle="tab" data-bs-target="#profile-password" type="button" role="tab">
                                        <i class="far fa-key"></i> <span id="tabPasswordText">Đổi mật khẩu</span>
                                    </button>
                                </li>
                                <li class="nav-item" role="presentation" id="profile-booking-tab-item" style="display: none;">
                                    <button class="nav-link" id="profile-booking-tab" data-bs-toggle="tab" data-bs-target="#profile-booking" type="button" role="tab">
                                        <i class="far fa-shopping-bag"></i> <span id="tabBookingText">Lịch sử đặt phòng</span>
                                    </button>
                                </li>
                            </ul>

                            <!-- Tabs Content -->
                            <div class="tab-content" id="profileTabContent">
                                <!-- Thay đổi thông tin Tab -->
                                <div class="tab-pane fade show active" id="profile-info" role="tabpanel">
                                    <div class="user-profile-card">
                                        <h4 class="user-profile-card-title" id="profileInfoTitle">Thay đổi thông tin</h4>
                                        <form id="profileForm">
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label id="labelUsername">Tên đăng nhập</label>
                                                    <input type="text" id="username" class="form-control" readonly>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label id="labelEmail">Email</label>
                                                    <input type="email" id="email" class="form-control" readonly>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label id="labelFullName">Họ và tên *</label>
                                                    <input type="text" id="fullName" class="form-control" required>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label id="labelPhone">Số điện thoại</label>
                                                    <input type="text" id="phone" class="form-control">
                                                </div>
                                                <div class="col-md-12">
                                                    <button type="submit" class="theme-btn">
                                                        <i class="far fa-save"></i> <span id="btnSaveText">Lưu thay đổi</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Đổi mật khẩu Tab -->
                                <div class="tab-pane fade" id="profile-password" role="tabpanel">
                                    <div class="user-profile-card">
                                        <h4 class="user-profile-card-title" id="profilePasswordTitle">Đổi mật khẩu</h4>
                                        <form id="changePasswordForm">
                                            <div class="row">
                                                <div class="col-md-12 mb-3">
                                                    <label id="labelCurrentPassword">Mật khẩu hiện tại *</label>
                                                    <input type="password" id="currentPassword" class="form-control" required>
                                                </div>
                                                <div class="col-md-12 mb-3">
                                                    <label id="labelNewPassword">Mật khẩu mới *</label>
                                                    <input type="password" id="newPassword" class="form-control" required minlength="6">
                                                    <small class="form-text text-muted" id="passwordHint">Mật khẩu phải có ít nhất 6 ký tự</small>
                                                </div>
                                                <div class="col-md-12 mb-3">
                                                    <label id="labelConfirmPassword">Xác nhận mật khẩu mới *</label>
                                                    <input type="password" id="confirmPassword" class="form-control" required minlength="6">
                                                </div>
                                                <div class="col-md-12">
                                                    <button type="submit" class="theme-btn">
                                                        <i class="far fa-key"></i> <span id="btnChangePasswordText">Đổi mật khẩu</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>

                                <!-- Lịch sử đặt phòng Tab (Only for USER role) -->
                                <div class="tab-pane fade" id="profile-booking" role="tabpanel">
                                    <div class="user-profile-card">
                                        <h4 class="user-profile-card-title" id="profileBookingTitle">Lịch sử đặt phòng</h4>
                                        <div class="table-responsive">
                                            <table class="table table-hover" id="bookingsHistoryTable">
                                                <thead>
                                                    <tr>
                                                        <th>STT</th>
                                                        <th>Mã đặt phòng</th>
                                                        <th>Phòng - Khách sạn</th>
                                                        <th>Ngày nhận phòng</th>
                                                        <th>Ngày trả phòng</th>
                                                        <th>Tổng tiền</th>
                                                        <th>Trạng thái</th>
                                                        <th>Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr>
                                                        <td colspan="8" class="text-center">Đang tải...</td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
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
    <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.appear.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/counter-up.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
    <script>
        const contextPath = '<c:out value="${pageContext.request.contextPath}" escapeXml="true" default="" />';
        
        // Helper function to safely get value
        function safeGet(obj, path, defaultValue = null) {
            try {
                const keys = path.split('.');
                let result = obj;
                for (const key of keys) {
                    if (result == null) return defaultValue;
                    result = result[key];
                }
                return result != null ? result : defaultValue;
            } catch (e) {
                return defaultValue;
            }
        }
        
        // Helper function to escape HTML
        function escapeHtml(text) {
            if (text == null) return 'N/A';
            return String(text)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        }
        
        document.addEventListener('DOMContentLoaded', async function() {
            // Hide preloader
            const preloader = document.querySelector('.preloader');
            if (preloader) {
                preloader.style.display = 'none';
            }
            
            try {
                if (!window.HotelBookingAPI || !window.HotelBookingAPI.TokenManager) {
                    console.error('HotelBookingAPI not loaded');
                    alert('System error: API not loaded. Please refresh the page.');
                    return;
                }
                
                if (!window.HotelBookingAPI.TokenManager.getToken()) {
                    window.location.href = contextPath + '/login';
                    return;
                }
                
                const userRole = window.HotelBookingAPI.TokenManager.getUserRole();
                // Allow all roles (USER, ADMIN, HOTEL_OWNER) to access profile
                
                // Load current user info from API
                const user = await window.HotelBookingAPI.UserAPI.getCurrentUser();
                
                // Update form fields
                document.getElementById('username').value = safeGet(user, 'username', '');
                document.getElementById('email').value = safeGet(user, 'email', '');
                document.getElementById('fullName').value = safeGet(user, 'fullName', '');
                document.getElementById('phone').value = safeGet(user, 'phone', '');
                
                // Update sidebar info
                const userFullName = document.getElementById('userFullName');
                const userEmail = document.getElementById('userEmail');
                if (userFullName) userFullName.textContent = safeGet(user, 'fullName') || safeGet(user, 'username') || 'User';
                if (userEmail) userEmail.textContent = safeGet(user, 'email') || '';
                
                // Update localStorage with latest info
                window.HotelBookingAPI.TokenManager.setUserInfo(user);
                
                // Load sidebar menu based on user role
                if (typeof loadSidebarMenu === 'function') {
                    loadSidebarMenu(userRole, '/user/profile');
                }
                
                // Update UI based on role
                updateUIForRole(userRole);
                
                // Load bookings history only for USER role
                if (userRole === 'USER') {
                    await loadBookingsHistory();
                }
            } catch (error) {
                console.error('Error loading user info:', error);
                alert('Error loading profile: ' + (error.message || 'Unknown error'));
            }
        });

        // Profile form submission
        document.getElementById('profileForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            // Get user role for language
            const userRole = window.HotelBookingAPI.TokenManager.getUserRole();
            const isVietnamese = userRole === 'USER';
            
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            const loadingText = isVietnamese ? 'Đang lưu...' : 'Saving...';
            submitBtn.innerHTML = '<i class="far fa-spinner fa-spin"></i> ' + loadingText;
            
            try {
                const profileData = {
                    fullName: document.getElementById('fullName').value.trim(),
                    phone: document.getElementById('phone').value.trim() || null
                };
                
                const updatedUser = await window.HotelBookingAPI.UserAPI.updateProfile(profileData);
                
                // Update localStorage
                window.HotelBookingAPI.TokenManager.setUserInfo(updatedUser);
                
                // Update sidebar
                const userFullName = document.getElementById('userFullName');
                if (userFullName) userFullName.textContent = safeGet(updatedUser, 'fullName') || safeGet(updatedUser, 'username') || 'User';
                
                const successMsg = isVietnamese ? 'Cập nhật thông tin thành công!' : 'Profile updated successfully!';
                alert(successMsg);
            } catch (error) {
                console.error('Error updating profile:', error);
                const errorMsg = isVietnamese ? 'Lỗi cập nhật thông tin: ' : 'Error updating profile: ';
                alert(errorMsg + (error.message || 'Unknown error'));
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });

        // Change password form submission
        document.getElementById('changePasswordForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            // Get user role for language
            const userRole = window.HotelBookingAPI.TokenManager.getUserRole();
            const isVietnamese = userRole === 'USER';
            
            // Validate passwords match
            if (newPassword !== confirmPassword) {
                alert(isVietnamese ? 'Mật khẩu mới và xác nhận mật khẩu không khớp!' : 'New password and confirm password do not match!');
                return;
            }
            
            // Validate password length
            if (newPassword.length < 6) {
                alert(isVietnamese ? 'Mật khẩu phải có ít nhất 6 ký tự!' : 'Password must be at least 6 characters!');
                return;
            }
            
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            const loadingText = isVietnamese ? 'Đang đổi mật khẩu...' : 'Changing password...';
            submitBtn.innerHTML = '<i class="far fa-spinner fa-spin"></i> ' + loadingText;
            
            try {
                const passwordData = {
                    oldPassword: currentPassword,
                    newPassword: newPassword
                };
                
                await window.HotelBookingAPI.UserAPI.changePassword(passwordData);
                
                const successMsg = isVietnamese ? 'Đổi mật khẩu thành công!' : 'Password changed successfully!';
                alert(successMsg);
                
                // Clear form
                document.getElementById('changePasswordForm').reset();
            } catch (error) {
                console.error('Error changing password:', error);
                const errorMsg = isVietnamese ? 'Lỗi đổi mật khẩu: ' : 'Error changing password: ';
                alert(errorMsg + (error.message || 'Unknown error'));
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });

        // Load bookings history
        async function loadBookingsHistory() {
            try {
                const tbody = document.querySelector('#bookingsHistoryTable tbody');
                if (!tbody) return;
                
                const bookings = await window.HotelBookingAPI.UserAPI.getMyBookings();
                
                if (!Array.isArray(bookings) || bookings.length === 0) {
                    tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">Chưa có đặt phòng nào</td></tr>';
                    return;
                }

                let html = '';
                let index = 1;
                bookings.forEach(booking => {
                    if (!booking || !booking.id) return;
                    
                    const statusClass = {
                        'PENDING': 'badge-warning',
                        'CONFIRMED': 'badge-success',
                        'CANCELLED': 'badge-danger',
                        'COMPLETED': 'badge-primary'
                    }[safeGet(booking, 'bookingStatus', '').toUpperCase()] || 'badge-secondary';
                    
                    // Get room name and hotel name
                    const roomName = safeGet(booking, 'roomType.name') || 
                                   safeGet(booking, 'roomName') || 
                                   'N/A';
                    const hotelName = safeGet(booking, 'roomType.hotel.name') || 
                                    safeGet(booking, 'hotel.name') || 
                                    'N/A';
                    
                    // Format dates
                    const checkInDate = safeGet(booking, 'checkInDate');
                    const checkOutDate = safeGet(booking, 'checkOutDate');
                    const formattedCheckIn = checkInDate && window.HotelBookingAPI && window.HotelBookingAPI.Utils 
                        ? window.HotelBookingAPI.Utils.formatDate(checkInDate) 
                        : (checkInDate || 'N/A');
                    const formattedCheckOut = checkOutDate && window.HotelBookingAPI && window.HotelBookingAPI.Utils 
                        ? window.HotelBookingAPI.Utils.formatDate(checkOutDate) 
                        : (checkOutDate || 'N/A');
                    
                    // Format price
                    const totalPrice = safeGet(booking, 'totalPrice', 0);
                    const formattedPrice = window.HotelBookingAPI && window.HotelBookingAPI.Utils 
                        ? window.HotelBookingAPI.Utils.formatCurrency(totalPrice) 
                        : totalPrice.toLocaleString() + ' VND';
                    
                    const bookingStatus = safeGet(booking, 'bookingStatus', 'N/A');
                    const bookingId = safeGet(booking, 'id', 'N/A');
                    
                    html += '<tr>' +
                        '<td>' + index + '</td>' +
                        '<td><strong>#' + bookingId + '</strong></td>' +
                        '<td><strong>' + escapeHtml(roomName) + '</strong><br><small class="text-muted">' + escapeHtml(hotelName) + '</small></td>' +
                        '<td>' + formattedCheckIn + '</td>' +
                        '<td>' + formattedCheckOut + '</td>' +
                        '<td><strong>' + formattedPrice + '</strong></td>' +
                        '<td><span class="badge ' + statusClass + '">' + escapeHtml(bookingStatus) + '</span></td>' +
                        '<td>' +
                            '<button class="btn btn-sm btn-info" onclick="viewBookingDetails(' + bookingId + ')" title="Xem chi tiết">' +
                                '<i class="far fa-eye"></i>' +
                            '</button>' +
                        '</td>' +
                    '</tr>';
                    index++;
                });
                tbody.innerHTML = html;
            } catch (error) {
                console.error('Error loading bookings history:', error);
                const tbody = document.querySelector('#bookingsHistoryTable tbody');
                if (tbody) {
                    tbody.innerHTML = '<tr><td colspan="8" class="text-center text-danger">Lỗi tải lịch sử đặt phòng: ' + (error.message || 'Unknown error') + '</td></tr>';
                }
            }
        }
        
        function viewBookingDetails(id) {
            if (!id) {
                alert('Invalid booking ID');
                return;
            }
            window.location.href = contextPath + '/hotel-booking?id=' + id;
        }
        
        // Update UI based on user role
        function updateUIForRole(role) {
            const bookingTabItem = document.getElementById('profile-booking-tab-item');
            const bookingTab = document.getElementById('profile-booking');
            
            if (role === 'USER') {
                // Show booking history tab for USER
                if (bookingTabItem) bookingTabItem.style.display = '';
                // Update text to Vietnamese for USER
                updateTextForLanguage('vi');
            } else {
                // Hide booking history tab for ADMIN and HOTEL_OWNER
                if (bookingTabItem) bookingTabItem.style.display = 'none';
                // Update text to English for ADMIN and HOTEL_OWNER
                updateTextForLanguage('en');
            }
        }
        
        function updateTextForLanguage(lang) {
            if (lang === 'vi') {
                // Vietnamese
                const tabInfoText = document.getElementById('tabInfoText');
                const tabPasswordText = document.getElementById('tabPasswordText');
                const tabBookingText = document.getElementById('tabBookingText');
                const profileInfoTitle = document.getElementById('profileInfoTitle');
                const profilePasswordTitle = document.getElementById('profilePasswordTitle');
                const profileBookingTitle = document.getElementById('profileBookingTitle');
                const labelUsername = document.getElementById('labelUsername');
                const labelEmail = document.getElementById('labelEmail');
                const labelFullName = document.getElementById('labelFullName');
                const labelPhone = document.getElementById('labelPhone');
                const labelCurrentPassword = document.getElementById('labelCurrentPassword');
                const labelNewPassword = document.getElementById('labelNewPassword');
                const labelConfirmPassword = document.getElementById('labelConfirmPassword');
                const passwordHint = document.getElementById('passwordHint');
                const btnSaveText = document.getElementById('btnSaveText');
                const btnChangePasswordText = document.getElementById('btnChangePasswordText');
                
                if (tabInfoText) tabInfoText.textContent = 'Thay đổi thông tin';
                if (tabPasswordText) tabPasswordText.textContent = 'Đổi mật khẩu';
                if (tabBookingText) tabBookingText.textContent = 'Lịch sử đặt phòng';
                if (profileInfoTitle) profileInfoTitle.textContent = 'Thay đổi thông tin';
                if (profilePasswordTitle) profilePasswordTitle.textContent = 'Đổi mật khẩu';
                if (profileBookingTitle) profileBookingTitle.textContent = 'Lịch sử đặt phòng';
                if (labelUsername) labelUsername.textContent = 'Tên đăng nhập';
                if (labelEmail) labelEmail.textContent = 'Email';
                if (labelFullName) labelFullName.textContent = 'Họ và tên *';
                if (labelPhone) labelPhone.textContent = 'Số điện thoại';
                if (labelCurrentPassword) labelCurrentPassword.textContent = 'Mật khẩu hiện tại *';
                if (labelNewPassword) labelNewPassword.textContent = 'Mật khẩu mới *';
                if (labelConfirmPassword) labelConfirmPassword.textContent = 'Xác nhận mật khẩu mới *';
                if (passwordHint) passwordHint.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                if (btnSaveText) btnSaveText.textContent = 'Lưu thay đổi';
                if (btnChangePasswordText) btnChangePasswordText.textContent = 'Đổi mật khẩu';
            } else {
                // English
                const tabInfoText = document.getElementById('tabInfoText');
                const tabPasswordText = document.getElementById('tabPasswordText');
                const tabBookingText = document.getElementById('tabBookingText');
                const profileInfoTitle = document.getElementById('profileInfoTitle');
                const profilePasswordTitle = document.getElementById('profilePasswordTitle');
                const profileBookingTitle = document.getElementById('profileBookingTitle');
                const labelUsername = document.getElementById('labelUsername');
                const labelEmail = document.getElementById('labelEmail');
                const labelFullName = document.getElementById('labelFullName');
                const labelPhone = document.getElementById('labelPhone');
                const labelCurrentPassword = document.getElementById('labelCurrentPassword');
                const labelNewPassword = document.getElementById('labelNewPassword');
                const labelConfirmPassword = document.getElementById('labelConfirmPassword');
                const passwordHint = document.getElementById('passwordHint');
                const btnSaveText = document.getElementById('btnSaveText');
                const btnChangePasswordText = document.getElementById('btnChangePasswordText');
                
                if (tabInfoText) tabInfoText.textContent = 'Update Information';
                if (tabPasswordText) tabPasswordText.textContent = 'Change Password';
                if (tabBookingText) tabBookingText.textContent = 'Booking History';
                if (profileInfoTitle) profileInfoTitle.textContent = 'Update Information';
                if (profilePasswordTitle) profilePasswordTitle.textContent = 'Change Password';
                if (profileBookingTitle) profileBookingTitle.textContent = 'Booking History';
                if (labelUsername) labelUsername.textContent = 'Username';
                if (labelEmail) labelEmail.textContent = 'Email';
                if (labelFullName) labelFullName.textContent = 'Full Name *';
                if (labelPhone) labelPhone.textContent = 'Phone';
                if (labelCurrentPassword) labelCurrentPassword.textContent = 'Current Password *';
                if (labelNewPassword) labelNewPassword.textContent = 'New Password *';
                if (labelConfirmPassword) labelConfirmPassword.textContent = 'Confirm New Password *';
                if (passwordHint) passwordHint.textContent = 'Password must be at least 6 characters';
                if (btnSaveText) btnSaveText.textContent = 'Save Changes';
                if (btnChangePasswordText) btnChangePasswordText.textContent = 'Change Password';
            }
        }
        
        // Export functions to global scope
        window.viewBookingDetails = viewBookingDetails;
    </script>
</body>
</html>
