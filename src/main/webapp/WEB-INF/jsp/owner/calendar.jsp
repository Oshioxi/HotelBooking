<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Owner - Booking Calendar</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .calendar-container {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .calendar-day {
            border: 1px solid #ddd;
            padding: 10px;
            min-height: 100px;
            position: relative;
        }
        .calendar-day-header {
            font-weight: bold;
            margin-bottom: 5px;
            color: #333;
        }
        .booking-item {
            background: #007bff;
            color: white;
            padding: 5px;
            margin: 2px 0;
            border-radius: 3px;
            font-size: 12px;
            cursor: pointer;
        }
        .booking-item.confirmed {
            background: #28a745;
        }
        .booking-item.pending {
            background: #ffc107;
            color: #333;
        }
        .booking-item.cancelled {
            background: #dc3545;
        }
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #ddd;
        }
        .date-filter {
            margin-bottom: 20px;
        }
    </style>
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
                <h2 class="breadcrumb-title">Booking Calendar</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="active">Calendar</li>
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
                        <div class="user-profile-card">
                            <h4 class="user-profile-card-title">Booking Calendar</h4>
                            
                            <div class="date-filter mb-4">
                                <div class="row">
                                    <div class="col-md-4">
                                        <label>Ngày Bắt Đầu</label>
                                        <input type="date" class="form-control" id="startDate">
                                    </div>
                                    <div class="col-md-4">
                                        <label>Ngày Kết Thúc</label>
                                        <input type="date" class="form-control" id="endDate">
                                    </div>
                                    <div class="col-md-4">
                                        <label>&nbsp;</label>
                                        <button class="btn btn-primary w-100" onclick="loadCalendar()">
                                            <i class="far fa-search"></i> Tải Lịch
                                        </button>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="calendar-container">
                                <div id="calendarContent">
                                    <p class="text-center text-muted">Loading calendar...</p>
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
    <script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
    <script>
        let ownerId = null;
        
        document.addEventListener('DOMContentLoaded', async function() {
            // Hide preloader
            const preloader = document.querySelector('.preloader');
            if (preloader) {
                preloader.style.display = 'none';
            }
            
            try {
                if (!HotelBookingAPI || !HotelBookingAPI.TokenManager) {
                    console.error('HotelBookingAPI not loaded');
                    return;
                }
                
                if (!HotelBookingAPI.TokenManager.getToken()) {
                    window.location.href = '/login';
                    return;
                }
                
                const userRole = HotelBookingAPI.TokenManager.getUserRole();
                if (userRole !== 'HOTEL_OWNER' && userRole !== 'ADMIN') {
                    window.location.href = '/dashboard';
                    return;
                }
                
                // Load sidebar menu and user info
                const userInfo = HotelBookingAPI.TokenManager.getUserInfo();
                const userFullNameEl = document.getElementById('userFullName');
                const userEmailEl = document.getElementById('userEmail');
                if (userFullNameEl) userFullNameEl.textContent = userInfo.fullName || userInfo.username || 'User';
                if (userEmailEl) userEmailEl.textContent = userInfo.email || '';
                
                if (typeof loadSidebarMenu === 'function') {
                    loadSidebarMenu(userRole, '/owner/calendar');
                }
                
                const userId = HotelBookingAPI.TokenManager.getUserId();
                ownerId = userId ? parseInt(userId, 10) : null;
                
                if (!ownerId) {
                    console.error('Owner ID not found');
                    document.getElementById('calendarContent').innerHTML = 
                        '<p class="text-danger">Error: Owner ID not found. Please log in again.</p>';
                    return;
                }
                
                // Set default dates
                const startDateEl = document.getElementById('startDate');
                const endDateEl = document.getElementById('endDate');
                
                if (startDateEl && endDateEl) {
                    const today = new Date();
                    const nextMonth = new Date(today);
                    nextMonth.setMonth(nextMonth.getMonth() + 1);
                    
                    startDateEl.value = today.toISOString().split('T')[0];
                    endDateEl.value = nextMonth.toISOString().split('T')[0];
                    
                    await loadCalendar();
                }
            } catch (error) {
                console.error('Error initializing calendar page:', error);
                const calendarContent = document.getElementById('calendarContent');
                if (calendarContent) {
                    calendarContent.innerHTML = 
                        '<p class="text-danger">Error initializing calendar: ' + (error.message || 'Unknown error') + '</p>';
                }
            }
        });

        async function loadCalendar() {
            try {
                if (!ownerId) {
                    throw new Error('Owner ID is not set');
                }
                
                const startDateEl = document.getElementById('startDate');
                const endDateEl = document.getElementById('endDate');
                
                if (!startDateEl || !endDateEl) {
                    throw new Error('Date input elements not found');
                }
                
                const startDate = startDateEl.value;
                const endDate = endDateEl.value;
                
                if (!startDate || !endDate) {
                    throw new Error('Please select start and end dates');
                }
                
                if (!HotelBookingAPI || !HotelBookingAPI.OwnerAPI || !HotelBookingAPI.OwnerAPI.getCalendar) {
                    throw new Error('API not loaded');
                }
                
                document.getElementById('calendarContent').innerHTML = 
                    '<p class="text-center text-muted">Loading calendar...</p>';
                
                const bookings = await HotelBookingAPI.OwnerAPI.getCalendar(ownerId, startDate, endDate);
                displayCalendar(bookings, startDate, endDate);
            } catch (error) {
                console.error('Error loading calendar:', error);
                const calendarContent = document.getElementById('calendarContent');
                if (calendarContent) {
                    calendarContent.innerHTML = 
                        '<p class="text-danger">Error loading calendar: ' + (error.message || 'Unknown error') + '</p>';
                }
            }
        }

        function displayCalendar(bookings, startDate, endDate) {
            const start = new Date(startDate);
            const end = new Date(endDate);
            const days = [];
            
            // Ensure bookings is an array
            if (!Array.isArray(bookings)) {
                bookings = [];
            }
            
            // Group bookings by date
            const bookingsByDate = {};
            bookings.forEach(booking => {
                if (!booking || !booking.checkInDate || !booking.checkOutDate) {
                    return; // Skip invalid bookings
                }
                
                const checkIn = new Date(booking.checkInDate);
                const checkOut = new Date(booking.checkOutDate);
                
                let current = new Date(checkIn);
                while (current <= checkOut) {
                    const dateStr = current.toISOString().split('T')[0];
                    if (!bookingsByDate[dateStr]) {
                        bookingsByDate[dateStr] = [];
                    }
                    bookingsByDate[dateStr].push(booking);
                    current.setDate(current.getDate() + 1);
                }
            });
            
            // Generate calendar days
            let current = new Date(start);
            while (current <= end) {
                days.push(new Date(current));
                current.setDate(current.getDate() + 1);
            }
            
            // Create calendar HTML
            let html = '<div class="calendar-grid">';
            
            // Day headers with full day names
            const dayNames = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
            dayNames.forEach(day => {
                html += `<div class="calendar-day-header" style="background: #f8f9fa; padding: 10px; text-align: center; font-weight: bold;">${day}</div>`;
            });
            
            // Calendar days
            days.forEach(day => {
                const dateStr = day.toISOString().split('T')[0];
                const dayBookings = bookingsByDate[dateStr] || [];
                
                // Get day of week (0 = Sunday, 1 = Monday, etc.)
                const dayOfWeek = day.getDay();
                const dayName = dayNames[dayOfWeek];
                const dayNumber = day.getDate();
                const month = day.getMonth() + 1;
                const year = day.getFullYear();
                
                // Format: Thứ Hai, 02/12/2025
                const dateDisplay = `${dayName}, ${String(dayNumber).padStart(2, '0')}/${String(month).padStart(2, '0')}/${year}`;
                
                html += '<div class="calendar-day">';
                html += `<div class="calendar-day-header">${dateDisplay}</div>`;
                
                dayBookings.forEach(booking => {
                    // Safely handle status with default value
                    const status = (booking.bookingStatus || booking.status || 'pending').toLowerCase();
                    const roomName = booking.roomType?.name || booking.roomName || 'Unknown Room Type';
                    const guestName = booking.guestName || 'Unknown Guest';
                    
                    html += `<div class="booking-item ${status}" title="${roomName} - ${guestName}">`;
                    html += `${roomName}<br><small>${guestName}</small>`;
                    html += `</div>`;
                });
                
                html += '</div>';
            });
            
            html += '</div>';
            document.getElementById('calendarContent').innerHTML = html;
        }
    </script>
</body>
</html>

