<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="keywords" content="">
    <title>Hotel Booking - <spring:message code="register.title"/></title>
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

    <jsp:include page="components/header.jsp" />

    <main class="main">
        <div class="site-breadcrumb" style="background: url(${pageContext.request.contextPath}/assets/img/breadcrumb/01.jpg)">
            <div class="container">
                <h2 class="breadcrumb-title">Sign Up</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Sign Up</li>
                </ul>
            </div>
        </div>

        <div class="login-area py-120">
            <div class="container">
                <div class="col-md-5 mx-auto">
                    <div class="login-form">
                        <div class="login-header">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/logo-dark.png" alt="">
                            <p><spring:message code="register.title"/></p>
                        </div>
                        <form id="registerForm">
                            <div id="registerError" class="alert alert-danger" style="display: none;"></div>
                            <div class="form-group">
                                <label><spring:message code="register.username"/></label>
                                <div class="form-group-icon">
                                    <input type="text" id="username" class="form-control" placeholder="<spring:message code="register.username"/>" required>
                                    <i class="far fa-user"></i>
                                </div>
                            </div>
                            <div class="form-group">
                                <label><spring:message code="register.full_name"/></label>
                                <div class="form-group-icon">
                                    <input type="text" id="fullName" class="form-control" placeholder="<spring:message code="register.full_name"/>" required>
                                    <i class="far fa-user"></i>
                                </div>
                            </div>
                            <div class="form-group">
                                <label><spring:message code="register.email"/></label>
                                <div class="form-group-icon">
                                    <input type="email" id="email" class="form-control" placeholder="<spring:message code="register.email"/>" required>
                                    <i class="far fa-envelope"></i>
                                </div>
                            </div>
                            <div class="form-group">
                                <label><spring:message code="register.phone"/></label>
                                <div class="form-group-icon">
                                    <input type="text" id="phone" class="form-control" placeholder="<spring:message code="register.phone"/>">
                                    <i class="far fa-phone"></i>
                                </div>
                            </div>
                            <div class="form-group">
                                <label><spring:message code="register.password"/></label>
                                <div class="form-group-icon">
                                    <input type="password" id="password" class="form-control" placeholder="<spring:message code="register.password"/>" required>
                                    <i class="far fa-lock"></i>
                                </div>
                            </div>
                            <div class="form-group">
                                <label><spring:message code="register.role"/></label>
                                <select id="role" class="form-control">
                                    <option value="USER"><spring:message code="register.role.user"/></option>
                                    <option value="HOTEL_OWNER"><spring:message code="register.role.owner"/></option>
                                </select>
                            </div>
                            <div class="form-check form-group">
                                <input class="form-check-input" type="checkbox" value="" id="agree" required>
                                <label class="form-check-label" for="agree">
                                   I agree with the <a href="#">Terms Of Service.</a>
                                </label>
                            </div>
                            <div class="d-flex align-items-center">
                                <button type="submit" class="theme-btn"><i class="far fa-paper-plane"></i> <spring:message code="register.sign_up"/></button>
                            </div>
                        </form>
                        <div class="login-footer">
                            <div class="login-divider"><span>Or</span></div>
                            <div class="social-login">
                                <a href="#" class="btn-fb"><i class="fab fa-facebook"></i> Login With Facebook</a>
                                <a href="#" class="btn-gl"><i class="fab fa-google"></i> Login With Google</a>
                            </div>
                            <p><spring:message code="register.have_account"/> <a href="${pageContext.request.contextPath}/login"><spring:message code="common.login"/>.</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <jsp:include page="components/footer.jsp" />

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
        // Check if user is already logged in
        document.addEventListener('DOMContentLoaded', function() {
            const token = HotelBookingAPI.TokenManager.getToken();
            if (token) {
                // User is already logged in, redirect to appropriate page
                const userRole = HotelBookingAPI.TokenManager.getUserRole();
                if (userRole === 'ADMIN' || userRole === 'HOTEL_OWNER') {
                    window.location.href = '${pageContext.request.contextPath}/dashboard';
                } else {
                    window.location.href = '${pageContext.request.contextPath}/index';
                }
            }
        });
        
        document.getElementById('registerForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const errorDiv = document.getElementById('registerError');
            errorDiv.style.display = 'none';
            
            const userData = {
                username: document.getElementById('username').value,
                fullName: document.getElementById('fullName').value,
                email: document.getElementById('email').value,
                phone: document.getElementById('phone').value || null,
                password: document.getElementById('password').value,
                role: document.getElementById('role').value
            };
            
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="far fa-spinner fa-spin"></i> Registering...';
            
            try {
                const response = await HotelBookingAPI.AuthAPI.register(userData);
                alert('Registration successful! Redirecting to login...');
                window.location.href = '${pageContext.request.contextPath}/login';
            } catch (error) {
                const errorMessage = error.message || 'Registration failed. Please try again.';
                errorDiv.textContent = errorMessage;
                errorDiv.style.display = 'block';
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
                
                // Clear password field for security
                document.getElementById('password').value = '';
                
                // Focus on the field that has error
                if (errorMessage.toLowerCase().includes('username')) {
                    document.getElementById('username').focus();
                    document.getElementById('username').select();
                } else if (errorMessage.toLowerCase().includes('email')) {
                    document.getElementById('email').focus();
                    document.getElementById('email').select();
                } else {
                    document.getElementById('username').focus();
                }
                
                // Scroll to error message
                errorDiv.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        });
    </script>
</body>
</html>


