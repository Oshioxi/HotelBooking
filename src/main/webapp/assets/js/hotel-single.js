// Hotel Single Room Page
let currentRoom = null;
let currentHotel = null;

// Share hotel function
function shareHotel() {
    if (navigator.share) {
        navigator.share({
            title: currentHotel ? currentHotel.name : 'Hotel Booking',
            text: currentHotel ? currentHotel.description : '',
            url: window.location.href
        }).catch(err => console.log('Error sharing:', err));
    } else {
        // Fallback: copy to clipboard
        navigator.clipboard.writeText(window.location.href).then(() => {
            alert('Link đã được sao chép vào clipboard!');
        }).catch(() => {
            alert('Link: ' + window.location.href);
        });
    }
}

document.addEventListener('DOMContentLoaded', async function() {
    const urlParams = new URLSearchParams(window.location.search);
    const hotelId = urlParams.get('hotelId');
    const roomId = urlParams.get('id');
    const roomTypeId = urlParams.get('roomTypeId');
    
    // If hotelId is provided, show hotel with room types list
    if (hotelId) {
        try {
            // Load hotel details
            currentHotel = await HotelBookingAPI.HotelAPI.getHotelById(hotelId);
            
            // Load hotel images and amenities
            const [hotelImages, hotelAmenities] = await Promise.all([
                HotelBookingAPI.HotelImageAPI.getByHotel(hotelId).catch(() => []),
                HotelBookingAPI.HotelAmenityAPI.getByHotel(hotelId).catch(() => [])
            ]);
            
            currentHotel.images = Array.isArray(hotelImages) ? hotelImages : [];
            currentHotel.amenities = Array.isArray(hotelAmenities) ? hotelAmenities : [];
            
            // Load full amenity details
            if (currentHotel.amenities.length > 0) {
                const amenityDetails = await Promise.all(
                    currentHotel.amenities.map(async (ha) => {
                        try {
                            const amenity = await HotelBookingAPI.AmenityAPI.getById(ha.amenityId);
                            return amenity;
                        } catch (e) {
                            return null;
                        }
                    })
                );
                currentHotel.amenityDetails = amenityDetails.filter(a => a != null);
            }
            
            displayHotelDetails(currentHotel);
            
            // Load Google Maps
            loadGoogleMap(currentHotel);
            
            // Load all room types from the hotel
            // Chỉ filter theo total_rooms > 0 và max_occupancy (nếu có guests)
            // KHÔNG filter theo ngày - ngày chỉ để pre-fill form booking
            const checkIn = urlParams.get('checkIn');
            const checkOut = urlParams.get('checkOut');
            const guests = urlParams.get('guests');
            await loadHotelRooms(hotelId, null, checkIn, checkOut, guests);
            
            // Setup room search form
            setupRoomSearchForm();
            
            // Check wishlist status
            checkWishlistStatus();
            
            // Pre-fill booking form if params exist (ngày chỉ để pre-fill, không filter phòng)
            if (checkIn && document.getElementById('bookingCheckIn')) {
                document.getElementById('bookingCheckIn').value = checkIn;
            }
            if (checkOut && document.getElementById('bookingCheckOut')) {
                document.getElementById('bookingCheckOut').value = checkOut;
            }
            if (guests && document.getElementById('bookingGuests')) {
                document.getElementById('bookingGuests').value = guests;
            }
            
            // Pre-fill room search form
            if (checkIn && document.getElementById('roomSearchCheckIn')) {
                document.getElementById('roomSearchCheckIn').value = checkIn;
            }
            if (checkOut && document.getElementById('roomSearchCheckOut')) {
                document.getElementById('roomSearchCheckOut').value = checkOut;
            }
            if (guests && document.getElementById('roomSearchGuests')) {
                document.getElementById('roomSearchGuests').value = guests;
            }
            
            // If roomTypeId is provided in URL, load that room as selected
            if (roomTypeId) {
                try {
                    currentRoom = await HotelBookingAPI.RoomTypeAPI.getById(roomTypeId);
                    // Add hidden input to store selected room
                    const bookingForm = document.getElementById('bookingForm');
                    if (bookingForm) {
                        let hiddenInput = document.getElementById('selectedRoomTypeId');
                        if (!hiddenInput) {
                            hiddenInput = document.createElement('input');
                            hiddenInput.type = 'hidden';
                            hiddenInput.id = 'selectedRoomTypeId';
                            hiddenInput.name = 'selectedRoomTypeId';
                            bookingForm.appendChild(hiddenInput);
                        }
                        hiddenInput.value = roomTypeId;
                    }
                } catch (error) {
                    console.error('Error loading selected room type:', error);
                }
            }
            
            // Set min dates for date inputs
            const today = new Date().toISOString().split('T')[0];
            const roomSearchCheckIn = document.getElementById('roomSearchCheckIn');
            const roomSearchCheckOut = document.getElementById('roomSearchCheckOut');
            const bookingCheckIn = document.getElementById('bookingCheckIn');
            const bookingCheckOut = document.getElementById('bookingCheckOut');
            if (roomSearchCheckIn) roomSearchCheckIn.setAttribute('min', today);
            if (roomSearchCheckOut) roomSearchCheckOut.setAttribute('min', today);
            if (bookingCheckIn) bookingCheckIn.setAttribute('min', today);
            if (bookingCheckOut) bookingCheckOut.setAttribute('min', today);
        } catch (error) {
            console.error('Error loading hotel:', error);
            alert('Error loading hotel details: ' + error.message);
        }
        return;
    }
    
    // If roomId is provided, show room type details (existing flow)
    if (roomId) {

    try {
        // Load room type details
        const room = await HotelBookingAPI.RoomTypeAPI.getById(roomId);
        currentRoom = room;
        
        // Load hotel details
        if (room.hotelId) {
            try {
                currentHotel = await HotelBookingAPI.HotelAPI.getHotelById(room.hotelId);
                displayHotelInfo(currentHotel);
                
                // Load other room types from the same hotel
                await loadHotelRooms(room.hotelId, roomId);
            } catch (error) {
                console.error('Error loading hotel:', error);
            }
        }
        
        displayRoomDetails(room);
        
        // Pre-fill booking form if params exist
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
        if (userInfo.fullName) {
            const guestNameInput = document.getElementById('guestName');
            const guestEmailInput = document.getElementById('guestEmail');
            if (guestNameInput) guestNameInput.value = userInfo.fullName;
            if (guestEmailInput) guestEmailInput.value = userInfo.email || '';
        }
        
        // Setup room search form
        setupRoomSearchForm();
        
        // Check wishlist status
        checkWishlistStatus();
        
        // Load Google Maps if hotel is available
        if (currentHotel) {
            loadGoogleMap(currentHotel);
        }
    } catch (error) {
        console.error('Error loading room:', error);
        alert('Error loading room details: ' + error.message);
    }
    } else {
        // Neither hotelId nor roomId provided - check if roomTypeId is available
        const roomTypeId = urlParams.get('roomTypeId');
        if (roomTypeId) {
            // If roomTypeId is provided, try to load the room and redirect to hotel page
            try {
                const room = await HotelBookingAPI.RoomTypeAPI.getById(roomTypeId);
                if (room.hotelId) {
                    // Redirect to hotel page with roomTypeId
                    const params = new URLSearchParams();
                    params.set('hotelId', room.hotelId);
                    params.set('roomTypeId', roomTypeId);
                    const checkIn = urlParams.get('checkIn');
                    const checkOut = urlParams.get('checkOut');
                    const guests = urlParams.get('guests');
                    if (checkIn) params.set('checkIn', checkIn);
                    if (checkOut) params.set('checkOut', checkOut);
                    if (guests) params.set('guests', guests);
                    
                    window.location.href = `/hotel-single?${params.toString()}`;
                    return;
                }
            } catch (error) {
                console.error('Error loading room type:', error);
            }
        }
        
        // If no hotelId, roomId, or valid roomTypeId, show error
        alert('Hotel ID or Room ID is required');
        window.location.href = '/index';
        return;
    }
    
    // Setup booking form
    const bookingForm = document.getElementById('bookingForm');
    if (bookingForm) {
        bookingForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            if (!HotelBookingAPI.TokenManager.getToken()) {
                alert('Please login to book a room');
                window.location.href = '/login';
                return;
            }
            
            const userId = HotelBookingAPI.TokenManager.getUserId();
            if (!userId) {
                alert('User information not found. Please try again.');
                return;
            }
            
            // Check if we're on a hotel page without a selected room
            const urlParams = new URLSearchParams(window.location.search);
            const hotelId = urlParams.get('hotelId');
            const roomId = urlParams.get('id');
            
            // If we have hotelId but no roomId and no currentRoom, we need to get a room
            let selectedRoom = currentRoom;
            if (hotelId && !roomId && !selectedRoom) {
                // Try to get roomTypeId from URL or form
                const roomTypeIdParam = urlParams.get('roomTypeId');
                if (roomTypeIdParam) {
                    try {
                        selectedRoom = await HotelBookingAPI.RoomTypeAPI.getById(roomTypeIdParam);
                    } catch (error) {
                        console.error('Error loading room type:', error);
                    }
                }
                
                // If still no room, check if there's a room selector in the form
                const roomTypeSelect = document.getElementById('selectedRoomTypeId');
                if (!selectedRoom && roomTypeSelect && roomTypeSelect.value) {
                    try {
                        selectedRoom = await HotelBookingAPI.RoomTypeAPI.getById(roomTypeSelect.value);
                    } catch (error) {
                        console.error('Error loading selected room type:', error);
                    }
                }
                
                // If still no room selected, show error
                if (!selectedRoom) {
                    alert('Vui lòng chọn một loại phòng từ danh sách phòng có sẵn bên dưới trước khi đặt phòng.');
                    // Scroll to available rooms section
                    const roomsSection = document.getElementById('availableRoomsList');
                    if (roomsSection) {
                        roomsSection.scrollIntoView({ behavior: 'smooth', block: 'start' });
                    }
                    return;
                }
            }
            
            if (!selectedRoom) {
                alert('Vui lòng chọn một loại phòng. Vui lòng thử lại.');
                return;
            }
            
            const errorDiv = document.getElementById('bookingError');
            const submitBtn = document.getElementById('bookNowBtn');
            const originalText = submitBtn.innerHTML;
            
            if (errorDiv) errorDiv.style.display = 'none';
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="far fa-spinner fa-spin"></span> Processing...';
            
            const numberOfRoomsInput = document.getElementById('numberOfRooms');
            const passengerRoomInput = document.querySelector('.passenger-room');
            const specialRequestsInput = document.getElementById('specialRequests');
            
            // Get numberOfRooms from either numberOfRooms input or passenger-room selector
            let numberOfRooms = 1;
            if (numberOfRoomsInput) {
                numberOfRooms = parseInt(numberOfRoomsInput.value) || 1;
            } else if (passengerRoomInput) {
                numberOfRooms = parseInt(passengerRoomInput.value) || 1;
            }
            
            // Validate dates
            const checkInDate = document.getElementById('bookingCheckIn').value;
            const checkOutDate = document.getElementById('bookingCheckOut').value;
            const today = new Date().toISOString().split('T')[0];
            
            if (checkInDate < today) {
                alert('Ngày check-in không thể là ngày trong quá khứ');
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
                return;
            }
            
            if (checkOutDate <= checkInDate) {
                alert('Ngày check-out phải sau ngày check-in');
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
                return;
            }
            
            const bookingData = {
                roomTypeId: selectedRoom.id,
                checkInDate: checkInDate,
                checkOutDate: checkOutDate,
                numberOfGuests: parseInt(document.getElementById('bookingGuests').value),
                numberOfRooms: numberOfRooms,
                guestName: document.getElementById('guestName').value,
                guestEmail: document.getElementById('guestEmail').value,
                guestPhone: document.getElementById('guestPhone').value,
                specialRequests: specialRequestsInput ? specialRequestsInput.value.trim() || null : null
            };
            
            try {
                const booking = await HotelBookingAPI.BookingAPI.create(userId, bookingData);
                // Redirect to checkout page for payment
                window.location.href = `/checkout?bookingId=${booking.id}`;
            } catch (error) {
                if (errorDiv) {
                    errorDiv.textContent = error.message || 'Có lỗi xảy ra khi đặt phòng. Vui lòng thử lại.';
                    errorDiv.style.display = 'block';
                } else {
                    alert('Lỗi đặt phòng: ' + (error.message || 'Vui lòng thử lại'));
                }
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
    }
});

function displayRoomDetails(room) {
    // Update title
    document.querySelector('title').textContent = `${room.name} - Hotel Booking`;
    
    // Update room name
    const roomNameEl = document.getElementById('roomName');
    if (roomNameEl) roomNameEl.textContent = room.name || 'Room';
    
    // Update location
    const roomLocationEl = document.getElementById('roomLocation');
    if (roomLocationEl && currentHotel) {
        roomLocationEl.innerHTML = `<i class="far fa-location-dot"></i> ${currentHotel.city || ''}, ${currentHotel.country || ''}`;
    }
    
    // Update price - convert VND to USD
    const priceInUSD = (parseFloat(room.pricePerNight) / 25000).toFixed(2);
    const priceEl = document.getElementById('roomPrice');
    if (priceEl) priceEl.textContent = `$${priceInUSD}`;
    
    const priceTagEl = document.getElementById('roomPriceTag');
    if (priceTagEl) priceTagEl.textContent = room.name || 'Room Price';
    
    // Ensure price amount container is visible
    const priceAmountEl = document.getElementById('roomPriceAmount');
    if (priceAmountEl) {
        priceAmountEl.style.display = 'block';
    }
    
    // Update room features
    const roomTypeEl = document.getElementById('roomTypeDisplay');
    if (roomTypeEl) roomTypeEl.textContent = room.roomType || '-';
    
    const maxOccupancyEl = document.getElementById('maxOccupancyDisplay');
    if (maxOccupancyEl) maxOccupancyEl.textContent = room.maxOccupancy ? `${room.maxOccupancy} Guests` : '-';
    
    const cityEl = document.getElementById('cityDisplay');
    if (cityEl && currentHotel) cityEl.textContent = currentHotel.city || '-';
    
    const countryEl = document.getElementById('countryDisplay');
    if (countryEl && currentHotel) countryEl.textContent = currentHotel.country || '-';
    
    // Update hotel rating if available
    if (currentHotel && currentHotel.rating) {
        const ratingEl = document.getElementById('hotelRating');
        const ratingValueEl = document.getElementById('ratingValue');
        if (ratingEl) ratingEl.style.display = 'block';
        if (ratingValueEl) ratingValueEl.textContent = parseFloat(currentHotel.rating).toFixed(1);
    }
    
    // Update description
    const descEl = document.getElementById('roomDescription');
    if (descEl) {
        descEl.textContent = room.description || 'No description available for this room.';
    }
    
    // Update images slider
    let images = [];
    try {
        images = room.images ? (typeof room.images === 'string' ? JSON.parse(room.images) : room.images) : [];
    } catch (e) {
        console.error('Error parsing images:', e);
    }
    
    const sliderEl = document.querySelector('.listing-slider');
    if (sliderEl) {
        // Destroy existing carousel if it exists
        if (typeof jQuery !== 'undefined' && jQuery.fn.owlCarousel && jQuery(sliderEl).data('owl.carousel')) {
            jQuery(sliderEl).trigger('destroy.owl.carousel');
            jQuery(sliderEl).removeClass('owl-carousel owl-theme');
        }
        
        // Clear any existing owl-carousel classes and data
        jQuery(sliderEl).removeClass('owl-carousel owl-theme owl-loaded owl-drag');
        jQuery(sliderEl).find('.owl-stage-outer, .owl-stage, .owl-item').remove();
        
        if (images.length > 0) {
            // Wrap each image in a div for owl carousel
            sliderEl.innerHTML = images.map(img => 
                `<div class="item"><img src="${img}" alt="${room.name}" style="width: 100%; height: auto; display: block;"></div>`
            ).join('');
            
            // Reinitialize owl carousel only if there are multiple images
            if (typeof jQuery !== 'undefined' && jQuery.fn.owlCarousel) {
                setTimeout(() => {
                    if (images.length > 1) {
                        jQuery(sliderEl).addClass('owl-carousel owl-theme').owlCarousel({
                            loop: true,
                            margin: 0,
                            nav: true,
                            dots: true,
                            navText: [
                                "<i class='far fa-long-arrow-left'></i>",
                                "<i class='far fa-long-arrow-right'></i>"
                            ],
                            autoplay: false,
                            responsive: {
                                0: { items: 1 },
                                600: { items: 1 },
                                1000: { items: 1 }
                            }
                        });
                    } else {
                        // Single image - just display it without carousel
                        jQuery(sliderEl).addClass('owl-carousel owl-theme');
                    }
                }, 300);
            }
        } else {
            // Use default image if no images
            sliderEl.innerHTML = `<div class="item"><img src="${window.location.origin}/assets/img/hotel/single-1.jpg" alt="${room.name}" style="width: 100%; height: auto; display: block;"></div>`;
        }
    }
    
    // Update amenities
    let amenities = [];
    try {
        amenities = room.amenities ? (typeof room.amenities === 'string' ? JSON.parse(room.amenities) : room.amenities) : [];
    } catch (e) {
        console.error('Error parsing amenities:', e);
    }
    
    const amenitiesEl = document.getElementById('roomAmenities');
    if (amenitiesEl) {
        if (amenities.length > 0) {
            amenitiesEl.innerHTML = '<div class="row">' + amenities.map(amenity => 
                `<div class="col-lg-4">
                    <div class="listing-amenity-item">
                        <h6><i class="far fa-check"></i> ${amenity}</h6>
                    </div>
                </div>`
            ).join('') + '</div>';
        } else {
            amenitiesEl.innerHTML = '<div class="col-12"><p class="text-muted">No amenities listed</p></div>';
        }
    }
}

function displayHotelInfo(hotel) {
    // Update hotel features if needed
    const cityEl = document.querySelector('.listing-feature-content span');
    if (cityEl && hotel.city) {
        // Update city in features
        const cityFeature = document.querySelectorAll('.listing-feature-content span')[4];
        if (cityFeature) cityFeature.textContent = hotel.city;
    }
    
    // Update country
    const countryFeature = document.querySelectorAll('.listing-feature-content span')[4];
    if (countryFeature && hotel.country) {
        countryFeature.textContent = hotel.country;
    }
}

async function loadHotelRooms(hotelId, excludeRoomTypeId, checkIn, checkOut, guests) {
    try {
        let rooms = await HotelBookingAPI.RoomTypeAPI.getByHotel(hotelId);
        
        // Filter: chỉ lấy phòng APPROVED, có total_rooms > 0, và không phải phòng đang xem
        let availableRooms = rooms.filter(r => {
            // Status phải là APPROVED
            if (r.status !== 'APPROVED') return false;
            
            // Không phải phòng đang xem
            if (r.id == excludeRoomTypeId) return false;
            
            // Phải có total_rooms > 0
            const totalRooms = parseInt(r.totalRooms) || 0;
            if (totalRooms <= 0) return false;
            
            // Filter theo max_occupancy nếu có số khách
            if (guests) {
                const maxOccupancy = parseInt(r.maxOccupancy) || 0;
                const numGuests = parseInt(guests) || 0;
                if (maxOccupancy < numGuests) return false;
            }
            
            return true;
        });
        
        // Ngày check-in/check-out KHÔNG dùng để filter phòng, chỉ để pre-fill form booking
        // Backend sẽ check availability khi booking
        
        await displayAvailableRooms(availableRooms, checkIn, checkOut, guests);
    } catch (error) {
        console.error('Error loading hotel room types:', error);
        const roomsContainer = document.getElementById('availableRoomsList');
        if (roomsContainer) {
            roomsContainer.innerHTML = '<div class="col-12"><div class="alert alert-danger">Lỗi khi tải danh sách phòng. Vui lòng thử lại.</div></div>';
        }
    }
}

function displayHotelDetails(hotel) {
    // Update title
    document.querySelector('title').textContent = `${hotel.name} - Hotel Booking`;
    
    // Update hotel name
    const hotelNameEl = document.getElementById('hotelName');
    if (hotelNameEl) hotelNameEl.textContent = hotel.name || 'Hotel';
    
    const hotelNameInRoomsEl = document.getElementById('hotelNameInRooms');
    if (hotelNameInRoomsEl) hotelNameInRoomsEl.textContent = hotel.name || 'Hotel';
    
    // Update location
    const hotelLocationEl = document.getElementById('hotelLocation');
    if (hotelLocationEl) {
        hotelLocationEl.innerHTML = `<i class="far fa-location-dot"></i> ${hotel.address || ''}, ${hotel.city || ''}, ${hotel.country || ''}`;
    }
    
    // Update hotel rating if available
    if (hotel.rating) {
        const ratingEl = document.getElementById('hotelRating');
        const ratingValueEl = document.getElementById('ratingValue');
        const ratingTypeEl = document.getElementById('ratingType');
        if (ratingEl) ratingEl.style.display = 'block';
        if (ratingValueEl) ratingValueEl.textContent = parseFloat(hotel.rating).toFixed(1);
        if (ratingTypeEl) {
            const rating = parseFloat(hotel.rating);
            if (rating >= 4.5) ratingTypeEl.textContent = 'Excellent';
            else if (rating >= 4) ratingTypeEl.textContent = 'Very Good';
            else if (rating >= 3) ratingTypeEl.textContent = 'Good';
            else if (rating >= 2) ratingTypeEl.textContent = 'Average';
            else ratingTypeEl.textContent = 'Poor';
        }
    }
    
    // Update description
    const descEl = document.getElementById('hotelDescription');
    if (descEl) {
        descEl.textContent = hotel.description || 'Khách sạn này chưa có mô tả.';
    }
    
    // Display hotel images in slider
    const sliderEl = document.querySelector('.listing-slider');
    if (sliderEl && hotel.images && Array.isArray(hotel.images) && hotel.images.length > 0) {
        // Sort images by displayOrder, primary first
        const sortedImages = [...hotel.images].sort((a, b) => {
            if (a.isPrimary && !b.isPrimary) return -1;
            if (!a.isPrimary && b.isPrimary) return 1;
            return (a.displayOrder || 0) - (b.displayOrder || 0);
        });
        
        sliderEl.innerHTML = sortedImages.map(img => {
            const imageUrl = img.imageUrl?.startsWith('http') ? img.imageUrl : 
                           img.imageUrl?.startsWith('/') ? img.imageUrl : 
                           `/${img.imageUrl}`;
            const altText = img.altText || hotel.name || 'Hotel Image';
            return `<div class="item">
                <img src="${imageUrl}" 
                     alt="${altText}" 
                     loading="lazy"
                     style="width: 100%; height: 500px; object-fit: cover;" 
                     onerror="this.src='/assets/img/hotel/single-1.jpg'">
            </div>`;
        }).join('');
        
        // Initialize owl carousel
        if (typeof jQuery !== 'undefined' && jQuery.fn.owlCarousel && sortedImages.length > 1) {
            setTimeout(() => {
                if (jQuery(sliderEl).data('owl.carousel')) {
                    jQuery(sliderEl).trigger('destroy.owl.carousel');
                }
                jQuery(sliderEl).addClass('owl-carousel owl-theme').owlCarousel({
                    loop: true,
                    margin: 0,
                    nav: true,
                    dots: true,
                    navText: [
                        "<i class='far fa-long-arrow-left'></i>",
                        "<i class='far fa-long-arrow-right'></i>"
                    ],
                    autoplay: false,
                    responsive: {
                        0: { items: 1 },
                        600: { items: 1 },
                        1000: { items: 1 }
                    }
                });
            }, 300);
        }
    } else if (sliderEl) {
        sliderEl.innerHTML = `<div class="item">
            <img src="/assets/img/hotel/single-1.jpg" 
                 alt="${hotel.name || 'Hotel'}" 
                 loading="lazy"
                 style="width: 90%; height: 500px; object-fit: cover;">
        </div>`;
    }
    
    // Display main amenities (top 6)
    const mainAmenitiesEl = document.getElementById('hotelMainAmenities');
    if (mainAmenitiesEl && hotel.amenityDetails && hotel.amenityDetails.length > 0) {
        const mainAmenities = hotel.amenityDetails.slice(0, 6);
        mainAmenitiesEl.innerHTML = mainAmenities.map(amenity => {
            const icon = amenity.icon || 'far fa-check';
            return `<span style="display: inline-flex; align-items: center; margin-right: 1rem; margin-bottom: 0.5rem;">
                <i class="${icon}" style="margin-right: 0.5rem; color: #007bff;"></i>
                <span>${amenity.name || amenity}</span>
            </span>`;
        }).join('');
    }
    
    // Display all amenities
    const allAmenitiesEl = document.getElementById('hotelAllAmenitiesList');
    if (allAmenitiesEl) {
        if (hotel.amenityDetails && hotel.amenityDetails.length > 0) {
            allAmenitiesEl.innerHTML = '<div class="row">' + hotel.amenityDetails.map(amenity => {
                const icon = amenity.icon || 'far fa-check';
                return `<div class="col-lg-4 col-md-6 mb-3">
                    <div class="listing-amenity-item">
                        <h6><i class="${icon}"></i> ${amenity.name || amenity}</h6>
                    </div>
                </div>`;
            }).join('') + '</div>';
        } else {
            allAmenitiesEl.innerHTML = '<div class="col-12"><p class="text-muted">Chưa có thông tin tiện ích</p></div>';
        }
    }
    
    // Update policies
    const checkInTimeEl = document.getElementById('checkInTime');
    const checkOutTimeEl = document.getElementById('checkOutTime');
    const fullAddressEl = document.getElementById('hotelFullAddress');
    const cityInfoEl = document.getElementById('hotelCityInfo');
    const countryInfoEl = document.getElementById('hotelCountryInfo');
    
    // Update policies tab elements (Location tab)
    const fullAddressEl2 = document.getElementById('hotelFullAddress2');
    const cityInfoEl2 = document.getElementById('hotelCityInfo2');
    const countryInfoEl2 = document.getElementById('hotelCountryInfo2');
    
    if (checkInTimeEl) checkInTimeEl.textContent = 'Từ 14:00';
    if (checkOutTimeEl) checkOutTimeEl.textContent = 'Trước 12:00';
    if (fullAddressEl) fullAddressEl.textContent = hotel.address || '-';
    if (cityInfoEl) cityInfoEl.textContent = hotel.city || '-';
    if (countryInfoEl) countryInfoEl.textContent = hotel.country || '-';
    
    // Update policies tab elements (Policies tab)
    if (fullAddressEl2) fullAddressEl2.textContent = hotel.address || '-';
    if (cityInfoEl2) cityInfoEl2.textContent = hotel.city || '-';
    if (countryInfoEl2) countryInfoEl2.textContent = hotel.country || '-';
    
    // Hide room-specific details and show hotel view
    const priceAmountEl = document.getElementById('roomPriceAmount');
    if (priceAmountEl) {
        priceAmountEl.style.display = 'none';
    }
    
    // Update breadcrumb
    const breadcrumbTitle = document.querySelector('.breadcrumb-title');
    if (breadcrumbTitle) {
        breadcrumbTitle.textContent = hotel.name || 'Hotel';
    }
    
    // Load Google Maps
    loadGoogleMap(hotel);
}

async function displayAvailableRooms(rooms, checkIn, checkOut, guests) {
    const roomsContainer = document.getElementById('availableRoomsList');
    if (!roomsContainer) return;
    
    if (rooms.length === 0) {
        roomsContainer.innerHTML = '<div class="col-12"><div class="alert alert-info"><i class="far fa-info-circle"></i> Không có phòng nào phù hợp với tiêu chí tìm kiếm của bạn.</div></div>';
        return;
    }
    
    const checkInParam = checkIn ? `&checkIn=${checkIn}` : '';
    const checkOutParam = checkOut ? `&checkOut=${checkOut}` : '';
    const guestsParam = guests ? `&guests=${guests}` : '';
    
    // Load room images and amenities for each room
    const roomsWithDetails = await Promise.all(rooms.map(async (room) => {
        try {
            const [images, amenities] = await Promise.all([
                HotelBookingAPI.RoomTypeImageAPI.getByRoomType(room.id).catch(() => []),
                HotelBookingAPI.RoomTypeAmenityAPI.getByRoomType(room.id).catch(() => [])
            ]);
            
            room.images = Array.isArray(images) ? images : [];
            
            // Load full amenity details
            if (Array.isArray(amenities) && amenities.length > 0) {
                const amenityDetails = await Promise.all(
                    amenities.map(async (rta) => {
                        try {
                            const amenity = await HotelBookingAPI.AmenityAPI.getById(rta.amenityId);
                            return amenity;
                        } catch (e) {
                            return null;
                        }
                    })
                );
                room.amenities = amenityDetails.filter(a => a != null);
            } else {
                room.amenities = [];
            }
            
            return room;
        } catch (e) {
            console.warn(`Error loading details for room ${room.id}:`, e);
            room.images = [];
            room.amenities = [];
            return room;
        }
    }));
    
    let html = '';
    roomsWithDetails.forEach(room => {
        // Get primary image or first image
        let imageUrl = '/assets/img/hotel/room/04.jpg';
        if (room.images && Array.isArray(room.images) && room.images.length > 0) {
            const primaryImage = room.images.find(img => img && img.isPrimary) || room.images[0];
            if (primaryImage && primaryImage.imageUrl) {
                imageUrl = primaryImage.imageUrl.startsWith('http') ? primaryImage.imageUrl :
                          primaryImage.imageUrl.startsWith('/') ? primaryImage.imageUrl :
                          `/${primaryImage.imageUrl}`;
            }
        }
        
        const priceInUSD = (parseFloat(room.pricePerNight) / 25000).toFixed(2);
        const priceInVND = parseFloat(room.pricePerNight).toLocaleString('vi-VN');
        
        // Room amenities as badges
        const amenitiesList = room.amenities && room.amenities.length > 0
            ? room.amenities.slice(0, 8).map(a => {
                return `<span class="badge bg-light text-dark me-2 mb-2" style="font-size: 0.85rem; padding: 0.4rem 0.8rem; border: 1px solid #dee2e6;">
                    ${a.name || a}
                </span>`;
            }).join('')
            : '<span class="text-muted small">Chưa có thông tin tiện ích</span>';
        
        // Room type display
        const roomTypeDisplay = room.roomType ? `<span class="badge bg-secondary me-2" style="font-size: 0.85rem;">${room.roomType}</span>` : '';
        
        html += `
            <div class="col-md-12 mb-4">
                <div class="room-item" style="border: 1px solid #e0e0e0; border-radius: 12px; overflow: hidden; background: white; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s, box-shadow 0.2s;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 12px rgba(0,0,0,0.15)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 6px rgba(0,0,0,0.1)'">
                    <div class="row g-0">
                        <div class="col-md-5">
                            <div class="room-img" style="height: 100%; min-height: 300px; position: relative; overflow: hidden;">
                                <img src="${imageUrl}" 
                                     alt="${room.name || 'Room'}" 
                                     loading="lazy"
                                     style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s;" 
                                     onerror="this.src='/assets/img/hotel/room/04.jpg'"
                                     onmouseover="this.style.transform='scale(1.05)'"
                                     onmouseout="this.style.transform='scale(1)'">
                                ${room.totalRooms > 0 ? `<span class="badge bg-success position-absolute top-0 end-0 m-2" style="font-size: 0.85rem; padding: 0.5rem 0.8rem; z-index: 10;">Còn ${room.totalRooms} phòng</span>` : ''}
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div class="room-content" style="padding: 2rem;">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h4 class="room-title mb-2" style="font-size: 1.75rem; font-weight: 700; color: #2c3e50; line-height: 1.3;">
                                            ${room.name || 'Room'}
                                        </h4>
                                        <div class="mb-2">
                                            ${roomTypeDisplay}
                                            <span class="text-muted small" style="font-size: 0.9rem;">
                                                <i class="far fa-user me-1"></i>Tối đa ${room.maxOccupancy || '-'} khách/phòng
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                ${room.description ? `
                                    <p class="room-description mb-3" style="color: #555; line-height: 1.6; font-size: 0.95rem;">
                                        ${room.description}
                                    </p>
                                ` : ''}
                                
                                <div class="room-amenities mb-4">
                                    <h6 class="mb-2" style="font-size: 0.9rem; font-weight: 600; color: #666; text-transform: uppercase; letter-spacing: 0.5px;">Tiện ích phòng</h6>
                                    <div style="line-height: 2;">
                                        ${amenitiesList}
                                    </div>
                                </div>
                                
                                <div class="room-bottom d-flex justify-content-between align-items-center pt-3" style="border-top: 2px solid #f0f0f0;">
                                    <div class="room-price">
                                        <div class="d-flex align-items-baseline">
                                            <span class="room-price-amount" style="font-size: 2rem; font-weight: 700; color: #007bff; margin-right: 0.5rem;">
                                                ${priceInVND}
                                            </span>
                                            <span class="text-muted" style="font-size: 0.9rem;">VND</span>
                                        </div>
                                        <div class="text-muted small mt-1" style="font-size: 0.85rem;">
                                            <i class="far fa-calendar-alt me-1"></i>$${priceInUSD} / đêm
                                        </div>
                                    </div>
                                    <div class="room-select-btn">
                                        <a href="/hotel-booking?roomTypeId=${room.id}${checkInParam}${checkOutParam}${guestsParam}" 
                                           class="btn btn-lg" 
                                           style="background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%); 
                                                  color: white; 
                                                  border: none; 
                                                  padding: 0.875rem 2.5rem; 
                                                  font-weight: 600; 
                                                  border-radius: 8px; 
                                                  text-decoration: none;
                                                  box-shadow: 0 4px 6px rgba(32, 201, 151, 0.3);
                                                  transition: all 0.3s;"
                                           onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 12px rgba(32, 201, 151, 0.4)'"
                                           onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 6px rgba(32, 201, 151, 0.3)'">
                                            <i class="far fa-calendar-check me-2"></i>Đặt Phòng Ngay
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    });
    
    roomsContainer.innerHTML = html;
}

// Setup room search form
function setupRoomSearchForm() {
    const roomSearchForm = document.getElementById('roomSearchForm');
    if (!roomSearchForm) return;
    
    roomSearchForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const checkIn = document.getElementById('roomSearchCheckIn').value;
        const checkOut = document.getElementById('roomSearchCheckOut').value;
        const guests = document.getElementById('roomSearchGuests').value;
        
        if (!checkIn || !checkOut || !guests) {
            alert('Vui lòng điền đầy đủ thông tin tìm kiếm');
            return;
        }
        
        if (new Date(checkIn) >= new Date(checkOut)) {
            alert('Ngày check-out phải sau ngày check-in');
            return;
        }
        
        const urlParams = new URLSearchParams(window.location.search);
        const hotelId = urlParams.get('hotelId');
        
        if (hotelId) {
            await loadHotelRooms(hotelId, null, checkIn, checkOut, guests);
        }
    });
}

// Load Google Maps
function loadGoogleMap(hotel) {
    const mapContainer = document.getElementById('hotelMap');
    if (!mapContainer || !hotel) return;
    
    const address = `${hotel.address || ''}, ${hotel.city || ''}, ${hotel.country || ''}`.trim();
    if (!address || address === ',') {
        mapContainer.innerHTML = '<p class="text-center text-muted py-5">Không có thông tin địa chỉ để hiển thị bản đồ</p>';
        return;
    }
    
    // Use Google Maps Embed API
    const encodedAddress = encodeURIComponent(address);
    const iframe = document.createElement('iframe');
    iframe.src = `https://www.google.com/maps/embed/v1/place?key=AIzaSyBFw0Qbyq9zTFTd-tUY6d-s6Y4cYZ9u8Lk&q=${encodedAddress}`;
    iframe.width = '100%';
    iframe.height = '400px';
    iframe.style.border = '0';
    iframe.allowFullscreen = true;
    iframe.loading = 'lazy';
    
    mapContainer.innerHTML = '';
    mapContainer.appendChild(iframe);
}

// Toggle wishlist
async function toggleWishlist(event) {
    event.preventDefault();
    
    if (!HotelBookingAPI.TokenManager.getToken()) {
        alert('Vui lòng đăng nhập để thêm vào yêu thích');
        window.location.href = '/login';
        return;
    }
    
    const urlParams = new URLSearchParams(window.location.search);
    const hotelId = urlParams.get('hotelId');
    const roomId = urlParams.get('id');
    
    if (!hotelId && !roomId) {
        alert('Không tìm thấy thông tin khách sạn hoặc phòng');
        return;
    }
    
    try {
        let isFavorite = false;
        
        if (hotelId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkHotelFavorite(hotelId);
            if (isFavorite) {
                await HotelBookingAPI.UserAPI.removeFavoriteHotel(hotelId);
                isFavorite = false;
            } else {
                await HotelBookingAPI.UserAPI.addFavorite(hotelId, null);
                isFavorite = true;
            }
        } else if (roomId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkRoomTypeFavorite(roomId);
            if (isFavorite) {
                await HotelBookingAPI.UserAPI.removeFavoriteRoomType(roomId);
                isFavorite = false;
            } else {
                await HotelBookingAPI.UserAPI.addFavorite(null, roomId);
                isFavorite = true;
            }
        }
        
        const wishlistBtn = document.getElementById('wishlistBtn');
        const wishlistText = document.getElementById('wishlistText');
        if (wishlistBtn && wishlistText) {
            if (isFavorite) {
                wishlistBtn.classList.add('active');
                wishlistText.textContent = 'Đã thêm vào yêu thích';
            } else {
                wishlistBtn.classList.remove('active');
                wishlistText.textContent = 'Thêm vào yêu thích';
            }
        }
    } catch (error) {
        console.error('Error toggling wishlist:', error);
        alert('Có lỗi xảy ra: ' + (error.message || 'Vui lòng thử lại'));
    }
}

// Check wishlist status on load
async function checkWishlistStatus() {
    if (!HotelBookingAPI.TokenManager.getToken()) return;
    
    const urlParams = new URLSearchParams(window.location.search);
    const hotelId = urlParams.get('hotelId');
    const roomId = urlParams.get('id');
    
    try {
        let isFavorite = false;
        if (hotelId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkHotelFavorite(hotelId);
        } else if (roomId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkRoomTypeFavorite(roomId);
        }
        
        const wishlistBtn = document.getElementById('wishlistBtn');
        const wishlistText = document.getElementById('wishlistText');
        if (wishlistBtn && wishlistText && isFavorite) {
            wishlistBtn.classList.add('active');
            wishlistText.textContent = 'Đã thêm vào yêu thích';
        }
    } catch (error) {
        // Silently handle 403 Forbidden (user not logged in) - this is expected behavior
        if (error.message && error.message.includes('Forbidden')) {
            // User is not logged in, wishlist check is not available
            // This is normal, so we don't show error
            return;
        }
        // Only log other errors
        console.error('Error checking wishlist status:', error);
    }
}

async function displayAvailableRooms(rooms, checkIn, checkOut, guests) {
    const roomsContainer = document.getElementById('availableRoomsList');
    if (!roomsContainer) return;
    
    if (rooms.length === 0) {
        roomsContainer.innerHTML = '<div class="col-12"><div class="alert alert-info"><i class="far fa-info-circle"></i> Không có phòng nào phù hợp với tiêu chí tìm kiếm của bạn.</div></div>';
        return;
    }
    
    const checkInParam = checkIn ? `&checkIn=${checkIn}` : '';
    const checkOutParam = checkOut ? `&checkOut=${checkOut}` : '';
    const guestsParam = guests ? `&guests=${guests}` : '';
    
    // Load room images and amenities for each room
    const roomsWithDetails = await Promise.all(rooms.map(async (room) => {
        try {
            const [images, amenities] = await Promise.all([
                HotelBookingAPI.RoomTypeImageAPI.getByRoomType(room.id).catch(() => []),
                HotelBookingAPI.RoomTypeAmenityAPI.getByRoomType(room.id).catch(() => [])
            ]);
            
            room.images = Array.isArray(images) ? images : [];
            
            // Load full amenity details
            if (Array.isArray(amenities) && amenities.length > 0) {
                const amenityDetails = await Promise.all(
                    amenities.map(async (rta) => {
                        try {
                            const amenity = await HotelBookingAPI.AmenityAPI.getById(rta.amenityId);
                            return amenity;
                        } catch (e) {
                            return null;
                        }
                    })
                );
                room.amenities = amenityDetails.filter(a => a != null);
            } else {
                room.amenities = [];
            }
            
            return room;
        } catch (e) {
            console.warn(`Error loading details for room ${room.id}:`, e);
            room.images = [];
            room.amenities = [];
            return room;
        }
    }));
    
    let html = '';
    roomsWithDetails.forEach(room => {
        // Get primary image or first image
        let imageUrl = '/assets/img/hotel/room/04.jpg';
        if (room.images && Array.isArray(room.images) && room.images.length > 0) {
            const primaryImage = room.images.find(img => img && img.isPrimary) || room.images[0];
            if (primaryImage && primaryImage.imageUrl) {
                imageUrl = primaryImage.imageUrl.startsWith('http') ? primaryImage.imageUrl :
                          primaryImage.imageUrl.startsWith('/') ? primaryImage.imageUrl :
                          `/${primaryImage.imageUrl}`;
            }
        }
        
        const priceInUSD = (parseFloat(room.pricePerNight) / 25000).toFixed(2);
        const priceInVND = parseFloat(room.pricePerNight).toLocaleString('vi-VN');
        
        // Room amenities as badges
        const amenitiesList = room.amenities && room.amenities.length > 0
            ? room.amenities.slice(0, 8).map(a => {
                return `<span class="badge bg-light text-dark me-2 mb-2" style="font-size: 0.85rem; padding: 0.4rem 0.8rem; border: 1px solid #dee2e6;">
                    ${a.name || a}
                </span>`;
            }).join('')
            : '<span class="text-muted small">Chưa có thông tin tiện ích</span>';
        
        // Room type display
        const roomTypeDisplay = room.roomType ? `<span class="badge bg-secondary me-2" style="font-size: 0.85rem;">${room.roomType}</span>` : '';
        
        html += `
            <div class="col-md-12 mb-4">
                <div class="room-item" style="border: 1px solid #e0e0e0; border-radius: 12px; overflow: hidden; background: white; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: transform 0.2s, box-shadow 0.2s;" onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 12px rgba(0,0,0,0.15)'" onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 6px rgba(0,0,0,0.1)'">
                    <div class="row g-0">
                        <div class="col-md-5">
                            <div class="room-img" style="height: 100%; min-height: 300px; position: relative; overflow: hidden;">
                                <img src="${imageUrl}" 
                                     alt="${room.name || 'Room'}" 
                                     loading="lazy"
                                     style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s;" 
                                     onerror="this.src='/assets/img/hotel/room/04.jpg'"
                                     onmouseover="this.style.transform='scale(1.05)'"
                                     onmouseout="this.style.transform='scale(1)'">
                                ${room.totalRooms > 0 ? `<span class="badge bg-success position-absolute top-0 end-0 m-2" style="font-size: 0.85rem; padding: 0.5rem 0.8rem; z-index: 10;">Còn ${room.totalRooms} phòng</span>` : ''}
                            </div>
                        </div>
                        <div class="col-md-7">
                            <div class="room-content" style="padding: 2rem;">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <h4 class="room-title mb-2" style="font-size: 1.75rem; font-weight: 700; color: #2c3e50; line-height: 1.3;">
                                            ${room.name || 'Room'}
                                        </h4>
                                        <div class="mb-2">
                                            ${roomTypeDisplay}
                                            <span class="text-muted small" style="font-size: 0.9rem;">
                                                <i class="far fa-user me-1"></i>Tối đa ${room.maxOccupancy || '-'} khách/phòng
                                            </span>
                                        </div>
                                    </div>
                                </div>
                                
                                ${room.description ? `
                                    <p class="room-description mb-3" style="color: #555; line-height: 1.6; font-size: 0.95rem;">
                                        ${room.description}
                                    </p>
                                ` : ''}
                                
                                <div class="room-amenities mb-4">
                                    <h6 class="mb-2" style="font-size: 0.9rem; font-weight: 600; color: #666; text-transform: uppercase; letter-spacing: 0.5px;">Tiện ích phòng</h6>
                                    <div style="line-height: 2;">
                                        ${amenitiesList}
                                    </div>
                                </div>
                                
                                <div class="room-bottom d-flex justify-content-between align-items-center pt-3" style="border-top: 2px solid #f0f0f0;">
                                    <div class="room-price">
                                        <div class="d-flex align-items-baseline">
                                            <span class="room-price-amount" style="font-size: 2rem; font-weight: 700; color: #007bff; margin-right: 0.5rem;">
                                                ${priceInVND}
                                            </span>
                                            <span class="text-muted" style="font-size: 0.9rem;">VND</span>
                                        </div>
                                        <div class="text-muted small mt-1" style="font-size: 0.85rem;">
                                            <i class="far fa-calendar-alt me-1"></i>$${priceInUSD} / đêm
                                        </div>
                                    </div>
                                    <div class="room-select-btn">
                                        <a href="/hotel-booking?roomTypeId=${room.id}${checkInParam}${checkOutParam}${guestsParam}" 
                                           class="btn btn-lg" 
                                           style="background: linear-gradient(135deg, #20c997 0%, #17a2b8 100%); 
                                                  color: white; 
                                                  border: none; 
                                                  padding: 0.875rem 2.5rem; 
                                                  font-weight: 600; 
                                                  border-radius: 8px; 
                                                  text-decoration: none;
                                                  box-shadow: 0 4px 6px rgba(32, 201, 151, 0.3);
                                                  transition: all 0.3s;"
                                           onmouseover="this.style.transform='translateY(-2px)'; this.style.boxShadow='0 6px 12px rgba(32, 201, 151, 0.4)'"
                                           onmouseout="this.style.transform='translateY(0)'; this.style.boxShadow='0 4px 6px rgba(32, 201, 151, 0.3)'">
                                            <i class="far fa-calendar-check me-2"></i>Đặt Phòng Ngay
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    });
    
    roomsContainer.innerHTML = html;
}

// Setup room search form
function setupRoomSearchForm() {
    const roomSearchForm = document.getElementById('roomSearchForm');
    if (!roomSearchForm) return;
    
    roomSearchForm.addEventListener('submit', async function(e) {
        e.preventDefault();
        
        const checkIn = document.getElementById('roomSearchCheckIn').value;
        const checkOut = document.getElementById('roomSearchCheckOut').value;
        const guests = document.getElementById('roomSearchGuests').value;
        
        if (!checkIn || !checkOut || !guests) {
            alert('Vui lòng điền đầy đủ thông tin tìm kiếm');
            return;
        }
        
        if (new Date(checkIn) >= new Date(checkOut)) {
            alert('Ngày check-out phải sau ngày check-in');
            return;
        }
        
        const urlParams = new URLSearchParams(window.location.search);
        const hotelId = urlParams.get('hotelId');
        
        if (hotelId) {
            await loadHotelRooms(hotelId, null, checkIn, checkOut, guests);
        }
    });
}

// Load Google Maps
function loadGoogleMap(hotel) {
    const mapContainer = document.getElementById('hotelMap');
    if (!mapContainer || !hotel) return;
    
    const address = `${hotel.address || ''}, ${hotel.city || ''}, ${hotel.country || ''}`.trim();
    if (!address || address === ',') {
        mapContainer.innerHTML = '<p class="text-center text-muted py-5">Không có thông tin địa chỉ để hiển thị bản đồ</p>';
        return;
    }
    
    // Use Google Maps Embed API
    const encodedAddress = encodeURIComponent(address);
    const iframe = document.createElement('iframe');
    iframe.src = `https://www.google.com/maps/embed/v1/place?key=AIzaSyBFw0Qbyq9zTFTd-tUY6d-s6Y4cYZ9u8Lk&q=${encodedAddress}`;
    iframe.width = '100%';
    iframe.height = '400px';
    iframe.style.border = '0';
    iframe.allowFullscreen = true;
    iframe.loading = 'lazy';
    
    mapContainer.innerHTML = '';
    mapContainer.appendChild(iframe);
}

// Toggle wishlist
async function toggleWishlist(event) {
    event.preventDefault();
    
    if (!HotelBookingAPI.TokenManager.getToken()) {
        alert('Vui lòng đăng nhập để thêm vào yêu thích');
        window.location.href = '/login';
        return;
    }
    
    const urlParams = new URLSearchParams(window.location.search);
    const hotelId = urlParams.get('hotelId');
    const roomId = urlParams.get('id');
    
    if (!hotelId && !roomId) {
        alert('Không tìm thấy thông tin khách sạn hoặc phòng');
        return;
    }
    
    try {
        let isFavorite = false;
        
        if (hotelId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkHotelFavorite(hotelId);
            if (isFavorite) {
                await HotelBookingAPI.UserAPI.removeFavoriteHotel(hotelId);
                isFavorite = false;
            } else {
                await HotelBookingAPI.UserAPI.addFavorite(hotelId, null);
                isFavorite = true;
            }
        } else if (roomId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkRoomTypeFavorite(roomId);
            if (isFavorite) {
                await HotelBookingAPI.UserAPI.removeFavoriteRoomType(roomId);
                isFavorite = false;
            } else {
                await HotelBookingAPI.UserAPI.addFavorite(null, roomId);
                isFavorite = true;
            }
        }
        
        const wishlistBtn = document.getElementById('wishlistBtn');
        const wishlistText = document.getElementById('wishlistText');
        if (wishlistBtn && wishlistText) {
            if (isFavorite) {
                wishlistBtn.classList.add('active');
                wishlistText.textContent = 'Đã thêm vào yêu thích';
            } else {
                wishlistBtn.classList.remove('active');
                wishlistText.textContent = 'Thêm vào yêu thích';
            }
        }
    } catch (error) {
        console.error('Error toggling wishlist:', error);
        alert('Có lỗi xảy ra: ' + (error.message || 'Vui lòng thử lại'));
    }
}

// Check wishlist status on load
async function checkWishlistStatus() {
    if (!HotelBookingAPI.TokenManager.getToken()) return;
    
    const urlParams = new URLSearchParams(window.location.search);
    const hotelId = urlParams.get('hotelId');
    const roomId = urlParams.get('id');
    
    try {
        let isFavorite = false;
        if (hotelId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkHotelFavorite(hotelId);
        } else if (roomId) {
            isFavorite = await HotelBookingAPI.UserAPI.checkRoomTypeFavorite(roomId);
        }
        
        const wishlistBtn = document.getElementById('wishlistBtn');
        const wishlistText = document.getElementById('wishlistText');
        if (wishlistBtn && wishlistText && isFavorite) {
            wishlistBtn.classList.add('active');
            wishlistText.textContent = 'Đã thêm vào yêu thích';
        }
    } catch (error) {
        // Silently handle 403 Forbidden (user not logged in) - this is expected behavior
        if (error.message && error.message.includes('Forbidden')) {
            // User is not logged in, wishlist check is not available
            // This is normal, so we don't show error
            return;
        }
        // Only log other errors
        console.error('Error checking wishlist status:', error);
    }
}
