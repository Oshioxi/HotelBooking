// Dashboard Page for Admin/Owner
// Only run dashboard-specific logic if we're on the dashboard page
document.addEventListener('DOMContentLoaded', async function() {
    const path = window.location.pathname;
    const isDashboardPage = path.includes('/dashboard') && !path.includes('/admin/') && !path.includes('/owner/');
    
    if (isDashboardPage) {
        if (!HotelBookingAPI.TokenManager.getToken()) {
            window.location.href = '/login';
            return;
        }

        const userRole = HotelBookingAPI.TokenManager.getUserRole();
        const userId = HotelBookingAPI.TokenManager.getUserId();
        const userInfo = HotelBookingAPI.TokenManager.getUserInfo();

        // Update user info in sidebar
        const userFullNameEl = document.getElementById('userFullName');
        const userEmailEl = document.getElementById('userEmail');
        if (userFullNameEl) userFullNameEl.textContent = userInfo.fullName || userInfo.username || 'User';
        if (userEmailEl) userEmailEl.textContent = userInfo.email || '';

        // Load sidebar menu based on role
        loadSidebarMenu(userRole, '/dashboard');

        if (userRole === 'ADMIN') {
            await loadAdminDashboard();
        } else if (userRole === 'HOTEL_OWNER') {
            await loadOwnerDashboard(userId);
        } else {
            // Regular user - redirect or show user dashboard
            window.location.href = '/index';
        }
    }
});

function loadSidebarMenu(role, currentPage) {
    const menuContainer = document.getElementById('sidebarMenu');
    if (!menuContainer) return;

    // Get current path
    const path = window.location.pathname;
    
    // Determine current page if not provided
    if (!currentPage) {
        currentPage = path;
    }
    
    // Helper function to check if a menu item should be active
    const isActive = (pagePath) => {
        if (!pagePath) return false;
        return currentPage.includes(pagePath) || path.includes(pagePath);
    };
    
    // Helper function to create menu item HTML with absolute path
    const menuItem = (href, icon, text, active) => {
        // Ensure href starts with / to make it absolute
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
        // USER role - Hồ sơ instead of Dashboard
        menuHTML += menuItem('/user/profile', 'far fa-user', 'Hồ sơ', isActive('/user/profile'));
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

async function loadAdminDashboard() {
    try {
        // Load statistics
        const stats = await HotelBookingAPI.StatisticsAPI.getAdminStats();
        displayAdminStats(stats);
        
        // Load pending room types
        const pendingRooms = await HotelBookingAPI.AdminAPI.getPendingRoomTypes();
        displayPendingRooms(pendingRooms);
        
        // Load recent bookings
        const bookings = await HotelBookingAPI.AdminAPI.getAllBookings();
        displayRecentBookings(bookings.slice(0, 10)); // Show last 10
        
        // Load all users count
        const users = await HotelBookingAPI.AdminAPI.getAllUsers();
        updateUserCount(users.length);
        
        // Load chart data (with real bookings data)
        await loadChartData(stats);
    } catch (error) {
        console.error('Error loading admin dashboard:', error);
        alert('Error loading dashboard: ' + error.message);
    }
}

function updateUserCount(count) {
    const userCountEl = document.getElementById('totalUsers');
    if (userCountEl) {
        userCountEl.textContent = count;
    }
}

async function loadOwnerDashboard(ownerId) {
    try {
        // Check if token exists
        const token = HotelBookingAPI.TokenManager.getToken();
        if (!token) {
            console.error('No token found. Redirecting to login...');
            window.location.href = '/login';
            return;
        }

        // Verify ownerId is valid and convert to number if needed
        if (!ownerId) {
            console.error('Invalid owner ID');
            alert('Invalid owner ID. Please login again.');
            window.location.href = '/login';
            return;
        }

        // Convert ownerId to number if it's a string
        const numericOwnerId = typeof ownerId === 'string' ? parseInt(ownerId, 10) : ownerId;
        if (isNaN(numericOwnerId)) {
            console.error('Invalid owner ID format:', ownerId);
            alert('Invalid owner ID format. Please login again.');
            window.location.href = '/login';
            return;
        }

        console.log('Loading owner dashboard for ownerId:', numericOwnerId);
        console.log('Token exists:', !!token);
        console.log('User role:', HotelBookingAPI.TokenManager.getUserRole());

        const stats = await HotelBookingAPI.StatisticsAPI.getOwnerStats(numericOwnerId);
        displayOwnerStats(stats);
        
        // Load chart data (with real bookings data)
        await loadChartData(stats);
        
        // Load owner's hotels
        const hotels = await HotelBookingAPI.HotelAPI.getByOwner(ownerId);
        displayHotels(hotels);
        
        // Hide pending rooms section for owner
        const pendingSection = document.getElementById('pendingRoomsSection');
        if (pendingSection) pendingSection.style.display = 'none';
    } catch (error) {
        console.error('Error loading owner dashboard:', error);
        
        // Check if it's a 403 Forbidden error
        if (error.message && (error.message.includes('Forbidden') || error.message.includes('403'))) {
            console.error('Access forbidden. Possible reasons:');
            console.error('1. Token may be expired or invalid');
            console.error('2. User role may not match required permissions');
            console.error('3. User may not have access to this resource');
            
            // Show user-friendly error message
            const errorMsg = 'Bạn không có quyền truy cập trang này. Vui lòng đăng nhập lại.';
            alert(errorMsg);
            
            // Optionally redirect to login
            // window.location.href = '/login';
            
            // Display error in dashboard instead of redirecting
            const statsContainer = document.querySelector('.user-profile-wrapper');
            if (statsContainer) {
                statsContainer.innerHTML = `
                    <div class="alert alert-danger">
                        <h5>Lỗi truy cập</h5>
                        <p>${errorMsg}</p>
                        <p><small>Chi tiết: ${error.message}</small></p>
                        <button class="btn btn-primary" onclick="window.location.href='/login'">Đăng nhập lại</button>
                    </div>
                `;
            }
        } else {
            // Other errors - show generic message
            const errorMsg = 'Không thể tải dữ liệu dashboard. Vui lòng thử lại sau.';
            console.error('Dashboard loading error:', error);
            
            const statsContainer = document.querySelector('.user-profile-wrapper');
            if (statsContainer) {
                statsContainer.innerHTML = `
                    <div class="alert alert-warning">
                        <h5>Cảnh báo</h5>
                        <p>${errorMsg}</p>
                        <p><small>Chi tiết: ${error.message || 'Unknown error'}</small></p>
                    </div>
                `;
            }
        }
    }
}

function displayAdminStats(stats) {
    const updateEl = (id, text) => {
        const el = document.getElementById(id);
        if (el) el.textContent = text;
    };
    
    updateEl('totalBookings', stats.totalBookings || 0);
    updateEl('totalRevenue', HotelBookingAPI.Utils.formatCurrency(stats.totalRevenue || 0));
    updateEl('pendingRooms', stats.pendingRooms || 0);
    
    // Show cancellation widget for admin
    const cancellationWidget = document.getElementById('cancellationWidget');
    if (cancellationWidget) {
        cancellationWidget.style.display = 'block';
        updateEl('cancellationRate', (stats.cancellationRate || 0).toFixed(2) + '%');
    }
    
    // Hide occupancy widget for admin
    const occupancyWidget = document.getElementById('occupancyWidget');
    if (occupancyWidget) occupancyWidget.style.display = 'none';
    
    // Show total users widget
    const totalUsersWidget = document.getElementById('totalUsersWidget');
    if (totalUsersWidget) totalUsersWidget.style.display = 'block';
}

function displayOwnerStats(stats) {
    const updateEl = (id, text) => {
        const el = document.getElementById(id);
        if (el) el.textContent = text;
    };
    
    updateEl('totalBookings', stats.totalBookings || 0);
    updateEl('totalRevenue', HotelBookingAPI.Utils.formatCurrency(stats.totalRevenue || 0));
    updateEl('occupancyRate', (stats.occupancyRate || 0).toFixed(2) + '%');
    updateEl('cancellationRate', (stats.cancellationRate || 0).toFixed(2) + '%');
    
    // Update labels
    const pendingLabel = document.getElementById('pendingLabel');
    if (pendingLabel) pendingLabel.textContent = 'Cancelled Bookings';
    const revenueLabel = document.getElementById('revenueLabel');
    if (revenueLabel) revenueLabel.textContent = 'You Earned';
    
    // Show additional widgets
    const occupancyWidget = document.getElementById('occupancyWidget');
    const cancellationWidget = document.getElementById('cancellationWidget');
    if (occupancyWidget) occupancyWidget.style.display = 'block';
    if (cancellationWidget) cancellationWidget.style.display = 'block';
}

function displayPendingRooms(rooms) {
    const container = document.getElementById('pendingRoomsList');
    if (!container) return;

    if (rooms.length === 0) {
        container.innerHTML = '<p class="text-muted">No pending rooms</p>';
        return;
    }

    let html = '<div class="table-responsive"><table class="table table-hover"><thead><tr><th>Room Name</th><th>Hotel</th><th>Type</th><th>Price/Night</th><th>Created</th><th>Actions</th></tr></thead><tbody>';
    rooms.forEach(room => {
        const createdDate = room.createdAt ? new Date(room.createdAt).toLocaleDateString() : 'N/A';
        html += `
            <tr>
                <td><strong>${room.name || 'N/A'}</strong></td>
                <td>${room.hotel?.name || 'N/A'}</td>
                <td>${room.roomType || 'N/A'}</td>
                <td>${HotelBookingAPI.Utils.formatCurrency(room.pricePerNight || 0)}</td>
                <td>${createdDate}</td>
                <td>
                    <button class="btn btn-sm btn-success me-1" onclick="approveRoomType(${room.id})">
                        <i class="far fa-check"></i> Approve
                    </button>
                    <button class="btn btn-sm btn-danger" onclick="rejectRoomType(${room.id})">
                        <i class="far fa-times"></i> Reject
                    </button>
                </td>
            </tr>
        `;
    });
    html += '</tbody></table></div>';
    container.innerHTML = html;
}

function displayRecentBookings(bookings) {
    const tbody = document.querySelector('#recentBookingsTable tbody');
    if (!tbody) return;

    if (bookings.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">No bookings found</td></tr>';
        return;
    }

    let html = '';
    bookings.forEach((booking, index) => {
        const statusClass = {
            'PENDING': 'badge-warning',
            'CONFIRMED': 'badge-success',
            'CANCELLED': 'badge-danger',
            'COMPLETED': 'badge-primary'
        }[booking.bookingStatus] || 'badge-secondary';
        
        html += `
            <tr>
                <td>${index + 1}.</td>
                <td><b>#${booking.id}</b></td>
                <td>${booking.roomType?.name || 'N/A'}</td>
                <td>${HotelBookingAPI.Utils.formatDate(booking.checkInDate)}</td>
                <td>${HotelBookingAPI.Utils.formatCurrency(booking.totalPrice || 0)}</td>
                <td><span class="badge ${statusClass}">${booking.bookingStatus || 'N/A'}</span></td>
                <td>
                    <a href="#" class="btn btn-outline-secondary btn-sm" onclick="viewBooking(${booking.id})">
                        <i class="far fa-eye"></i>
                    </a>
                </td>
            </tr>
        `;
    });
    tbody.innerHTML = html;
}

async function loadChartData(stats) {
    try {
        // Get all bookings to analyze by month
        const bookings = await HotelBookingAPI.BookingAPI.getAll();
        
        // Group bookings by month for the last 6 months
        const monthlyData = processMonthlyData(bookings);
        
        // Render the chart
        renderSalesChart(monthlyData);
    } catch (error) {
        console.error('Error loading chart data:', error);
    }
}

function processMonthlyData(bookings) {
    const months = [];
    const bookingCounts = [];
    const revenues = [];
    
    // Get last 6 months
    const now = new Date();
    for (let i = 5; i >= 0; i--) {
        const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
        const monthName = date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' });
        months.push(monthName);
        
        // Filter bookings for this month
        const monthBookings = bookings.filter(b => {
            const bookingDate = new Date(b.createdAt || b.checkInDate);
            return bookingDate.getFullYear() === date.getFullYear() && 
                   bookingDate.getMonth() === date.getMonth();
        });
        
        bookingCounts.push(monthBookings.length);
        
        // Calculate revenue for paid bookings
        const monthRevenue = monthBookings
            .filter(b => b.paymentStatus === 'PAID')
            .reduce((sum, b) => sum + (parseFloat(b.totalPrice) || 0), 0);
        revenues.push(monthRevenue);
    }
    
    return { months, bookingCounts, revenues };
}

function renderSalesChart(data) {
    const chartElement = document.querySelector('#chart');
    if (!chartElement) return;
    
    const options = {
        series: [{
            name: 'Bookings',
            type: 'column',
            data: data.bookingCounts
        }, {
            name: 'Revenue ($)',
            type: 'line',
            data: data.revenues.map(r => (r / 25000).toFixed(2)) // Convert to USD
        }],
        chart: {
            height: 350,
            type: 'line',
            toolbar: {
                show: false
            }
        },
        stroke: {
            width: [0, 4]
        },
        dataLabels: {
            enabled: true,
            enabledOnSeries: [1]
        },
        labels: data.months,
        xaxis: {
            type: 'category'
        },
        yaxis: [{
            title: {
                text: 'Bookings',
            },
        }, {
            opposite: true,
            title: {
                text: 'Revenue ($)'
            }
        }],
        colors: ['#5156be', '#ff6c2f'],
        legend: {
            position: 'top',
            horizontalAlign: 'left'
        }
    };

    const chart = new ApexCharts(chartElement, options);
    chart.render();
}

function displayHotels(hotels) {
    const container = document.getElementById('hotelsList');
    if (!container) return;

    if (hotels.length === 0) {
        container.innerHTML = '<p>No hotels found. <a href="hotel-add.html">Add a hotel</a></p>';
        return;
    }

    let html = '';
    hotels.forEach(hotel => {
        html += `
            <div class="hotel-item">
                <h4>${hotel.name}</h4>
                <p>${hotel.city}, ${hotel.country}</p>
                <a href="hotel-add.html?id=${hotel.id}" class="btn btn-primary">Edit</a>
            </div>
        `;
    });
    container.innerHTML = html;
}

async function approveRoomType(roomTypeId) {
    if (!confirm('Approve this room type? It will be visible to users.')) return;
    try {
        await HotelBookingAPI.AdminAPI.approveRoomType(roomTypeId);
        alert('Room type approved successfully!');
        location.reload();
    } catch (error) {
        alert('Error approving room type: ' + error.message);
    }
}

async function rejectRoomType(roomTypeId) {
    const reason = prompt('Enter rejection reason:');
    if (!reason || reason.trim() === '') {
        alert('Rejection reason is required');
        return;
    }
    try {
        await HotelBookingAPI.AdminAPI.rejectRoomType(roomTypeId, reason);
        alert('Room type rejected successfully');
        location.reload();
    } catch (error) {
        alert('Error rejecting room type: ' + error.message);
    }
}

function viewBooking(bookingId) {
    // Navigate to booking details or show modal
    window.location.href = `${window.location.pathname}?booking=${bookingId}`;
}

// Make functions global
window.approveRoomType = approveRoomType;
window.rejectRoomType = rejectRoomType;
window.viewBooking = viewBooking;
