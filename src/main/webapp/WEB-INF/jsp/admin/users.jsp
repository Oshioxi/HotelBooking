<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - User Management</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/assets/img/logo/favicon.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/all-fontawesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/nice-select.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery-ui.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        #usersTable th:last-child,
        #usersTable td:last-child {
            white-space: nowrap;
            min-width: 120px;
        }
        #usersTable td:last-child .btn {
            display: inline-block;
            margin-right: 5px;
        }
        #usersTable td:last-child .btn:last-child {
            margin-right: 0;
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
                <h2 class="breadcrumb-title"><spring:message code="admin.users"/></h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/"><spring:message code="common.home"/></a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard"><spring:message code="common.dashboard"/></a></li>
                    <li class="active"><spring:message code="admin.users"/></li>
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
                                <h4 class="user-profile-card-title"><spring:message code="admin.users"/></h4>
                                <button class="theme-btn" onclick="showAddUserModal()">
                                    <i class="far fa-plus"></i> <spring:message code="admin.add_user"/>
                                </button>
                            </div>
                            <div class="table-responsive">
                                <table class="table table-hover" id="usersTable">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th><spring:message code="login.username"/></th>
                                            <th><spring:message code="register.full_name"/></th>
                                            <th><spring:message code="register.email"/></th>
                                            <th><spring:message code="register.phone"/></th>
                                            <th><spring:message code="register.role"/></th>
                                            <th><spring:message code="common.status"/></th>
                                            <th><spring:message code="common.created"/></th>
                                            <th><spring:message code="common.actions"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td colspan="9" class="text-center"><spring:message code="common.loading"/></td>
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

    <!-- Add/Edit User Modal -->
    <div class="modal fade" id="userModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userModalTitle"><spring:message code="admin.add_user"/></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="userForm">
                        <input type="hidden" id="userId">
                        <div class="form-group mb-3">
                            <label><spring:message code="login.username"/> *</label>
                            <input type="text" id="username" class="form-control" required>
                        </div>
                        <div class="form-group mb-3">
                            <label><spring:message code="register.full_name"/> *</label>
                            <input type="text" id="fullName" class="form-control" required>
                        </div>
                        <div class="form-group mb-3">
                            <label><spring:message code="register.email"/> *</label>
                            <input type="email" id="email" class="form-control" required>
                        </div>
                        <div class="form-group mb-3">
                            <label><spring:message code="register.phone"/></label>
                            <input type="text" id="phone" class="form-control">
                        </div>
                        <div class="form-group mb-3">
                            <label><spring:message code="register.role"/> *</label>
                            <select id="role" class="form-control" required>
                                <option value="USER"><spring:message code="register.role.user"/></option>
                                <option value="HOTEL_OWNER"><spring:message code="register.role.owner"/></option>
                                <option value="ADMIN">Admin</option>
                            </select>
                        </div>
                        <div class="form-group mb-3" id="passwordGroup">
                            <label><spring:message code="login.password"/> *</label>
                            <input type="password" id="password" class="form-control" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal"><spring:message code="common.cancel"/></button>
                    <button type="button" class="theme-btn" onclick="saveUser()"><spring:message code="common.save"/></button>
                </div>
            </div>
        </div>
    </div>

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
        let users = [];
        
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
            loadSidebarMenu(userRole, '/admin/users');
            
            await loadUsers();
        });

        async function loadUsers() {
            try {
                const tbody = document.querySelector('#usersTable tbody');
                if (!tbody) {
                    console.error('Table body not found');
                    return;
                }
                tbody.innerHTML = '<tr><td colspan="9" class="text-center">Loading...</td></tr>';
                
                const response = await HotelBookingAPI.AdminAPI.getAllUsers();
                console.log('API Response:', response);
                
                users = Array.isArray(response) ? response : [];
                console.log('Users array:', users);
                
                // Normalize user data - handle potential false/null values and both camelCase/snake_case
                users = users.map(user => {
                    // Handle both camelCase and snake_case formats
                    const getValue = (obj, ...keys) => {
                        for (const key of keys) {
                            if (obj && obj[key] !== undefined && obj[key] !== null) {
                                return obj[key];
                            }
                        }
                        return null;
                    };
                    
                    const normalized = {
                        id: getValue(user, 'id') || null,
                        username: (() => {
                            const val = getValue(user, 'username');
                            return (val && val !== 'false' && val !== false && val !== '') ? String(val) : null;
                        })(),
                        fullName: (() => {
                            const val = getValue(user, 'fullName', 'full_name');
                            return (val && val !== 'false' && val !== false && val !== '') ? String(val) : null;
                        })(),
                        email: (() => {
                            const val = getValue(user, 'email');
                            return (val && val !== 'false' && val !== false && val !== '') ? String(val) : null;
                        })(),
                        phone: (() => {
                            const val = getValue(user, 'phone');
                            return (val && val !== 'false' && val !== false && val !== '') ? String(val) : null;
                        })(),
                        role: (() => {
                            const val = getValue(user, 'role');
                            return (val && val !== 'false' && val !== false) ? String(val) : 'USER';
                        })(),
                        isActive: (() => {
                            const val = getValue(user, 'isActive', 'is_active');
                            return val !== undefined && val !== null ? Boolean(val) : true;
                        })(),
                        createdAt: getValue(user, 'createdAt', 'created_at') || null
                    };
                    console.log('Original user:', user);
                    console.log('Normalized user:', normalized);
                    return normalized;
                });
                
                displayUsers(users);
            } catch (error) {
                console.error('Error loading users:', error);
                const tbody = document.querySelector('#usersTable tbody');
                if (tbody) {
                    tbody.innerHTML = '<tr><td colspan="9" class="text-center text-danger">Error loading users: ' + error.message + '</td></tr>';
                }
            }
        }

        function displayUsers(usersList) {
            const tbody = document.querySelector('#usersTable tbody');
            if (!tbody) {
                console.error('Table body not found in displayUsers');
                return;
            }
            
            if (!usersList || usersList.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="text-center text-muted">No users found</td></tr>';
                return;
            }

            console.log('Displaying users:', usersList);

            // Helper function to safely get string value
            const getStringValue = (value) => {
                if (value === null || value === undefined || value === false || value === '' || value === 'false') {
                    return 'N/A';
                }
                return String(value);
            };

            // Helper function to escape HTML (but not N/A)
            const escapeHtml = (text) => {
                if (!text || text === 'N/A') return 'N/A';
                const div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            };

            let html = '';
            usersList.forEach((user, index) => {
                try {
                    const statusClass = user.isActive ? 'badge-success' : 'badge-danger';
                    const statusText = user.isActive ? 'Active' : 'Inactive';
                    let createdDate = 'N/A';
                    if (user.createdAt) {
                        try {
                            createdDate = new Date(user.createdAt).toLocaleDateString('vi-VN');
                        } catch (e) {
                            createdDate = String(user.createdAt);
                        }
                    }
                    
                    // Safely get values with proper escaping
                    const userId = user.id ? String(user.id) : 'N/A';
                    const username = escapeHtml(getStringValue(user.username));
                    const fullName = escapeHtml(getStringValue(user.fullName));
                    const email = escapeHtml(getStringValue(user.email));
                    const phone = escapeHtml(getStringValue(user.phone));
                    const role = escapeHtml(getStringValue(user.role));
                    const userActive = user.isActive ? true : false;
                    const eyeIcon = userActive ? 'fa-eye' : 'fa-eye-slash';
                    
                    let roleBadgeClass = 'badge-secondary'; 
                    const roleUpper = String(user.role || '').toUpperCase();
                    if (roleUpper === 'ADMIN') {
                        roleBadgeClass = 'badge-danger'; 
                    } else if (roleUpper === 'HOTEL_OWNER') {
                        roleBadgeClass = 'badge-warning'; 
                    } else if (roleUpper === 'USER') {
                        roleBadgeClass = 'badge-success'; 
                    }
                    
                    html += '<tr>';
                    html += '<td>' + userId + '</td>';
                    html += '<td><strong>' + username + '</strong></td>';
                    html += '<td>' + fullName + '</td>';
                    html += '<td>' + email + '</td>';
                    html += '<td>' + phone + '</td>';
                    html += '<td><span class="badge ' + roleBadgeClass + '">' + role + '</span></td>';
                    html += '<td><span class="badge ' + statusClass + '">' + statusText + '</span></td>';
                    html += '<td>' + createdDate + '</td>';
                    html += '<td style="white-space: nowrap;">';
                    html += '<button class="btn btn-sm btn-primary me-1" onclick="editUser(' + (user.id || 0) + ')" title="Edit" style="display: inline-block;">';
                    html += '<i class="far fa-edit"></i>';
                    html += '</button>';
                    html += '<button class="btn btn-sm btn-warning me-1" onclick="toggleUserStatus(' + (user.id || 0) + ')" title="Toggle Status" style="display: inline-block;">';
                    html += '<i class="far ' + eyeIcon + '"></i>';
                    html += '</button>';
                    html += '<button class="btn btn-sm btn-danger" onclick="deleteUser(' + (user.id || 0) + ')" title="Delete" style="display: inline-block;">';
                    html += '<i class="far fa-trash"></i>';
                    html += '</button>';
                    html += '</td>';
                    html += '</tr>';
                } catch (err) {
                    console.error('Error rendering user at index ' + index + ':', err, user);
                }
            });
            
            console.log('Generated HTML length:', html.length);
            tbody.innerHTML = html;
        }

        function showAddUserModal() {
            document.getElementById('userModalTitle').textContent = 'Add User';
            document.getElementById('userForm').reset();
            document.getElementById('userId').value = '';
            document.getElementById('passwordGroup').style.display = 'block';
            document.getElementById('password').required = true;
            new bootstrap.Modal(document.getElementById('userModal')).show();
        }

        function editUser(id) {
            const user = users.find(u => u.id === id);
            if (!user) {
                alert('User not found');
                return;
            }

            document.getElementById('userModalTitle').textContent = 'Edit User';
            document.getElementById('userId').value = user.id || '';
            document.getElementById('username').value = (user.username && user.username !== 'false') ? user.username : '';
            document.getElementById('fullName').value = (user.fullName && user.fullName !== 'false') ? user.fullName : '';
            document.getElementById('email').value = (user.email && user.email !== 'false') ? user.email : '';
            document.getElementById('phone').value = (user.phone && user.phone !== 'false') ? user.phone : '';
            document.getElementById('role').value = user.role || 'USER';
            document.getElementById('passwordGroup').style.display = 'none';
            document.getElementById('password').required = false;
            new bootstrap.Modal(document.getElementById('userModal')).show();
        }

        async function saveUser() {
            const userId = document.getElementById('userId').value;
            const username = document.getElementById('username').value.trim();
            const fullName = document.getElementById('fullName').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const role = document.getElementById('role').value;
            
            // Validation
            if (!username) {
                alert('Username is required');
                return;
            }
            if (!fullName) {
                alert('Full name is required');
                return;
            }
            if (!email) {
                alert('Email is required');
                return;
            }
            
            const userData = {
                username: username,
                fullName: fullName,
                email: email,
                phone: phone || null,
                role: role
            };

            if (userId) {
                // Update
                try {
                    await HotelBookingAPI.AdminAPI.updateUser(userId, userData);
                    alert('User updated successfully');
                    bootstrap.Modal.getInstance(document.getElementById('userModal')).hide();
                    await loadUsers();
                } catch (error) {
                    alert('Error updating user: ' + error.message);
                }
            } else {
                // Create
                const password = document.getElementById('password').value;
                if (!password) {
                    alert('Password is required');
                    return;
                }
                userData.password = password;
                try {
                    await HotelBookingAPI.AdminAPI.createUser(userData);
                    alert('User created successfully');
                    bootstrap.Modal.getInstance(document.getElementById('userModal')).hide();
                    await loadUsers();
                } catch (error) {
                    alert('Error creating user: ' + error.message);
                }
            }
        }

        async function toggleUserStatus(id) {
            if (!confirm('Are you sure you want to toggle user status?')) return;
            try {
                await HotelBookingAPI.AdminAPI.toggleUserStatus(id);
                alert('User status updated');
                await loadUsers();
            } catch (error) {
                alert('Error updating status: ' + error.message);
            }
        }

        async function deleteUser(id) {
            if (!confirm('Are you sure you want to delete this user? This action cannot be undone.')) return;
            try {
                await HotelBookingAPI.AdminAPI.deleteUser(id);
                alert('User deleted successfully');
                await loadUsers();
            } catch (error) {
                alert('Error deleting user: ' + error.message);
            }
        }
    </script>
</body>
</html>

