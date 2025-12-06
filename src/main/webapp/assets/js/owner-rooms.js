// Owner Rooms Page JavaScript
(function() {
    'use strict';
    
    const contextPath = window.contextPath || '';
    let ownerId = null;
    let hotelId = null;
    let isEditMode = false;
    let currentRoomTypeId = null;
    let managingRoomTypeId = null;
    let hotels = [];
    let allRoomsData = [];
    
    // Helper function to normalize image URL
    function normalizeImageUrl(url) {
        if (!url || typeof url !== 'string') return null;
        
        const trimmed = url.trim();
        if (!trimmed) return null;
        
        if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
            return trimmed;
        }
        
        if (trimmed.startsWith('/')) {
            return trimmed;
        }
        
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
                loadSidebarMenu(userRole, '/owner/rooms');
            }
            
            ownerId = window.HotelBookingAPI.TokenManager.getUserId();
            if (!ownerId) {
                alert('Error: User ID not found. Please login again.');
                window.location.href = contextPath + '/login';
                return;
            }
            
            const urlParams = new URLSearchParams(window.location.search);
            hotelId = urlParams.get('hotelId');
            
            await loadHotels();
            await loadRooms();
        } catch (error) {
            console.error('Initialization error:', error);
            alert('Error initializing page: ' + (error.message || 'Unknown error'));
        }
    });

    async function loadHotels() {
        try {
            hotels = await window.HotelBookingAPI.HotelAPI.getByOwner(ownerId);
            const select = document.getElementById('hotelId');
            if (!select) {
                console.error('Hotel select not found');
                return;
            }
            
            select.innerHTML = '<option value="">Select Hotel</option>';
            
            // Filter only APPROVED hotels for dropdown
            const approvedHotels = Array.isArray(hotels) ? hotels.filter(hotel => hotel && hotel.status === 'APPROVED') : [];
            
            approvedHotels.forEach(hotel => {
                if (!hotel || !hotel.id) return;
                const option = document.createElement('option');
                option.value = hotel.id;
                option.textContent = safeGet(hotel, 'name', 'Unnamed Hotel');
                if (hotelId && hotel.id == hotelId) {
                    option.selected = true;
                }
                select.appendChild(option);
            });
        } catch (error) {
            console.error('Error loading hotels:', error);
            alert('Error loading hotels: ' + (error.message || 'Unknown error'));
        }
    }

    async function loadRooms() {
        try {
            const tbody = document.querySelector('#roomsTable tbody');
            if (!tbody) {
                console.error('Table body not found');
                return;
            }
            
            let rooms = [];
            if (hotelId) {
                rooms = await window.HotelBookingAPI.RoomTypeAPI.getByHotel(hotelId);
            } else {
                // Get all hotels of owner, then get all room types
                if (Array.isArray(hotels) && hotels.length > 0) {
                    for (const hotel of hotels) {
                        if (!hotel || !hotel.id) continue;
                        try {
                            const hotelRoomTypes = await window.HotelBookingAPI.RoomTypeAPI.getByHotel(hotel.id);
                            if (Array.isArray(hotelRoomTypes)) {
                                rooms = rooms.concat(hotelRoomTypes);
                            }
                        } catch (e) {
                            console.warn(`Error loading rooms for hotel ${hotel.id}:`, e);
                        }
                    }
                }
            }
            
            // Load images and amenities for each room
            if (Array.isArray(rooms) && rooms.length > 0) {
                const loadPromises = rooms.map(async (room) => {
                    if (!room || !room.id) return;
                    
                    try {
                        // Load images
                        try {
                            const images = await window.HotelBookingAPI.RoomTypeImageAPI.getByRoomType(room.id);
                            room.images = Array.isArray(images) ? images : [];
                        } catch (e) {
                            console.warn(`Error loading images for room ${room.id}:`, e);
                            room.images = [];
                        }
                        
                        // Load amenities
                        try {
                            const roomAmenities = await window.HotelBookingAPI.RoomTypeAmenityAPI.getByRoomType(room.id);
                            room.amenities = [];
                            
                            if (Array.isArray(roomAmenities) && roomAmenities.length > 0) {
                                const amenityPromises = roomAmenities.map(async (rta) => {
                                    if (!rta || !rta.amenityId) return null;
                                    try {
                                        const amenity = await window.HotelBookingAPI.AmenityAPI.getById(rta.amenityId);
                                        return amenity || null;
                                    } catch (e) {
                                        console.warn(`Error loading amenity ${rta.amenityId}:`, e);
                                        return null;
                                    }
                                });
                                
                                const amenities = await Promise.all(amenityPromises);
                                room.amenities = amenities.filter(a => a != null);
                            }
                        } catch (e) {
                            console.warn(`Error loading amenities for room ${room.id}:`, e);
                            room.amenities = [];
                        }
                    } catch (e) {
                        console.error(`Error loading details for room ${room.id}:`, e);
                        room.images = room.images || [];
                        room.amenities = room.amenities || [];
                    }
                });
                
                await Promise.all(loadPromises);
            }
            
            allRoomsData = Array.isArray(rooms) ? rooms : [];
            displayRooms(allRoomsData);
        } catch (error) {
            console.error('Error loading rooms:', error);
            const tbody = document.querySelector('#roomsTable tbody');
            if (tbody) {
                tbody.innerHTML = '<tr><td colspan="10" class="text-center text-danger">Error loading rooms: ' + (error.message || 'Unknown error') + '</td></tr>';
            }
            alert('Error loading rooms: ' + (error.message || 'Unknown error'));
        }
    }

    function displayRooms(rooms) {
        const tbody = document.querySelector('#roomsTable tbody');
        if (!tbody) {
            console.error('Table body not found');
            return;
        }
        
        if (!Array.isArray(rooms) || rooms.length === 0) {
            tbody.innerHTML = '<tr><td colspan="10" class="text-center text-muted">No rooms found. <button class="theme-btn mt-2" onclick="showAddRoomModal()">Add Your First Room</button></td></tr>';
            return;
        }

        const escapeHtml = (text) => {
            if (text == null) return 'N/A';
            return String(text)
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;')
                .replace(/"/g, '&quot;')
                .replace(/'/g, '&#39;');
        };

        let html = '';
        rooms.forEach(room => {
            if (!room || !room.id) return;
            
            const statusClass = {
                'PENDING': 'badge-warning',
                'APPROVED': 'badge-success',
                'REJECTED': 'badge-danger'
            }[safeGet(room, 'status', '').toUpperCase()] || 'badge-secondary';
            
            const hotelName = safeGet(room, 'hotel.name') || safeGet(room, 'hotelName') || 'N/A';
            const price = safeGet(room, 'pricePerNight', 0);
            const formattedPrice = window.HotelBookingAPI && window.HotelBookingAPI.Utils 
                ? window.HotelBookingAPI.Utils.formatCurrency(price) 
                : price.toLocaleString() + ' VND';
            const totalRooms = safeGet(room, 'totalRooms', 0);
            
            // Images count and preview
            const images = Array.isArray(room.images) ? room.images : [];
            const imagesCount = images.length;
            let imagesHtml = '';
            
            if (imagesCount > 0) {
                const primaryImage = images.find(img => img && img.isPrimary) || images.find(img => img && img.imageUrl) || null;
                
                if (primaryImage && primaryImage.imageUrl) {
                    const imageUrl = normalizeImageUrl(primaryImage.imageUrl);
                    if (imageUrl) {
                        imagesHtml = '<div style="text-align: center;">';
                        imagesHtml += `<span class="badge bg-info mb-2 d-block">${imagesCount} <i class="far fa-image"></i></span>`;
                        imagesHtml += `<img src="${imageUrl}" 
                            style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px; border: 2px solid #007bff; cursor: pointer;" 
                            alt="Room Image" 
                            title="Room Image"
                            onerror="this.onerror=null; this.style.display='none'; if(this.nextElementSibling) this.nextElementSibling.style.display='block';"
                            onclick="manageRoomDetails(${room.id})">`;
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
            const amenities = Array.isArray(room.amenities) ? room.amenities : [];
            const amenitiesCount = amenities.length;
            const amenitiesHtml = amenitiesCount > 0
                ? `<span class="badge bg-secondary">${amenitiesCount} <i class="far fa-list"></i></span>`
                : '<span class="text-muted">No amenities</span>';
            
            html += '<tr>' +
                '<td>' + (room.id || 'N/A') + '</td>' +
                '<td><strong>' + escapeHtml(safeGet(room, 'name')) + '</strong></td>' +
                '<td>' + escapeHtml(hotelName) + '</td>' +
                '<td>' + escapeHtml(safeGet(room, 'roomType')) + '</td>' +
                '<td>' + formattedPrice + '</td>' +
                '<td style="text-align: center;">' +
                    '<div class="d-flex align-items-center justify-content-center gap-2">' +
                    '<input type="number" class="form-control form-control-sm" id="totalRooms_' + room.id + '" ' +
                    'value="' + totalRooms + '" min="0" style="width: 80px; text-align: center;" ' +
                    'onchange="updateTotalRooms(' + room.id + ', this.value)" ' +
                    'title="Click to edit total rooms">' +
                    '<button class="btn btn-sm btn-success" onclick="updateTotalRooms(' + room.id + ', document.getElementById(\'totalRooms_' + room.id + '\').value)" ' +
                    'title="Save total rooms" style="padding: 2px 8px;">' +
                    '<i class="far fa-check"></i>' +
                    '</button>' +
                    '</div>' +
                '</td>' +
                '<td><span class="badge ' + statusClass + '">' + escapeHtml(safeGet(room, 'status')) + '</span></td>' +
                '<td style="text-align: center;">' + imagesHtml + '</td>' +
                '<td style="text-align: center;">' + amenitiesHtml + '</td>' +
                '<td style="white-space: nowrap;">' +
                    '<button class="btn btn-sm btn-info me-1" onclick="manageRoomDetails(' + room.id + ')" title="Manage Images & Amenities">' +
                        '<i class="far fa-cog"></i>' +
                    '</button>' +
                    '<button class="btn btn-sm btn-secondary me-1" onclick="editRoom(' + room.id + ')" title="Edit">' +
                        '<i class="far fa-edit"></i>' +
                    '</button>' +
                    '<button class="btn btn-sm btn-danger" onclick="deleteRoom(' + room.id + ')" title="Delete">' +
                        '<i class="far fa-trash"></i>' +
                    '</button>' +
                '</td>' +
            '</tr>';
        });
        tbody.innerHTML = html;
    }

    function showAddRoomModal() {
        try {
            const title = document.getElementById('roomModalTitle');
            const form = document.getElementById('roomForm');
            const roomTypeIdInput = document.getElementById('roomTypeId');
            
            if (!title || !form || !roomTypeIdInput) {
                alert('Error: Modal elements not found');
                return;
            }
            
            title.textContent = 'Add Room';
            form.reset();
            roomTypeIdInput.value = '';
            document.getElementById('totalRooms').value = '1';
            document.getElementById('maxOccupancy').value = '2';
            if (hotelId) {
                document.getElementById('hotelId').value = hotelId;
            }
            isEditMode = false;
            currentRoomTypeId = null;
            
            const modal = document.getElementById('roomModal');
            if (modal) {
                const bsModal = new bootstrap.Modal(modal);
                bsModal.show();
            }
        } catch (error) {
            console.error('Error showing add room modal:', error);
            alert('Error opening form: ' + (error.message || 'Unknown error'));
        }
    }

    async function editRoom(id) {
        if (!id) {
            alert('Invalid room ID');
            return;
        }
        
        try {
            const room = await window.HotelBookingAPI.RoomTypeAPI.getById(id);
            if (!room) {
                alert('Room not found');
                return;
            }
            
            const title = document.getElementById('roomModalTitle');
            const roomTypeIdInput = document.getElementById('roomTypeId');
            const hotelIdInput = document.getElementById('hotelId');
            const nameInput = document.getElementById('name');
            const roomTypeInput = document.getElementById('roomType');
            const priceInput = document.getElementById('pricePerNight');
            const totalRoomsInput = document.getElementById('totalRooms');
            const maxOccupancyInput = document.getElementById('maxOccupancy');
            const descriptionInput = document.getElementById('description');
            
            if (!title || !roomTypeIdInput || !hotelIdInput || !nameInput || !roomTypeInput || 
                !priceInput || !totalRoomsInput || !maxOccupancyInput || !descriptionInput) {
                alert('Error: Form elements not found');
                return;
            }
            
            title.textContent = 'Edit Room Type';
            roomTypeIdInput.value = safeGet(room, 'id', '');
            hotelIdInput.value = safeGet(room, 'hotelId', '');
            nameInput.value = safeGet(room, 'name', '');
            roomTypeInput.value = safeGet(room, 'roomType', '');
            priceInput.value = safeGet(room, 'pricePerNight', '');
            totalRoomsInput.value = safeGet(room, 'totalRooms', 1);
            maxOccupancyInput.value = safeGet(room, 'maxOccupancy', 2);
            descriptionInput.value = safeGet(room, 'description', '');
            
            // Parse amenities - try to load from API
            try {
                const amenities = await window.HotelBookingAPI.RoomTypeAmenityAPI.getByRoomType(id);
                if (Array.isArray(amenities) && amenities.length > 0) {
                    // Get amenity names
                    const amenityPromises = amenities.map(async (rta) => {
                        if (!rta || !rta.amenityId) return null;
                        try {
                            const amenity = await window.HotelBookingAPI.AmenityAPI.getById(rta.amenityId);
                            return amenity ? amenity.name : null;
                        } catch (e) {
                            return null;
                        }
                    });
                    const amenityNames = (await Promise.all(amenityPromises)).filter(a => a != null);
                    document.getElementById('amenities').value = amenityNames.join(', ');
                }
            } catch (e) {
                console.warn('Error loading amenities:', e);
            }
            
            // Parse images - try to load from API
            try {
                const images = await window.HotelBookingAPI.RoomTypeImageAPI.getByRoomType(id);
                if (Array.isArray(images) && images.length > 0) {
                    const imageUrls = images.map(img => safeGet(img, 'imageUrl', '')).filter(url => url);
                    document.getElementById('images').value = imageUrls.join('\n');
                }
            } catch (e) {
                console.warn('Error loading images:', e);
            }
            
            isEditMode = true;
            currentRoomTypeId = id;
            
            const modal = document.getElementById('roomModal');
            if (modal) {
                const bsModal = new bootstrap.Modal(modal);
                bsModal.show();
            }
        } catch (error) {
            console.error('Error loading room:', error);
            alert('Error loading room: ' + (error.message || 'Unknown error'));
        }
    }

    async function saveRoom() {
        try {
            const hotelIdInput = document.getElementById('hotelId');
            const nameInput = document.getElementById('name');
            const roomTypeInput = document.getElementById('roomType');
            const priceInput = document.getElementById('pricePerNight');
            
            if (!hotelIdInput || !nameInput || !roomTypeInput || !priceInput) {
                alert('Error: Form elements not found');
                return;
            }
            
            const hotelIdValue = hotelIdInput.value;
            const name = (nameInput.value || '').trim();
            const roomType = roomTypeInput.value;
            const pricePerNight = priceInput.value;
            
            if (!hotelIdValue || !name || !roomType || !pricePerNight) {
                alert('Please fill in all required fields');
                return;
            }
            
            const formData = {
                hotelId: parseInt(hotelIdValue),
                name: name,
                roomType: roomType,
                pricePerNight: parseFloat(pricePerNight),
                totalRooms: parseInt(document.getElementById('totalRooms').value) || 1,
                maxOccupancy: parseInt(document.getElementById('maxOccupancy').value) || 2,
                description: (document.getElementById('description') ? (document.getElementById('description').value || '').trim() : '')
            };
            
            let savedRoom;
            if (isEditMode && currentRoomTypeId) {
                savedRoom = await window.HotelBookingAPI.RoomTypeAPI.update(currentRoomTypeId, formData);
                alert('Room type updated successfully!');
            } else {
                savedRoom = await window.HotelBookingAPI.RoomTypeAPI.create(formData);
                alert('Room type created successfully! It will be pending approval.');
            }
            
            // Save amenities
            const amenitiesText = document.getElementById('amenities') ? document.getElementById('amenities').value : '';
            if (amenitiesText && savedRoom && savedRoom.id) {
                const amenityNames = amenitiesText.split(',').map(a => a.trim()).filter(a => a);
                // Note: This would require backend support to save amenities by name
                // For now, we'll skip this or implement a different approach
            }
            
            // Save images
            const imagesText = document.getElementById('images') ? document.getElementById('images').value : '';
            if (imagesText && savedRoom && savedRoom.id) {
                const imageUrls = imagesText.split('\n').map(i => i.trim()).filter(i => i);
                // Note: This would require backend support to save images
                // For now, we'll skip this or implement a different approach
            }
            
            const modal = document.getElementById('roomModal');
            if (modal) {
                const bsModalInstance = bootstrap.Modal.getInstance(modal);
                if (bsModalInstance) {
                    bsModalInstance.hide();
                }
            }
            
            await loadRooms();
        } catch (error) {
            console.error('Error saving room:', error);
            alert('Error saving room: ' + (error.message || 'Unknown error'));
        }
    }

    async function deleteRoom(id) {
        if (!id) {
            alert('Invalid room ID');
            return;
        }
        
        if (!confirm('Are you sure you want to delete this room type?')) {
            return;
        }
        
        try {
            await window.HotelBookingAPI.RoomTypeAPI.delete(id);
            alert('Room type deleted successfully');
            await loadRooms();
        } catch (error) {
            console.error('Error deleting room:', error);
            alert('Error deleting room: ' + (error.message || 'Unknown error'));
        }
    }

    async function manageRoomDetails(roomTypeId) {
        if (!roomTypeId) {
            alert('Invalid room type ID');
            return;
        }
        
        try {
            managingRoomTypeId = roomTypeId;
            const room = allRoomsData.find(r => r && r.id === roomTypeId);
            
            const titleEl = document.getElementById('roomDetailsModalTitle');
            const modalEl = document.getElementById('roomDetailsModal');
            
            if (!titleEl || !modalEl) {
                alert('Error: Modal elements not found');
                return;
            }
            
            if (room) {
                titleEl.textContent = `Manage: ${safeGet(room, 'name', 'Room')}`;
            } else {
                titleEl.textContent = 'Manage Room Details';
            }
            
            const bsModal = new bootstrap.Modal(modalEl);
            bsModal.show();
            
            await Promise.all([
                loadRoomImages(roomTypeId),
                loadRoomAmenities(roomTypeId)
            ]);
        } catch (error) {
            console.error('Error managing room details:', error);
            alert('Error opening room details: ' + (error.message || 'Unknown error'));
        }
    }

    async function loadRoomImages(roomTypeId) {
        const container = document.getElementById('roomImagesList');
        if (!container) {
            console.error('Images container not found');
            return;
        }
        
        try {
            if (!roomTypeId) {
                throw new Error('Room type ID is required');
            }
            
            const images = await window.HotelBookingAPI.RoomTypeImageAPI.getByRoomType(roomTypeId);
            displayRoomImages(Array.isArray(images) ? images : []);
        } catch (error) {
            console.error('Error loading images:', error);
            const errorMsg = error.message || 'Unknown error';
            container.innerHTML = '<div class="col-12"><p class="text-danger">Error loading images: ' + errorMsg + '</p></div>';
        }
    }

    function displayRoomImages(images) {
        const container = document.getElementById('roomImagesList');
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
            
            const altText = (safeGet(image, 'altText', 'Room Image') || 'Room Image')
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
                '<button class="btn btn-sm btn-danger mt-2" onclick="deleteRoomImage(' + imageId + ')">' +
                '<i class="far fa-trash"></i> Delete' +
                '</button>' +
                '</div>' +
                '</div>' +
                '</div>';
        });
        container.innerHTML = html;
    }

    async function loadRoomAmenities(roomTypeId) {
        const container = document.getElementById('roomAmenitiesList');
        if (!container) {
            console.error('Amenities container not found');
            return;
        }
        
        try {
            if (!roomTypeId) {
                throw new Error('Room type ID is required');
            }
            
            const roomAmenities = await window.HotelBookingAPI.RoomTypeAmenityAPI.getByRoomType(roomTypeId);
            
            if (!Array.isArray(roomAmenities) || roomAmenities.length === 0) {
                displayRoomAmenities([]);
                return;
            }
            
            // Get full amenity details
            const amenityPromises = roomAmenities.map(async (rta) => {
                if (!rta || !rta.amenityId) return null;
                try {
                    const amenity = await window.HotelBookingAPI.AmenityAPI.getById(rta.amenityId);
                    if (amenity && amenity.id) {
                        return { ...amenity, roomTypeAmenityId: safeGet(rta, 'id') };
                    }
                    return null;
                } catch (e) {
                    console.warn('Error loading amenity:', e);
                    return null;
                }
            });
            
            const amenities = await Promise.all(amenityPromises);
            displayRoomAmenities(amenities.filter(a => a != null));
        } catch (error) {
            console.error('Error loading amenities:', error);
            const errorMsg = error.message || 'Unknown error';
            container.innerHTML = '<div class="col-12"><p class="text-danger">Error loading amenities: ' + errorMsg + '</p></div>';
        }
    }

    function displayRoomAmenities(amenities) {
        const container = document.getElementById('roomAmenitiesList');
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
            const roomTypeAmenityId = safeGet(amenity, 'roomTypeAmenityId', 0);
            
            if (!roomTypeAmenityId) {
                console.warn('Missing roomTypeAmenityId for amenity:', amenity);
                return;
            }
            
            html += '<div class="col-md-4 mb-2">' +
                '<div class="d-flex justify-content-between align-items-center p-2 border rounded">' +
                '<div>' +
                '<strong>' + amenityName.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</strong><br>' +
                '<small class="text-muted">' + amenityCategory.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</small>' +
                '</div>' +
                '<button class="btn btn-sm btn-danger" onclick="removeRoomAmenity(' + roomTypeAmenityId + ')">' +
                '<i class="far fa-times"></i>' +
                '</button>' +
                '</div>' +
                '</div>';
        });
        container.innerHTML = html;
    }

    function showAddRoomImageForm() {
        try {
            if (!managingRoomTypeId) {
                alert('Error: No room selected');
                return;
            }
            
            const form = document.getElementById('addRoomImageForm');
            const displayOrderInput = document.getElementById('roomImageDisplayOrder');
            const modal = document.getElementById('addRoomImageModal');
            
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
    }

    async function saveRoomImage() {
        try {
            if (!managingRoomTypeId) {
                alert('Error: No room selected');
                return;
            }
            
            const fileInput = document.getElementById('roomImageFile');
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
            
            // Upload image - Note: This would need a room type image upload endpoint
            // For now, we'll use a generic upload and then add to room type
            const uploadResult = await window.HotelBookingAPI.FileUploadAPI.uploadHotelImage(file, null);
            
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
            
            // Add image to room type
            const altTextInput = document.getElementById('roomImageAltText');
            const isPrimaryInput = document.getElementById('roomImageIsPrimary');
            const displayOrderInput = document.getElementById('roomImageDisplayOrder');
            
            const imageData = {
                imageUrl: imageUrl,
                altText: (altTextInput ? (altTextInput.value || '').trim() : ''),
                isPrimary: (isPrimaryInput ? isPrimaryInput.checked : false),
                displayOrder: (displayOrderInput ? (parseInt(displayOrderInput.value) || 0) : 0)
            };

            await window.HotelBookingAPI.RoomTypeImageAPI.add(managingRoomTypeId, imageData);
            
            const modal = document.getElementById('addRoomImageModal');
            if (modal) {
                const bsModalInstance = bootstrap.Modal.getInstance(modal);
                if (bsModalInstance) {
                    bsModalInstance.hide();
                }
            }
            
            await Promise.all([
                loadRoomImages(managingRoomTypeId),
                loadRooms()
            ]);
            
            alert('Image added successfully');
        } catch (error) {
            console.error('Error adding image:', error);
            alert('Error adding image: ' + (error.message || 'Unknown error'));
        }
    }

    async function deleteRoomImage(imageId) {
        if (!imageId) {
            alert('Invalid image ID');
            return;
        }
        
        if (!managingRoomTypeId) {
            alert('Error: No room selected');
            return;
        }
        
        if (!confirm('Are you sure you want to delete this image?')) {
            return;
        }
        
        try {
            await window.HotelBookingAPI.RoomTypeImageAPI.delete(managingRoomTypeId, imageId);
            
            await Promise.all([
                loadRoomImages(managingRoomTypeId),
                loadRooms()
            ]);
            
            alert('Image deleted successfully');
        } catch (error) {
            console.error('Error deleting image:', error);
            alert('Error deleting image: ' + (error.message || 'Unknown error'));
        }
    }

    async function showAddRoomAmenityForm() {
        try {
            if (!managingRoomTypeId) {
                alert('Error: No room selected');
                return;
            }
            
            const selectElement = document.getElementById('roomAmenitySelect');
            const modal = document.getElementById('addRoomAmenityModal');
            
            if (!selectElement || !modal) {
                alert('Error: Form elements not found');
                return;
            }
            
            selectElement.innerHTML = '<option value="">Loading amenities...</option>';
            
            let roomAmenities = [];
            
            // Try to load ROOM category amenities first
            try {
                roomAmenities = await window.HotelBookingAPI.AmenityAPI.getByCategory('ROOM');
                if (!Array.isArray(roomAmenities)) {
                    roomAmenities = [];
                }
            } catch (e) {
                console.warn('Error loading ROOM category, trying case variations:', e);
                try {
                    roomAmenities = await window.HotelBookingAPI.AmenityAPI.getByCategory('Room');
                    if (!Array.isArray(roomAmenities)) {
                        roomAmenities = [];
                    }
                } catch (e2) {
                    console.warn('Error loading Room category, trying all amenities:', e2);
                    try {
                        const allAmenities = await window.HotelBookingAPI.AmenityAPI.getAll();
                        if (Array.isArray(allAmenities)) {
                            roomAmenities = allAmenities.filter(a => 
                                a && a.category && (
                                    String(a.category).toUpperCase() === 'ROOM'
                                )
                            );
                        }
                    } catch (e3) {
                        console.error('Error loading all amenities:', e3);
                    }
                }
            }
            
            // If still no amenities, try loading all and show them
            if (!Array.isArray(roomAmenities) || roomAmenities.length === 0) {
                try {
                    const allAmenities = await window.HotelBookingAPI.AmenityAPI.getAll();
                    if (Array.isArray(allAmenities) && allAmenities.length > 0) {
                        roomAmenities = allAmenities;
                    }
                } catch (e) {
                    console.error('Error loading all amenities:', e);
                }
            }
            
            if (!Array.isArray(roomAmenities) || roomAmenities.length === 0) {
                selectElement.innerHTML = '<option value="">No amenities available. Please add amenities first.</option>';
                const bsModal = new bootstrap.Modal(modal);
                bsModal.show();
                return;
            }
            
            // Populate select with amenities not already added
            const room = allRoomsData.find(r => r && r.id === managingRoomTypeId);
            // Get existing amenities
            let existingAmenityIds = [];
            try {
                const existingRoomAmenities = await window.HotelBookingAPI.RoomTypeAmenityAPI.getByRoomType(managingRoomTypeId);
                if (Array.isArray(existingRoomAmenities)) {
                    existingAmenityIds = existingRoomAmenities.map(rta => rta && rta.amenityId).filter(id => id != null);
                }
            } catch (e) {
                console.warn('Error loading existing amenities:', e);
            }
            
            const availableAmenities = roomAmenities.filter(a => 
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
                html = '<option value="">All amenities have been added to this room</option>';
            }
            
            selectElement.innerHTML = html;
            const bsModal = new bootstrap.Modal(modal);
            bsModal.show();
        } catch (error) {
            console.error('Error loading amenities:', error);
            const selectElement = document.getElementById('roomAmenitySelect');
            if (selectElement) {
                const errorMsg = error.message || 'Unknown error';
                selectElement.innerHTML = '<option value="">Error loading amenities: ' + errorMsg + '</option>';
            }
            alert('Error loading amenities: ' + (error.message || 'Unknown error'));
        }
    }

    async function saveRoomAmenity() {
        try {
            if (!managingRoomTypeId) {
                alert('Error: No room selected');
                return;
            }
            
            const selectElement = document.getElementById('roomAmenitySelect');
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

            await window.HotelBookingAPI.RoomTypeAmenityAPI.add(managingRoomTypeId, amenityIdNum);
            
            const modal = document.getElementById('addRoomAmenityModal');
            if (modal) {
                const bsModalInstance = bootstrap.Modal.getInstance(modal);
                if (bsModalInstance) {
                    bsModalInstance.hide();
                }
            }
            
            await Promise.all([
                loadRooms(),
                loadRoomAmenities(managingRoomTypeId)
            ]);
            
            alert('Amenity added successfully');
        } catch (error) {
            console.error('Error adding amenity:', error);
            alert('Error adding amenity: ' + (error.message || 'Unknown error'));
        }
    }

    async function removeRoomAmenity(roomTypeAmenityId) {
        if (!roomTypeAmenityId) {
            alert('Invalid amenity ID');
            return;
        }
        
        if (!managingRoomTypeId) {
            alert('Error: No room selected');
            return;
        }
        
        if (!confirm('Are you sure you want to remove this amenity?')) {
            return;
        }
        
        try {
            await window.HotelBookingAPI.RoomTypeAmenityAPI.remove(managingRoomTypeId, roomTypeAmenityId);
            
            await Promise.all([
                loadRooms(),
                loadRoomAmenities(managingRoomTypeId)
            ]);
            
            alert('Amenity removed successfully');
        } catch (error) {
            console.error('Error removing amenity:', error);
            alert('Error removing amenity: ' + (error.message || 'Unknown error'));
        }
    }

    async function updateTotalRooms(roomId, newTotalRooms) {
        if (!roomId) {
            alert('Invalid room ID');
                return;
            }
            
        const totalRoomsNum = parseInt(newTotalRooms);
        if (isNaN(totalRoomsNum) || totalRoomsNum < 0) {
            alert('Please enter a valid number (0 or greater)');
                return;
            }
            
        try {
            // Get current room data
            const room = await window.HotelBookingAPI.RoomTypeAPI.getById(roomId);
            if (!room) {
                alert('Room not found');
                return;
            }
            
            // Update only totalRooms
            const updateData = {
                hotelId: safeGet(room, 'hotelId'),
                name: safeGet(room, 'name'),
                roomType: safeGet(room, 'roomType'),
                pricePerNight: safeGet(room, 'pricePerNight', 0),
                totalRooms: totalRoomsNum,
                maxOccupancy: safeGet(room, 'maxOccupancy', 2),
                description: safeGet(room, 'description', '')
            };
            
            await window.HotelBookingAPI.RoomTypeAPI.update(roomId, updateData);
            
            // Update the input value to reflect the saved value
            const inputEl = document.getElementById('totalRooms_' + roomId);
            if (inputEl) {
                inputEl.value = totalRoomsNum;
            }
            
            // Show success message
            const successMsg = document.createElement('span');
            successMsg.className = 'text-success ms-2';
            successMsg.innerHTML = '<i class="far fa-check"></i> Saved';
            successMsg.style.fontSize = '12px';
            
            if (inputEl && inputEl.parentElement) {
                inputEl.parentElement.appendChild(successMsg);
                setTimeout(() => {
                    successMsg.remove();
                }, 2000);
            }
            
            // Reload rooms to update display
            await loadRooms();
        } catch (error) {
            console.error('Error updating total rooms:', error);
            alert('Error updating total rooms: ' + (error.message || 'Unknown error'));
        }
    }

    // Export functions to global scope
    window.showAddRoomModal = showAddRoomModal;
    window.editRoom = editRoom;
    window.saveRoom = saveRoom;
    window.deleteRoom = deleteRoom;
    window.manageRoomDetails = manageRoomDetails;
    window.showAddRoomImageForm = showAddRoomImageForm;
    window.saveRoomImage = saveRoomImage;
    window.deleteRoomImage = deleteRoomImage;
    window.showAddRoomAmenityForm = showAddRoomAmenityForm;
    window.saveRoomAmenity = saveRoomAmenity;
    window.removeRoomAmenity = removeRoomAmenity;
    window.updateTotalRooms = updateTotalRooms;
})();
