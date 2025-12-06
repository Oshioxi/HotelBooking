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
    <title>Hotel Booking - Reset Password</title>
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
                <h2 class="breadcrumb-title">Reset Password</h2>
                <ul class="breadcrumb-menu">
                    <li><a href="${pageContext.request.contextPath}/">Home</a></li>
                    <li class="active">Reset Password</li>
                </ul>
            </div>
        </div>

        <div class="login-area py-120">
            <div class="container">
                <div class="col-md-5 mx-auto">
                    <div class="login-form">
                        <div class="login-header">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/logo-dark.png" alt="">
                            <p>Reset Password</p>
                        </div>
                        <form id="resetPasswordForm">
                            <div id="resetPasswordError" class="alert alert-danger" style="display: none;"></div>
                            <div id="resetPasswordSuccess" class="alert alert-success" style="display: none;"></div>
                            <input type="hidden" id="resetToken" value="">
                            <div class="form-group">
                                <label>New Password</label>
                                <div class="form-group-icon">
                                    <input type="password" id="newPassword" class="form-control" placeholder="Enter new password" required minlength="6">
                                    <i class="far fa-lock"></i>
                                </div>
                                <small class="form-text text-muted">Password must be at least 6 characters long.</small>
                            </div>
                            <div class="form-group">
                                <label>Confirm New Password</label>
                                <div class="form-group-icon">
                                    <input type="password" id="confirmPassword" class="form-control" placeholder="Confirm new password" required minlength="6">
                                    <i class="far fa-lock"></i>
                                </div>
                            </div>
                            <div class="d-flex align-items-center">
                                <button type="submit" class="theme-btn"><i class="far fa-key"></i> Reset Password</button>
                            </div>
                        </form>
                        <div class="login-footer">
                            <p>Remember your password? <a href="${pageContext.request.contextPath}/login">Login here</a></p>
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
                window.location.href = '${pageContext.request.contextPath}/index';
            }
            
            // Get token from URL
            const urlParams = new URLSearchParams(window.location.search);
            const resetToken = urlParams.get('token');
            
            if (!resetToken) {
                document.getElementById('resetPasswordError').textContent = 'Invalid reset link. Please request a new password reset.';
                document.getElementById('resetPasswordError').style.display = 'block';
                document.getElementById('resetPasswordForm').style.display = 'none';
            } else {
                document.getElementById('resetToken').value = resetToken;
            }
        });
        
        document.getElementById('resetPasswordForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const errorDiv = document.getElementById('resetPasswordError');
            const successDiv = document.getElementById('resetPasswordSuccess');
            errorDiv.style.display = 'none';
            successDiv.style.display = 'none';
            
            const resetToken = document.getElementById('resetToken').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (newPassword !== confirmPassword) {
                errorDiv.textContent = 'Passwords do not match.';
                errorDiv.style.display = 'block';
                return;
            }
            
            if (newPassword.length < 6) {
                errorDiv.textContent = 'Password must be at least 6 characters long.';
                errorDiv.style.display = 'block';
                return;
            }
            
            const submitBtn = e.target.querySelector('button[type="submit"]');
            const originalText = submitBtn.innerHTML;
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="far fa-spinner fa-spin"></i> Resetting...';
            
            try {
                await HotelBookingAPI.AuthAPI.resetPassword(resetToken, newPassword);
                successDiv.textContent = 'Password has been reset successfully! Redirecting to login...';
                successDiv.style.display = 'block';
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/login';
                }, 2000);
            } catch (error) {
                errorDiv.textContent = error.message || 'Failed to reset password. The link may have expired.';
                errorDiv.style.display = 'block';
                submitBtn.disabled = false;
                submitBtn.innerHTML = originalText;
            }
        });
    </script>
</body>
</html>


