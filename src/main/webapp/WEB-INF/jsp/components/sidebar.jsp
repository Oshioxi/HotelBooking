<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

