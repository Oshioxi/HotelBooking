<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" buffer="64kb" autoFlush="true" %>
<%@ page errorPage="/error.jsp" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Owner - My Rooms</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
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
                <h2 class="breadcrumb-title">My Rooms</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="active">Rooms</li>
                </ul>
            </div>
        </div>

        <div class="user-profile py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3">
                        <div class="user-profile-sidebar">
                            <div class="user-profile-sidebar-top">
                                <div class="user-profile-img">
                                    <img src="${pageContext.request.contextPath}/assets/img/account/user.jpg" alt="">
                                    <button type="button" class="profile-img-btn"><i class="far fa-camera"></i></button>
                                    <input type="file" class="profile-img-file">
                                </div>
                                <h4 id="userFullName">Loading...</h4>
                                <p id="userEmail">Loading...</p>
                            </div>
                            <ul class="user-profile-sidebar-list" id="sidebarMenu">
                                <!-- Menu will be populated by JavaScript based on user role -->
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-9">
                        <div class="user-profile-card">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="user-profile-card-title">My Rooms</h4>
                                <button class="theme-btn" onclick="showAddRoomModal()">
                                    <i class="far fa-plus"></i> Add Room
                                </button>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover" id="roomsTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Room Name</th>
                                            <th>Hotel</th>
                                            <th>Type</th>
                                            <th>Price/Night</th>
                                            <th>Status</th>
                                            <th>Images</th>
                                            <th>Amenities</th>
                                            <th style="white-space: nowrap;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="9" class="text-center">Loading...</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Add/Edit Room Modal -->
                        <div class="modal fade" id="roomModal" tabindex="-1">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="roomModalTitle">Add Room</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="roomForm">
                                            <input type="hidden" id="roomTypeId" name="id">
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Hotel <span class="text-danger">*</span></label>
                                                        <select class="form-control" id="hotelId" name="hotelId" required>
                                                            <option value="">Select Hotel</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Room Name <span class="text-danger">*</span></label>
                                                        <input type="text" class="form-control" id="name" name="name" required placeholder="Enter room name">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Room Type <span class="text-danger">*</span></label>
                                                        <select class="form-control" id="roomType" name="roomType" required>
                                                            <option value="">Select Room Type</option>
                                                            <option value="Single">Single</option>
                                                            <option value="Double">Double</option>
                                                            <option value="Twin">Twin</option>
                                                            <option value="Deluxe">Deluxe</option>
                                                            <option value="Suite">Suite</option>
                                                            <option value="Family">Family</option>
                                                        </select>
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Price Per Night (VND) <span class="text-danger">*</span></label>
                                                        <input type="number" class="form-control" id="pricePerNight" name="pricePerNight" required min="0" step="1000" placeholder="Enter price">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Total Rooms <span class="text-danger">*</span></label>
                                                        <input type="number" class="form-control" id="totalRooms" name="totalRooms" required min="1" value="1">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Max Occupancy <span class="text-danger">*</span></label>
                                                        <input type="number" class="form-control" id="maxOccupancy" name="maxOccupancy" required min="1" value="2">
                                                    </div>
                                                </div>
                                                <div class="col-12">
                                                    <div class="form-group mb-3">
                                                        <label>Description</label>
                                                        <textarea class="form-control" id="description" name="description" rows="4" placeholder="Enter room description"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <button type="button" class="theme-btn" onclick="saveRoom()">Save Room</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Room Details Modal (Images & Amenities) -->
    <div class="modal fade" id="roomDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="roomDetailsModalTitle">Manage Room Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <ul class="nav nav-tabs" id="roomDetailsTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="room-images-tab" data-bs-toggle="tab" data-bs-target="#room-images" type="button" role="tab">
                                <i class="far fa-image"></i> Images
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="room-amenities-tab" data-bs-toggle="tab" data-bs-target="#room-amenities" type="button" role="tab">
                                <i class="far fa-list"></i> Amenities
                            </button>
                        </li>
                    </ul>
                    <div class="tab-content" id="roomDetailsTabContent">
                        <!-- Images Tab -->
                        <div class="tab-pane fade show active" id="room-images" role="tabpanel">
                            <div class="mt-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6>Room Images</h6>
                                    <button class="btn btn-sm btn-primary" onclick="showAddRoomImageForm()">
                                        <i class="far fa-plus"></i> Add Image
                                    </button>
                                </div>
                                <div id="roomImagesList" class="row">
                                    <!-- Images will be loaded here -->
                                </div>
                            </div>
                        </div>
                        <!-- Amenities Tab -->
                        <div class="tab-pane fade" id="room-amenities" role="tabpanel">
                            <div class="mt-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6>Room Amenities</h6>
                                    <button class="btn btn-sm btn-primary" onclick="showAddRoomAmenityForm()">
                                        <i class="far fa-plus"></i> Add Amenity
                                    </button>
                                </div>
                                <div id="roomAmenitiesList" class="row">
                                    <!-- Amenities will be loaded here -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Room Image Modal -->
    <div class="modal fade" id="addRoomImageModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Room Image</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addRoomImageForm">
                        <div class="mb-3">
                            <label class="form-label">Upload Image</label>
                            <input type="file" class="form-control" id="roomImageFile" accept="image/*" required>
                            <small class="form-text text-muted">Image will be saved to local storage</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Alt Text</label>
                            <input type="text" class="form-control" id="roomImageAltText" placeholder="Image description">
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="roomImageIsPrimary">
                                <label class="form-check-label" for="roomImageIsPrimary">
                                    Set as Primary Image
                                </label>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Display Order</label>
                            <input type="number" class="form-control" id="roomImageDisplayOrder" value="0" min="0">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveRoomImage()">Save Image</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Room Amenity Modal -->
    <div class="modal fade" id="addRoomAmenityModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Room Amenity</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addRoomAmenityForm">
                        <div class="mb-3">
                            <label class="form-label">Select Amenity</label>
                            <select class="form-control" id="roomAmenitySelect" required>
                                <option value="">Loading amenities...</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveRoomAmenity()">Add Amenity</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../components/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/modernizr.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.appear.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/counter-up.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.nice-select.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery-ui.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/wow.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/api.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
    <script>
        // Prevent jQuery plugin errors if elements don't exist
        $(document).ready(function() {
            try {
                if ($('.select').length > 0) {
                    $('.select').niceSelect();
                }
            } catch(e) {
                console.log('niceSelect not available or no elements found');
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script>
        // Set context path for JavaScript
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/owner-rooms.js"></script>
</body>
</html>

