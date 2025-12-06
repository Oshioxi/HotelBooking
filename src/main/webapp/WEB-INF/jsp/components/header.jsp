<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- header area -->
<header class="header">

    <!-- header-top -->
    <div class="header-top">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-7">
                    <div class="header-top-left">
                        <div class="top-social">
                            <a href="#"><i class="fab fa-facebook-f"></i></a>
                            <a href="#"><i class="fab fa-x-twitter"></i></a>
                            <a href="#"><i class="fab fa-instagram"></i></a>
                            <a href="#"><i class="fab fa-linkedin-in"></i></a>
                        </div>
                        <div class="top-contact-info">
                            <ul>
                                <li><a href="tel:+21234567897"><i class="far fa-phone-arrow-down-left"></i>+2 123
                                        4567 897</a></li>
                                <li><a href="mailto:info@hotelbooking.com"><i
                                            class="far fa-envelopes"></i>info@hotelbooking.com</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="col-md-5">
                    <div class="header-top-right">
                        <div class="lang">
                            <select name="lang" id="languageSelect" class="select" onchange="changeLanguage(this.value)">
                                <option value="vi">Tiếng Việt</option>
                                <option value="en">English</option>
                            </select>
                        </div>
                        <div class="currency">
                            <select name="currency" class="select">
                                <option value="1">USD</option>
                                <option value="2">EUR</option>
                                <option value="3">AUD</option>
                                <option value="4">BRL</option>
                                <option value="5">CAD</option>
                                <option value="6">MXN</option>
                            </select>
                        </div>
                        <div class="account" id="accountSection">
                            <!-- Will be populated by JavaScript -->
                            <a href="${pageContext.request.contextPath}/login" id="loginLink"><i class="far fa-sign-in"></i><spring:message code="common.login"/></a>
                            <a href="${pageContext.request.contextPath}/register" id="registerLink"><i class="far fa-user-tie"></i><spring:message code="common.register"/></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- header-top end -->

    <!-- navbar -->
    <div class="main-navigation">
        <nav class="navbar navbar-expand-lg">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/index">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/logo.png" class="logo-display" alt="logo">
                    <img src="${pageContext.request.contextPath}/assets/img/logo/logo-dark.png" class="logo-scrolled" alt="logo">
                </a>
                <div class="mobile-menu-right">
                    <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
                        data-bs-target="#main_nav" aria-expanded="false" aria-label="Toggle navigation">
                        <span class="navbar-toggler-btn-icon"><i class="far fa-bars"></i></span>
                    </button>
                </div>
                <div class="collapse navbar-collapse" id="main_nav">
                    <ul class="navbar-nav">
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/index"><spring:message code="nav.home"/></a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown"><spring:message code="nav.hotels"/></a>
                            <ul class="dropdown-menu fade-down">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/hotel-search-result"><spring:message code="hotel.search"/></a></li>
                            </ul>
                        </li>
                        <li class="nav-item dropdown" id="userMenu" style="display: none;">
                            <a class="nav-link dropdown-toggle" href="#" data-bs-toggle="dropdown" id="userMenuLink">
                                <i class="far fa-user"></i> <span id="userName">User</span>
                            </a>
                            <ul class="dropdown-menu fade-down">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard"><i class="far fa-gauge-high"></i> <spring:message code="common.dashboard"/></a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile-booking"><i class="far fa-shopping-bag"></i> <spring:message code="user.bookings_history"/></a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/wishlist"><i class="far fa-heart"></i> My Wishlist</a></li>
                                <li><a class="dropdown-item" href="#" id="logoutLink"><i class="far fa-sign-out"></i> <spring:message code="common.logout"/></a></li>
                            </ul>
                        </li>
                        <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/contact"><spring:message code="nav.contact"/></a></li>
                    </ul>
                    <div class="header-nav-right">
                        <div class="header-btn">
                            <a href="${pageContext.request.contextPath}/index" class="theme-btn mt-2"><spring:message code="hotel.book_now"/></a>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    </div>
    <!-- navbar end -->

</header>
<!-- header area end -->

<script src="${pageContext.request.contextPath}/assets/js/i18n.js"></script>

