<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Owner - My Bookings</title>
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
                <h2 class="breadcrumb-title">My Bookings</h2>
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
                            <h4 class="user-profile-card-title">Bookings for My Hotels</h4>
                            <div class="table-responsive">
                                <table class="table table-hover" id="bookingsTable">
                                    <thead>
                                        <tr>
                                            <th>Booking ID</th>
                                            <th>Guest Name</th>
                                            <th>Room</th>
                                            <th>Hotel</th>
                                            <th>Check-in</th>
                                            <th>Check-out</th>
                                            <th>Total Price</th>
                                            <th>Status</th>
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

    <!-- Edit Booking Modal -->
    <div class="modal fade" id="editBookingModal" tabindex="-1" aria-labelledby="editBookingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editBookingModalLabel">Edit Booking</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editBookingForm">
                        <input type="hidden" id="editBookingId">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label for="editCheckInDate" class="form-label">Check-in Date *</label>
                                <input type="date" class="form-control" id="editCheckInDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editCheckOutDate" class="form-label">Check-out Date *</label>
                                <input type="date" class="form-control" id="editCheckOutDate" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editNumberOfRooms" class="form-label">Number of Rooms *</label>
                                <input type="number" class="form-control" id="editNumberOfRooms" min="1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label for="editNumberOfGuests" class="form-label">Number of Guests *</label>
                                <input type="number" class="form-control" id="editNumberOfGuests" min="1" required>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label for="editTotalPrice" class="form-label">Total Price (Auto-calculated)</label>
                                <input type="number" class="form-control" id="editTotalPrice" step="0.01" min="0" readonly>
                                <small class="text-muted">Price will be automatically calculated based on dates and number of rooms</small>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label class="form-label">Room Type</label>
                                <input type="text" class="form-control" id="editRoomTypeName" readonly>
                            </div>
                            <div class="col-md-12 mb-3">
                                <label class="form-label">Price per Night</label>
                                <input type="text" class="form-control" id="editPricePerNight" readonly>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveBookingChanges()">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

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
        let ownerId = null;
        
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
                if (userRole !== 'HOTEL_OWNER' && userRole !== 'ADMIN') {
                    window.location.href = contextPath + '/dashboard';
                    return;
                }
                
                // Load sidebar menu and user info
                const userInfo = window.HotelBookingAPI.TokenManager.getUserInfo();
                const userFullNameEl = document.getElementById('userFullName');
                const userEmailEl = document.getElementById('userEmail');
                if (userFullNameEl) userFullNameEl.textContent = safeGet(userInfo, 'fullName') || safeGet(userInfo, 'username') || 'User';
                if (userEmailEl) userEmailEl.textContent = safeGet(userInfo, 'email') || '';
                
                if (typeof loadSidebarMenu === 'function') {
                    loadSidebarMenu(userRole, '/owner/bookings');
                }
                
                ownerId = window.HotelBookingAPI.TokenManager.getUserId();
                if (!ownerId) {
                    alert('Error: User ID not found. Please login again.');
                    window.location.href = contextPath + '/login';
                    return;
                }
                
                await loadBookings();
            } catch (error) {
                console.error('Error initializing bookings page:', error);
                alert('Error initializing page: ' + (error.message || 'Unknown error'));
            }
        });

        async function loadBookings() {
            try {
                const tbody = document.querySelector('#bookingsTable tbody');
                if (tbody) {
                    tbody.innerHTML = '<tr><td colspan="9" class="text-center">Loading bookings...</td></tr>';
                }
                
                if (!ownerId) {
                    throw new Error('Owner ID is not set');
                }
                
                let allBookings = [];
                
                // Use fallback method: Get all hotels of owner and get bookings for each hotel
                // This is more reliable as OwnerAPI.getBookings endpoint may not be available
                const hotels = await window.HotelBookingAPI.HotelAPI.getByOwner(ownerId);
                if (!Array.isArray(hotels)) {
                    throw new Error('Failed to load hotels');
                }
                
                if (hotels.length === 0) {
                    displayBookings([]);
                    return;
                }
                
                // Get bookings for each hotel
                const bookingPromises = hotels.map(async (hotel) => {
                    if (!hotel || !hotel.id) return [];
                    try {
                        const bookings = await window.HotelBookingAPI.BookingAPI.getByHotel(hotel.id);
                        return Array.isArray(bookings) ? bookings : [];
                    } catch (error) {
                        console.warn(`Error loading bookings for hotel ${hotel.id}:`, error);
                        return [];
                    }
                });
                
                const bookingArrays = await Promise.all(bookingPromises);
                allBookings = bookingArrays.flat();
                
                // Ensure bookings is an array
                if (!Array.isArray(allBookings)) {
                    allBookings = [];
                }
                
                displayBookings(allBookings);
            } catch (error) {
                console.error('Error loading bookings:', error);
                const tbody = document.querySelector('#bookingsTable tbody');
                if (tbody) {
                    tbody.innerHTML = '<tr><td colspan="9" class="text-center text-danger">Error loading bookings: ' + (error.message || 'Unknown error') + '</td></tr>';
                }
                alert('Error loading bookings: ' + (error.message || 'Unknown error'));
            }
        }

        async function displayBookings(bookings) {
            const tbody = document.querySelector('#bookingsTable tbody');
            if (!tbody) {
                console.error('Table body not found');
                return;
            }
            
            if (!Array.isArray(bookings) || bookings.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted">No bookings found</td></tr>';
                return;
            }

            // Load additional details for bookings that might be missing room/hotel info
            const bookingsWithDetails = await Promise.all(bookings.map(async (booking) => {
                if (!booking || !booking.id) return booking;
                
                // If room type info is missing, try to load it
                if (!safeGet(booking, 'roomType.name') && safeGet(booking, 'roomTypeId')) {
                    try {
                        const roomType = await window.HotelBookingAPI.RoomTypeAPI.getById(booking.roomTypeId);
                        if (roomType) {
                            booking.roomType = roomType;
                            // If hotel info is missing, try to load it
                            if (!safeGet(booking, 'roomType.hotel.name') && safeGet(roomType, 'hotelId')) {
                                try {
                                    const hotel = await window.HotelBookingAPI.HotelAPI.getById(roomType.hotelId);
                                    if (hotel) {
                                        booking.roomType.hotel = hotel;
                                    }
                                } catch (e) {
                                    console.warn('Error loading hotel for booking:', e);
                                }
                            }
                        }
                    } catch (e) {
                        console.warn('Error loading room type for booking:', e);
                    }
                }
                
                return booking;
            }));

            let html = '';
            bookingsWithDetails.forEach(booking => {
                if (!booking || !booking.id) return;
                
                const statusClass = {
                    'PENDING': 'badge-warning',
                    'CONFIRMED': 'badge-success',
                    'CANCELLED': 'badge-danger',
                    'COMPLETED': 'badge-primary'
                }[safeGet(booking, 'bookingStatus', '').toUpperCase()] || 'badge-secondary';
                
                // Get room name - try multiple paths
                const roomName = safeGet(booking, 'roomType.name') || 
                               safeGet(booking, 'roomName') || 
                               safeGet(booking, 'roomTypeName') || 
                               'N/A';
                
                // Get hotel name - try multiple paths
                const hotelName = safeGet(booking, 'roomType.hotel.name') || 
                                 safeGet(booking, 'hotel.name') || 
                                 safeGet(booking, 'hotelName') || 
                                 safeGet(booking, 'roomType.hotelName') || 
                                 'N/A';
                
                // Get guest name
                const guestName = safeGet(booking, 'guestName') || 
                                safeGet(booking, 'user.fullName') || 
                                safeGet(booking, 'user.username') || 
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
                    '<td><strong>#' + bookingId + '</strong></td>' +
                    '<td>' + escapeHtml(guestName) + '</td>' +
                    '<td><strong>' + escapeHtml(roomName) + '</strong></td>' +
                    '<td>' + escapeHtml(hotelName) + '</td>' +
                    '<td>' + formattedCheckIn + '</td>' +
                    '<td>' + formattedCheckOut + '</td>' +
                    '<td><strong>' + formattedPrice + '</strong></td>' +
                    '<td><span class="badge ' + statusClass + '">' + escapeHtml(bookingStatus) + '</span></td>' +
                    '<td style="white-space: nowrap;">' +
                        (bookingStatus.toUpperCase() === 'PENDING' ? 
                            '<button class="btn btn-sm btn-success me-1" onclick="confirmBooking(' + bookingId + ')" title="Confirm Booking">' +
                                '<i class="far fa-check"></i> Confirm' +
                            '</button>' 
                        : '') +
                        '<button class="btn btn-sm btn-warning me-1" onclick="editBooking(' + bookingId + ')" title="Edit Booking">' +
                            '<i class="far fa-edit"></i> Edit' +
                        '</button>' +
                        '<button class="btn btn-sm btn-info" onclick="viewBookingDetails(' + bookingId + ')" title="View Details">' +
                            '<i class="far fa-eye"></i>' +
                        '</button>' +
                    '</td>' +
                '</tr>';
            });
            tbody.innerHTML = html;
        }

        async function confirmBooking(id) {
            if (!id) {
                alert('Invalid booking ID');
                return;
            }
            
            if (!confirm('Are you sure you want to confirm this booking?')) {
                return;
            }
            
            try {
                await window.HotelBookingAPI.OwnerAPI.confirmBooking(id);
                alert('Booking confirmed successfully');
                await loadBookings();
            } catch (error) {
                console.error('Error confirming booking:', error);
                alert('Error confirming booking: ' + (error.message || 'Unknown error'));
            }
        }
        
        function viewBookingDetails(id) {
            if (!id) {
                alert('Invalid booking ID');
                return;
            }
            // Navigate to booking details page or show modal
            window.location.href = contextPath + '/hotel-booking?id=' + id;
        }
        
        let currentEditingBooking = null;
        let currentRoomType = null;

        async function editBooking(id) {
            if (!id) {
                alert('Invalid booking ID');
                return;
            }
            
            try {
                // Load booking details
                const booking = await window.HotelBookingAPI.BookingAPI.getById(id);
                if (!booking) {
                    alert('Booking not found');
                    return;
                }
                
                currentEditingBooking = booking;
                
                // Load room type to get price per night
                const roomTypeId = safeGet(booking, 'roomTypeId');
                if (roomTypeId) {
                    currentRoomType = await window.HotelBookingAPI.RoomTypeAPI.getById(roomTypeId);
                }
                
                // Populate form
                document.getElementById('editBookingId').value = booking.id;
                document.getElementById('editCheckInDate').value = safeGet(booking, 'checkInDate') || '';
                document.getElementById('editCheckOutDate').value = safeGet(booking, 'checkOutDate') || '';
                document.getElementById('editNumberOfRooms').value = safeGet(booking, 'numberOfRooms', 1);
                document.getElementById('editNumberOfGuests').value = safeGet(booking, 'numberOfGuests', 1);
                
                // Display room type info
                const roomTypeName = safeGet(booking, 'roomType.name') || safeGet(currentRoomType, 'name') || 'N/A';
                const pricePerNight = safeGet(booking, 'roomType.pricePerNight') || safeGet(currentRoomType, 'pricePerNight', 0);
                document.getElementById('editRoomTypeName').value = roomTypeName;
                document.getElementById('editPricePerNight').value = window.HotelBookingAPI && window.HotelBookingAPI.Utils 
                    ? window.HotelBookingAPI.Utils.formatCurrency(pricePerNight) 
                    : pricePerNight.toLocaleString() + ' VND';
                
                // Calculate and display initial total price
                calculateTotalPrice();
                
                // Show modal
                const modal = new bootstrap.Modal(document.getElementById('editBookingModal'));
                modal.show();
                
                // Add event listeners for auto-calculation
                document.getElementById('editCheckInDate').addEventListener('change', calculateTotalPrice);
                document.getElementById('editCheckOutDate').addEventListener('change', calculateTotalPrice);
                document.getElementById('editNumberOfRooms').addEventListener('input', calculateTotalPrice);
            } catch (error) {
                console.error('Error loading booking for edit:', error);
                alert('Error loading booking: ' + (error.message || 'Unknown error'));
            }
        }
        
        function calculateTotalPrice() {
            const checkInDate = document.getElementById('editCheckInDate').value;
            const checkOutDate = document.getElementById('editCheckOutDate').value;
            const numberOfRooms = parseInt(document.getElementById('editNumberOfRooms').value) || 1;
            
            if (!checkInDate || !checkOutDate || !currentRoomType) {
                document.getElementById('editTotalPrice').value = '';
                return;
            }
            
            const checkIn = new Date(checkInDate);
            const checkOut = new Date(checkOutDate);
            
            if (checkOut <= checkIn) {
                document.getElementById('editTotalPrice').value = '';
                return;
            }
            
            // Calculate nights
            const nights = Math.ceil((checkOut - checkIn) / (1000 * 60 * 60 * 24));
            const pricePerNight = parseFloat(safeGet(currentRoomType, 'pricePerNight', 0));
            const totalPrice = nights * pricePerNight * numberOfRooms;
            
            document.getElementById('editTotalPrice').value = totalPrice.toFixed(2);
        }
        
        async function saveBookingChanges() {
            try {
                const bookingId = document.getElementById('editBookingId').value;
                const checkInDate = document.getElementById('editCheckInDate').value;
                const checkOutDate = document.getElementById('editCheckOutDate').value;
                const numberOfRooms = parseInt(document.getElementById('editNumberOfRooms').value);
                const numberOfGuests = parseInt(document.getElementById('editNumberOfGuests').value);
                const totalPrice = parseFloat(document.getElementById('editTotalPrice').value);
                
                if (!checkInDate || !checkOutDate) {
                    alert('Please fill in all required fields');
                    return;
                }
                
                if (new Date(checkOutDate) <= new Date(checkInDate)) {
                    alert('Check-out date must be after check-in date');
                    return;
                }
                
                if (!numberOfRooms || numberOfRooms < 1) {
                    alert('Number of rooms must be at least 1');
                    return;
                }
                
                if (!numberOfGuests || numberOfGuests < 1) {
                    alert('Number of guests must be at least 1');
                    return;
                }
                
                // Prepare update data
                const updateData = {
                    roomTypeId: safeGet(currentEditingBooking, 'roomTypeId'),
                    checkInDate: checkInDate,
                    checkOutDate: checkOutDate,
                    numberOfRooms: numberOfRooms,
                    numberOfGuests: numberOfGuests,
                    guestName: safeGet(currentEditingBooking, 'guestName'),
                    guestEmail: safeGet(currentEditingBooking, 'guestEmail'),
                    guestPhone: safeGet(currentEditingBooking, 'guestPhone'),
                    specialRequests: safeGet(currentEditingBooking, 'specialRequests')
                };
                
                // Update booking
                const saveBtn = document.querySelector('#editBookingModal .btn-primary');
                const originalText = saveBtn.innerHTML;
                saveBtn.disabled = true;
                saveBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Saving...';
                
                const updatedBooking = await window.HotelBookingAPI.BookingAPI.update(bookingId, updateData);
                
                // Close modal
                const modal = bootstrap.Modal.getInstance(document.getElementById('editBookingModal'));
                modal.hide();
                
                alert('Booking updated successfully! Status has been automatically updated based on dates.');
                
                // Reload bookings to show updated data
                await loadBookings();
                
                saveBtn.disabled = false;
                saveBtn.innerHTML = originalText;
            } catch (error) {
                console.error('Error updating booking:', error);
                alert('Error updating booking: ' + (error.message || 'Unknown error'));
                const saveBtn = document.querySelector('#editBookingModal .btn-primary');
                saveBtn.disabled = false;
                saveBtn.innerHTML = 'Save Changes';
            }
        }
        
        // Export functions to global scope
        window.confirmBooking = confirmBooking;
        window.viewBookingDetails = viewBookingDetails;
        window.loadBookings = loadBookings;
        window.editBooking = editBooking;
        window.saveBookingChanges = saveBookingChanges;
    </script>
</body>
</html>


