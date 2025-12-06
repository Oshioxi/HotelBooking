<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - Hotel Booking</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery.timepicker.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .wishlist-card {
            background: var(--color-white);
            border-radius: 40px 40px 40px 0;
            padding: 5px;
            margin-bottom: 30px;
            box-shadow: var(--box-shadow);
            transition: var(--transition);
            overflow: hidden;
            height: 100%;
        }
        .wishlist-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .wishlist-img {
            position: relative;
            border-radius: 35px 35px 35px 0;
            overflow: hidden;
            height: 250px;
        }
        .wishlist-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .wishlist-card:hover .wishlist-img img {
            transform: scale(1.1);
        }
        .wishlist-img .favorite-heart {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 40px;
            height: 40px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.3s;
            z-index: 10;
        }
        .wishlist-img .favorite-heart:hover {
            background: var(--theme-color);
            transform: scale(1.1);
        }
        .wishlist-img .favorite-heart i {
            color: #dc3545;
            font-size: 18px;
        }
        .wishlist-img .favorite-heart:hover i {
            color: var(--color-white);
        }
        .wishlist-content {
            padding: 20px 15px 15px 15px;
        }
        .wishlist-title {
            margin-bottom: 10px;
        }
        .wishlist-title a {
            color: var(--color-dark);
            font-size: 18px;
            font-weight: 600;
            text-decoration: none;
            transition: var(--transition);
        }
        .wishlist-title a:hover {
            color: var(--theme-color);
        }
        .wishlist-info {
            margin-bottom: 8px;
            color: var(--color-dark);
            font-size: 14px;
        }
        .wishlist-info i {
            color: var(--theme-color);
            margin-right: 5px;
            width: 16px;
        }
        .wishlist-price {
            font-size: 20px;
            font-weight: 700;
            color: var(--theme-color);
            margin: 15px 0;
        }
        .wishlist-badge {
            display: inline-block;
            background: #FFA903;
            color: var(--color-white);
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .empty-wishlist {
            text-align: center;
            padding: 80px 20px;
        }
        .empty-wishlist i {
            font-size: 100px;
            color: #ddd;
            margin-bottom: 30px;
            display: block;
        }
        .empty-wishlist h4 {
            color: var(--color-dark);
            margin-bottom: 15px;
        }
        .empty-wishlist p {
            color: #666;
            margin-bottom: 30px;
        }
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
        }
        .toast {
            min-width: 300px;
        }
        .filter-tabs {
            margin-bottom: 30px;
        }
        .filter-tabs .nav-link {
            color: var(--color-dark);
            border: none;
            padding: 10px 20px;
            margin-right: 10px;
            border-radius: 25px;
            transition: var(--transition);
        }
        .filter-tabs .nav-link.active {
            background: var(--theme-color);
            color: var(--color-white);
        }
        .filter-tabs .nav-link:hover {
            background: #f0f0f0;
        }
        .filter-tabs .nav-link.active:hover {
            background: var(--theme-color);
        }
    </style>
</head>
<body>
    <div class="preloader">
        <div class="loader">
            <span style="--i:1;"></span><span style="--i:2;"></span><span style="--i:3;"></span>
            <span style="--i:4;"></span><span style="--i:5;"></span><span style="--i:6;"></span>
            <span style="--i:7;"></span><span style="--i:8;"></span><span style="--i:9;"></span>
            <span style="--i:10;"></span><span style="--i:11;"></span><span style="--i:12;"></span>
            <span style="--i:13;"></span><span style="--i:14;"></span><span style="--i:15;"></span>
            <span style="--i:16;"></span><span style="--i:17;"></span><span style="--i:18;"></span>
            <span style="--i:19;"></span><span style="--i:20;"></span>
            <div class="loader-plane"></div>
        </div>
    </div>

    <jsp:include page="../components/header.jsp" />

    <main class="main">
        <div class="site-breadcrumb" style="background: url(${pageContext.request.contextPath}/assets/img/breadcrumb/01.jpg)">
            <div class="container">
                <h2 class="breadcrumb-title">My Wishlist</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Wishlist</li>
                </ul>
            </div>
        </div>

        <div class="py-120">
            <div class="container">
                <div class="row">
                    <div class="col-12">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h3>My Favorites</h3>
                            <span class="badge bg-primary" id="favoriteCount" style="font-size: 16px; padding: 10px 20px;">0 items</span>
                        </div>
                        
                        <ul class="nav nav-pills filter-tabs" id="filterTabs" role="tablist" style="display: none;">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="all-tab" data-bs-toggle="pill" data-bs-target="#all" type="button" role="tab">All</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="hotels-tab" data-bs-toggle="pill" data-bs-target="#hotels" type="button" role="tab">Hotels</button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="rooms-tab" data-bs-toggle="pill" data-bs-target="#rooms" type="button" role="tab">Rooms</button>
                            </li>
                        </ul>
                        
                        <div id="favoritesContainer">
                            <div class="text-center py-5">
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                                <p class="mt-3 text-muted">Loading your favorites...</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Toast Container -->
    <div class="toast-container"></div>

    <jsp:include page="../components/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/modernizr.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/imagesloaded.pkgd.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/isotope.pkgd.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.appear.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/counter-up.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/masonry.pkgd.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script>
        // Set context path to avoid EL expression conflicts
        const contextPath = '${pageContext.request.contextPath}';
        const defaultImageUrl = contextPath + '/assets/img/hotel/hotel-1.jpg';
        
        let allFavorites = [];
        let currentFilter = 'all';

        document.addEventListener('DOMContentLoaded', async function() {
            if (!HotelBookingAPI.TokenManager.getToken()) {
                showToast('Please login to view your wishlist', 'warning');
                setTimeout(() => {
                    window.location.href = '/login';
                }, 1500);
                return;
            }

            await loadFavorites();
            setupFilterTabs();
        });

        function setupFilterTabs() {
            const filterTabs = document.getElementById('filterTabs');
            if (!filterTabs) return;

            const tabs = filterTabs.querySelectorAll('.nav-link');
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    currentFilter = this.getAttribute('data-bs-target').replace('#', '');
                    renderFavorites();
                });
            });
        }

        function showToast(message, type = 'info') {
            const toastContainer = document.querySelector('.toast-container');
            const toastId = 'toast-' + Date.now();
            const bgColor = type === 'success' ? 'bg-success' : type === 'error' ? 'bg-danger' : type === 'warning' ? 'bg-warning' : 'bg-info';
            const title = type === 'success' ? 'Success' : type === 'error' ? 'Error' : type === 'warning' ? 'Warning' : 'Info';
            
            const toastHTML = '<div id="' + toastId + '" class="toast ' + bgColor + ' text-white" role="alert" aria-live="assertive" aria-atomic="true">' +
                '<div class="toast-header ' + bgColor + ' text-white">' +
                '<strong class="me-auto">' + title + '</strong>' +
                '<button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>' +
                '<div class="toast-body">' + message + '</div>' +
                '</div>';
            
            toastContainer.insertAdjacentHTML('beforeend', toastHTML);
            const toastElement = document.getElementById(toastId);
            const toast = new bootstrap.Toast(toastElement, { delay: 3000 });
            toast.show();
            
            toastElement.addEventListener('hidden.bs.toast', () => {
                toastElement.remove();
            });
        }

        async function loadFavorites() {
            try {
                allFavorites = await HotelBookingAPI.UserAPI.getMyFavorites();
                const count = await HotelBookingAPI.UserAPI.getFavoriteCount();
                
                const countText = count + ' item' + (count !== 1 ? 's' : '');
                document.getElementById('favoriteCount').textContent = countText;
                
                // Show filter tabs if there are favorites
                const filterTabs = document.getElementById('filterTabs');
                if (allFavorites.length > 0 && filterTabs) {
                    filterTabs.style.display = 'flex';
                }
                
                renderFavorites();
            } catch (error) {
                console.error('Error loading favorites:', error);
                document.getElementById('favoritesContainer').innerHTML = 
                    '<div class="alert alert-danger"><i class="far fa-exclamation-circle"></i> Error loading favorites. Please try again later.</div>';
                showToast('Error loading favorites: ' + error.message, 'error');
            }
        }

        function renderFavorites() {
            const container = document.getElementById('favoritesContainer');
            
            if (allFavorites.length === 0) {
                container.innerHTML = '<div class="empty-wishlist">' +
                    '<i class="far fa-heart"></i>' +
                    '<h4>Your wishlist is empty</h4>' +
                    '<p>Start adding hotels and rooms to your favorites!</p>' +
                    '<a href="' + window.location.origin + '/hotel-search-result" class="theme-btn mt-3">' +
                    '<i class="far fa-search me-2"></i>Browse Hotels</a>' +
                    '</div>';
                return;
            }

            // Filter favorites based on current filter
            let filteredFavorites = allFavorites;
            if (currentFilter === 'hotels') {
                filteredFavorites = allFavorites.filter(f => f.hotel);
            } else if (currentFilter === 'rooms') {
                filteredFavorites = allFavorites.filter(f => f.roomType);
            }

            if (filteredFavorites.length === 0) {
                const filterText = currentFilter === 'all' ? '' : currentFilter;
                container.innerHTML = '<div class="empty-wishlist">' +
                    '<i class="far fa-filter"></i>' +
                    '<h4>No ' + filterText + ' found</h4>' +
                    '<p>Try selecting a different filter.</p>' +
                    '</div>';
                return;
            }

            // Load favorites with images
            Promise.all(filteredFavorites.map(async (favorite) => {
                if (favorite.hotel) {
                    return await createHotelCard(favorite);
                } else if (favorite.roomType) {
                    return await createRoomTypeCard(favorite);
                }
                return '';
            })).then(cards => {
                container.innerHTML = '<div class="row">' + cards.join('') + '</div>';
            }).catch(error => {
                console.error('Error rendering favorites:', error);
                showToast('Error displaying favorites', 'error');
            });
        }

        async function createHotelCard(favorite) {
            const hotel = favorite.hotel;
            let imageUrl = defaultImageUrl;
            
            try {
                const images = await HotelBookingAPI.HotelImageAPI.getByHotel(hotel.id);
                if (images && images.length > 0 && images[0].imageUrl) {
                    imageUrl = images[0].imageUrl;
                }
            } catch (error) {
                console.error('Error loading hotel images:', error);
            }

            const hotelCity = hotel.city || '';
            const hotelUrl = window.location.origin + '/hotel-search-result?city=' + encodeURIComponent(hotelCity);
            const hotelName = hotel.name || 'Hotel';
            const hotelLocation = (hotel.city || '') + ', ' + (hotel.country || '');
            const ratingHtml = hotel.rating ? 
                '<div class="wishlist-info"><i class="far fa-star"></i><span>' + parseFloat(hotel.rating).toFixed(1) + '/5 Rating</span></div>' : '';
            
            return '<div class="col-md-6 col-lg-4 mb-4">' +
                '<div class="wishlist-card">' +
                '<div class="wishlist-img">' +
                '<img src="' + imageUrl + '" alt="' + hotelName + '" onerror="this.src=\'' + defaultImageUrl + '\'">' +
                '<div class="favorite-heart" onclick="removeFavoriteHotel(' + hotel.id + ')" title="Remove from wishlist">' +
                '<i class="fas fa-heart"></i></div></div>' +
                '<div class="wishlist-content">' +
                '<div class="wishlist-title"><a href="' + hotelUrl + '">' + hotelName + '</a></div>' +
                '<div class="wishlist-info"><i class="far fa-map-marker-alt"></i><span>' + hotelLocation + '</span></div>' +
                ratingHtml +
                '<a href="' + hotelUrl + '" class="theme-btn btn-sm mt-3">' +
                '<i class="far fa-eye me-2"></i>View Rooms</a></div></div></div>';
        }

        async function createRoomTypeCard(favorite) {
            const roomType = favorite.roomType;
            const hotel = roomType.hotel || {};
            let imageUrl = defaultImageUrl;
            
            try {
                const images = await HotelBookingAPI.RoomTypeImageAPI.getByRoomType(roomType.id);
                if (images && images.length > 0 && images[0].imageUrl) {
                    imageUrl = images[0].imageUrl;
                }
            } catch (error) {
                console.error('Error loading room type images:', error);
            }

            const priceInUSD = (parseFloat(roomType.pricePerNight) / 25000).toFixed(2);
            const roomUrl = window.location.origin + '/hotel-single?id=' + roomType.id;
            const roomName = roomType.name || 'Room Type';
            const hotelName = hotel.name || 'Hotel';
            const hotelLocation = (hotel.city || '') + ', ' + (hotel.country || '');
            const roomTypeBadge = roomType.roomType ? '<div class="wishlist-badge">' + roomType.roomType + '</div>' : '';
            const maxOccupancy = roomType.maxOccupancy || '-';
            
            return '<div class="col-md-6 col-lg-4 mb-4">' +
                '<div class="wishlist-card">' +
                '<div class="wishlist-img">' +
                '<img src="' + imageUrl + '" alt="' + roomName + '" onerror="this.src=\'' + defaultImageUrl + '\'">' +
                '<div class="favorite-heart" onclick="removeFavoriteRoomType(' + roomType.id + ')" title="Remove from wishlist">' +
                '<i class="fas fa-heart"></i></div></div>' +
                '<div class="wishlist-content">' +
                '<div class="wishlist-title"><a href="' + roomUrl + '">' + roomName + '</a></div>' +
                '<div class="wishlist-info"><i class="far fa-building"></i><span>' + hotelName + '</span></div>' +
                '<div class="wishlist-info"><i class="far fa-map-marker-alt"></i><span>' + hotelLocation + '</span></div>' +
                roomTypeBadge +
                '<div class="wishlist-price">$' + priceInUSD + '<small>/night</small></div>' +
                '<div class="wishlist-info"><i class="far fa-users"></i><span>Max ' + maxOccupancy + ' guests</span></div>' +
                '<a href="' + roomUrl + '" class="theme-btn btn-sm mt-3">' +
                '<i class="far fa-eye me-2"></i>View Details</a></div></div></div>';
        }

        async function removeFavoriteHotel(hotelId) {
            if (!confirm('Remove this hotel from your wishlist?')) return;
            
            try {
                await HotelBookingAPI.UserAPI.removeFavoriteHotel(hotelId);
                showToast('Hotel removed from wishlist', 'success');
                // Remove from local array
                allFavorites = allFavorites.filter(f => !f.hotel || f.hotel.id !== hotelId);
                await loadFavorites();
            } catch (error) {
                console.error('Error removing favorite:', error);
                showToast('Error removing favorite: ' + error.message, 'error');
            }
        }

        async function removeFavoriteRoomType(roomTypeId) {
            if (!confirm('Remove this room type from your wishlist?')) return;
            
            try {
                await HotelBookingAPI.UserAPI.removeFavoriteRoomType(roomTypeId);
                showToast('Room type removed from wishlist', 'success');
                // Remove from local array
                allFavorites = allFavorites.filter(f => !f.roomType || f.roomType.id !== roomTypeId);
                await loadFavorites();
            } catch (error) {
                console.error('Error removing favorite:', error);
                showToast('Error removing favorite: ' + error.message, 'error');
            }
        }
    </script>
</body>
</html>


