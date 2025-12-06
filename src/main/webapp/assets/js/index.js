// Index Page - Hotel Search Integration
let availableCities = [];
let availableProvinces = [];
let selectedCity = null;
let selectedDestination = null; // Can be hotel name or city

document.addEventListener('DOMContentLoaded', async function() {
    // Load available cities and provinces for autocomplete
    await Promise.all([
        loadAvailableCities(),
        loadProvinces()
    ]);
    
    // Setup hotel search form
    const hotelSearchForm = document.getElementById('hotelSearchForm');
    if (hotelSearchForm) {
        hotelSearchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const cityInput = document.getElementById('searchCity');
            const destination = selectedDestination || cityInput?.value?.trim() || '';
            const checkIn = document.getElementById('searchCheckIn')?.value || '';
            const checkOut = document.getElementById('searchCheckOut')?.value || '';
            const guestsInput = document.querySelector('input[name="totalGuests"]');
            const guests = guestsInput?.value || document.getElementById('searchGuests')?.textContent?.trim() || '2';
            
            // Basic validation
            if (!destination || destination.trim() === '') {
                alert('Vui lòng nhập tên khách sạn hoặc thành phố');
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
            sessionStorage.setItem('searchCity', destination);
            sessionStorage.setItem('searchCheckIn', checkIn);
            sessionStorage.setItem('searchCheckOut', checkOut);
            sessionStorage.setItem('searchGuests', guests);
            
            // Redirect to search results
            const params = new URLSearchParams({
                city: destination,
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

async function loadProvinces() {
    try {
        const response = await fetch('/api/provinces');
        if (response.ok) {
            availableProvinces = await response.json();
            console.log('Loaded provinces:', availableProvinces.length);
        }
    } catch (error) {
        console.error('Error loading provinces:', error);
    }
}

function setupCityAutocomplete() {
    const cityInput = document.getElementById('searchCity');
    if (!cityInput) {
        console.warn('City input not found');
        return;
    }
    
    // Create autocomplete dropdown
    const autocompleteContainer = document.createElement('div');
    autocompleteContainer.className = 'destination-autocomplete';
    autocompleteContainer.id = 'destinationAutocomplete';
    autocompleteContainer.style.cssText = 'position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; border-top: none; border-radius: 0 0 4px 4px; max-height: 300px; overflow-y: auto; z-index: 1000; display: none; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-top: -1px;';
    
    const formGroup = cityInput.closest('.form-group');
    if (formGroup) {
        formGroup.style.position = 'relative';
        formGroup.appendChild(autocompleteContainer);
    } else {
        console.warn('Form group not found for city input');
        return;
    }
    
    let debounceTimer;
    let currentSuggestions = [];
    
    cityInput.addEventListener('input', async function(e) {
        const query = e.target.value.trim();
        selectedDestination = null; // Reset selected destination when user types
        
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(async () => {
            if (query.length < 2) {
                autocompleteContainer.style.display = 'none';
                return;
            }
            
            try {
                // Search hotels by name or city
                const hotels = await HotelBookingAPI.HotelAPI.searchAutocomplete(query);
                
                // Also filter cities and provinces
                const filteredCities = availableCities.filter(city => 
                    city.toLowerCase().includes(query.toLowerCase())
                ).slice(0, 5);
                
                const filteredProvinces = availableProvinces.filter(province => 
                    province.name && province.name.toLowerCase().includes(query.toLowerCase())
                ).slice(0, 5);
                
                // Combine results
                currentSuggestions = {
                    hotels: hotels || [],
                    cities: filteredCities,
                    provinces: filteredProvinces
                };
                
                if (hotels.length === 0 && filteredCities.length === 0 && filteredProvinces.length === 0) {
                    autocompleteContainer.style.display = 'none';
                    cityInput.style.borderColor = '#dc3545';
                    return;
                }
                
                cityInput.style.borderColor = '';
                displayDestinationSuggestions(currentSuggestions, autocompleteContainer, cityInput);
            } catch (error) {
                console.error('Error searching:', error);
                autocompleteContainer.style.display = 'none';
            }
        }, 300);
    });
    
    cityInput.addEventListener('focus', async function() {
        const query = cityInput.value.trim();
        if (query.length >= 2) {
            // Trigger search on focus if there's a query
            cityInput.dispatchEvent(new Event('input'));
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

function displayDestinationSuggestions(suggestions, container, input) {
    container.innerHTML = '';
    
    const { hotels, cities, provinces } = suggestions;
    let hasContent = false;
    
    // Display Hotels
    if (hotels && hotels.length > 0) {
        const section = document.createElement('div');
        section.className = 'autocomplete-section';
        section.style.cssText = 'padding: 8px 0; border-bottom: 2px solid #eee;';
        
        const sectionTitle = document.createElement('div');
        sectionTitle.className = 'autocomplete-section-title';
        sectionTitle.style.cssText = 'padding: 5px 15px; font-weight: 600; color: #666; font-size: 12px; text-transform: uppercase;';
        sectionTitle.textContent = 'Khách sạn';
        section.appendChild(sectionTitle);
        
        hotels.slice(0, 5).forEach(hotel => {
            const item = createAutocompleteItem(
                hotel.name,
                `${hotel.city || ''}, ${hotel.country || ''}`,
                'far fa-hotel',
                () => {
                    input.value = hotel.name;
                    selectedDestination = hotel.name;
                    container.style.display = 'none';
                }
            );
            section.appendChild(item);
        });
        
        container.appendChild(section);
        hasContent = true;
    }
    
    // Display Cities
    if (cities && cities.length > 0) {
        const section = document.createElement('div');
        section.className = 'autocomplete-section';
        section.style.cssText = 'padding: 8px 0; border-bottom: 2px solid #eee;';
        
        const sectionTitle = document.createElement('div');
        sectionTitle.className = 'autocomplete-section-title';
        sectionTitle.style.cssText = 'padding: 5px 15px; font-weight: 600; color: #666; font-size: 12px; text-transform: uppercase;';
        sectionTitle.textContent = 'Thành phố';
        section.appendChild(sectionTitle);
        
        cities.forEach(city => {
            const item = createAutocompleteItem(
                city,
                '',
                'far fa-map-marker-alt',
                () => {
                    input.value = city;
                    selectedDestination = city;
                    selectedCity = city;
                    container.style.display = 'none';
                }
            );
            section.appendChild(item);
        });
        
        container.appendChild(section);
        hasContent = true;
    }
    
    // Display Provinces
    if (provinces && provinces.length > 0) {
        const section = document.createElement('div');
        section.className = 'autocomplete-section';
        section.style.cssText = 'padding: 8px 0;';
        
        const sectionTitle = document.createElement('div');
        sectionTitle.className = 'autocomplete-section-title';
        sectionTitle.style.cssText = 'padding: 5px 15px; font-weight: 600; color: #666; font-size: 12px; text-transform: uppercase;';
        sectionTitle.textContent = 'Tỉnh/Thành phố';
        section.appendChild(sectionTitle);
        
        provinces.forEach(province => {
            const item = createAutocompleteItem(
                province.name,
                '',
                'far fa-map-marker-alt',
                () => {
                    input.value = province.name;
                    selectedDestination = province.name;
                    selectedCity = province.name;
                    container.style.display = 'none';
                }
            );
            section.appendChild(item);
        });
        
        container.appendChild(section);
        hasContent = true;
    }
    
    if (hasContent) {
        container.style.display = 'block';
    } else {
        container.style.display = 'none';
    }
}

function createAutocompleteItem(title, subtitle, icon, onClick) {
    const item = document.createElement('div');
    item.className = 'autocomplete-item';
    item.style.cssText = 'padding: 10px 15px; cursor: pointer; border-bottom: 1px solid #f0f0f0; transition: background 0.2s; display: flex; align-items: center; gap: 10px;';
    
    const iconEl = document.createElement('i');
    iconEl.className = icon;
    iconEl.style.cssText = 'color: #666; width: 20px; text-align: center;';
    
    const content = document.createElement('div');
    content.style.cssText = 'flex: 1;';
    
    const titleEl = document.createElement('div');
    titleEl.style.cssText = 'font-weight: 500; color: #333;';
    titleEl.textContent = title;
    
    content.appendChild(titleEl);
    
    if (subtitle) {
        const subtitleEl = document.createElement('div');
        subtitleEl.style.cssText = 'font-size: 12px; color: #999; margin-top: 2px;';
        subtitleEl.textContent = subtitle;
        content.appendChild(subtitleEl);
    }
    
    item.appendChild(iconEl);
    item.appendChild(content);
    
    item.addEventListener('mouseenter', function() {
        item.style.backgroundColor = '#f5f5f5';
    });
    
    item.addEventListener('mouseleave', function() {
        item.style.backgroundColor = 'white';
    });
    
    item.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        onClick();
    });
    
    return item;
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
