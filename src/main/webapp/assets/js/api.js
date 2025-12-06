// Hotel Booking API Client
const API_BASE_URL = 'http://localhost:8081/api';

// Token management
const TokenManager = {
    getToken: () => localStorage.getItem('authToken'),
    setToken: (token) => localStorage.setItem('authToken', token),
    removeToken: () => localStorage.removeItem('authToken'),
    getUserId: () => localStorage.getItem('userId'),
    setUserId: (id) => localStorage.setItem('userId', id),
    getUserRole: () => localStorage.getItem('userRole'),
    setUserRole: (role) => localStorage.setItem('userRole', role),
    getUserInfo: () => {
        return {
            id: localStorage.getItem('userId'),
            username: localStorage.getItem('username'),
            email: localStorage.getItem('email'),
            fullName: localStorage.getItem('fullName'),
            role: localStorage.getItem('userRole')
        };
    },
    setUserInfo: (user) => {
        if (user.id) localStorage.setItem('userId', user.id);
        if (user.username) localStorage.setItem('username', user.username);
        if (user.email) localStorage.setItem('email', user.email);
        if (user.fullName) localStorage.setItem('fullName', user.fullName);
        if (user.role) localStorage.setItem('userRole', user.role);
    },
    clear: () => {
        localStorage.removeItem('authToken');
        localStorage.removeItem('userId');
        localStorage.removeItem('username');
        localStorage.removeItem('email');
        localStorage.removeItem('fullName');
        localStorage.removeItem('userRole');
    }
};

// API Request helper
async function apiRequest(endpoint, options = {}) {
    const token = TokenManager.getToken();
    const headers = {
        'Content-Type': 'application/json',
        ...options.headers
    };
    
    if (token) {
        headers['Authorization'] = `Bearer ${token}`;
    }
    
    // Store endpoint for error handling
    const requestEndpoint = endpoint;
    
    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, {
            ...options,
            headers
        });
        
        // Try to parse JSON response
        let data = {};
        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
            try {
                data = await response.json();
            } catch (parseError) {
                console.error('Error parsing JSON response:', parseError);
                // If JSON parsing fails, try to get text
                const text = await response.text();
                if (text) {
                    data = { error: text };
                }
            }
        } else {
            // If not JSON, try to get text
            const text = await response.text();
            if (text) {
                data = { error: text };
            }
        }
        
        if (!response.ok) {
            // Try to get detailed error message - check multiple possible keys
            let errorMessage = data.message || data.error || data.errorMessage || `HTTP error! status: ${response.status}`;
            
            // If there are validation errors, format them nicely
            if (data.errors && typeof data.errors === 'object') {
                const errorList = Object.entries(data.errors)
                    .map(([field, msg]) => `${field}: ${msg}`)
                    .join(', ');
                if (errorList) {
                    errorMessage = errorList;
                }
            }
            
            // If error message is still generic, provide more context
            if (errorMessage.includes('HTTP error!')) {
                errorMessage = `Request failed with status ${response.status}. ${data.error || data.message || ''}`;
            }
            
            throw new Error(errorMessage);
        }
        
        return data;
    } catch (error) {
        // Don't log 404 errors for payment endpoints - they're expected for new bookings
        const shouldSilenceError = requestEndpoint.includes('/payments/booking/') && 
                                   requestEndpoint.includes('/latest') &&
                                   (error.message && (error.message.includes('No payment found') || 
                                                      error.message.includes('404')));
        
        if (!shouldSilenceError) {
            console.error('API Error:', error);
        }
        
        // If it's already an Error object, throw it as is
        if (error instanceof Error) {
            throw error;
        }
        // Otherwise, wrap it in an Error
        throw new Error(error.message || 'An unexpected error occurred');
    }
}

// Auth API
const AuthAPI = {
    login: async (username, password) => {
        const response = await apiRequest('/auth/login', {
            method: 'POST',
            body: JSON.stringify({ username, password })
        });
        TokenManager.setToken(response.token);
        TokenManager.setUserInfo(response);
        return response;
    },
    
    register: async (userData) => {
        const response = await apiRequest('/auth/register', {
            method: 'POST',
            body: JSON.stringify(userData)
        });
        TokenManager.setToken(response.token);
        TokenManager.setUserInfo(response);
        return response;
    },
    
    logout: () => {
        TokenManager.clear();
        window.location.href = '/login';
    },
    
    loginWithGoogle: async (idToken) => {
        const response = await apiRequest('/auth/google', {
            method: 'POST',
            body: JSON.stringify({ idToken })
        });
        TokenManager.setToken(response.token);
        TokenManager.setUserInfo(response);
        return response;
    },
    
    forgotPassword: async (email) => {
        return await apiRequest('/auth/forgot-password', {
            method: 'POST',
            body: JSON.stringify({ email })
        });
    },
    
    resetPassword: async (token, newPassword) => {
        return await apiRequest('/auth/reset-password', {
            method: 'POST',
            body: JSON.stringify({ token, newPassword })
        });
    }
};

// Hotel API
const HotelAPI = {
    getAll: async () => {
        return await apiRequest('/hotels');
    },
    
    getById: async (id) => {
        return await apiRequest(`/hotels/${id}`);
    },
    
    getHotelById: async (id) => {
        return await apiRequest(`/hotels/${id}`);
    },
    
    getByOwner: async (ownerId) => {
        return await apiRequest(`/hotels/owner/${ownerId}`);
    },
    
    create: async (hotelData) => {
        return await apiRequest('/hotels', {
            method: 'POST',
            body: JSON.stringify(hotelData)
        });
    },
    
    update: async (id, hotelData) => {
        return await apiRequest(`/hotels/${id}`, {
            method: 'PUT',
            body: JSON.stringify(hotelData)
        });
    },
    
    delete: async (id) => {
        return await apiRequest(`/hotels/${id}`, {
            method: 'DELETE'
        });
    },
    
    getPending: async () => {
        return await apiRequest('/hotels/pending');
    },
    
    approve: async (id) => {
        return await apiRequest(`/hotels/${id}/approve`, {
            method: 'PUT'
        });
    },
    
    reject: async (id, reason) => {
        return await apiRequest(`/hotels/${id}/reject`, {
            method: 'PUT',
            body: JSON.stringify({ reason })
        });
    },
    
    search: async (city) => {
        const params = city ? `?city=${encodeURIComponent(city)}` : '';
        return await apiRequest(`/hotels/search${params}`);
    },
    
    searchByCity: async (city) => {
        return await apiRequest(`/hotels/search?city=${encodeURIComponent(city)}`);
    },
    
    getAvailableCities: async () => {
        return await apiRequest('/hotels/cities');
    },
    
    searchAutocomplete: async (query) => {
        if (!query || query.trim().length < 2) {
            return [];
        }
        const params = `?q=${encodeURIComponent(query.trim())}`;
        return await apiRequest(`/hotels/search/autocomplete${params}`);
    }
};

    // Hotel Amenities API
    const HotelAmenityAPI = {
        getByHotel: async (hotelId) => {
            return await apiRequest(`/hotels/${hotelId}/amenities`);
        },

        add: async (hotelId, amenityId) => {
            return await apiRequest(`/hotels/${hotelId}/amenities`, {
                method: 'POST',
                body: JSON.stringify({ amenityId })
            });
        },

        remove: async (hotelId, id) => {
            return await apiRequest(`/hotels/${hotelId}/amenities/${id}`, {
                method: 'DELETE'
            });
        }
    };

    // Hotel Images API
    const HotelImageAPI = {
        getByHotel: async (hotelId) => {
            return await apiRequest(`/hotels/${hotelId}/images`);
        },

        add: async (hotelId, imageData) => {
            return await apiRequest(`/hotels/${hotelId}/images`, {
                method: 'POST',
                body: JSON.stringify(imageData)
            });
        },

        update: async (hotelId, id, imageData) => {
            return await apiRequest(`/hotels/${hotelId}/images/${id}`, {
                method: 'PUT',
                body: JSON.stringify(imageData)
            });
        },

        delete: async (hotelId, id) => {
            return await apiRequest(`/hotels/${hotelId}/images/${id}`, {
                method: 'DELETE'
            });
        }
    };

    // Amenity API
    const AmenityAPI = {
        getAll: async () => {
            return await apiRequest('/amenities');
        },

        getById: async (id) => {
            return await apiRequest(`/amenities/${id}`);
        },

        getByCategory: async (category) => {
            return await apiRequest(`/amenities/category/${encodeURIComponent(category)}`);
        }
    };

    // File Upload API
    const FileUploadAPI = {
        uploadHotelImage: async (file, hotelId) => {
            const formData = new FormData();
            formData.append('file', file);
            if (hotelId) {
                formData.append('hotelId', hotelId);
            }

            const token = TokenManager.getToken();
            const headers = {};
            if (token) {
                headers['Authorization'] = `Bearer ${token}`;
            }

            const response = await fetch(`${API_BASE_URL}/upload/hotel-image`, {
                method: 'POST',
                headers,
                body: formData
            });

            if (!response.ok) {
                const error = await response.json().catch(() => ({ message: 'Upload failed' }));
                throw new Error(error.message || 'Upload failed');
            }

            return await response.json();
        },

        deleteHotelImage: async (imageUrl) => {
            return await apiRequest(`/upload/hotel-image?imageUrl=${encodeURIComponent(imageUrl)}`, {
                method: 'DELETE'
            });
        }
    };

// RoomType API
const RoomTypeAPI = {
    getAll: async () => {
        return await apiRequest('/room-types');
    },
    
    getById: async (id) => {
        return await apiRequest(`/room-types/${id}`);
    },
    
    getByHotel: async (hotelId) => {
        return await apiRequest(`/room-types/hotel/${hotelId}`);
    },
    
    getPending: async () => {
        return await apiRequest('/room-types/pending');
    },
    
    create: async (roomTypeData) => {
        return await apiRequest('/room-types', {
            method: 'POST',
            body: JSON.stringify(roomTypeData)
        });
    },
    
    update: async (id, roomTypeData) => {
        return await apiRequest(`/room-types/${id}`, {
            method: 'PUT',
            body: JSON.stringify(roomTypeData)
        });
    },
    
    approve: async (id) => {
        return await apiRequest(`/room-types/${id}/approve`, {
            method: 'PUT'
        });
    },
    
    reject: async (id, reason) => {
        return await apiRequest(`/room-types/${id}/reject`, {
            method: 'PUT',
            body: JSON.stringify({ reason })
        });
    },
    
    delete: async (id) => {
        return await apiRequest(`/room-types/${id}`, {
            method: 'DELETE'
        });
    },
    
    search: async (city, minPrice, maxPrice, guests, amenities) => {
        const params = new URLSearchParams();
        if (city) params.append('city', city);
        if (minPrice) params.append('minPrice', minPrice);
        if (maxPrice) params.append('maxPrice', maxPrice);
        if (guests) params.append('guests', guests);
        if (amenities && Array.isArray(amenities)) {
            amenities.forEach(amenity => params.append('amenities', amenity));
        }
        return await apiRequest(`/room-types/search?${params.toString()}`);
    },
    
    searchWithDates: async (city, minPrice, maxPrice, guests, checkInDate, checkOutDate, amenities) => {
        const params = new URLSearchParams();
        if (city) params.append('city', city);
        if (minPrice) params.append('minPrice', minPrice);
        if (maxPrice) params.append('maxPrice', maxPrice);
        if (guests) params.append('guests', guests);
        if (checkInDate) params.append('checkInDate', checkInDate);
        if (checkOutDate) params.append('checkOutDate', checkOutDate);
        if (amenities && Array.isArray(amenities)) {
            amenities.forEach(amenity => params.append('amenities', amenity));
        }
        return await apiRequest(`/room-types/search?${params.toString()}`);
    }
};

// RoomType Amenities API
const RoomTypeAmenityAPI = {
    getByRoomType: async (roomTypeId) => {
        const response = await apiRequest(`/room-types/${roomTypeId}/amenities`);
        return Array.isArray(response) ? response : [];
    },

    add: async (roomTypeId, amenityId) => {
        const response = await apiRequest(`/room-types/${roomTypeId}/amenities`, {
            method: 'POST',
            body: JSON.stringify({ amenityId })
        });
        // Handle response format: {success: true, data: {...}}
        return response.data || response;
    },

    remove: async (roomTypeId, id) => {
        const response = await apiRequest(`/room-types/${roomTypeId}/amenities/${id}`, {
            method: 'DELETE'
        });
        return response;
    }
};

// RoomType Images API
const RoomTypeImageAPI = {
    getByRoomType: async (roomTypeId) => {
        const response = await apiRequest(`/room-types/${roomTypeId}/images`);
        return Array.isArray(response) ? response : [];
    },

    add: async (roomTypeId, imageData) => {
        const response = await apiRequest(`/room-types/${roomTypeId}/images`, {
            method: 'POST',
            body: JSON.stringify(imageData)
        });
        // Handle response format: {success: true, data: {...}}
        return response.data || response;
    },

    update: async (roomTypeId, id, imageData) => {
        const response = await apiRequest(`/room-types/${roomTypeId}/images/${id}`, {
            method: 'PUT',
            body: JSON.stringify(imageData)
        });
        // Handle response format: {success: true, data: {...}}
        return response.data || response;
    },

    delete: async (roomTypeId, id) => {
        const response = await apiRequest(`/room-types/${roomTypeId}/images/${id}`, {
            method: 'DELETE'
        });
        return response;
    }
};

// User API
const UserAPI = {
    getCurrentUser: async () => {
        return await apiRequest('/user/me');
    },
    
    updateProfile: async (profileData) => {
        return await apiRequest('/user/profile', {
            method: 'PUT',
            body: JSON.stringify(profileData)
        });
    },
    
    changePassword: async (passwordData) => {
        return await apiRequest('/user/change-password', {
            method: 'PUT',
            body: JSON.stringify(passwordData)
        });
    },
    
    getMyBookings: async () => {
        return await apiRequest('/user/bookings');
    },
    
    getMyBooking: async (id) => {
        return await apiRequest(`/user/bookings/${id}`);
    },
    
    cancelMyBooking: async (id) => {
        return await apiRequest(`/user/bookings/${id}/cancel`, {
            method: 'PUT'
        });
    },
    
    // Favorites API
    getMyFavorites: async () => {
        return await apiRequest('/user/favorites');
    },
    
    addFavorite: async (hotelId, roomTypeId) => {
        return await apiRequest('/user/favorites', {
            method: 'POST',
            body: JSON.stringify({ hotelId, roomTypeId })
        });
    },
    
    removeFavoriteHotel: async (hotelId) => {
        return await apiRequest(`/user/favorites/hotel/${hotelId}`, {
            method: 'DELETE'
        });
    },
    
    removeFavoriteRoomType: async (roomTypeId) => {
        return await apiRequest(`/user/favorites/room-type/${roomTypeId}`, {
            method: 'DELETE'
        });
    },
    
    checkHotelFavorite: async (hotelId) => {
        try {
            const response = await apiRequest(`/user/favorites/check/hotel/${hotelId}`);
            return response.isFavorite;
        } catch (error) {
            // If 403 Forbidden, user is not logged in - return false instead of throwing
            if (error.message && (error.message.includes('Forbidden') || error.message.includes('403'))) {
                return false;
            }
            throw error;
        }
    },
    
    checkRoomTypeFavorite: async (roomTypeId) => {
        try {
            const response = await apiRequest(`/user/favorites/check/room-type/${roomTypeId}`);
            return response.isFavorite;
        } catch (error) {
            // If 403 Forbidden, user is not logged in - return false instead of throwing
            if (error.message && (error.message.includes('Forbidden') || error.message.includes('403'))) {
                return false;
            }
            throw error;
        }
    },
    
    getFavoriteCount: async () => {
        const response = await apiRequest('/user/favorites/count');
        return response.count;
    }
};

// Booking API
const BookingAPI = {
    getAll: async () => {
        return await apiRequest('/bookings');
    },
    
    getById: async (id) => {
        return await apiRequest(`/bookings/${id}`);
    },
    
    getByUser: async (userId) => {
        return await apiRequest(`/bookings/user/${userId}`);
    },
    
    getByRoomType: async (roomTypeId) => {
        return await apiRequest(`/bookings/room-type/${roomTypeId}`);
    },
    
    getByHotel: async (hotelId) => {
        return await apiRequest(`/bookings/hotel/${hotelId}`);
    },
    
    create: async (userId, bookingData) => {
        return await apiRequest(`/bookings?userId=${userId}`, {
            method: 'POST',
            body: JSON.stringify(bookingData)
        });
    },
    
    cancel: async (id, userId) => {
        return await apiRequest(`/bookings/${id}/cancel?userId=${userId}`, {
            method: 'PUT'
        });
    },
    
    cancelByAdmin: async (id) => {
        return await apiRequest(`/bookings/${id}/cancel-by-admin`, {
            method: 'PUT'
        });
    },
    
    confirm: async (id) => {
        return await apiRequest(`/bookings/${id}/confirm`, {
            method: 'PUT'
        });
    },
    
    update: async (id, bookingData) => {
        return await apiRequest(`/bookings/${id}`, {
            method: 'PUT',
            body: JSON.stringify(bookingData)
        });
    }
};

const PaymentAPI = {
    getAll: async () => {
        return await apiRequest('/payments');
    },
    
    getById: async (id) => {
        return await apiRequest(`/payments/${id}`);
    },
    
    getByBooking: async (bookingId) => {
        return await apiRequest(`/payments/booking/${bookingId}`);
    },
    
    getLatestByBooking: async (bookingId) => {
        try {
            return await apiRequest(`/payments/booking/${bookingId}/latest`);
        } catch (error) {
            // If 404 or "No payment found", return null instead of throwing
            // This is a normal case for new bookings that don't have payment yet
            const errorMsg = error.message || '';
            if (errorMsg.includes('No payment found') || 
                errorMsg.includes('404') || 
                errorMsg.includes('Not Found') ||
                errorMsg.includes('ResourceNotFoundException')) {
                // Silently return null - this is expected for new bookings
                return null;
            }
            // For other errors, re-throw
            throw error;
        }
    },
    
    create: async (bookingId, paymentMethod) => {
        return await apiRequest(`/payments/create?bookingId=${bookingId}&paymentMethod=${paymentMethod}`, {
            method: 'POST'
        });
    },
    
    process: async (paymentRequest) => {
        return await apiRequest('/payments/process', {
            method: 'POST',
            body: JSON.stringify(paymentRequest)
        });
    },
    
    confirm: async (id) => {
        return await apiRequest(`/payments/${id}/confirm`, {
            method: 'PUT'
        });
    },
    
    fail: async (id, reason) => {
        const url = reason ? `/payments/${id}/fail?reason=${encodeURIComponent(reason)}` : `/payments/${id}/fail`;
        return await apiRequest(url, {
            method: 'PUT'
        });
    },
    
    refund: async (id, reason) => {
        const url = reason ? `/payments/${id}/refund?reason=${encodeURIComponent(reason)}` : `/payments/${id}/refund`;
        return await apiRequest(url, {
            method: 'PUT'
        });
    },
    
    cancel: async (id) => {
        return await apiRequest(`/payments/${id}/cancel`, {
            method: 'PUT'
        });
    }
};

// Statistics API
const StatisticsAPI = {
    getAdminStats: async () => {
        return await apiRequest('/admin/statistics');
    },
    
    getOwnerStats: async (ownerId, startDate, endDate) => {
        const params = new URLSearchParams({ ownerId });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        return await apiRequest(`/owner/statistics?${params.toString()}`);
    }
};

// Owner API
const OwnerAPI = {
    getStatistics: async (ownerId, startDate, endDate) => {
        const params = new URLSearchParams({ ownerId });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        return await apiRequest(`/owner/statistics?${params.toString()}`);
    },
    
    getRoomTypeStatus: async (roomTypeId, date) => {
        return await apiRequest(`/owner/room-types/${roomTypeId}/status?date=${date}`);
    },
    
    getCalendar: async (ownerId, startDate, endDate) => {
        const params = new URLSearchParams({ ownerId });
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        return await apiRequest(`/owner/calendar?${params.toString()}`);
    },
    
    getBookings: async (ownerId, hotelId, roomTypeId, startDate, endDate) => {
        const params = new URLSearchParams({ ownerId });
        if (hotelId) params.append('hotelId', hotelId);
        if (roomTypeId) params.append('roomTypeId', roomTypeId);
        if (startDate) params.append('startDate', startDate);
        if (endDate) params.append('endDate', endDate);
        return await apiRequest(`/owner/bookings?${params.toString()}`);
    },
    
    confirmBooking: async (bookingId) => {
        return await apiRequest(`/owner/bookings/${bookingId}/confirm`, {
            method: 'PUT'
        });
    },
    
    cancelBooking: async (bookingId, reason) => {
        return await apiRequest(`/owner/bookings/${bookingId}/cancel?reason=${encodeURIComponent(reason || '')}`, {
            method: 'PUT'
        });
    }
};

// Admin API
const AdminAPI = {
    // User Management
    getAllUsers: async () => {
        return await apiRequest('/admin/users');
    },
    
    getUserById: async (id) => {
        return await apiRequest(`/admin/users/${id}`);
    },
    
    createUser: async (userData) => {
        return await apiRequest('/admin/users', {
            method: 'POST',
            body: JSON.stringify(userData)
        });
    },
    
    updateUser: async (id, userData) => {
        return await apiRequest(`/admin/users/${id}`, {
            method: 'PUT',
            body: JSON.stringify(userData)
        });
    },
    
    deleteUser: async (id) => {
        return await apiRequest(`/admin/users/${id}`, {
            method: 'DELETE'
        });
    },
    
    toggleUserStatus: async (id) => {
        return await apiRequest(`/admin/users/${id}/toggle-status`, {
            method: 'PUT'
        });
    },
    
    // RoomType Management
    getAllRoomTypes: async () => {
        return await apiRequest('/room-types');
    },
    
    getPendingRoomTypes: async () => {
        return await apiRequest('/room-types/pending');
    },
    
    approveRoomType: async (id) => {
        return await apiRequest(`/room-types/${id}/approve`, {
            method: 'PUT'
        });
    },
    
    rejectRoomType: async (id, reason) => {
        return await apiRequest(`/room-types/${id}/reject`, {
            method: 'PUT',
            body: JSON.stringify({ reason })
        });
    },
    
    deleteRoomType: async (id) => {
        return await apiRequest(`/room-types/${id}`, {
            method: 'DELETE'
        });
    },
    
    // Hotel Management
    getAllHotels: async () => {
        return await apiRequest('/hotels');
    },
    
    getAllHotelsWithOwner: async () => {
        return await apiRequest('/hotels/with-owner');
    },
    
    getHotelById: async (id) => {
        return await apiRequest(`/hotels/${id}`);
    },
    
    searchByCity: async (city) => {
        return await apiRequest(`/hotels/search?city=${encodeURIComponent(city)}`);
    },
    
    getAvailableCities: async () => {
        return await apiRequest('/hotels/cities');
    },
    
    getPendingHotels: async () => {
        return await apiRequest('/hotels/pending');
    },
    
    approveHotel: async (id) => {
        return await apiRequest(`/hotels/${id}/approve`, {
            method: 'PUT'
        });
    },
    
    rejectHotel: async (id, reason) => {
        return await apiRequest(`/hotels/${id}/reject`, {
            method: 'PUT',
            body: JSON.stringify({ reason })
        });
    },
    
    deleteHotel: async (id) => {
        return await apiRequest(`/hotels/${id}`, {
            method: 'DELETE'
        });
    },
    
    // Booking Management
    getAllBookings: async () => {
        return await apiRequest('/bookings');
    },
    
    getBookingById: async (id) => {
        return await apiRequest(`/bookings/${id}`);
    },
    
    confirmBooking: async (id) => {
        return await apiRequest(`/bookings/${id}/confirm`, {
            method: 'PUT'
        });
    }
};

// Utility functions
const Utils = {
    formatDate: (dateString) => {
        const date = new Date(dateString);
        return date.toLocaleDateString('vi-VN');
    },
    
    formatCurrency: (amount) => {
        // Convert VND to USD (approximate rate: 1 USD = 25,000 VND)
        const amountInUSD = amount / 25000;
        
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        }).format(amountInUSD);
    },
    
    showAlert: (message, type = 'info') => {
        // Simple alert - can be replaced with better UI
        alert(message);
    },
    
    redirect: (url) => {
        window.location.href = url;
    },
    
    checkAuth: () => {
        const token = TokenManager.getToken();
        if (!token) {
            Utils.redirect('/login');
            return false;
        }
        return true;
    },
    
    checkRole: (allowedRoles) => {
        const userRole = TokenManager.getUserRole();
        if (!userRole || !allowedRoles.includes(userRole)) {
            Utils.redirect('/login');
            return false;
        }
        return true;
    }
};

// Update user menu based on login status
function updateUserMenu() {
    const token = TokenManager.getToken();
    const accountSection = document.getElementById('accountSection');
    const userMenu = document.getElementById('userMenu');
    const loginLink = document.getElementById('loginLink');
    const registerLink = document.getElementById('registerLink');
    const userName = document.getElementById('userName');
    const userMenuLink = document.getElementById('userMenuLink');

    if (token) {
        // User is logged in
        const userInfo = TokenManager.getUserInfo();
        const fullName = userInfo.fullName || userInfo.username || 'User';
        
        // Hide login/register links completely
        if (loginLink) {
            loginLink.style.display = 'none';
            loginLink.style.visibility = 'hidden';
        }
        if (registerLink) {
            registerLink.style.display = 'none';
            registerLink.style.visibility = 'hidden';
        }
        
        // Show user menu
        if (userMenu) {
            userMenu.style.display = 'block';
            userMenu.style.visibility = 'visible';
        }
        if (userName) userName.textContent = fullName;
        
        // Setup logout
        const logoutLink = document.getElementById('logoutLink');
        if (logoutLink) {
            // Remove previous onclick handler to avoid duplicates
            logoutLink.onclick = null;
            logoutLink.onclick = function(e) {
                e.preventDefault();
                if (confirm('Bạn có chắc chắn muốn đăng xuất?')) {
                    TokenManager.clear();
                    // Reload to update menu and redirect to home
                    window.location.href = '/index';
                }
            };
        }
    } else {
        // User is not logged in
        if (loginLink) {
            loginLink.style.display = '';
            loginLink.style.visibility = 'visible';
        }
        if (registerLink) {
            registerLink.style.display = '';
            registerLink.style.visibility = 'visible';
        }
        if (userMenu) {
            userMenu.style.display = 'none';
            userMenu.style.visibility = 'hidden';
        }
    }
}

// Initialize user menu when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', updateUserMenu);
} else {
    updateUserMenu();
}

// Export for use in HTML
window.HotelBookingAPI = {
    AuthAPI,
    UserAPI,
    HotelAPI,
    RoomTypeAPI,
    BookingAPI,
    PaymentAPI,
    StatisticsAPI,
    AdminAPI,
    OwnerAPI,
    HotelAmenityAPI,
    HotelImageAPI,
    RoomTypeAmenityAPI,
    RoomTypeImageAPI,
    AmenityAPI,
    FileUploadAPI,
    TokenManager,
    Utils,
    updateUserMenu
};


