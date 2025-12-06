<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Room Management</title>
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
                <h2 class="breadcrumb-title">Room Management</h2>
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
                                <h4 class="user-profile-card-title">All Rooms</h4>
                                <div>
                                    <select id="statusFilter" class="form-control d-inline-block" style="width: auto;" onchange="filterRooms()">
                                        <option value="">All Status</option>
                                        <option value="PENDING">Pending</option>
                                        <option value="APPROVED">Approved</option>
                                        <option value="REJECTED">Rejected</option>
                                    </select>
                                </div>
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
                                            <th>Created</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="8" class="text-center">Loading...</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

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
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
    <script>
        let allRooms = [];
        
        document.addEventListener('DOMContentLoaded', async function() {
            if (!HotelBookingAPI.TokenManager.getToken()) {
                window.location.href = '/login';
                return;
            }
            
            const userRole = HotelBookingAPI.TokenManager.getUserRole();
            if (userRole !== 'ADMIN') {
                window.location.href = '/dashboard';
                return;
            }
            
            // Load sidebar menu and user info
            const userInfo = HotelBookingAPI.TokenManager.getUserInfo();
            const userFullNameEl = document.getElementById('userFullName');
            const userEmailEl = document.getElementById('userEmail');
            if (userFullNameEl) userFullNameEl.textContent = userInfo.fullName || userInfo.username || 'User';
            if (userEmailEl) userEmailEl.textContent = userInfo.email || '';
            loadSidebarMenu(userRole, '/admin/rooms');
            
            await loadRooms();
        });

        async function loadRooms() {
            try {
                allRooms = await HotelBookingAPI.AdminAPI.getAllRoomTypes();
                filterRooms();
            } catch (error) {
                console.error('Error loading room types:', error);
                alert('Error loading room types: ' + error.message);
            }
        }

        function filterRooms() {
            const status = document.getElementById('statusFilter').value;
            const filtered = status ? allRooms.filter(r => r.status === status) : allRooms;
            displayRooms(filtered);
        }

        function displayRooms(rooms) {
            const tbody = document.querySelector('#roomsTable tbody');
            if (rooms.length === 0) {
                tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">No rooms found</td></tr>';
                return;
            }

            let html = '';
            rooms.forEach(room => {
                const statusClass = {
                    'PENDING': 'badge-warning',
                    'APPROVED': 'badge-success',
                    'REJECTED': 'badge-danger'
                }[room.status] || 'badge-secondary';
                
                const createdDate = room.createdAt ? new Date(room.createdAt).toLocaleDateString() : 'N/A';
                
                html += '<tr>' +
                    '<td>' + room.id + '</td>' +
                    '<td><strong>' + (room.name || 'N/A') + '</strong></td>' +
                    '<td>' + (room.hotel?.name || 'N/A') + '</td>' +
                    '<td>' + (room.roomType || 'N/A') + '</td>' +
                    '<td>' + HotelBookingAPI.Utils.formatCurrency(room.pricePerNight || 0) + '</td>' +
                    '<td><span class="badge ' + statusClass + '">' + (room.status || 'N/A') + '</span></td>' +
                    '<td>' + createdDate + '</td>' +
                    '<td>' +
                        (room.status === 'PENDING' ? 
                            '<button class="btn btn-sm btn-success me-1" onclick="approveRoomType(' + room.id + ')">' +
                                '<i class="far fa-check"></i> Approve' +
                            '</button>' +
                            '<button class="btn btn-sm btn-danger me-1" onclick="rejectRoomType(' + room.id + ')">' +
                                '<i class="far fa-times"></i> Reject' +
                            '</button>' 
                        : '') +
                        '<button class="btn btn-sm btn-danger" onclick="deleteRoomType(' + room.id + ')">' +
                            '<i class="far fa-trash"></i>' +
                        '</button>' +
                    '</td>' +
                '</tr>';
            });
            tbody.innerHTML = html;
        }

        async function approveRoomType(id) {
            if (!confirm('Approve this room type? It will be visible to users.')) return;
            try {
                await HotelBookingAPI.AdminAPI.approveRoomType(id);
                alert('Room type approved successfully');
                await loadRooms();
            } catch (error) {
                alert('Error approving room type: ' + error.message);
            }
        }

        async function rejectRoomType(id) {
            const reason = prompt('Enter rejection reason:');
            if (!reason || reason.trim() === '') {
                alert('Rejection reason is required');
                return;
            }
            try {
                await HotelBookingAPI.AdminAPI.rejectRoomType(id, reason);
                alert('Room type rejected successfully');
                await loadRooms();
            } catch (error) {
                alert('Error rejecting room type: ' + error.message);
            }
        }

        async function deleteRoomType(id) {
            if (!confirm('Are you sure you want to delete this room type? This action cannot be undone.')) return;
            try {
                await HotelBookingAPI.AdminAPI.deleteRoomType(id);
                alert('Room type deleted successfully');
                await loadRooms();
            } catch (error) {
                alert('Error deleting room type: ' + error.message);
            }
        }
    </script>
</body>
</html>

