<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="user.profile"/></title>
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
                <h2 class="breadcrumb-title"><spring:message code="user.profile"/></h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/"><spring:message code="common.home"/></a></li>
                    <li><a href="${pageContext.request.contextPath}/dashboard"><spring:message code="common.dashboard"/></a></li>
                    <li class="active"><spring:message code="user.profile"/></li>
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
                        <div class="user-profile-wrapper">
                            <div class="user-profile-card">
                                <h4 class="user-profile-card-title"><spring:message code="user.profile"/></h4>
                                <form id="profileForm">
                                    <div class="row">
                                        <div class="col-md-6 mb-3">
                                            <label><spring:message code="login.username"/></label>
                                            <input type="text" id="username" class="form-control" readonly>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label><spring:message code="register.email"/></label>
                                            <input type="email" id="email" class="form-control" readonly>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label><spring:message code="register.full_name"/> *</label>
                                            <input type="text" id="fullName" class="form-control" required>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <label><spring:message code="register.phone"/></label>
                                            <input type="text" id="phone" class="form-control">
                                        </div>
                                        <div class="col-md-12 d-flex gap-2">
                                            <button type="submit" class="theme-btn">
                                                <i class="far fa-save"></i> <spring:message code="common.save"/>
                                            </button>
                                            <a href="${pageContext.request.contextPath}/user/change-password" class="theme-btn btn-secondary">
                                                <i class="far fa-key"></i> <spring:message code="user.change_password"/>
                                            </a>
                                        </div>
                                    </div>
                                </form>
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
        // Messages for JavaScript
        const messages = {
            saving: '<spring:message code="user.saving" javaScriptEscape="true"/>',
            profileUpdatedSuccess: '<spring:message code="user.profile_updated_success" javaScriptEscape="true"/>',
            errorUpdatingProfile: '<spring:message code="user.error_updating_profile" javaScriptEscape="true"/>',
            errorLoadingProfile: '<spring:message code="user.error_loading_profile" javaScriptEscape="true"/>'
        };
        
        document.addEventListener('DOMContentLoaded', async function() {
            // Hide preloader
            const preloader = document.querySelector('.preloader');
            if (preloader) {
                preloader.style.display = 'none';
            }
            
            if (!HotelBookingAPI.TokenManager.getToken()) {
                window.location.href = '/login';
                return;
            }
            
            try {
                // Load current user info from API
                const user = await HotelBookingAPI.UserAPI.getCurrentUser();
                
                // Update form fields
                document.getElementById('username').value = user.username || '';
                document.getElementById('email').value = user.email || '';
                document.getElementById('fullName').value = user.fullName || '';
                document.getElementById('phone').value = user.phone || '';
                
                // Update sidebar info
                const userFullName = document.getElementById('userFullName');
                const userEmail = document.getElementById('userEmail');
                if (userFullName) userFullName.textContent = user.fullName || user.username || 'User';
                if (userEmail) userEmail.textContent = user.email || '';
                
                // Update localStorage with latest info
                HotelBookingAPI.TokenManager.setUserInfo(user);
                
                // Load sidebar menu based on user role (using shared function from dashboard.js)
                const userRole = HotelBookingAPI.TokenManager.getUserRole();
                if (typeof loadSidebarMenu === 'function') {
                    loadSidebarMenu(userRole, '/user/profile');
                }
            } catch (error) {
                console.error('Error loading user info:', error);
                HotelBookingAPI.Utils.showAlert(messages.errorLoadingProfile + ': ' + error.message, 'error');
            }
        });

        // Sidebar menu loading is handled by dashboard.js
        // logout function is also in dashboard.js

        document.getElementById('profileForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="far fa-spinner fa-spin"></i> ' + messages.saving;
            
            try {
                const profileData = {
                    fullName: document.getElementById('fullName').value.trim(),
                    phone: document.getElementById('phone').value.trim() || null
                };
                
                const updatedUser = await HotelBookingAPI.UserAPI.updateProfile(profileData);
                
                // Update localStorage
                HotelBookingAPI.TokenManager.setUserInfo(updatedUser);
                
                HotelBookingAPI.Utils.showAlert(messages.profileUpdatedSuccess, 'success');
            } catch (error) {
                console.error('Error updating profile:', error);
                HotelBookingAPI.Utils.showAlert(messages.errorUpdatingProfile + ': ' + error.message, 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
    </script>
</body>
</html>

