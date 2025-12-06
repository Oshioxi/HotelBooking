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
    <title>Hotel Booking - <spring:message code="login.title"/></title>
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
                <h2 class="breadcrumb-title">Login</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Login</li>
                </ul>
            </div>
        </div>

        <div class="login-area py-120">
            <div class="container">
                <div class="col-md-5 mx-auto">
                    <div class="login-form">
                        <div class="login-header">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/logo-dark.png" alt="">
                            <p><spring:message code="login.title"/></p>
                        </div>
                        <form id="loginForm">
                            <div id="loginError" class="alert alert-danger" style="display: none;"></div>
                            <div class="form-group">
                                <label><spring:message code="login.username"/></label>
                                <div class="form-group-icon">
                                    <input type="text" id="username" class="form-control" placeholder="<spring:message code="login.username"/>" required>
                                    <i class="far fa-user"></i>
                                </div>
                            </div>
                            <div class="form-group">
                                <label><spring:message code="login.password"/></label>
                                <div class="form-group-icon">
                                    <input type="password" id="password" class="form-control" placeholder="<spring:message code="login.password"/>" required>
                                    <i class="far fa-lock"></i>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between mb-3">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" value="" id="remember">
                                    <label class="form-check-label" for="remember"><spring:message code="login.remember_me"/></label>
                                </div>
                                <a href="${pageContext.request.contextPath}/forgot-password" class="forgot-pass"><spring:message code="login.forgot_password"/></a>
                            </div>
                            <div class="d-flex align-items-center">
                                <button type="submit" class="theme-btn"><i class="far fa-sign-in"></i> <spring:message code="login.sign_in"/></button>
                            </div>
                        </form>
                        <div class="login-footer">
                            <div class="login-divider"><span>Or</span></div>
                            <div class="social-login">
                                <a href="#" class="btn-fb" onclick="return false;"><i class="fab fa-facebook"></i> Login With Facebook</a>
                                <div id="googleSignInButton" style="display: inline-block; width: 100%;"></div>
                            </div>
                            <p><spring:message code="login.no_account"/> <a href="${pageContext.request.contextPath}/register"><spring:message code="common.register"/>.</a></p>
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
    <!-- Google Identity Services -->
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <script>
        // Google OAuth Configuration
        const GOOGLE_CLIENT_ID = '1084206905822-9kredqvh4fhvv1rvfuddhp71geeho97a.apps.googleusercontent.com'; // Replace with your Google Client ID
        
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
            
            // Initialize Google Sign-In
            if (typeof google !== 'undefined' && google.accounts) {
                google.accounts.id.initialize({
                    client_id: GOOGLE_CLIENT_ID,
                    callback: handleGoogleSignIn
                });
                
                google.accounts.id.renderButton(
                    document.getElementById('googleSignInButton'),
                    {
                        theme: 'outline',
                        size: 'large',
                        width: '100%',
                        text: 'signin_with',
                        locale: 'en'
                    }
                );
            } else {
                // Fallback if Google script hasn't loaded yet
                window.addEventListener('load', function() {
                    if (typeof google !== 'undefined' && google.accounts) {
                        google.accounts.id.initialize({
                            client_id: GOOGLE_CLIENT_ID,
                            callback: handleGoogleSignIn
                        });
                        
                        google.accounts.id.renderButton(
                            document.getElementById('googleSignInButton'),
                            {
                                theme: 'outline',
                                size: 'large',
                                width: '100%',
                                text: 'signin_with',
                                locale: 'en'
                            }
                        );
                    }
                });
            }
        });
        
        async function handleGoogleSignIn(response) {
            try {
                const errorDiv = document.getElementById('loginError');
                errorDiv.style.display = 'none';
                
                // Show loading state
                const googleButton = document.getElementById('googleSignInButton');
                const originalContent = googleButton.innerHTML;
                googleButton.innerHTML = '<div style="text-align: center; padding: 10px;"><i class="far fa-spinner fa-spin"></i> Authenticating...</div>';
                googleButton.style.pointerEvents = 'none';
                
                // Send ID token to backend
                const authResponse = await HotelBookingAPI.AuthAPI.loginWithGoogle(response.credential);
                
                // Redirect based on role
                const role = authResponse.role;
                if (role === 'ADMIN' || role === 'HOTEL_OWNER') {
                    window.location.href = '${pageContext.request.contextPath}/dashboard';
                } else {
                    window.location.href = '${pageContext.request.contextPath}/index';
                }
            } catch (error) {
                console.error('Google sign-in error:', error);
                const errorDiv = document.getElementById('loginError');
                errorDiv.textContent = error.message || 'Failed to sign in with Google. Please try again.';
                errorDiv.style.display = 'block';
                
                // Restore button
                const googleButton = document.getElementById('googleSignInButton');
                googleButton.style.pointerEvents = 'auto';
                // Re-render button
                if (typeof google !== 'undefined' && google.accounts) {
                    google.accounts.id.renderButton(
                        googleButton,
                        {
                            theme: 'outline',
                            size: 'large',
                            width: '100%',
                            text: 'signin_with',
                            locale: 'en'
                        }
                    );
                }
            }
        }
        
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const errorDiv = document.getElementById('loginError');
            errorDiv.style.display = 'none';
            
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="far fa-spinner fa-spin"></i> Logging in...';
            
            try {
                const response = await HotelBookingAPI.AuthAPI.login(username, password);
                const role = response.role;
                if (role === 'ADMIN' || role === 'HOTEL_OWNER') {
                    window.location.href = '${pageContext.request.contextPath}/dashboard';
                } else {
                    window.location.href = '${pageContext.request.contextPath}/index';
                }
            } catch (error) {
                errorDiv.textContent = error.message || 'Login failed. Please check your credentials.';
                errorDiv.style.display = 'block';
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
    </script>
</body>
</html>


