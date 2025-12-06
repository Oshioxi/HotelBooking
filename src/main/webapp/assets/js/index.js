// Index Page - Hotel Search Integration
let availableCities = [];
let selectedCity = null;

document.addEventListener('DOMContentLoaded', function() {
    // Load available cities for autocomplete
    loadAvailableCities();
    
    // Setup hotel search form
    const hotelSearchForm = document.getElementById('hotelSearchForm');
    if (hotelSearchForm) {
        hotelSearchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const cityInput = document.getElementById('searchCity');
            const city = selectedCity || cityInput?.value?.trim() || '';
            const checkIn = document.getElementById('searchCheckIn')?.value || '';
            const checkOut = document.getElementById('searchCheckOut')?.value || '';
            const guestsInput = document.querySelector('input[name="totalGuests"]');
            const guests = guestsInput?.value || document.getElementById('searchGuests')?.textContent?.trim() || '2';
            
            // Basic validation
            if (!city || city.trim() === '') {
                alert('Please enter a destination city');
                cityInput?.focus();
                return;
            }
            
            if (!checkIn || !checkOut) {
                alert('Please select check-in and check-out dates');
                return;
            }
            
            if (new Date(checkIn) >= new Date(checkOut)) {
                alert('Check-out date must be after check-in date');
                return;
            }
            
            // Store search params
            sessionStorage.setItem('searchCity', city);
            sessionStorage.setItem('searchCheckIn', checkIn);
            sessionStorage.setItem('searchCheckOut', checkOut);
            sessionStorage.setItem('searchGuests', guests);
            
            // Redirect to search results
            const params = new URLSearchParams({
                city: city,
                checkIn: checkIn,
                checkOut: checkOut,
                guests: guests
            });
            
            // Use relative path - will work with any context path
            window.location.href = `hotel-search-result?${params.toString()}`;
        });
    }
    
    // Setup date pickers
    const today = new Date().toISOString().split('T')[0];
    const tomorrow = new Date(Date.now() + 86400000).toISOString().split('T')[0];
    
    const checkInInputs = document.querySelectorAll('input[name="check-in"], #searchCheckIn');
    const checkOutInputs = document.querySelectorAll('input[name="check-out"], #searchCheckOut');
    
    checkInInputs.forEach(input => {
        if (input) {
            input.setAttribute('min', today);
            if (!input.value) input.value = today;
        }
    });
    
    checkOutInputs.forEach(input => {
        if (input) {
            input.setAttribute('min', today);
            if (!input.value) input.value = tomorrow;
        }
    });
    
    // Load featured hotels
    loadFeaturedHotels();
});

async function loadAvailableCities() {
    try {
        if (typeof HotelBookingAPI === 'undefined' || !HotelBookingAPI.HotelAPI) {
            console.error('HotelBookingAPI not loaded');
            return;
        }
        
        if (!HotelBookingAPI.HotelAPI.getAvailableCities) {
            console.error('getAvailableCities method not found in HotelAPI');
            return;
        }
        
        availableCities = await HotelBookingAPI.HotelAPI.getAvailableCities();
        console.log('Loaded cities:', availableCities);
        
        // Setup autocomplete after cities are loaded
        if (availableCities.length > 0) {
            setupCityAutocomplete();
        }
    } catch (error) {
        console.error('Error loading cities:', error);
    }
}

function setupCityAutocomplete() {
    const cityInput = document.getElementById('searchCity');
    if (!cityInput) {
        console.warn('City input not found');
        return;
    }
    
    // Wait for cities to load
    if (availableCities.length === 0) {
        console.log('Waiting for cities to load...');
        setTimeout(setupCityAutocomplete, 500);
        return;
    }
    
    // Create autocomplete dropdown
    const autocompleteContainer = document.createElement('div');
    autocompleteContainer.className = 'city-autocomplete';
    autocompleteContainer.id = 'cityAutocomplete';
    autocompleteContainer.style.cssText = 'position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; border-top: none; border-radius: 0 0 4px 4px; max-height: 200px; overflow-y: auto; z-index: 1000; display: none; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-top: -1px;';
    
    const formGroup = cityInput.closest('.form-group');
    if (formGroup) {
        formGroup.style.position = 'relative';
        formGroup.appendChild(autocompleteContainer);
    } else {
        console.warn('Form group not found for city input');
        return;
    }
    
    let debounceTimer;
    
    cityInput.addEventListener('input', function(e) {
        const query = e.target.value.trim().toLowerCase();
        selectedCity = null; // Reset selected city when user types
        
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            if (query.length === 0) {
                autocompleteContainer.style.display = 'none';
                return;
            }
            
            // Filter cities
            const filtered = availableCities.filter(city => 
                city.toLowerCase().includes(query)
            );
            
            if (filtered.length === 0) {
                autocompleteContainer.style.display = 'none';
                cityInput.style.borderColor = '#dc3545'; // Red border if no match
                return;
            }
            
            cityInput.style.borderColor = ''; // Reset border color
            
            // Display suggestions
            displayCitySuggestions(filtered, autocompleteContainer, cityInput);
        }, 200);
    });
    
    cityInput.addEventListener('focus', function() {
        const query = cityInput.value.trim().toLowerCase();
        if (query.length > 0 && availableCities.length > 0) {
            const filtered = availableCities.filter(city => 
                city.toLowerCase().includes(query)
            );
            if (filtered.length > 0) {
                displayCitySuggestions(filtered, autocompleteContainer, cityInput);
            }
        }
    });
    
    // Hide autocomplete when clicking outside
    document.addEventListener('click', function(e) {
        if (!formGroup?.contains(e.target)) {
            autocompleteContainer.style.display = 'none';
        }
    });
    
    // Prevent form submission when clicking on suggestion
    autocompleteContainer.addEventListener('click', function(e) {
        e.stopPropagation();
    });
}

function displayCitySuggestions(cities, container, input) {
    container.innerHTML = '';
    
    cities.forEach(city => {
        const item = document.createElement('div');
        item.className = 'autocomplete-item';
        item.style.cssText = 'padding: 10px 15px; cursor: pointer; border-bottom: 1px solid #eee; transition: background 0.2s;';
        item.textContent = city;
        
        item.addEventListener('mouseenter', function() {
            item.style.backgroundColor = '#f5f5f5';
        });
        
        item.addEventListener('mouseleave', function() {
            item.style.backgroundColor = 'white';
        });
        
        item.addEventListener('click', function() {
            input.value = city;
            selectedCity = city;
            container.style.display = 'none';
            input.focus();
        });
        
        container.appendChild(item);
    });
    
    container.style.display = 'block';
}

async function loadFeaturedHotels() {
    try {
        if (typeof HotelBookingAPI === 'undefined') return;
        
        const hotels = await HotelBookingAPI.HotelAPI.getAll();
        const approvedHotels = hotels.filter(h => h.status === 'APPROVED').slice(0, 6);
        
        if (approvedHotels.length > 0) {
            displayFeaturedHotels(approvedHotels);
        }
    } catch (error) {
        console.error('Error loading featured hotels:', error);
    }
}

function displayFeaturedHotels(hotels) {
    const container = document.getElementById('featuredRooms');
    if (!container) return;
    
    let html = '';
    hotels.forEach(hotel => {
        const imageUrl = hotel.images && hotel.images.length > 0 
            ? hotel.images[0].imageUrl 
            : '/assets/img/hotel/01.jpg';
        const rating = parseFloat(hotel.rating) || 0;
        
        html += `
            <div class="col-md-6 col-lg-4">
                <div class="hotel-item">
                    <div class="hotel-img">
                        <img src="${imageUrl}" alt="${hotel.name}" onerror="this.src='/assets/img/hotel/01.jpg'">
                        <a href="#" class="add-wishlist"><i class="far fa-heart"></i></a>
                    </div>
                    <div class="hotel-content">
                        <h4 class="hotel-title">
                            <a href="/hotel-single?hotelId=${hotel.id}">${hotel.name || 'Hotel'}</a>
                        </h4>
                        <p><i class="far fa-location-dot"></i> ${hotel.city || 'City'}, ${hotel.country || 'Country'}</p>
                        <div class="hotel-rate">
                            <span class="badge"><i class="far fa-star"></i> ${rating.toFixed(1)}</span>
                            <span class="hotel-rate-type">${rating >= 4 ? 'Excellent' : rating >= 3 ? 'Good' : 'Average'}</span>
                        </div>
                        <div class="hotel-bottom">
                            <div class="hotel-text-btn">
                                <a href="/hotel-single?hotelId=${hotel.id}">See Details <i class="fas fa-arrow-right"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    });
    
    container.innerHTML = html;
}
