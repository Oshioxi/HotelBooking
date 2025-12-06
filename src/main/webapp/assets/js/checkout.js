// Checkout Page
let currentBooking = null;
let currentPayment = null;

document.addEventListener('DOMContentLoaded', async function() {
    const urlParams = new URLSearchParams(window.location.search);
    const bookingId = urlParams.get('bookingId');
    
    if (!bookingId) {
        alert('Booking ID is required');
        window.location.href = '/index';
        return;
    }

    if (!HotelBookingAPI.TokenManager.getToken()) {
        alert('Please login to proceed with payment');
        window.location.href = '/login';
        return;
    }

    try {
        // Load booking details
        currentBooking = await HotelBookingAPI.BookingAPI.getById(bookingId);
        
        // Verify booking belongs to current user
        const userId = HotelBookingAPI.TokenManager.getUserId();
        if (currentBooking.userId != userId) {
            alert('You can only pay for your own bookings');
            window.location.href = '/index';
            return;
        }

        // Load room and hotel details
        const room = await HotelBookingAPI.RoomTypeAPI.getById(currentBooking.roomTypeId);
        let hotel = null;
        if (room.hotelId) {
            try {
                hotel = await HotelBookingAPI.HotelAPI.getHotelById(room.hotelId);
            } catch (error) {
                console.error('Error loading hotel:', error);
            }
        }

        // Display booking information
        displayBookingInfo(currentBooking, room, hotel);
        displayBookingSummary(currentBooking, room, hotel);

        // Check if payment already exists
        try {
            currentPayment = await HotelBookingAPI.PaymentAPI.getLatestByBooking(bookingId);
            if (currentPayment.paymentStatus === 'PAID') {
                // Payment already completed, redirect to booking page
                window.location.href = `/hotel-booking?id=${bookingId}`;
                return;
            }
        } catch (error) {
            // No payment exists yet, that's fine
            console.log('No existing payment found');
        }

        // Setup payment form
        setupPaymentForm();
    } catch (error) {
        console.error('Error loading checkout:', error);
        alert('Error loading checkout: ' + (error.message || 'Please try again'));
        window.location.href = '/index';
    }
});

function displayBookingInfo(booking, room, hotel) {
    const bookingInfoEl = document.getElementById('bookingInfo');
    if (!bookingInfoEl) return;

    const formatDate = (dateStr) => {
        const date = new Date(dateStr);
        return date.toLocaleDateString('vi-VN', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });
    };

    const stayDuration = Math.ceil((new Date(booking.checkOutDate) - new Date(booking.checkInDate)) / (1000 * 60 * 60 * 24));

    let html = `
        <div class="row">
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Tên khách</p>
                <p class="fw-bold">${booking.guestName}</p>
            </div>
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Email</p>
                <p class="fw-bold">${booking.guestEmail}</p>
            </div>
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Số điện thoại</p>
                <p class="fw-bold">${booking.guestPhone}</p>
            </div>
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Số khách</p>
                <p class="fw-bold">${booking.numberOfGuests} khách</p>
            </div>
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Số phòng</p>
                <p class="fw-bold">${booking.numberOfRooms} phòng</p>
            </div>
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Thời gian lưu trú</p>
                <p class="fw-bold">${stayDuration} đêm</p>
            </div>
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Check-in</p>
                <p class="fw-bold">${formatDate(booking.checkInDate)}</p>
            </div>
            <div class="col-md-6 mb-3">
                <p class="text-muted mb-1">Check-out</p>
                <p class="fw-bold">${formatDate(booking.checkOutDate)}</p>
            </div>
            ${hotel ? `
            <div class="col-md-12 mb-3">
                <p class="text-muted mb-1">Khách sạn</p>
                <p class="fw-bold">${hotel.name}</p>
                <p class="text-muted small">${hotel.address || ''}, ${hotel.city || ''}, ${hotel.country || ''}</p>
            </div>
            ` : ''}
            <div class="col-md-12 mb-3">
                <p class="text-muted mb-1">Loại phòng</p>
                <p class="fw-bold">${room.name || 'Room'}</p>
            </div>
            ${booking.specialRequests ? `
            <div class="col-md-12 mb-3">
                <p class="text-muted mb-1">Yêu cầu đặc biệt</p>
                <p class="fw-bold">${booking.specialRequests}</p>
            </div>
            ` : ''}
        </div>
    `;

    bookingInfoEl.innerHTML = html;
}

function displayBookingSummary(booking, room, hotel) {
    const summaryEl = document.getElementById('bookingSummary');
    const totalAmountEl = document.getElementById('totalAmount');
    
    if (!summaryEl || !totalAmountEl) return;

    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    };

    const stayDuration = Math.ceil((new Date(booking.checkOutDate) - new Date(booking.checkInDate)) / (1000 * 60 * 60 * 24));
    const pricePerNight = parseFloat(room.pricePerNight);
    const totalPrice = parseFloat(booking.totalPrice);

    let html = `
        <ul>
            <li>Check-in: <span>${new Date(booking.checkInDate).toLocaleDateString('vi-VN')}</span></li>
            <li>Check-out: <span>${new Date(booking.checkOutDate).toLocaleDateString('vi-VN')}</span></li>
            <li>Loại phòng: <span>${room.name || 'Room'}</span></li>
            <li>Số phòng: <span>${booking.numberOfRooms}</span></li>
            <li>Giá/đêm: <span>${formatCurrency(pricePerNight)}</span></li>
            <li>Số khách: <span>${booking.numberOfGuests}</span></li>
            <li>Số đêm: <span>${stayDuration} đêm</span></li>
        </ul>
    `;

    summaryEl.innerHTML = html;
    totalAmountEl.textContent = formatCurrency(totalPrice);
}

function setupPaymentForm() {
    const processBtn = document.getElementById('processPaymentBtn');
    if (!processBtn) return;

    processBtn.addEventListener('click', async function() {
        if (!currentBooking) {
            alert('Booking information not loaded');
            return;
        }

        // Get selected payment method
        const activeTab = document.querySelector('#paymentMethodTab .nav-link.active');
        let paymentMethod = null;

        if (activeTab) {
            const tabId = activeTab.getAttribute('data-bs-target');
            if (tabId === '#online') {
                paymentMethod = 'ONLINE';
            } else if (tabId === '#cod') {
                paymentMethod = 'COD';
            } else if (tabId === '#athotel') {
                paymentMethod = 'AT_HOTEL';
            }
        }

        if (!paymentMethod) {
            alert('Vui lòng chọn phương thức thanh toán');
            return;
        }

        const userId = HotelBookingAPI.TokenManager.getUserId();
        if (!userId) {
            alert('User information not found');
            return;
        }

        processBtn.disabled = true;
        processBtn.innerHTML = '<span class="far fa-spinner fa-spin me-2"></span>Đang xử lý...';

        try {
            // Create payment if not exists
            if (!currentPayment) {
                currentPayment = await HotelBookingAPI.PaymentAPI.create(currentBooking.id, paymentMethod);
            }

            // Process payment
            const paymentRequest = {
                bookingId: currentBooking.id,
                paymentMethod: paymentMethod,
                transactionId: currentPayment.transactionId || null,
                notes: null
            };

            const processedPayment = await HotelBookingAPI.PaymentAPI.process(paymentRequest);

            if (processedPayment.paymentStatus === 'PAID') {
                alert('Thanh toán thành công! Booking của bạn đã được xác nhận.');
                window.location.href = `/hotel-booking?id=${currentBooking.id}`;
            } else {
                alert('Thanh toán đã được ghi nhận. Booking của bạn đang chờ xác nhận.');
                window.location.href = `/hotel-booking?id=${currentBooking.id}`;
            }
        } catch (error) {
            console.error('Error processing payment:', error);
            alert('Lỗi xử lý thanh toán: ' + (error.message || 'Vui lòng thử lại'));
            processBtn.disabled = false;
            processBtn.innerHTML = '<span class="far fa-credit-card me-2"></span>Xác nhận thanh toán';
        }
    });
}





