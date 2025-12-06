// Hotel Search Result Page
let allHotels = [];
let filteredHotels = [];
let currentFilters = {
    city: '',
    checkIn: '',
    checkOut: '',
    guests: 2,
    adults: 2,
    children: 0,
    rooms: 1,
    minPrice: 0,
    maxPrice: 1000000,
    facilities: [],
    amenities: [],
    starRating: [],
    languages: [],
    reviewScore: []
};

let availableCities = [];
let availableProvinces = [];
let selectedCity = null;
let selectedDestination = null; // Can be hotel name or city

// Pagination state
let currentPage = 1;
const itemsPerPage = 6;

// Function to load search parameters from URL and update UI
async function loadSearchParamsFromURL() {
    const urlParams = new URLSearchParams(window.location.search);
    const city = urlParams.get('city') || urlParams.get('destination') || sessionStorage.getItem('searchCity') || '';
    let checkIn = urlParams.get('checkIn') || urlParams.get('checkInDate') || sessionStorage.getItem('searchCheckIn') || '';
    let checkOut = urlParams.get('checkOut') || urlParams.get('checkOutDate') || sessionStorage.getItem('searchCheckOut') || '';
    const guests = parseInt(urlParams.get('guests') || sessionStorage.getItem('searchGuests') || '2');
    const adults = parseInt(urlParams.get('adults') || sessionStorage.getItem('searchAdults') || '2');
    const children = parseInt(urlParams.get('children') || sessionStorage.getItem('searchChildren') || '0');
    const rooms = parseInt(urlParams.get('rooms') || sessionStorage.getItem('searchRooms') || '1');
    const location = urlParams.get('location') || sessionStorage.getItem('searchLocation') || '';
    
    // Normalize dates to ISO format (yyyy-MM-dd)
    checkIn = normalizeDateToISO(checkIn);
    checkOut = normalizeDateToISO(checkOut);
    
    // Update current filters
    currentFilters.city = city;
    currentFilters.checkIn = checkIn;
    currentFilters.checkOut = checkOut;
    currentFilters.guests = guests;
    currentFilters.adults = adults;
    currentFilters.children = children;
    currentFilters.rooms = rooms;
    
    // Set selected city if city is provided
    if (city && availableCities.includes(city)) {
        selectedCity = city;
    }
    
    // Update search form
    updateSearchForm(city, checkIn, checkOut, guests, adults, children, rooms, location);
    
    // Load hotels from API
    await loadHotels();
}

document.addEventListener('DOMContentLoaded', async function() {
    // Load available cities and provinces for autocomplete
    await Promise.all([
        loadAvailableCities(),
        loadProvinces()
    ]);
    
    // Initialize date pickers
    initializeDatePickers();
    
    // Initialize passenger/guest selector
    initializePassengerSelector();
    
    // Initialize price range slider (will be updated after loading rooms)
    // Initialize with default max, will be recalculated after loading rooms
    initializePriceSlider(1000000);
    
    // Load search params from URL and update UI
    await loadSearchParamsFromURL();
    
    // Setup city autocomplete
    setupCityAutocomplete();
    
    // Setup search form submit
    setupSearchForm();
    
    // Setup sidebar filters
    setupSidebarFilters();
});

// Handle browser back/forward buttons
window.addEventListener('popstate', async function(event) {
    // Reload search params from URL when navigating with browser buttons
    await loadSearchParamsFromURL();
});

async function loadAvailableCities() {
    try {
        if (typeof HotelBookingAPI === 'undefined' || !HotelBookingAPI.HotelAPI) {
            console.error('HotelBookingAPI not loaded');
            return;
        }
        
        availableCities = await HotelBookingAPI.HotelAPI.getAvailableCities();
        console.log('Loaded cities:', availableCities);
    } catch (error) {
        console.error('Error loading cities:', error);
    }
}

async function loadProvinces() {
    try {
        const contextPath = window.contextPath || '';
        const response = await fetch(`${contextPath}/api/provinces`);
        if (response.ok) {
            availableProvinces = await response.json();
            console.log('Loaded provinces:', availableProvinces.length);
        }
    } catch (error) {
        console.error('Error loading provinces:', error);
    }
}

function setupCityAutocomplete() {
    const cityInput = document.querySelector('input[name="destination"]');
    if (!cityInput) return;
    
    // Create autocomplete dropdown
    const autocompleteContainer = document.createElement('div');
    autocompleteContainer.className = 'destination-autocomplete';
    autocompleteContainer.id = 'destinationAutocomplete';
    autocompleteContainer.style.cssText = 'position: absolute; top: 100%; left: 0; right: 0; background: white; border: 1px solid #ddd; border-top: none; border-radius: 0 0 4px 4px; max-height: 300px; overflow-y: auto; z-index: 1000; display: none; box-shadow: 0 2px 8px rgba(0,0,0,0.1); margin-top: -1px;';
    
    const formGroup = cityInput.closest('.form-group');
    if (formGroup) {
        formGroup.style.position = 'relative';
        formGroup.appendChild(autocompleteContainer);
    }
    
    let debounceTimer;
    let currentSuggestions = [];
    
    cityInput.addEventListener('input', async function(e) {
        const query = e.target.value.trim();
        selectedDestination = null;
        
        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(async () => {
            if (query.length < 2) {
                autocompleteContainer.style.display = 'none';
                return;
            }
            
            try {
                // Search hotels by name or city
                const hotels = await HotelBookingAPI.HotelAPI.searchAutocomplete(query);
                
                // Filter cities and provinces
                const filteredCities = availableCities.filter(city => 
                    city.toLowerCase().includes(query.toLowerCase())
                ).slice(0, 5);
                
                const filteredProvinces = availableProvinces.filter(province => 
                    province.name && province.name.toLowerCase().includes(query.toLowerCase())
                ).slice(0, 5);
                
                currentSuggestions = {
                    hotels: hotels || [],
                    cities: filteredCities,
                    provinces: filteredProvinces
                };
                
                if (hotels.length === 0 && filteredCities.length === 0 && filteredProvinces.length === 0) {
                    autocompleteContainer.style.display = 'none';
                    return;
                }
                
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

function initializeDatePickers() {
    // Initialize jQuery UI date picker if available
    if (typeof jQuery !== 'undefined' && jQuery.fn.datepicker) {
        jQuery('.date-picker').datepicker({
            dateFormat: 'yy-mm-dd',
            minDate: 0,
            onSelect: function(selectedDate) {
                const instance = jQuery(this);
                if (instance.hasClass('journey-date')) {
                    const checkOutPicker = jQuery('.return-date');
                    checkOutPicker.datepicker('option', 'minDate', selectedDate);
                    updateDayName(instance, '.journey-day-name');
                } else if (instance.hasClass('return-date')) {
                    updateDayName(instance, '.return-day-name');
                }
            }
        });
    }
}

function updateDayName(input, selector) {
    const date = new Date(input.val());
    const dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    const dayName = dayNames[date.getDay()];
    jQuery(selector).text(dayName);
}

function initializePassengerSelector() {
    // Handle passenger quantity buttons
    document.querySelectorAll('.passenger-qty').forEach(qty => {
        const minusBtn = qty.querySelector('.minus-btn');
        const plusBtn = qty.querySelector('.plus-btn');
        const input = qty.querySelector('.qty-amount');
        
        if (minusBtn) {
            minusBtn.addEventListener('click', function() {
                let value = parseInt(input.value) || 0;
                if (value > 0) {
                    input.value = value - 1;
                    updatePassengerTotal();
                }
            });
        }
        
        if (plusBtn) {
            plusBtn.addEventListener('click', function() {
                let value = parseInt(input.value) || 0;
                input.value = value + 1;
                updatePassengerTotal();
            });
        }
    });
}

function updatePassengerTotal() {
    const adultsInput = document.querySelector('.passenger-adult');
    const childrenInput = document.querySelector('.passenger-children');
    const roomsInput = document.querySelector('.passenger-room');
    
    const adults = parseInt(adultsInput?.value || '2');
    const children = parseInt(childrenInput?.value || '0');
    const rooms = parseInt(roomsInput?.value || '1');
    const totalGuests = adults + children;
    
    const totalRoomEl = document.querySelector('.passenger-total-room');
    const totalAmountEl = document.querySelector('.passenger-total-amount');
    const classNameEl = document.querySelector('.passenger-class-name');
    
    if (totalRoomEl) totalRoomEl.textContent = rooms;
    if (totalAmountEl) totalAmountEl.textContent = totalGuests;
    
    const roomTypeInput = document.querySelector('input[name="room-type"]:checked');
    const roomType = roomTypeInput?.value || 'Double Room';
    if (classNameEl) classNameEl.textContent = roomType;
    
    currentFilters.adults = adults;
    currentFilters.children = children;
    currentFilters.rooms = rooms;
    currentFilters.guests = totalGuests;
}

function initializePriceSlider(maxPrice = 10000000) {
    // Initialize price range slider if jQuery UI slider is available
    if (typeof jQuery !== 'undefined' && jQuery.fn.slider) {
        const priceSlider = jQuery('#price-range1');
        if (priceSlider.length) {
            // Destroy existing slider if it exists
            if (priceSlider.hasClass('ui-slider')) {
                priceSlider.slider('destroy');
            }
            
            priceSlider.slider({
                range: true,
                min: 0,
                max: maxPrice,
                step: Math.max(10000, Math.floor(maxPrice / 100)),
                values: [0, maxPrice],
                slide: function(event, ui) {
                    currentFilters.minPrice = ui.values[0];
                    currentFilters.maxPrice = ui.values[1];
                    jQuery('#priceRange1').val(formatCurrency(ui.values[0]) + ' - ' + formatCurrency(ui.values[1]));
                },
                change: function(event, ui) {
                    applyFilters();
                }
            });
            jQuery('#priceRange1').val(formatCurrency(0) + ' - ' + formatCurrency(maxPrice));
            currentFilters.maxPrice = maxPrice;
        }
    }
}

function formatCurrency(amount) {
    // Convert VND to USD (approximate rate: 1 USD = 25,000 VND)
    const amountInUSD = amount / 25000;
    
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD',
        minimumFractionDigits: 0,
        maximumFractionDigits: 0
    }).format(amountInUSD);
}

/**
 * Normalize date to ISO format (yyyy-MM-dd)
 * Handles various date formats and converts them to yyyy-MM-dd
 */
function normalizeDateToISO(dateString) {
    if (!dateString) return '';
    
    // If already in ISO format (yyyy-MM-dd), return as is
    if (/^\d{4}-\d{2}-\d{2}$/.test(dateString)) {
        return dateString;
    }
    
    // Try to parse the date
    let date;
    
    // Handle MM/d/yyyy or MM/dd/yyyy format
    if (/^\d{1,2}\/\d{1,2}\/\d{4}$/.test(dateString)) {
        const parts = dateString.split('/');
        const month = parseInt(parts[0], 10);
        const day = parseInt(parts[1], 10);
        const year = parseInt(parts[2], 10);
        date = new Date(year, month - 1, day);
    } else {
        // Try standard Date parsing
        date = new Date(dateString);
    }
    
    // Check if date is valid
    if (isNaN(date.getTime())) {
        console.warn('Invalid date format:', dateString);
        return '';
    }
    
    // Format to ISO (yyyy-MM-dd)
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    
    return `${year}-${month}-${day}`;
}

function updateSearchForm(city, checkIn, checkOut, guests, adults, children, rooms, location) {
    const cityInput = document.querySelector('input[name="destination"]');
    const checkInInput = document.querySelector('input[name="journey-date"]');
    const checkOutInput = document.querySelector('input[name="return-date"]');
    const locationText = document.querySelector('.destination-location');
    const adultsInput = document.querySelector('.passenger-adult');
    const childrenInput = document.querySelector('.passenger-children');
    const roomsInput = document.querySelector('.passenger-room');
    
    // Update destination
    if (cityInput) cityInput.value = city || '';
    
    // Update location text (city, country or custom location)
    if (locationText) {
        locationText.textContent = location || '';
    }
    
    // Update dates
    if (checkInInput) {
        checkInInput.value = checkIn || '';
        if (checkIn && typeof jQuery !== 'undefined' && jQuery.fn.datepicker) {
            updateDayName(jQuery(checkInInput), '.journey-day-name');
        }
    }
    if (checkOutInput) {
        checkOutInput.value = checkOut || '';
        if (checkOut && typeof jQuery !== 'undefined' && jQuery.fn.datepicker) {
            updateDayName(jQuery(checkOutInput), '.return-day-name');
        }
    }
    
    // Update passengers/rooms
    if (adultsInput) adultsInput.value = adults || 2;
    if (childrenInput) childrenInput.value = children || 0;
    if (roomsInput) roomsInput.value = rooms || 1;
    
    // Update passenger totals display
    updatePassengerTotal();
}

function setupSearchForm() {
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const cityInput = document.querySelector('input[name="destination"]');
            const destination = selectedDestination || cityInput?.value?.trim() || '';
            let checkIn = document.querySelector('input[name="journey-date"]')?.value || '';
            let checkOut = document.querySelector('input[name="return-date"]')?.value || '';
            const adults = parseInt(document.querySelector('.passenger-adult')?.value || '2');
            const children = parseInt(document.querySelector('.passenger-children')?.value || '0');
            const rooms = parseInt(document.querySelector('.passenger-room')?.value || '1');
            const guests = adults + children;
            const locationText = document.querySelector('.destination-location')?.textContent || '';
            
            // Validate destination
            if (!destination) {
                alert('Vui lòng nhập tên khách sạn hoặc thành phố');
                cityInput?.focus();
                return;
            }
            
            // Normalize dates to ISO format (yyyy-MM-dd)
            checkIn = normalizeDateToISO(checkIn);
            checkOut = normalizeDateToISO(checkOut);
            
            // Update current filters
            currentFilters.city = destination; // Can be hotel name or city
            currentFilters.checkIn = checkIn;
            currentFilters.checkOut = checkOut;
            currentFilters.guests = guests;
            currentFilters.adults = adults;
            currentFilters.children = children;
            currentFilters.rooms = rooms;
            
            // Save to session storage (always in ISO format)
            sessionStorage.setItem('searchCity', destination);
            sessionStorage.setItem('searchCheckIn', checkIn);
            sessionStorage.setItem('searchCheckOut', checkOut);
            sessionStorage.setItem('searchGuests', guests.toString());
            sessionStorage.setItem('searchAdults', adults.toString());
            sessionStorage.setItem('searchChildren', children.toString());
            sessionStorage.setItem('searchRooms', rooms.toString());
            if (locationText) {
                sessionStorage.setItem('searchLocation', locationText);
            }
            
            // Update URL with search parameters
            const urlParams = new URLSearchParams();
            urlParams.set('city', destination);
            if (checkIn) urlParams.set('checkIn', checkIn);
            if (checkOut) urlParams.set('checkOut', checkOut);
            if (guests) urlParams.set('guests', guests.toString());
            if (adults) urlParams.set('adults', adults.toString());
            if (children) urlParams.set('children', children.toString());
            if (rooms) urlParams.set('rooms', rooms.toString());
            
            // Update URL without page reload
            const newUrl = `${window.location.pathname}?${urlParams.toString()}`;
            window.history.pushState({ path: newUrl }, '', newUrl);
            
            // Reload hotels with new search criteria
            loadHotels();
        });
    }
}

function setupSidebarFilters() {
    // Setup facility/amenity filters (will be populated dynamically)
    // Event delegation for dynamically added checkboxes
    document.addEventListener('change', function(e) {
        if (e.target.matches('input[name="facility"]')) {
            const facilities = Array.from(document.querySelectorAll('input[name="facility"]:checked'))
                .map(cb => cb.value);
            currentFilters.facilities = facilities;
            currentFilters.amenities = facilities;
            
            // Update selected count
            updateFacilitySelectedCount();
            
            // Show loading indicator
            showFilteringEffect();
            
            // Apply filters with slight delay for better UX
            setTimeout(async () => {
                await applyFilters();
                hideFilteringEffect();
            }, 200);
        }
        
        if (e.target.matches('input[name="hotel-star"]')) {
            const stars = Array.from(document.querySelectorAll('input[name="hotel-star"]:checked'))
                .map(cb => parseInt(cb.value));
            currentFilters.starRating = stars;
            
            // Show loading indicator
            showFilteringEffect();
            setTimeout(async () => {
                await applyFilters();
                hideFilteringEffect();
            }, 200);
        }
        
        if (e.target.matches('input[name="review-score"]')) {
            const scores = Array.from(document.querySelectorAll('input[name="review-score"]:checked'))
                .map(cb => parseInt(cb.value));
            currentFilters.reviewScore = scores;
            
            // Show loading indicator
            showFilteringEffect();
            setTimeout(async () => {
                await applyFilters();
                hideFilteringEffect();
            }, 200);
        }
    });
    
    // Setup sort dropdown
    const sortSelect = document.querySelector('.booking-sort-box select');
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            const sortValue = this.value;
            sortHotels(sortValue);
        });
    }
}

async function loadHotels() {
    try {
        if (typeof HotelBookingAPI === 'undefined' || !HotelBookingAPI.HotelAPI) {
            console.error('HotelBookingAPI not loaded');
            document.getElementById('hotelsContainer').innerHTML = 
                '<div class="col-12"><div class="alert alert-danger">API not loaded. Please refresh the page.</div></div>';
            return;
        }
        
        const container = document.getElementById('hotelsContainer');
        if (container) {
            container.innerHTML = '<div class="col-12 text-center"><div class="spinner-border" role="status"><span class="visually-hidden">Loading...</span></div></div>';
        }
        
        let hotels = [];
        let { city } = currentFilters;
        
        if (!city) {
            // If no city, get all approved hotels
            hotels = await HotelBookingAPI.HotelAPI.getAll();
            hotels = hotels.filter(hotel => hotel.status === 'APPROVED');
        } else {
            // Search hotels by name or city using autocomplete endpoint
            try {
                hotels = await HotelBookingAPI.HotelAPI.searchAutocomplete(city);
            } catch (error) {
                console.warn('Autocomplete search failed, falling back to city search:', error);
                // Fallback to city search
                hotels = await HotelBookingAPI.HotelAPI.searchByCity(city);
            }
        }
        
        // Load images for each hotel
        const hotelsWithImages = await Promise.all(hotels.map(async (hotel) => {
            try {
                const images = await HotelBookingAPI.HotelImageAPI.getByHotel(hotel.id);
                hotel.images = Array.isArray(images) ? images : [];
                return hotel;
            } catch (e) {
                console.warn(`Error loading images for hotel ${hotel.id}:`, e);
                hotel.images = [];
                return hotel;
            }
        }));
        
        allHotels = hotelsWithImages;
        filteredHotels = [...allHotels];
        
        // Populate filters dynamically from loaded hotels
        await populateFilters(hotelsWithImages);
        
        // Apply current filters
        applyFilters();
        
    } catch (error) {
        console.error('Error loading hotels:', error);
        const container = document.getElementById('hotelsContainer');
        if (container) {
            container.innerHTML = 
                '<div class="col-12"><div class="alert alert-danger">Error loading hotels. Please try again.</div></div>';
        }
    }
}

async function applyFilters() {
    filteredHotels = [...allHotels];
    
    // Reset pagination when filters change
    currentPage = 1;
    
    // Filter by hotel star rating
    if (currentFilters.starRating && currentFilters.starRating.length > 0) {
        filteredHotels = filteredHotels.filter(hotel => {
            if (!hotel.rating) return false;
            const rating = parseFloat(hotel.rating) || 0;
            
            // Map rating to star rating
            let starRating;
            if (rating < 1) starRating = 1;
            else if (rating < 2) starRating = 2;
            else if (rating < 3) starRating = 3;
            else if (rating < 4) starRating = 4;
            else starRating = 5;
            
            return currentFilters.starRating.includes(starRating);
        });
    }
    
    // Filter by facilities/amenities
    if (currentFilters.facilities && currentFilters.facilities.length > 0) {
        // We need to check if hotel has the selected amenities
        // This requires async check, so we'll filter synchronously for now
        // and improve later if needed
        filteredHotels = filteredHotels.filter(hotel => {
            // For now, we'll just pass all hotels
            // In a real implementation, we'd check hotel amenities
            return true;
        });
    }
    
    // Filter by price range (if room prices are available)
    // This would require loading room types for each hotel
    // For now, we'll skip price filtering at hotel level
    
    // Filter by review score (if review data is available)
    // This would need to be implemented when review data is accessible
    if (currentFilters.reviewScore && currentFilters.reviewScore.length > 0) {
        // TODO: Implement review score filtering when review data is available
        // For now, we'll skip this filter
    }
    
    // Display filtered results
    displayHotels(filteredHotels, currentFilters.checkIn, currentFilters.checkOut, currentFilters.guests);
}

function sortHotels(sortValue) {
    switch(sortValue) {
        case '2': // Popular (by rating)
            filteredHotels.sort((a, b) => (parseFloat(b.rating) || 0) - (parseFloat(a.rating) || 0));
            break;
        case '3': // Low Price (by hotel rating as proxy)
            filteredHotels.sort((a, b) => (parseFloat(a.rating) || 0) - (parseFloat(b.rating) || 0));
            break;
        case '4': // High Price (by hotel rating as proxy)
            filteredHotels.sort((a, b) => (parseFloat(b.rating) || 0) - (parseFloat(a.rating) || 0));
            break;
        default: // Default
            filteredHotels.sort((a, b) => a.id - b.id);
    }
    displayHotels(filteredHotels, currentFilters.checkIn, currentFilters.checkOut, currentFilters.guests);
}

async function displayHotels(hotels, checkIn, checkOut, guests) {
    const container = document.getElementById('hotelsContainer');
    if (!container) return;

    // Remove pagination and loading elements
    const existingPagination = container.querySelector('.pagination-area');
    if (existingPagination) existingPagination.remove();

    if (hotels.length === 0) {
        container.innerHTML = '<div class="col-12"><div class="alert alert-info">No hotels found for your search criteria.</div></div>';
        updateResultsCount(0);
        return;
    }

    // Get paginated hotels
    const paginatedHotels = getPaginatedHotels(hotels);

    let html = '';
    paginatedHotels.forEach(hotel => {
        // Get primary image or first image
        let imageUrl = '/assets/img/hotel/01.jpg';
        if (hotel.images && Array.isArray(hotel.images) && hotel.images.length > 0) {
            const primaryImage = hotel.images.find(img => img && img.isPrimary) || hotel.images[0];
            if (primaryImage && primaryImage.imageUrl) {
                imageUrl = primaryImage.imageUrl.startsWith('http') 
                    ? primaryImage.imageUrl 
                    : primaryImage.imageUrl.startsWith('/') 
                        ? primaryImage.imageUrl 
                        : `/${primaryImage.imageUrl}`;
            }
        }
        
        const statusBadge = hotel.status === 'APPROVED' ? '' : '<span class="badge badge-warning">Pending</span>';
        const city = hotel.city || 'City';
        const country = hotel.country || 'Country';
        const rating = parseFloat(hotel.rating) || 0;
        
        // Build hotel URL with proper query parameters
        const hotelUrlParams = new URLSearchParams();
        hotelUrlParams.set('hotelId', hotel.id);
        if (checkIn) hotelUrlParams.set('checkIn', checkIn);
        if (checkOut) hotelUrlParams.set('checkOut', checkOut);
        if (guests) hotelUrlParams.set('guests', guests.toString());
        if (currentFilters.rooms) hotelUrlParams.set('rooms', currentFilters.rooms.toString());
        
        const hotelUrl = `/hotel-single?${hotelUrlParams.toString()}`;
        
        html += `
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="hotel-item">
                    <div class="hotel-img">
                        ${statusBadge}
                        <a href="${hotelUrl}">
                            <img src="${imageUrl}" alt="${hotel.name || 'Hotel'}" onerror="this.src='/assets/img/hotel/01.jpg'">
                        </a>
                        <a href="#" class="add-wishlist" id="wishlist-${hotel.id}" onclick="toggleHotelWishlist(${hotel.id}, event)" title="Add to wishlist">
                            <i class="far fa-heart"></i>
                        </a>
                    </div>
                    <div class="hotel-content">
                        <h4 class="hotel-title">
                            <a href="${hotelUrl}">${hotel.name || 'Hotel'}</a>
                        </h4>
                        <p><i class="far fa-location-dot"></i> ${city}, ${country}</p>
                        <div class="hotel-rate">
                            <span class="badge"><i class="far fa-star"></i> ${rating.toFixed(1)}</span>
                            <span class="hotel-rate-type">${rating >= 4 ? 'Excellent' : rating >= 3 ? 'Good' : 'Average'}</span>
                        </div>
                        <div class="hotel-bottom">
                            <div class="hotel-text-btn">
                                <a href="${hotelUrl}">View Rooms <i class="fas fa-arrow-right"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;
    });

    container.innerHTML = html;
    
    // Add pagination
    addPagination(hotels.length);
    
    // Update results count (show total, not paginated count)
    updateResultsCount(hotels.length);
    
    // Load wishlist status for each hotel
    await loadWishlistStatus(hotels);
}

// Load wishlist status for hotels
async function loadWishlistStatus(hotels) {
    if (!HotelBookingAPI || !HotelBookingAPI.TokenManager || !HotelBookingAPI.TokenManager.getToken()) {
        // User not logged in, hide wishlist buttons or show login prompt
        return;
    }
    
    try {
        for (const hotel of hotels) {
            try {
                const isFavorite = await HotelBookingAPI.UserAPI.checkHotelFavorite(hotel.id);
                const wishlistBtn = document.getElementById(`wishlist-${hotel.id}`);
                if (wishlistBtn) {
                    if (isFavorite) {
                        wishlistBtn.classList.add('active');
                        wishlistBtn.title = 'Remove from wishlist';
                    } else {
                        wishlistBtn.classList.remove('active');
                        wishlistBtn.title = 'Add to wishlist';
                    }
                }
            } catch (error) {
                // If error (e.g., 403), just leave button as is
                console.warn(`Error checking wishlist status for hotel ${hotel.id}:`, error);
            }
        }
    } catch (error) {
        console.error('Error loading wishlist status:', error);
    }
}

// Toggle hotel wishlist
async function toggleHotelWishlist(hotelId, event) {
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
    
    if (!HotelBookingAPI || !HotelBookingAPI.TokenManager || !HotelBookingAPI.TokenManager.getToken()) {
        alert('Please login to add hotels to your wishlist');
        return;
    }
    
    try {
        const wishlistBtn = document.getElementById(`wishlist-${hotelId}`);
        if (!wishlistBtn) return;
        
        const isFavorite = wishlistBtn.classList.contains('active');
        
        if (isFavorite) {
            await HotelBookingAPI.UserAPI.removeFavoriteHotel(hotelId);
            wishlistBtn.classList.remove('active');
            wishlistBtn.title = 'Add to wishlist';
            // Show toast or notification
            if (typeof showToast === 'function') {
                showToast('Hotel removed from wishlist', 'success');
            }
        } else {
            await HotelBookingAPI.UserAPI.addFavorite(hotelId, null);
            wishlistBtn.classList.add('active');
            wishlistBtn.title = 'Remove from wishlist';
            // Show toast or notification
            if (typeof showToast === 'function') {
                showToast('Hotel added to wishlist', 'success');
            }
        }
    } catch (error) {
        console.error('Error toggling wishlist:', error);
        alert('Error updating wishlist: ' + (error.message || 'Please try again'));
    }
}

// Export to global scope
window.toggleHotelWishlist = toggleHotelWishlist;

function addPagination(totalResults) {
    const container = document.getElementById('hotelsContainer');
    if (!container) return;
    
    const totalPages = Math.ceil(totalResults / itemsPerPage);
    
    if (totalPages <= 1) return;
    
    let paginationHtml = `
        <div class="col-12 mt-4">
            <div class="pagination-area">
                <div aria-label="Page navigation example">
                    <ul class="pagination">
    `;
    
    // Previous button
    paginationHtml += `
        <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
            <a class="page-link" href="#" aria-label="Previous" data-page="${currentPage - 1}">
                <span aria-hidden="true"><i class="far fa-angle-double-left"></i></span>
            </a>
        </li>
    `;
    
    // Page numbers - show max 5 pages
    const startPage = Math.max(1, currentPage - 2);
    const endPage = Math.min(totalPages, startPage + 4);
    
    for (let i = startPage; i <= endPage; i++) {
        paginationHtml += `
            <li class="page-item ${i === currentPage ? 'active' : ''}">
                <a class="page-link" href="#" data-page="${i}">${i}</a>
            </li>
        `;
    }
    
    // Next button
    paginationHtml += `
        <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
            <a class="page-link" href="#" aria-label="Next" data-page="${currentPage + 1}">
                <span aria-hidden="true"><i class="far fa-angle-double-right"></i></span>
            </a>
        </li>
    `;
    
    paginationHtml += `
                    </ul>
                </div>
                <div class="pagination-showing">
                    <p>Showing ${((currentPage - 1) * itemsPerPage) + 1} - ${Math.min(currentPage * itemsPerPage, totalResults)} of ${totalResults} Hotels</p>
                </div>
            </div>
        </div>
    `;
    
    container.insertAdjacentHTML('beforeend', paginationHtml);
    
    // Setup pagination click handlers
    container.querySelectorAll('.page-link[data-page]').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const page = parseInt(this.getAttribute('data-page'));
            if (page >= 1 && page <= totalPages && page !== currentPage) {
                currentPage = page;
                displayHotels(filteredHotels, currentFilters.checkIn, currentFilters.checkOut, currentFilters.guests);
            }
        });
    });
}

function getPaginatedHotels(hotels) {
    const start = (currentPage - 1) * itemsPerPage;
    const end = start + itemsPerPage;
    return hotels.slice(start, end);
}

function updateResultsCount(count) {
    const resultsCount = document.getElementById('resultsCount');
    if (resultsCount) {
        resultsCount.textContent = `${count} Results Found`;
    }
    
    const resultsTitle = document.getElementById('resultsTitle');
    if (resultsTitle) {
        resultsTitle.textContent = `${count} Results Found`;
    }
}

// Populate filters dynamically from hotels data
async function populateFilters(hotels) {
    if (!hotels || hotels.length === 0) return;
    
    // Extract hotel ratings and populate hotel stars
    populateHotelStars(hotels);
    
    // Populate facilities/amenities from hotels
    await populateFacilities(hotels);
    
    // Populate review scores (will be populated when review data is available)
    // For now, we'll set up the structure
    populateReviewScores(hotels);
}

async function populateFacilities(hotels) {
    const facilitiesContainer = document.getElementById('facilitiesContainer');
    if (!facilitiesContainer) return;
    
    try {
        // Load amenities for all hotels
        const amenitiesMap = new Map(); // amenity name -> count
        const amenityDetailsMap = new Map(); // amenity name -> amenity object
        const amenityCache = new Map(); // amenityId -> amenity object (cache to avoid duplicate API calls)
        
        // Load amenities for each hotel
        for (const hotel of hotels) {
            try {
                if (typeof HotelBookingAPI !== 'undefined' && HotelBookingAPI.HotelAmenityAPI && HotelBookingAPI.AmenityAPI) {
                    const hotelAmenities = await HotelBookingAPI.HotelAmenityAPI.getByHotel(hotel.id);
                    console.log(`Loaded ${hotelAmenities?.length || 0} amenities for hotel ${hotel.id}`, hotelAmenities);
                    
                    if (Array.isArray(hotelAmenities) && hotelAmenities.length > 0) {
                        // Load full amenity details for each hotel amenity
                        for (const hotelAmenity of hotelAmenities) {
                            try {
                                const amenityId = hotelAmenity.amenityId || hotelAmenity.id;
                                if (amenityId) {
                                    // Check cache first
                                    let amenity = amenityCache.get(amenityId);
                                    if (!amenity) {
                                        amenity = await HotelBookingAPI.AmenityAPI.getById(amenityId);
                                        if (amenity) {
                                            amenityCache.set(amenityId, amenity);
                                        }
                                    }
                                    
                                    if (amenity && amenity.name) {
                                        const amenityName = amenity.name.trim();
                                        if (amenityName) {
                                            amenitiesMap.set(amenityName, (amenitiesMap.get(amenityName) || 0) + 1);
                                            // Store amenity details for later use
                                            if (!amenityDetailsMap.has(amenityName)) {
                                                amenityDetailsMap.set(amenityName, amenity);
                                            }
                                        }
                                    }
                                }
                            } catch (e) {
                                console.warn(`Error loading amenity details for hotel ${hotel.id}, amenityId: ${hotelAmenity.amenityId || hotelAmenity.id}:`, e);
                            }
                        }
                    }
                } else {
                    console.warn('HotelBookingAPI.HotelAmenityAPI or AmenityAPI not available');
                }
            } catch (e) {
                console.warn(`Error loading amenities for hotel ${hotel.id}:`, e);
            }
        }
        
        console.log('Total unique amenities found:', amenitiesMap.size, Array.from(amenitiesMap.keys()));
        
        // Clear existing content
        facilitiesContainer.innerHTML = '';
        
        if (amenitiesMap.size === 0) {
            facilitiesContainer.innerHTML = '<div class="text-muted small">No facilities available.</div>';
            return;
        }
        
        // Add "Clear All" button
        const clearAllHtml = `
            <div class="d-flex justify-content-between align-items-center mb-2">
                <small class="text-muted" id="facilitySelectedCount"></small>
                <button type="button" class="btn btn-sm btn-link text-danger p-0" id="clearAllFacilities" style="display: none; font-size: 0.85rem;">
                    Clear All
                </button>
            </div>
        `;
        facilitiesContainer.insertAdjacentHTML('beforeend', clearAllHtml);
        
        // Setup clear all button
        const clearBtn = document.getElementById('clearAllFacilities');
        if (clearBtn) {
            clearBtn.addEventListener('click', function() {
                document.querySelectorAll('input[name="facility"]:checked').forEach(cb => {
                    cb.checked = false;
                });
                currentFilters.facilities = [];
                currentFilters.amenities = [];
                clearBtn.style.display = 'none';
                updateFacilitySelectedCount();
                applyFilters();
            });
        }
        
        // Sort amenities alphabetically
        // Filter out any invalid entries and ensure all keys are strings
        const validEntries = Array.from(amenitiesMap.entries()).filter(([key]) => {
            return key != null && (typeof key === 'string' || typeof key === 'number');
        });
        
        const sortedAmenities = validEntries.sort((a, b) => {
            const nameA = String(a[0] || '').toLowerCase().trim();
            const nameB = String(b[0] || '').toLowerCase().trim();
            if (!nameA || !nameB) return 0; // Skip comparison if empty
            return nameA.localeCompare(nameB);
        });
        
        // Populate facilities checkboxes
        sortedAmenities.forEach(([amenityName, count], index) => {
            const checkboxId = `facility-${index + 1}`;
            
            const facilityHtml = `
                <div class="form-check">
                    <input class="form-check-input" name="facility" type="checkbox" value="${amenityName}"
                        id="${checkboxId}">
                    <label class="form-check-label" for="${checkboxId}">
                        ${amenityName} <span class="text-muted">(${count})</span>
                    </label>
                </div>
            `;
            facilitiesContainer.insertAdjacentHTML('beforeend', facilityHtml);
        });
        
        // Update selected count initially
        updateFacilitySelectedCount();
    } catch (error) {
        console.error('Error populating facilities:', error);
        facilitiesContainer.innerHTML = '<div class="text-muted small">Error loading facilities.</div>';
    }
}

// Update facility selected count display
function updateFacilitySelectedCount() {
    const selectedCount = document.querySelectorAll('input[name="facility"]:checked').length;
    const countEl = document.getElementById('facilitySelectedCount');
    const clearBtn = document.getElementById('clearAllFacilities');
    
    if (countEl) {
        if (selectedCount > 0) {
            countEl.textContent = `${selectedCount} selected`;
            if (clearBtn) clearBtn.style.display = 'inline';
        } else {
            countEl.textContent = '';
            if (clearBtn) clearBtn.style.display = 'none';
        }
    }
}

function updatePriceSlider(hotels) {
    // Price filtering will be done at room type level when viewing hotel details
    // For now, keep default max price
    initializePriceSlider(1000000);
}

function populateHotelStars(hotels) {
    const hotelStarContainer = document.getElementById('hotelStarContainer');
    if (!hotelStarContainer) return;
    
    // Extract hotel ratings and count by star rating
    const starCounts = { 1: 0, 2: 0, 3: 0, 4: 0, 5: 0 };
    
    hotels.forEach(hotel => {
        const rating = parseFloat(hotel.rating) || 0;
        
        // Map rating (0-5) to star rating (1-5)
        // Rating 0-1 = 1 star, 1-2 = 2 stars, 2-3 = 3 stars, 3-4 = 4 stars, 4-5 = 5 stars
        let starRating;
        if (rating < 1) starRating = 1;
        else if (rating < 2) starRating = 2;
        else if (rating < 3) starRating = 3;
        else if (rating < 4) starRating = 4;
        else starRating = 5;
        
        starCounts[starRating] = (starCounts[starRating] || 0) + 1;
    });
    
    // Clear existing content
    hotelStarContainer.innerHTML = '';
    
    // Populate hotel star checkboxes (from 5 stars to 1 star)
    for (let stars = 5; stars >= 1; stars--) {
        const count = starCounts[stars] || 0;
        if (count > 0) {
            const checkboxId = `hotel-star-${stars}`;
            const starHtml = `
                <div class="form-check">
                    <input class="form-check-input" name="hotel-star" type="checkbox" value="${stars}"
                        id="${checkboxId}">
                    <label class="form-check-label" for="${checkboxId}">
                        ${stars} Star${stars > 1 ? 's' : ''} <span>(${count})</span>
                    </label>
                </div>
            `;
            hotelStarContainer.insertAdjacentHTML('beforeend', starHtml);
        }
    }
}

async function populateReviewScores(hotels) {
    const reviewScoreContainer = document.getElementById('reviewScoreContainer');
    if (!reviewScoreContainer) return;
    
    // Try to fetch reviews if ReviewAPI is available
    // For now, we'll set up the structure based on review ratings from reviews table
    // Since we don't have direct access to reviews in room data, we'll create a placeholder
    // that can be populated when review data is available
    
    // Clear existing content
    reviewScoreContainer.innerHTML = '';
    
    // Review score categories based on rating (1-5)
    const reviewCategories = [
        { rating: 5, label: 'Excellent', min: 4.5 },
        { rating: 4, label: 'Very Good', min: 4.0 },
        { rating: 3, label: 'Average', min: 3.0 },
        { rating: 2, label: 'Poor', min: 2.0 },
        { rating: 1, label: 'Very Poor', min: 1.0 }
    ];
    
    // For now, create placeholders that will be populated when review data is available
    // In a real implementation, you would fetch reviews and calculate average ratings per room/hotel
    reviewCategories.forEach(category => {
        const checkboxId = `review-score-${category.rating}`;
        const scoreHtml = `
            <div class="form-check">
                <input class="form-check-input" name="review-score" type="checkbox" value="${category.rating}"
                    id="${checkboxId}">
                <label class="form-check-label" for="${checkboxId}">
                    ${category.label} <span>(0)</span>
                </label>
            </div>
        `;
        reviewScoreContainer.insertAdjacentHTML('beforeend', scoreHtml);
    });
    
    // TODO: Fetch reviews from API and populate counts
    // This would require a Review API endpoint
}

// Helper functions for UI feedback
function showFilteringEffect() {
    const hotelsContainer = document.getElementById('hotelsContainer');
    if (hotelsContainer) {
        hotelsContainer.style.opacity = '0.6';
        hotelsContainer.style.pointerEvents = 'none';
        hotelsContainer.style.transition = 'opacity 0.2s ease';
    }
}

function hideFilteringEffect() {
    const hotelsContainer = document.getElementById('hotelsContainer');
    if (hotelsContainer) {
        hotelsContainer.style.opacity = '1';
        hotelsContainer.style.pointerEvents = 'auto';
    }
}
