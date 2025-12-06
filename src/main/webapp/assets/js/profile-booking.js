// Profile Booking Page - Shows only active bookings (PENDING, CONFIRMED)
document.addEventListener('DOMContentLoaded', async function() {
    if (!HotelBookingAPI.TokenManager.getToken()) {
        window.location.href = '/login';
        return;
    }

    try {
        // Load active bookings only (PENDING, CONFIRMED)
        const allBookings = await HotelBookingAPI.UserAPI.getMyBookings();
        const activeBookings = allBookings.filter(booking => 
            booking.bookingStatus === 'PENDING' || booking.bookingStatus === 'CONFIRMED'
        );
        await displayBookings(activeBookings);
    } catch (error) {
        console.error('Error loading bookings:', error);
        const container = document.getElementById('bookingsContainer');
        if (container) {
            container.innerHTML = '<tr><td colspan="7" class="text-center text-danger">Error loading bookings</td></tr>';
        }
    }
});

async function displayBookings(bookings) {
    const container = document.getElementById('bookingsContainer');
    if (!container) return;

    if (bookings.length === 0) {
        container.innerHTML = '<tr><td colspan="7" class="text-center text-muted">No active bookings found</td></tr>';
        return;
    }

    let html = '';
    let index = 1;
    for (const booking of bookings) {
        try {
            // Get room type information
            const room = booking.roomType || await HotelBookingAPI.RoomTypeAPI.getById(booking.roomTypeId);
            const roomName = room?.name || 'N/A';
            const hotelName = room?.hotel?.name || booking.hotel?.name || 'N/A';
            
            const statusClass = {
                'CONFIRMED': 'badge-success',
                'PENDING': 'badge-warning',
                'CANCELLED': 'badge-danger',
                'COMPLETED': 'badge-info'
            }[booking.bookingStatus] || 'badge-secondary';

            html += `
                <tr>
                    <td>${index.toString().padStart(2, '0')}.</td>
                    <td><b>#${booking.id}</b></td>
                    <td>${roomName} - ${hotelName}</td>
                    <td>${HotelBookingAPI.Utils.formatDate(booking.checkInDate)}</td>
                    <td>${HotelBookingAPI.Utils.formatCurrency(booking.totalPrice || 0)}</td>
                    <td><span class="badge ${statusClass}">${booking.bookingStatus}</span></td>
                    <td>
                        <a href="${window.location.pathname.includes('/profile-booking') ? '#' : '/hotel-booking?id=' + booking.id}" 
                           class="btn btn-outline-secondary btn-sm" 
                           onclick="${booking.id ? `viewBooking(${booking.id}); return false;` : 'return false;'}">
                            <i class="far fa-eye"></i>
                        </a>
                        ${booking.bookingStatus !== 'CANCELLED' && booking.bookingStatus !== 'COMPLETED' ? 
                            `<a href="#" class="btn btn-outline-danger btn-sm" onclick="cancelBooking(${booking.id}); return false;">Cancel</a>` : ''}
                    </td>
                </tr>
            `;
            index++;
        } catch (error) {
            console.error('Error loading room for booking:', error);
        }
    }

    container.innerHTML = html;
}

async function cancelBooking(bookingId) {
    if (!confirm('Are you sure you want to cancel this booking?')) return;
    
    try {
        await HotelBookingAPI.UserAPI.cancelMyBooking(bookingId);
        HotelBookingAPI.Utils.showAlert('Booking cancelled successfully', 'success');
        
        // Reload bookings
        const allBookings = await HotelBookingAPI.UserAPI.getMyBookings();
        const activeBookings = allBookings.filter(booking => 
            booking.bookingStatus === 'PENDING' || booking.bookingStatus === 'CONFIRMED'
        );
        await displayBookings(activeBookings);
    } catch (error) {
        console.error('Error cancelling booking:', error);
        HotelBookingAPI.Utils.showAlert('Error cancelling booking: ' + error.message, 'error');
    }
}

function viewBooking(bookingId) {
    // Navigate to booking details page if available
    window.location.href = `${window.location.pathname}?booking=${bookingId}`;
}

// Make functions global
window.cancelBooking = cancelBooking;
window.viewBooking = viewBooking;




