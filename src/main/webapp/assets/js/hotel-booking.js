// Hotel Booking Page
document.addEventListener('DOMContentLoaded', async function() {
    const urlParams = new URLSearchParams(window.location.search);
    const bookingId = urlParams.get('id');
    const roomTypeId = urlParams.get('roomTypeId');
    
    if (!HotelBookingAPI.TokenManager.getToken()) {
        alert('Please login to continue');
        window.location.href = '/login';
        return;
    }

    // If roomTypeId is provided, show booking form
    if (roomTypeId) {
        try {
            await loadBookingForm(roomTypeId, urlParams);
        } catch (error) {
            console.error('Error loading booking form:', error);
            alert('Error loading booking form: ' + (error.message || 'Please try again'));
            window.location.href = '/index';
        }
        return;
    }

    // If bookingId is provided, show booking details
    if (bookingId) {
        // Show booking details section
        const bookingFormSection = document.getElementById('bookingFormSection');
        const bookingDetailsSection = document.getElementById('bookingDetailsSection');
        const roomInfoSection = document.getElementById('roomInfoForBooking');
        const bookingSummarySection = document.getElementById('bookingSummarySection');
        
        if (bookingFormSection) {
            bookingFormSection.style.display = 'none';
        }
        if (bookingDetailsSection) {
            bookingDetailsSection.style.display = 'block';
        }
        if (roomInfoSection) {
            roomInfoSection.style.display = 'none';
        }
        if (bookingSummarySection) {
            bookingSummarySection.style.display = 'block';
        }

        try {
            const booking = await HotelBookingAPI.BookingAPI.getById(bookingId);
            await displayBookingDetails(booking);
            
            // Setup cancel booking button
            setupCancelBooking(booking);
        } catch (error) {
            console.error('Error loading booking:', error);
            alert('Error loading booking details: ' + (error.message || 'Please try again'));
            window.location.href = '/index';
        }
        return;
    }

    // Neither bookingId nor roomTypeId provided
    alert('Booking ID or Room Type ID is required');
    window.location.href = '/index';
});

async function displayBookingDetails(booking) {
    try {
        // Load room type details
        const room = await HotelBookingAPI.RoomTypeAPI.getById(booking.roomTypeId);
        
        // Load hotel details
        let hotel = null;
        if (room.hotelId) {
            try {
                hotel = await HotelBookingAPI.HotelAPI.getById(room.hotelId);
            } catch (error) {
                console.error('Error loading hotel:', error);
            }
        }
        
        // Helper function to update element
        const updateElement = (id, text) => {
            const el = document.getElementById(id);
            if (el) el.textContent = text;
        };
        
        const updateHTML = (id, html) => {
            const el = document.getElementById(id);
            if (el) el.innerHTML = html;
        };
        
        // Update booking ID
        updateElement('displayBookingId', `#${booking.id}`);
        
        // Update booking status with appropriate badge color
        const bookingStatusEl = document.getElementById('displayBookingStatus');
        if (bookingStatusEl) {
            bookingStatusEl.textContent = booking.bookingStatus;
            bookingStatusEl.className = 'badge';
            switch(booking.bookingStatus) {
                case 'CONFIRMED':
                    bookingStatusEl.classList.add('bg-success');
                    break;
                case 'PENDING':
                    bookingStatusEl.classList.add('bg-warning');
                    break;
                case 'CANCELLED':
                    bookingStatusEl.classList.add('bg-danger');
                    break;
                case 'COMPLETED':
                    bookingStatusEl.classList.add('bg-info');
                    break;
                default:
                    bookingStatusEl.classList.add('bg-secondary');
            }
        }
        
        // Load payment information
        try {
            const payment = await HotelBookingAPI.PaymentAPI.getLatestByBooking(booking.id);
            displayPaymentInfo(payment);
        } catch (error) {
            console.log('No payment found for this booking');
            // Show payment section with message
            const paymentSection = document.getElementById('paymentInfoSection');
            if (paymentSection) {
                paymentSection.innerHTML = '<p class="text-muted">Chưa có thông tin thanh toán. Vui lòng thanh toán để xác nhận booking.</p>';
            }
        }
        
        // Update guest information
        updateElement('displayGuestName', booking.guestName);
        updateElement('displayGuestEmail', booking.guestEmail);
        updateElement('displayGuestPhone', booking.guestPhone);
        updateElement('displayGuests', `${booking.numberOfGuests} Guest${booking.numberOfGuests > 1 ? 's' : ''}`);
        updateElement('displayGuestsCount', `${booking.numberOfGuests} Guest${booking.numberOfGuests > 1 ? 's' : ''}`);
        
        // Update number of rooms if available
        if (booking.numberOfRooms) {
            const roomsEl = document.getElementById('displayRooms');
            const roomsContainer = document.getElementById('displayRoomsContainer');
            const roomsCountEl = document.getElementById('displayRoomsCount');
            const roomsListItem = document.getElementById('displayRoomsListItem');
            
            if (roomsEl) roomsEl.textContent = `${booking.numberOfRooms} Room${booking.numberOfRooms > 1 ? 's' : ''}`;
            if (roomsContainer) roomsContainer.style.display = 'block';
            if (roomsCountEl) roomsCountEl.textContent = `${booking.numberOfRooms} Room${booking.numberOfRooms > 1 ? 's' : ''}`;
            if (roomsListItem) roomsListItem.style.display = 'list-item';
        }
        
        // Update special requests if available
        if (booking.specialRequests) {
            const requestsEl = document.getElementById('displaySpecialRequests');
            const requestsContainer = document.getElementById('displaySpecialRequestsContainer');
            if (requestsEl) requestsEl.textContent = booking.specialRequests;
            if (requestsContainer) requestsContainer.style.display = 'block';
        }
        
        // Update room information
        updateElement('displayRoomName', room.name || 'Room');
        updateElement('displayRoomType', room.roomType || '-');
        
        // Update hotel location
        if (hotel) {
            updateHTML('displayHotelLocation', `<i class="far fa-map-marker-alt"></i> ${hotel.city || ''}, ${hotel.country || ''}`);
            
            // Update hotel rating if available
            if (hotel.rating && parseFloat(hotel.rating) > 0) {
                updateElement('displayHotelRating', parseFloat(hotel.rating).toFixed(1));
                const ratingSection = document.getElementById('hotelRatingSection');
                if (ratingSection) ratingSection.style.display = 'block';
            }
        }
        
        // Update room image
        let images = [];
        try {
            images = room.images ? (typeof room.images === 'string' ? JSON.parse(room.images) : room.images) : [];
        } catch (e) {
            console.error('Error parsing images:', e);
        }
        
        const roomImageEl = document.getElementById('roomImage');
        if (roomImageEl && images.length > 0) {
            roomImageEl.src = images[0];
            roomImageEl.alt = room.name;
        }
        
        // Calculate dates and duration
        const checkInDate = new Date(booking.checkInDate);
        const checkOutDate = new Date(booking.checkOutDate);
        const stayDuration = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));
        
        // Format dates
        const formatDateDisplay = (dateStr) => {
            const date = new Date(dateStr);
            return date.toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: 'short', 
                day: 'numeric' 
            });
        };
        
        updateElement('displayCheckIn', formatDateDisplay(booking.checkInDate));
        updateElement('displayCheckOut', formatDateDisplay(booking.checkOutDate));
        updateElement('displayStayDuration', `${stayDuration} Night${stayDuration > 1 ? 's' : ''}`);
        updateElement('displayNumberOfNights', `${stayDuration} Night${stayDuration > 1 ? 's' : ''}`);
        
        // Update pricing
        const pricePerNight = parseFloat(room.pricePerNight);
        const totalPrice = parseFloat(booking.totalPrice);
        
        updateElement('displayPricePerNight', HotelBookingAPI.Utils.formatCurrency(pricePerNight));
        updateElement('displayTotalPrice', HotelBookingAPI.Utils.formatCurrency(totalPrice));
        
    } catch (error) {
        console.error('Error displaying booking details:', error);
        throw error;
    }
}

function formatPaymentMethod(method) {
    const methodMap = {
        'ONLINE': 'Thanh toán trực tuyến',
        'COD': 'Thanh toán khi nhận phòng',
        'AT_HOTEL': 'Thanh toán tại khách sạn',
        'CREDIT_CARD': 'Thẻ tín dụng',
        'DEBIT_CARD': 'Thẻ ghi nợ',
        'PAYPAL': 'PayPal'
    };
    return methodMap[method] || method;
}

function formatPaymentStatus(status) {
    const statusMap = {
        'PENDING': 'Chờ thanh toán',
        'PAID': 'Đã thanh toán',
        'FAILED': 'Thanh toán thất bại',
        'REFUNDED': 'Đã hoàn tiền',
        'CANCELLED': 'Đã hủy'
    };
    return statusMap[status] || status;
}

function displayPaymentInfo(payment) {
    const paymentSection = document.getElementById('paymentInfoSection');
    if (!paymentSection) {
        // Create payment section if it doesn't exist
        const bookingStatusSection = document.querySelector('.booking-status-info');
        if (bookingStatusSection) {
            const newSection = document.createElement('div');
            newSection.className = 'booking-widget';
            newSection.id = 'paymentInfoSection';
            newSection.innerHTML = '<h4 class="booking-widget-title">Thông tin thanh toán</h4><div class="booking-status-info"></div>';
            bookingStatusSection.parentNode.insertBefore(newSection, bookingStatusSection.nextSibling);
        }
    }

    const paymentContainer = paymentSection ? paymentSection.querySelector('.booking-status-info') : null;
    if (!paymentContainer) return;

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    };

    const formatDateTime = (dateStr) => {
        if (!dateStr) return '-';
        const date = new Date(dateStr);
        return date.toLocaleString('vi-VN', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    };

    let statusBadgeClass = 'bg-secondary';
    if (payment.paymentStatus === 'PAID') statusBadgeClass = 'bg-success';
    else if (payment.paymentStatus === 'FAILED') statusBadgeClass = 'bg-danger';
    else if (payment.paymentStatus === 'PENDING') statusBadgeClass = 'bg-warning';
    else if (payment.paymentStatus === 'REFUNDED') statusBadgeClass = 'bg-info';

    let html = `
        <div class="row">
            <div class="col-lg-12 mb-3">
                <p class="text-muted mb-1">Trạng thái thanh toán</p>
                <span class="badge ${statusBadgeClass}" style="font-size: 1rem; padding: 0.5rem 1rem;">
                    ${formatPaymentStatus(payment.paymentStatus)}
                </span>
            </div>
            <div class="col-lg-12 mb-3">
                <p class="text-muted mb-1">Phương thức thanh toán</p>
                <p class="fw-bold">${formatPaymentMethod(payment.paymentMethod)}</p>
            </div>
            <div class="col-lg-12 mb-3">
                <p class="text-muted mb-1">Số tiền</p>
                <p class="fw-bold">${formatCurrency(payment.amount)}</p>
            </div>
            ${payment.transactionId ? `
            <div class="col-lg-12 mb-3">
                <p class="text-muted mb-1">Mã giao dịch</p>
                <p class="fw-bold">${payment.transactionId}</p>
            </div>
            ` : ''}
            ${payment.paymentDate ? `
            <div class="col-lg-12 mb-3">
                <p class="text-muted mb-1">Ngày thanh toán</p>
                <p class="fw-bold">${formatDateTime(payment.paymentDate)}</p>
            </div>
            ` : ''}
            ${payment.notes ? `
            <div class="col-lg-12 mb-3">
                <p class="text-muted mb-1">Ghi chú</p>
                <p class="fw-bold">${payment.notes}</p>
            </div>
            ` : ''}
        </div>
    `;

    paymentContainer.innerHTML = html;
}

async function loadBookingForm(roomTypeId, urlParams) {
    try {
        // Load room type details
        const room = await HotelBookingAPI.RoomTypeAPI.getById(roomTypeId);
        
        // Load hotel details
        let hotel = null;
        if (room.hotelId) {
            try {
                hotel = await HotelBookingAPI.HotelAPI.getHotelById(room.hotelId);
            } catch (error) {
                console.error('Error loading hotel:', error);
            }
        }

        // Update breadcrumb title
        const breadcrumbTitle = document.querySelector('.breadcrumb-title');
        if (breadcrumbTitle) {
            breadcrumbTitle.textContent = 'Đặt phòng';
        }

        // Show booking form section
        const bookingFormSection = document.getElementById('bookingFormSection');
        const bookingDetailsSection = document.getElementById('bookingDetailsSection');
        const roomInfoSection = document.getElementById('roomInfoForBooking');
        const bookingSummarySection = document.getElementById('bookingSummarySection');
        
        if (bookingFormSection) {
            bookingFormSection.style.display = 'block';
        }
        if (bookingDetailsSection) {
            bookingDetailsSection.style.display = 'none';
        }
        if (roomInfoSection) {
            roomInfoSection.style.display = 'block';
        }
        if (bookingSummarySection) {
            bookingSummarySection.style.display = 'none';
        }

        // Display room and hotel info
        displayRoomInfoForBooking(room, hotel);
        
        // Pre-fill form with URL parameters
        const checkIn = urlParams.get('checkIn');
        const checkOut = urlParams.get('checkOut');
        const guests = urlParams.get('guests');

        if (checkIn && document.getElementById('bookingCheckIn')) {
            document.getElementById('bookingCheckIn').value = checkIn;
        }
        if (checkOut && document.getElementById('bookingCheckOut')) {
            document.getElementById('bookingCheckOut').value = checkOut;
        }
        if (guests && document.getElementById('bookingGuests')) {
            document.getElementById('bookingGuests').value = guests;
        }

        // Set min dates
        const today = new Date().toISOString().split('T')[0];
        const checkInInput = document.getElementById('bookingCheckIn');
        const checkOutInput = document.getElementById('bookingCheckOut');
        if (checkInInput) checkInInput.setAttribute('min', today);
        if (checkOutInput) checkOutInput.setAttribute('min', today);

        // Auto-fill guest info if logged in
        const userInfo = HotelBookingAPI.TokenManager.getUserInfo();
        if (userInfo.fullName && document.getElementById('guestName')) {
            document.getElementById('guestName').value = userInfo.fullName;
        }
        if (userInfo.email && document.getElementById('guestEmail')) {
            document.getElementById('guestEmail').value = userInfo.email;
        }

        // Setup booking form submission
        setupBookingFormSubmission(roomTypeId, room, hotel);
    } catch (error) {
        console.error('Error loading booking form:', error);
        throw error;
    }
}

function displayRoomInfoForBooking(room, hotel) {
    const roomInfoEl = document.getElementById('roomInfoForBooking');
    if (!roomInfoEl) return;

    const priceInVND = parseFloat(room.pricePerNight).toLocaleString('vi-VN');
    const priceInUSD = (parseFloat(room.pricePerNight) / 25000).toFixed(2);

    let html = `
        <div class="booking-property-img mb-3">
            <img src="/assets/img/hotel/room/04.jpg" alt="${room.name}" id="roomImageForBooking" style="width: 100%; height: auto; border-radius: 8px;">
        </div>
        <div class="booking-property-content">
            <h5>${room.name || 'Room'}</h5>
            ${hotel ? `<p><i class="far fa-map-marker-alt"></i> ${hotel.name}, ${hotel.city || ''}, ${hotel.country || ''}</p>` : ''}
            <div class="mb-3">
                <span class="badge bg-secondary me-2">${room.roomType || '-'}</span>
                <span class="text-muted"><i class="far fa-user me-1"></i>Tối đa ${room.maxOccupancy || '-'} khách</span>
            </div>
            <div class="booking-property-rate">
                <span class="badge bg-primary" style="font-size: 1.2rem; padding: 0.5rem 1rem;">
                    ${priceInVND} VND
                </span>
                <span class="text-muted ms-2">($${priceInUSD} / đêm)</span>
            </div>
        </div>
    `;

    roomInfoEl.innerHTML = html;

    // Load room image
    try {
        const images = room.images ? (typeof room.images === 'string' ? JSON.parse(room.images) : room.images) : [];
        if (images.length > 0) {
            const roomImageEl = document.getElementById('roomImageForBooking');
            if (roomImageEl) roomImageEl.src = images[0];
        }
    } catch (e) {
        console.error('Error loading room image:', e);
    }
}

function setupBookingFormSubmission(roomTypeId, room, hotel) {
    const bookingForm = document.getElementById('newBookingForm');
    if (!bookingForm) return;

    bookingForm.addEventListener('submit', async function(e) {
        e.preventDefault();

        const userId = HotelBookingAPI.TokenManager.getUserId();
        if (!userId) {
            alert('User information not found. Please login again.');
            return;
        }

        // Validate dates
        const checkInDate = document.getElementById('bookingCheckIn').value;
        const checkOutDate = document.getElementById('bookingCheckOut').value;
        const today = new Date().toISOString().split('T')[0];

        if (!checkInDate || !checkOutDate) {
            alert('Vui lòng chọn ngày check-in và check-out');
            return;
        }

        if (checkInDate < today) {
            alert('Ngày check-in không thể là ngày trong quá khứ');
            return;
        }

        if (checkOutDate <= checkInDate) {
            alert('Ngày check-out phải sau ngày check-in');
            return;
        }

        const submitBtn = document.getElementById('submitBookingBtn');
        const originalText = submitBtn.innerHTML;
        
        submitBtn.disabled = true;
        submitBtn.innerHTML = '<span class="far fa-spinner fa-spin me-2"></span>Đang xử lý...';

        const bookingData = {
            roomTypeId: roomTypeId,
            checkInDate: checkInDate,
            checkOutDate: checkOutDate,
            numberOfGuests: parseInt(document.getElementById('bookingGuests').value) || 1,
            numberOfRooms: parseInt(document.getElementById('numberOfRooms').value) || 1,
            guestName: document.getElementById('guestName').value,
            guestEmail: document.getElementById('guestEmail').value,
            guestPhone: document.getElementById('guestPhone').value,
            specialRequests: document.getElementById('specialRequests') ? document.getElementById('specialRequests').value.trim() || null : null
        };

        try {
            const booking = await HotelBookingAPI.BookingAPI.create(userId, bookingData);
            // Redirect to checkout page
            window.location.href = `/checkout?bookingId=${booking.id}`;
        } catch (error) {
            console.error('Error creating booking:', error);
            alert('Lỗi đặt phòng: ' + (error.message || 'Vui lòng thử lại'));
            submitBtn.disabled = false;
            submitBtn.innerHTML = originalText;
        }
    });
}

function setupCancelBooking(booking) {
    // Show cancel button only if booking is PENDING or CONFIRMED
    if (booking.bookingStatus === 'PENDING' || booking.bookingStatus === 'CONFIRMED') {
        const cancelSection = document.getElementById('cancelBookingSection');
        if (cancelSection) cancelSection.style.display = 'block';
        
        const cancelBtn = document.getElementById('cancelBookingBtn');
        if (cancelBtn) {
            // Remove existing event listeners by cloning
            const newCancelBtn = cancelBtn.cloneNode(true);
            cancelBtn.parentNode.replaceChild(newCancelBtn, cancelBtn);
            
            newCancelBtn.addEventListener('click', async function() {
                if (!confirm('Are you sure you want to cancel this booking?')) {
                    return;
                }
                
                try {
                    newCancelBtn.disabled = true;
                    newCancelBtn.innerHTML = '<span class="far fa-spinner fa-spin"></span> Cancelling...';
                    
                    // Check user role to use appropriate endpoint
                    const userRole = HotelBookingAPI.TokenManager.getUserRole();
                    const userId = HotelBookingAPI.TokenManager.getUserId();
                    const bookingUserId = booking.userId;
                    
                    // If user is ADMIN or HOTEL_OWNER, or if booking belongs to current user, allow cancel
                    if (userRole === 'ADMIN' || userRole === 'HOTEL_OWNER') {
                        // Admin/Owner can cancel any booking
                        await HotelBookingAPI.BookingAPI.cancelByAdmin(booking.id);
                    } else if (userId && bookingUserId && userId.toString() === bookingUserId.toString()) {
                        // User can cancel their own booking
                        await HotelBookingAPI.BookingAPI.cancel(booking.id, userId);
                    } else {
                        throw new Error('You can only cancel your own bookings');
                    }
                    
                    alert('Booking cancelled successfully');
                    location.reload();
                } catch (error) {
                    alert('Error cancelling booking: ' + (error.message || 'Please try again'));
                    newCancelBtn.disabled = false;
                    newCancelBtn.innerHTML = '<i class="far fa-times-circle"></i> Cancel Booking';
                }
            });
        }
    }
}

