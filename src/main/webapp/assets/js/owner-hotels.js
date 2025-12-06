// Owner Hotels Page JavaScript
(function() {
    'use strict';
    
    const contextPath = window.contextPath || '';
    let ownerId = null;
    let isEditMode = false;
    let currentHotelId = null;
    let allHotelsData = [];
    let managingHotelId = null;
    
    // Address API integration
    const PROVINCES_API = 'https://provinces.open-api.vn/api';
    let provincesData = [];
    let wardsData = [];
    let selectedProvince = null;
    let selectedWard = null;
    
    // Helper function to normalize image URL
    function normalizeImageUrl(url) {
        if (!url || typeof url !== 'string') return null;
        
        const trimmed = url.trim();
        if (!trimmed) return null;
        
        // If it's already a full URL (http/https), use it as is
        if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
            return trimmed;
        }
        
        // If it starts with /, it's already a valid relative path
        if (trimmed.startsWith('/')) {
            return trimmed;
        }
        
        // Otherwise, add / at the beginning
        return '/' + trimmed;
    }
    
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
    
    // Initialize page
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
                loadSidebarMenu(userRole, '/owner/hotels');
            }
            
            ownerId = window.HotelBookingAPI.TokenManager.getUserId();
            if (!ownerId) {
                alert('Error: User ID not found. Please login again.');
                window.location.href = contextPath + '/login';
                return;
            }
            
            await loadHotels();
        } catch (error) {
            console.error('Initialization error:', error);
            alert('Error initializing page: ' + (error.message || 'Unknown error'));
        }
    });

    async function loadHotels() {
        const tbody = document.querySelector('#hotelsTable tbody');
        if (!tbody) {
            console.error('Table body not found');
            return;
        }
        
        try {
            tbody.innerHTML = '<tr><td colspan="10" class="text-center">Loading...</td></tr>';
            
            if (!ownerId) {
                throw new Error('Owner ID is required');
            }
            
            // Load hotels
            const hotels = await window.HotelBookingAPI.HotelAPI.getByOwner(ownerId);
            if (!Array.isArray(hotels)) {
                throw new Error('Invalid response format');
            }
            
            allHotelsData = hotels;
            
            // Load images and amenities for each hotel
            const loadPromises = hotels.map(async (hotel) => {
                if (!hotel || !hotel.id) return;
                
                try {
                    // Load images
                    try {
                        hotel.images = await window.HotelBookingAPI.HotelImageAPI.getByHotel(hotel.id);
                        if (!Array.isArray(hotel.images)) {
                            hotel.images = [];
                        }
                    } catch (e) {
                        console.warn(`Error loading images for hotel ${hotel.id}:`, e);
                        hotel.images = [];
                    }
                    
                    // Load amenities
                    try {
                        const hotelAmenities = await window.HotelBookingAPI.HotelAmenityAPI.getByHotel(hotel.id);
                        hotel.amenities = [];
                        
                        if (Array.isArray(hotelAmenities) && hotelAmenities.length > 0) {
                            const amenityPromises = hotelAmenities.map(async (ha) => {
                                if (!ha || !ha.amenityId) return null;
                                try {
                                    const amenity = await window.HotelBookingAPI.AmenityAPI.getById(ha.amenityId);
                                    return amenity || null;
                                } catch (e) {
                                    console.warn(`Error loading amenity ${ha.amenityId}:`, e);
                                    return null;
                                }
                            });
                            
                            const amenities = await Promise.all(amenityPromises);
                            hotel.amenities = amenities.filter(a => a != null);
                        }
                    } catch (e) {
                        console.warn(`Error loading amenities for hotel ${hotel.id}:`, e);
                        hotel.amenities = [];
                    }
                } catch (e) {
                    console.error(`Error loading details for hotel ${hotel.id}:`, e);
                    hotel.images = hotel.images || [];
                    hotel.amenities = hotel.amenities || [];
                }
            });
            
            await Promise.all(loadPromises);
            displayHotels(hotels);
        } catch (error) {
            console.error('Error loading hotels:', error);
            const errorMsg = error.message || 'Unknown error occurred';
            tbody.innerHTML = `<tr><td colspan="10" class="text-center text-danger">Error loading hotels: ${errorMsg}</td></tr>`;
            alert('Error loading hotels: ' + errorMsg);
        }
    }

    function displayHotels(hotels) {
        const tbody = document.querySelector('#hotelsTable tbody');
        if (!tbody) {
            console.error('Table body not found');
            return;
        }
        
        if (!Array.isArray(hotels) || hotels.length === 0) {
            tbody.innerHTML = '<tr><td colspan="10" class="text-center text-muted">No hotels found. <button class="theme-btn mt-2" onclick="window.showAddHotelModal()">Add Your First Hotel</button></td></tr>';
            return;
        }

        let html = '';
        hotels.forEach(hotel => {
            if (!hotel || !hotel.id) return;
            
            const statusClass = {
                'PENDING': 'badge-warning',
                'APPROVED': 'badge-success',
                'REJECTED': 'badge-danger'
            }[safeGet(hotel, 'status', '').toUpperCase()] || 'badge-secondary';
            
            let createdDate = 'N/A';
            try {
                if (hotel.createdAt) {
                    const date = new Date(hotel.createdAt);
                    if (!isNaN(date.getTime())) {
                        createdDate = date.toLocaleDateString();
                    }
                }
            } catch (e) {
                console.warn('Error parsing date:', e);
            }
            
            // Images count and preview
            const images = Array.isArray(hotel.images) ? hotel.images : [];
            const imagesCount = images.length;
            let imagesHtml = '';
            
            if (imagesCount > 0) {
                const primaryImage = images.find(img => img && img.isPrimary) || images.find(img => img && img.imageUrl) || null;
                
                if (primaryImage && primaryImage.imageUrl) {
                    const imageUrl = normalizeImageUrl(primaryImage.imageUrl);
                    if (imageUrl) {
                        const altText = (safeGet(primaryImage, 'altText', 'Hotel Image') || 'Hotel Image')
                            .replace(/"/g, '&quot;')
                            .replace(/'/g, '&#39;');
                        
                        imagesHtml = '<div style="text-align: center;">';
                        imagesHtml += `<span class="badge bg-info mb-2 d-block">${imagesCount} <i class="far fa-image"></i></span>`;
                        imagesHtml += `<img src="${imageUrl}" 
                            style="width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 2px solid #007bff; cursor: pointer;" 
                            alt="${altText}" 
                            title="${altText}"
                            onerror="this.onerror=null; this.style.display='none'; if(this.nextElementSibling) this.nextElementSibling.style.display='block';"
                            onclick="window.showImageGallery(${hotel.id})">`;
                        imagesHtml += '<span style="display:none; color: red; font-size: 10px;">Image not found</span>';
                        
                        if (imagesCount > 1) {
                            imagesHtml += `<br><small class="text-muted mt-1 d-block">+${imagesCount - 1} more</small>`;
                        }
                        imagesHtml += '</div>';
                    } else {
                        imagesHtml = `<span class="badge bg-info">${imagesCount} <i class="far fa-image"></i></span><br><small class="text-muted">Invalid image URL</small>`;
                    }
                } else {
                    imagesHtml = `<span class="badge bg-info">${imagesCount} <i class="far fa-image"></i></span><br><small class="text-muted">No valid image</small>`;
                }
            } else {
                imagesHtml = '<span class="text-muted">No images</span>';
            }
            
            // Amenities count
            const amenities = Array.isArray(hotel.amenities) ? hotel.amenities : [];
            const amenitiesCount = amenities.length;
            const amenitiesHtml = amenitiesCount > 0
                ? `<span class="badge bg-secondary">${amenitiesCount} <i class="far fa-list"></i></span>`
                : '<span class="text-muted">No amenities</span>';
            
            // Escape HTML in text fields
            const escapeHtml = (text) => {
                if (text == null) return 'N/A';
                return String(text)
                    .replace(/&/g, '&amp;')
                    .replace(/</g, '&lt;')
                    .replace(/>/g, '&gt;')
                    .replace(/"/g, '&quot;')
                    .replace(/'/g, '&#39;');
            };
            
            html += '<tr>' +
                '<td>' + (hotel.id || 'N/A') + '</td>' +
                '<td><strong>' + escapeHtml(safeGet(hotel, 'name')) + '</strong></td>' +
                '<td>' + escapeHtml(safeGet(hotel, 'city')) + '</td>' +
                '<td>' + escapeHtml(safeGet(hotel, 'country')) + '</td>' +
                '<td>' + (safeGet(hotel, 'rating', '0.0') || '0.0') + '</td>' +
                '<td><span class="badge ' + statusClass + '">' + escapeHtml(safeGet(hotel, 'status')) + '</span></td>' +
                '<td style="text-align: center;">' + imagesHtml + '</td>' +
                '<td style="text-align: center;">' + amenitiesHtml + '</td>' +
                '<td>' + createdDate + '</td>' +
                '<td style="white-space: nowrap;">' +
                    '<button class="btn btn-sm btn-info me-1" onclick="window.manageHotelDetails(' + hotel.id + ')" title="Manage Images & Amenities">' +
                        '<i class="far fa-cog"></i>' +
                    '</button>' +
                    '<a href="' + contextPath + '/owner/rooms?hotelId=' + hotel.id + '" class="btn btn-sm btn-primary me-1" title="Manage Rooms">' +
                        '<i class="far fa-door-open"></i>' +
                    '</a>' +
                    '<button class="btn btn-sm btn-secondary me-1" onclick="window.editHotel(' + hotel.id + ')" title="Edit">' +
                        '<i class="far fa-edit"></i>' +
                    '</button>' +
                    '<button class="btn btn-sm btn-danger" onclick="window.deleteHotel(' + hotel.id + ')" title="Delete">' +
                        '<i class="far fa-trash"></i>' +
                    '</button>' +
                '</td>' +
            '</tr>';
        });
        tbody.innerHTML = html;
    }

    // Load provinces from API
    async function loadProvinces() {
        try {
            // Use proxy endpoint to avoid CORS
            const response = await fetch(`${contextPath}/api/provinces`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            
            if (!response.ok) {
                throw new Error('Failed to load provinces');
            }
            provincesData = await response.json();
            
            const provinceSelect = document.getElementById('province');
            if (!provinceSelect) return;
            
            provinceSelect.innerHTML = '<option value="">-- Chọn Tỉnh/Thành phố --</option>';
            provincesData.forEach(province => {
                const option = document.createElement('option');
                option.value = province.code;
                option.textContent = province.name;
                provinceSelect.appendChild(option);
            });
        } catch (error) {
            console.error('Error loading provinces:', error);
            const provinceSelect = document.getElementById('province');
            if (provinceSelect) {
                provinceSelect.innerHTML = '<option value="">Lỗi tải danh sách tỉnh/thành phố</option>';
            }
        }
    }
    
    // Load wards from API (API v2: wards are directly under province)
    async function loadWards(provinceCode) {
        try {
            if (!provinceCode) {
                const wardSelect = document.getElementById('ward');
                if (wardSelect) {
                    wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                    wardSelect.disabled = true;
                }
                return;
            }
            
            // Use proxy endpoint to avoid CORS
            const response = await fetch(`${contextPath}/api/provinces/${provinceCode}/wards`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });
            
            if (!response.ok) {
                throw new Error('Failed to load wards');
            }
            const responseData = await response.json();
            console.log('Wards response:', responseData); // Debug log
            
            // API v2 returns array of wards directly
            wardsData = Array.isArray(responseData) ? responseData : [];
            
            console.log('Parsed wards data:', wardsData); // Debug log
            
            const wardSelect = document.getElementById('ward');
            if (!wardSelect) return;
            
            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            
            if (wardsData.length === 0) {
                wardSelect.innerHTML = '<option value="">Không có phường/xã</option>';
                wardSelect.disabled = true;
                return;
            }
            
            wardsData.forEach(ward => {
                const option = document.createElement('option');
                option.value = ward.code;
                option.textContent = ward.name;
                wardSelect.appendChild(option);
            });
            wardSelect.disabled = false;
        } catch (error) {
            console.error('Error loading wards:', error);
            const wardSelect = document.getElementById('ward');
            if (wardSelect) {
                wardSelect.innerHTML = '<option value="">Lỗi tải danh sách phường/xã</option>';
            }
        }
    }
    
    // Setup address dropdowns event listeners
    function setupAddressDropdowns() {
        const provinceSelect = document.getElementById('province');
        const wardSelect = document.getElementById('ward');
        
        if (provinceSelect) {
            provinceSelect.addEventListener('change', async function() {
                const provinceCode = this.value;
                selectedProvince = provincesData.find(p => p.code == provinceCode);
                await loadWards(provinceCode);
                
                // Update city field
                const cityInput = document.getElementById('city');
                if (cityInput && selectedProvince) {
                    cityInput.value = selectedProvince.name;
                }
            });
        }
        
        if (wardSelect) {
            wardSelect.addEventListener('change', function() {
                const wardCode = this.value;
                selectedWard = wardsData.find(w => w.code == wardCode);
            });
        }
    }
    
    window.showAddHotelModal = async function() {
        try {
            const modal = document.getElementById('hotelModal');
            const title = document.getElementById('hotelModalTitle');
            const form = document.getElementById('hotelForm');
            const hotelIdInput = document.getElementById('hotelId');
            const ownerIdInput = document.getElementById('ownerId');
            
            if (!modal || !title || !form || !hotelIdInput || !ownerIdInput) {
                alert('Error: Modal elements not found');
                return;
            }
            
            title.textContent = 'Add Hotel';
            form.reset();
            hotelIdInput.value = '';
            ownerIdInput.value = ownerId || '';
            isEditMode = false;
            currentHotelId = null;
            
            // Reset address dropdowns
            selectedProvince = null;
            selectedWard = null;
            
            // Load provinces
            await loadProvinces();
            
            // Setup event listeners
            setupAddressDropdowns();
            
            // Set country to Vietnam
            const countryInput = document.getElementById('country');
            if (countryInput) {
                countryInput.value = 'Việt Nam';
            }
            
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
        } catch (error) {
            console.error('Error showing add hotel modal:', error);
            alert('Error opening form: ' + (error.message || 'Unknown error'));
        }
    };

    window.editHotel = async function(id) {
        if (!id) {
            alert('Invalid hotel ID');
            return;
        }
        
        try {
            const hotel = await window.HotelBookingAPI.HotelAPI.getById(id);
            if (!hotel) {
                alert('Hotel not found');
                return;
            }
            
            const title = document.getElementById('hotelModalTitle');
            const hotelIdInput = document.getElementById('hotelId');
            const nameInput = document.getElementById('name');
            const cityInput = document.getElementById('city');
            const countryInput = document.getElementById('country');
            const ratingInput = document.getElementById('rating');
            const addressInput = document.getElementById('address');
            const descriptionInput = document.getElementById('description');
            const ownerIdInput = document.getElementById('ownerId');
            
            if (!title || !hotelIdInput || !nameInput || !cityInput || !countryInput || 
                !ratingInput || !addressInput || !descriptionInput || !ownerIdInput) {
                alert('Error: Form elements not found');
                return;
            }
            
            title.textContent = 'Edit Hotel';
            hotelIdInput.value = safeGet(hotel, 'id', '');
            nameInput.value = safeGet(hotel, 'name', '');
            cityInput.value = safeGet(hotel, 'city', '');
            countryInput.value = safeGet(hotel, 'country', 'Việt Nam');
            ratingInput.value = safeGet(hotel, 'rating', '0.0');
            // Parse address to extract detail part
            const fullAddress = safeGet(hotel, 'address', '');
            // Try to extract detail address (before first comma or use full address)
            const addressParts = fullAddress.split(',');
            const addressDetail = addressParts.length > 0 ? addressParts[0].trim() : fullAddress;
            addressInput.value = addressDetail;
            descriptionInput.value = safeGet(hotel, 'description', '');
            ownerIdInput.value = safeGet(hotel, 'ownerId', ownerId || '');
            
            // Load provinces and try to match existing address
            await loadProvinces();
            setupAddressDropdowns();
            
            // Try to parse and set province/district/ward from existing address
            await parseAndSetAddress(hotel.address, hotel.city);
            
            isEditMode = true;
            currentHotelId = id;
            
            const modal = document.getElementById('hotelModal');
            if (modal) {
                const bsModal = new bootstrap.Modal(modal);
                bsModal.show();
            }
        } catch (error) {
            console.error('Error loading hotel:', error);
            alert('Error loading hotel: ' + (error.message || 'Unknown error'));
        }
    };

    // Parse and set address from existing data
    async function parseAndSetAddress(address, city) {
        try {
            if (!city) return;
            
            // Find province by city name
            const province = provincesData.find(p => 
                p.name.toLowerCase().includes(city.toLowerCase()) || 
                city.toLowerCase().includes(p.name.toLowerCase())
            );
            
            if (province) {
                const provinceSelect = document.getElementById('province');
                if (provinceSelect) {
                    provinceSelect.value = province.code;
                    selectedProvince = province;
                    await loadWards(province.code);
                    
                    // Try to find ward from address
                    if (address && wardsData.length > 0) {
                        for (const ward of wardsData) {
                            if (address.toLowerCase().includes(ward.name.toLowerCase())) {
                                const wardSelect = document.getElementById('ward');
                                if (wardSelect) {
                                    wardSelect.value = ward.code;
                                    selectedWard = ward;
                                }
                                break;
                            }
                        }
                    }
                }
            }
        } catch (error) {
            console.error('Error parsing address:', error);
        }
    }
    
    window.saveHotel = async function() {
        try {
            const nameInput = document.getElementById('name');
            const cityInput = document.getElementById('city');
            const countryInput = document.getElementById('country');
            const addressInput = document.getElementById('address');
            const ratingInput = document.getElementById('rating');
            const descriptionInput = document.getElementById('description');
            const provinceSelect = document.getElementById('province');
            const wardSelect = document.getElementById('ward');
            
            if (!nameInput || !cityInput || !countryInput || !addressInput) {
                alert('Error: Form elements not found');
                return;
            }
            
            const name = (nameInput.value || '').trim();
            const addressDetail = (addressInput.value || '').trim();
            
            // Validate required fields
            if (!name) {
                alert('Vui lòng nhập tên khách sạn');
                return;
            }
            
            if (!provinceSelect || !provinceSelect.value) {
                alert('Vui lòng chọn Tỉnh/Thành phố');
                return;
            }
            
            if (!wardSelect || !wardSelect.value) {
                alert('Vui lòng chọn Phường/Xã');
                return;
            }
            
            if (!addressDetail) {
                alert('Vui lòng nhập địa chỉ chi tiết (số nhà, tên đường)');
                return;
            }
            
            // Build full address (API v2: only province and ward)
            const provinceName = selectedProvince ? selectedProvince.name : '';
            const wardName = selectedWard ? selectedWard.name : '';
            
            const fullAddress = `${addressDetail}, ${wardName}, ${provinceName}`;
            const city = provinceName; // Use province name as city
            const country = 'Việt Nam';
            
            if (!ownerId) {
                alert('Error: Owner ID not found. Please refresh the page.');
                return;
            }
            
            let rating = 0.0;
            if (ratingInput && ratingInput.value) {
                const ratingValue = parseFloat(ratingInput.value);
                if (!isNaN(ratingValue)) {
                    rating = Math.max(0, Math.min(5, ratingValue)); // Clamp between 0 and 5
                }
            }
            
            const formData = {
                name: name,
                city: city,
                country: country,
                address: fullAddress,
                description: (descriptionInput ? (descriptionInput.value || '').trim() : ''),
                rating: rating,
                ownerId: ownerId
            };
            
            if (isEditMode && currentHotelId) {
                await window.HotelBookingAPI.HotelAPI.update(currentHotelId, formData);
                alert('Hotel updated successfully!');
            } else {
                await window.HotelBookingAPI.HotelAPI.create(formData);
                alert('Hotel created successfully!');
            }
            
            const modal = document.getElementById('hotelModal');
            if (modal) {
                const bsModalInstance = bootstrap.Modal.getInstance(modal);
                if (bsModalInstance) {
                    bsModalInstance.hide();
                }
            }
            
            await loadHotels();
        } catch (error) {
            console.error('Error saving hotel:', error);
            alert('Error saving hotel: ' + (error.message || 'Unknown error'));
        }
    };

    window.deleteHotel = async function(id) {
        if (!id) {
            alert('Invalid hotel ID');
            return;
        }
        
        if (!confirm('Are you sure you want to delete this hotel? This will also delete all rooms and bookings. This action cannot be undone.')) {
            return;
        }
        
        try {
            await window.HotelBookingAPI.HotelAPI.delete(id);
            alert('Hotel deleted successfully');
            await loadHotels();
        } catch (error) {
            console.error('Error deleting hotel:', error);
            alert('Error deleting hotel: ' + (error.message || 'Unknown error'));
        }
    };

    window.manageHotelDetails = async function(hotelId) {
        if (!hotelId) {
            alert('Invalid hotel ID');
            return;
        }
        
        try {
            managingHotelId = hotelId;
            const hotel = allHotelsData.find(h => h && h.id === hotelId);
            
            const titleEl = document.getElementById('hotelDetailsModalTitle');
            const modalEl = document.getElementById('hotelDetailsModal');
            
            if (!titleEl || !modalEl) {
                alert('Error: Modal elements not found');
                return;
            }
            
            if (hotel) {
                titleEl.textContent = `Manage: ${safeGet(hotel, 'name', 'Hotel')}`;
            } else {
                titleEl.textContent = 'Manage Hotel Details';
            }
            
            const bsModal = new bootstrap.Modal(modalEl);
            bsModal.show();
            
            await Promise.all([
                loadHotelImages(hotelId),
                loadHotelAmenities(hotelId)
            ]);
        } catch (error) {
            console.error('Error managing hotel details:', error);
            alert('Error opening hotel details: ' + (error.message || 'Unknown error'));
        }
    };

    async function loadHotelImages(hotelId) {
        const container = document.getElementById('imagesList');
        if (!container) {
            console.error('Images container not found');
            return;
        }
        
        try {
            if (!hotelId) {
                throw new Error('Hotel ID is required');
            }
            
            const images = await window.HotelBookingAPI.HotelImageAPI.getByHotel(hotelId);
            displayImages(Array.isArray(images) ? images : []);
        } catch (error) {
            console.error('Error loading images:', error);
            const errorMsg = error.message || 'Unknown error';
            container.innerHTML = '<div class="col-12"><p class="text-danger">Error loading images: ' + errorMsg + '</p></div>';
        }
    }

    function displayImages(images) {
        const container = document.getElementById('imagesList');
        if (!container) {
            console.error('Images container not found');
            return;
        }
        
        if (!Array.isArray(images) || images.length === 0) {
            container.innerHTML = '<div class="col-12"><p class="text-muted">No images found</p></div>';
            return;
        }

        let html = '';
        images.forEach(image => {
            if (!image || !image.id) return;
            
            const imageUrl = normalizeImageUrl(safeGet(image, 'imageUrl'));
            if (!imageUrl) return;
            
            const altText = (safeGet(image, 'altText', 'Hotel Image') || 'Hotel Image')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
            
            const isPrimary = safeGet(image, 'isPrimary', false);
            const imageId = safeGet(image, 'id', 0);
            
            html += '<div class="col-md-3 mb-3">' +
                '<div class="card">' +
                '<img src="' + imageUrl + '" class="card-img-top" style="height: 150px; object-fit: cover;" alt="' + altText + '" ' +
                'onerror="this.onerror=null; this.style.border=\'2px solid red\'; this.alt=\'Image not found\';" />' +
                '<div class="card-body p-2">' +
                (isPrimary ? '<span class="badge bg-success mb-2">Primary</span><br>' : '') +
                '<small class="text-muted">' + altText + '</small><br>' +
                '<button class="btn btn-sm btn-danger mt-2" onclick="window.deleteImage(' + imageId + ')">' +
                '<i class="far fa-trash"></i> Delete' +
                '</button>' +
                '</div>' +
                '</div>' +
                '</div>';
        });
        container.innerHTML = html;
    }

    async function loadHotelAmenities(hotelId) {
        const container = document.getElementById('amenitiesList');
        if (!container) {
            console.error('Amenities container not found');
            return;
        }
        
        try {
            if (!hotelId) {
                throw new Error('Hotel ID is required');
            }
            
            const hotelAmenities = await window.HotelBookingAPI.HotelAmenityAPI.getByHotel(hotelId);
            
            if (!Array.isArray(hotelAmenities) || hotelAmenities.length === 0) {
                displayAmenities([]);
                return;
            }
            
            // Get full amenity details
            const amenityPromises = hotelAmenities.map(async (ha) => {
                if (!ha || !ha.amenityId) return null;
                try {
                    const amenity = await window.HotelBookingAPI.AmenityAPI.getById(ha.amenityId);
                    if (amenity && amenity.id) {
                        return { ...amenity, hotelAmenityId: safeGet(ha, 'id') };
                    }
                    return null;
                } catch (e) {
                    console.warn('Error loading amenity:', e);
                    return null;
                }
            });
            
            const amenities = await Promise.all(amenityPromises);
            displayAmenities(amenities.filter(a => a != null));
        } catch (error) {
            console.error('Error loading amenities:', error);
            const errorMsg = error.message || 'Unknown error';
            container.innerHTML = '<div class="col-12"><p class="text-danger">Error loading amenities: ' + errorMsg + '</p></div>';
        }
    }

    function displayAmenities(amenities) {
        const container = document.getElementById('amenitiesList');
        if (!container) {
            console.error('Amenities container not found');
            return;
        }
        
        if (!Array.isArray(amenities) || amenities.length === 0) {
            container.innerHTML = '<div class="col-12"><p class="text-muted">No amenities found</p></div>';
            return;
        }
        
        let html = '';
        amenities.forEach(amenity => {
            if (!amenity || !amenity.id || !amenity.name) return;
            
            const amenityName = safeGet(amenity, 'name', 'N/A');
            const amenityCategory = safeGet(amenity, 'category', '');
            const hotelAmenityId = safeGet(amenity, 'hotelAmenityId', 0);
            
            if (!hotelAmenityId) {
                console.warn('Missing hotelAmenityId for amenity:', amenity);
                return;
            }
            
            html += '<div class="col-md-4 mb-2">' +
                '<div class="d-flex justify-content-between align-items-center p-2 border rounded">' +
                '<div>' +
                '<strong>' + amenityName.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</strong><br>' +
                '<small class="text-muted">' + amenityCategory.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</small>' +
                '</div>' +
                '<button class="btn btn-sm btn-danger" onclick="window.removeAmenity(' + hotelAmenityId + ')">' +
                '<i class="far fa-times"></i>' +
                '</button>' +
                '</div>' +
                '</div>';
        });
        container.innerHTML = html;
    }

    window.showAddImageForm = function() {
        try {
            if (!managingHotelId) {
                alert('Error: No hotel selected');
                return;
            }
            
            const form = document.getElementById('addImageForm');
            const displayOrderInput = document.getElementById('imageDisplayOrder');
            const modal = document.getElementById('addImageModal');
            
            if (!form || !displayOrderInput || !modal) {
                alert('Error: Form elements not found');
                return;
            }
            
            form.reset();
            displayOrderInput.value = '0';
            
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
        } catch (error) {
            console.error('Error showing add image form:', error);
            alert('Error opening form: ' + (error.message || 'Unknown error'));
        }
    };

    window.saveImage = async function() {
        try {
            if (!managingHotelId) {
                alert('Error: No hotel selected');
                return;
            }
            
            const fileInput = document.getElementById('imageFile');
            if (!fileInput) {
                alert('Error: File input not found');
                return;
            }
            
            const file = fileInput.files && fileInput.files[0];
            if (!file) {
                alert('Please select an image file');
                return;
            }
            
            // Validate file type
            if (!file.type.startsWith('image/')) {
                alert('Please select a valid image file');
                return;
            }
            
            // Upload image
            const uploadResult = await window.HotelBookingAPI.FileUploadAPI.uploadHotelImage(file, managingHotelId);
            
            if (!uploadResult || !uploadResult.success) {
                const errorMsg = safeGet(uploadResult, 'message', 'Upload failed');
                alert('Upload failed: ' + errorMsg);
                return;
            }
            
            const imageUrl = safeGet(uploadResult, 'imageUrl');
            if (!imageUrl) {
                alert('Upload failed: No image URL returned');
                return;
            }
            
            // Add image to hotel
            const altTextInput = document.getElementById('imageAltText');
            const isPrimaryInput = document.getElementById('imageIsPrimary');
            const displayOrderInput = document.getElementById('imageDisplayOrder');
            
            const imageData = {
                imageUrl: imageUrl,
                altText: (altTextInput ? (altTextInput.value || '').trim() : ''),
                isPrimary: (isPrimaryInput ? isPrimaryInput.checked : false),
                displayOrder: (displayOrderInput ? (parseInt(displayOrderInput.value) || 0) : 0)
            };

            await window.HotelBookingAPI.HotelImageAPI.add(managingHotelId, imageData);
            
            const modal = document.getElementById('addImageModal');
            if (modal) {
                const bsModalInstance = bootstrap.Modal.getInstance(modal);
                if (bsModalInstance) {
                    bsModalInstance.hide();
                }
            }
            
            await Promise.all([
                loadHotelImages(managingHotelId),
                loadHotels()
            ]);
            
            alert('Image added successfully');
        } catch (error) {
            console.error('Error adding image:', error);
            alert('Error adding image: ' + (error.message || 'Unknown error'));
        }
    };

    window.deleteImage = async function(imageId) {
        if (!imageId) {
            alert('Invalid image ID');
            return;
        }
        
        if (!managingHotelId) {
            alert('Error: No hotel selected');
            return;
        }
        
        if (!confirm('Are you sure you want to delete this image?')) {
            return;
        }
        
        try {
            await window.HotelBookingAPI.HotelImageAPI.delete(managingHotelId, imageId);
            
            await Promise.all([
                loadHotelImages(managingHotelId),
                loadHotels()
            ]);
            
            alert('Image deleted successfully');
        } catch (error) {
            console.error('Error deleting image:', error);
            alert('Error deleting image: ' + (error.message || 'Unknown error'));
        }
    };

    window.showAddAmenityForm = async function() {
        try {
            if (!managingHotelId) {
                alert('Error: No hotel selected');
                return;
            }
            
            const selectElement = document.getElementById('amenitySelect');
            const modal = document.getElementById('addAmenityModal');
            
            if (!selectElement || !modal) {
                alert('Error: Form elements not found');
                return;
            }
            
            selectElement.innerHTML = '<option value="">Loading amenities...</option>';
            
            let hotelAmenities = [];
            
            // Try to load HOTEL category amenities first
            try {
                hotelAmenities = await window.HotelBookingAPI.AmenityAPI.getByCategory('HOTEL');
                if (!Array.isArray(hotelAmenities)) {
                    hotelAmenities = [];
                }
            } catch (e) {
                console.warn('Error loading HOTEL category, trying case variations:', e);
                try {
                    hotelAmenities = await window.HotelBookingAPI.AmenityAPI.getByCategory('Hotel');
                    if (!Array.isArray(hotelAmenities)) {
                        hotelAmenities = [];
                    }
                } catch (e2) {
                    console.warn('Error loading Hotel category, trying all amenities:', e2);
                    try {
                        const allAmenities = await window.HotelBookingAPI.AmenityAPI.getAll();
                        if (Array.isArray(allAmenities)) {
                            hotelAmenities = allAmenities.filter(a => 
                                a && a.category && (
                                    String(a.category).toUpperCase() === 'HOTEL'
                                )
                            );
                        }
                    } catch (e3) {
                        console.error('Error loading all amenities:', e3);
                    }
                }
            }
            
            // If still no amenities, try loading all and show them
            if (!Array.isArray(hotelAmenities) || hotelAmenities.length === 0) {
                try {
                    const allAmenities = await window.HotelBookingAPI.AmenityAPI.getAll();
                    if (Array.isArray(allAmenities) && allAmenities.length > 0) {
                        hotelAmenities = allAmenities;
                    }
                } catch (e) {
                    console.error('Error loading all amenities:', e);
                }
            }
            
            if (!Array.isArray(hotelAmenities) || hotelAmenities.length === 0) {
                selectElement.innerHTML = '<option value="">No amenities available. Please add amenities first.</option>';
                const bsModal = new bootstrap.Modal(modal);
                bsModal.show();
                return;
            }
            
            // Populate select with amenities not already added
            const hotel = allHotelsData.find(h => h && h.id === managingHotelId);
            const existingAmenityIds = (hotel && Array.isArray(hotel.amenities)) 
                ? hotel.amenities.map(a => a && a.id).filter(id => id != null)
                : [];
            
            const availableAmenities = hotelAmenities.filter(a => 
                a && a.id && !existingAmenityIds.includes(a.id)
            );
            
            let html = '<option value="">Select Amenity</option>';
            if (availableAmenities.length > 0) {
                availableAmenities.forEach(amenity => {
                    if (amenity && amenity.id && amenity.name) {
                        const name = String(amenity.name).replace(/</g, '&lt;').replace(/>/g, '&gt;');
                        const category = amenity.category ? ' (' + String(amenity.category).replace(/</g, '&lt;').replace(/>/g, '&gt;') + ')' : '';
                        html += `<option value="${amenity.id}">${name}${category}</option>`;
                    }
                });
            } else {
                html = '<option value="">All amenities have been added to this hotel</option>';
            }
            
            selectElement.innerHTML = html;
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
        } catch (error) {
            console.error('Error loading amenities:', error);
            const selectElement = document.getElementById('amenitySelect');
            if (selectElement) {
                const errorMsg = error.message || 'Unknown error';
                selectElement.innerHTML = '<option value="">Error loading amenities: ' + errorMsg + '</option>';
            }
            alert('Error loading amenities: ' + (error.message || 'Unknown error'));
        }
    };

    window.saveAmenity = async function() {
        try {
            if (!managingHotelId) {
                alert('Error: No hotel selected');
                return;
            }
            
            const selectElement = document.getElementById('amenitySelect');
            if (!selectElement) {
                alert('Error: Select element not found');
                return;
            }
            
            const amenityId = selectElement.value;
            if (!amenityId) {
                alert('Please select an amenity');
                return;
            }
            
            const amenityIdNum = parseInt(amenityId);
            if (isNaN(amenityIdNum)) {
                alert('Invalid amenity ID');
                return;
            }

            await window.HotelBookingAPI.HotelAmenityAPI.add(managingHotelId, amenityIdNum);
            
            const modal = document.getElementById('addAmenityModal');
            if (modal) {
                const bsModalInstance = bootstrap.Modal.getInstance(modal);
                if (bsModalInstance) {
                    bsModalInstance.hide();
                }
            }
            
            await Promise.all([
                loadHotels(),
                loadHotelAmenities(managingHotelId)
            ]);
            
            alert('Amenity added successfully');
        } catch (error) {
            console.error('Error adding amenity:', error);
            alert('Error adding amenity: ' + (error.message || 'Unknown error'));
        }
    };

    window.removeAmenity = async function(hotelAmenityId) {
        if (!hotelAmenityId) {
            alert('Invalid amenity ID');
            return;
        }
        
        if (!managingHotelId) {
            alert('Error: No hotel selected');
            return;
        }
        
        if (!confirm('Are you sure you want to remove this amenity?')) {
            return;
        }
        
        try {
            await window.HotelBookingAPI.HotelAmenityAPI.remove(managingHotelId, hotelAmenityId);
            
            await Promise.all([
                loadHotels(),
                loadHotelAmenities(managingHotelId)
            ]);
            
            alert('Amenity removed successfully');
        } catch (error) {
            console.error('Error removing amenity:', error);
            alert('Error removing amenity: ' + (error.message || 'Unknown error'));
        }
    };

    window.showImageGallery = function(hotelId) {
        try {
            if (!hotelId) {
                alert('Invalid hotel ID');
                return;
            }
            
            const hotel = allHotelsData.find(h => h && h.id === hotelId);
            if (!hotel) {
                alert('Hotel not found');
                return;
            }
            
            const images = Array.isArray(hotel.images) ? hotel.images : [];
            if (images.length === 0) {
                alert('No images available');
                return;
            }
            
            // Open the manage modal and switch to images tab
            managingHotelId = hotelId;
            
            const titleEl = document.getElementById('hotelDetailsModalTitle');
            const modalEl = document.getElementById('hotelDetailsModal');
            const imagesTab = document.getElementById('images-tab');
            
            if (!titleEl || !modalEl) {
                alert('Error: Modal elements not found');
                return;
            }
            
            titleEl.textContent = `Manage: ${safeGet(hotel, 'name', 'Hotel')}`;
            
            // Switch to images tab
            if (imagesTab) {
                imagesTab.click();
            }
            
            const bsModal = new bootstrap.Modal(modalEl);
            bsModal.show();
            
            loadHotelImages(hotelId);
        } catch (error) {
            console.error('Error showing image gallery:', error);
            alert('Error opening image gallery: ' + (error.message || 'Unknown error'));
        }
    };
})();

