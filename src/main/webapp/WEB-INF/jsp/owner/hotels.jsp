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
    <title>Owner - My Hotels</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
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
                <h2 class="breadcrumb-title">My Hotels</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
                    <li class="active">Hotels</li>
                </ul>
            </div>
        </div>

        <div class="user-profile py-120">
            <div class="container">
                <div class="row">
                    <div class="col-lg-3">
                        <jsp:include page="../components/sidebar.jsp" />
                    </div>
                    <div class="col-lg-9">
                        <div class="user-profile-card">
                            <div class="d-flex justify-content-between align-items-center mb-4">
                                <h4 class="user-profile-card-title">My Hotels</h4>
                                <button class="theme-btn" onclick="showAddHotelModal()">
                                    <i class="far fa-plus"></i> Add Hotel
                                </button>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover" id="hotelsTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Hotel Name</th>
                                            <th>City</th>
                                            <th>Country</th>
                                            <th>Rating</th>
                                            <th>Status</th>
                                            <th>Images</th>
                                            <th>Amenities</th>
                                            <th>Created</th>
                                            <th style="white-space: nowrap;">Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="10" class="text-center">Loading...</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Add/Edit Hotel Modal -->
                        <div class="modal fade" id="hotelModal" tabindex="-1">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title" id="hotelModalTitle">Add Hotel</h5>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <form id="hotelForm">
                                            <input type="hidden" id="hotelId" name="id">
                                            <input type="hidden" id="ownerId" name="ownerId">
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Hotel Name <span class="text-danger">*</span></label>
                                                        <input type="text" id="name" class="form-control" required placeholder="Enter hotel name">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>City <span class="text-danger">*</span></label>
                                                        <input type="text" id="city" class="form-control" required placeholder="Enter city">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Country <span class="text-danger">*</span></label>
                                                        <input type="text" id="country" class="form-control" required placeholder="Enter country">
                                                    </div>
                                                </div>
                                                <div class="col-md-6">
                                                    <div class="form-group mb-3">
                                                        <label>Rating</label>
                                                        <input type="number" id="rating" class="form-control" min="0" max="5" step="0.1" placeholder="0.0 - 5.0">
                                                        <small class="form-text text-muted">Rating from 0.0 to 5.0</small>
                                                    </div>
                                                </div>
                                                <div class="col-12">
                                                    <div class="form-group mb-3">
                                                        <label>Address <span class="text-danger">*</span></label>
                                                        <textarea id="address" class="form-control" required rows="3" placeholder="Enter full address"></textarea>
                                                    </div>
                                                </div>
                                                <div class="col-12">
                                                    <div class="form-group mb-3">
                                                        <label>Description</label>
                                                        <textarea id="description" class="form-control" rows="5" placeholder="Enter hotel description"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                        <button type="button" class="theme-btn" onclick="saveHotel()">Save Hotel</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Hotel Details Modal (Images & Amenities) -->
    <div class="modal fade" id="hotelDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="hotelDetailsModalTitle">Manage Hotel Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <ul class="nav nav-tabs" id="hotelDetailsTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="images-tab" data-bs-toggle="tab" data-bs-target="#images" type="button" role="tab">
                                <i class="far fa-image"></i> Images
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="amenities-tab" data-bs-toggle="tab" data-bs-target="#amenities" type="button" role="tab">
                                <i class="far fa-list"></i> Amenities
                            </button>
                        </li>
                    </ul>
                    <div class="tab-content" id="hotelDetailsTabContent">
                        <!-- Images Tab -->
                        <div class="tab-pane fade show active" id="images" role="tabpanel">
                            <div class="mt-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6>Hotel Images</h6>
                                    <button class="btn btn-sm btn-primary" onclick="showAddImageForm()">
                                        <i class="far fa-plus"></i> Add Image
                                    </button>
                                </div>
                                <div id="imagesList" class="row">
                                    <!-- Images will be loaded here -->
                                </div>
                            </div>
                        </div>
                        <!-- Amenities Tab -->
                        <div class="tab-pane fade" id="amenities" role="tabpanel">
                            <div class="mt-3">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h6>Hotel Amenities</h6>
                                    <button class="btn btn-sm btn-primary" onclick="showAddAmenityForm()">
                                        <i class="far fa-plus"></i> Add Amenity
                                    </button>
                                </div>
                                <div id="amenitiesList" class="row">
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

    <!-- Add Image Modal -->
    <div class="modal fade" id="addImageModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Hotel Image</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addImageForm">
                        <div class="mb-3">
                            <label class="form-label">Upload Image</label>
                            <input type="file" class="form-control" id="imageFile" accept="image/*" required>
                            <small class="form-text text-muted">Image will be saved to local storage</small>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Alt Text</label>
                            <input type="text" class="form-control" id="imageAltText" placeholder="Image description">
                        </div>
                        <div class="mb-3">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="imageIsPrimary">
                                <label class="form-check-label" for="imageIsPrimary">
                                    Set as Primary Image
                                </label>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Display Order</label>
                            <input type="number" class="form-control" id="imageDisplayOrder" value="0" min="0">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveImage()">Save Image</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Amenity Modal -->
    <div class="modal fade" id="addAmenityModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add Hotel Amenity</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="addAmenityForm">
                        <div class="mb-3">
                            <label class="form-label">Select Amenity</label>
                            <select class="form-control" id="amenitySelect" required>
                                <option value="">Loading amenities...</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="saveAmenity()">Add Amenity</button>
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
            
            try {
                if ($(".price-range").length > 0) {
                    $(".price-range").slider({
                        step: 500,
                        range: true,
                        min: 0,
                        max: 10000,
                        values: [1500, 5000],
                        slide: function (event, ui) { 
                            $(".priceRange").val("$" + ui.values[0].toLocaleString() + " - $" + ui.values[1].toLocaleString()); 
                        }
                    });
                    $(".priceRange").val("$" + $(".price-range").slider("values", 0).toLocaleString() + " - $" + $(".price-range").slider("values", 1).toLocaleString());
                }
            } catch(e) {
                console.log('slider not available or no elements found');
            }
        });
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script>
        // Set context path for JavaScript
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/assets/js/owner-hotels.js"></script>
</body>
</html>
