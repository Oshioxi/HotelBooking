// Load Header and Footer Components
(function() {
    'use strict';

    // Load component function
    function loadComponent(url, targetId, callback) {
        fetch(url)
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.text();
            })
            .then(html => {
                const target = document.getElementById(targetId);
                if (target) {
                    target.innerHTML = html;
                    // Update current year in footer
                    if (targetId === 'footer-container') {
                        const yearSpan = document.getElementById('currentYear');
                        if (yearSpan) {
                            yearSpan.textContent = new Date().getFullYear();
                        }
                    }
                    // Initialize user menu if API is available
                    if (targetId === 'header-container' && typeof HotelBookingAPI !== 'undefined') {
                        updateUserMenu();
                    }
                    if (callback) callback();
                }
            })
            .catch(error => {
                console.error(`Error loading ${url}:`, error);
            });
    }

    // Update user menu based on login status
    function updateUserMenu() {
        if (typeof HotelBookingAPI === 'undefined' || !HotelBookingAPI.TokenManager) {
            return;
        }

        const token = HotelBookingAPI.TokenManager.getToken();
        const accountSection = document.getElementById('accountSection');
        const userMenu = document.getElementById('userMenu');
        const loginLink = document.getElementById('loginLink');
        const registerLink = document.getElementById('registerLink');
        const userName = document.getElementById('userName');
        const userMenuLink = document.getElementById('userMenuLink');

        if (token) {
            // User is logged in
            const userInfo = HotelBookingAPI.TokenManager.getUserInfo();
            const fullName = userInfo.fullName || userInfo.username || 'User';
            
            // Hide login/register links
            if (loginLink) loginLink.style.display = 'none';
            if (registerLink) registerLink.style.display = 'none';
            
            // Show user menu
            if (userMenu) userMenu.style.display = 'block';
            if (userName) userName.textContent = fullName;
            
            // Setup logout
            const logoutLink = document.getElementById('logoutLink');
            if (logoutLink) {
                logoutLink.addEventListener('click', function(e) {
                    e.preventDefault();
                    if (confirm('Are you sure you want to logout?')) {
                        HotelBookingAPI.TokenManager.clear();
                        window.location.href = '/index';
                    }
                });
            }
        } else {
            // User is not logged in
            if (loginLink) loginLink.style.display = 'inline-block';
            if (registerLink) registerLink.style.display = 'inline-block';
            if (userMenu) userMenu.style.display = 'none';
        }
    }

    // Load components when DOM is ready
    document.addEventListener('DOMContentLoaded', function() {
        // Load header
        const headerContainer = document.getElementById('header-container');
        if (headerContainer) {
            const contextPath = window.location.pathname.split('/').slice(0, -1).join('/') || '';
            loadComponent(contextPath + '/components/components/header.html', 'header-container', function() {
                // Update user menu after header is loaded
                if (typeof HotelBookingAPI !== 'undefined') {
                    updateUserMenu();
                }
            });
        }

        // Load footer
        const footerContainer = document.getElementById('footer-container');
        if (footerContainer) {
            const contextPath = window.location.pathname.split('/').slice(0, -1).join('/') || '';
            loadComponent(contextPath + '/components/components/footer.html', 'footer-container');
        }

        // Setup newsletter form
        setTimeout(function() {
            const newsletterForm = document.getElementById('newsletterForm');
            if (newsletterForm) {
                newsletterForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    const email = this.querySelector('input[type="email"]').value;
                    alert('Thank you for subscribing! We will send updates to ' + email);
                    this.reset();
                });
            }
        }, 1000);
    });

    // Re-check user menu when token changes (after login/logout)
    if (typeof HotelBookingAPI !== 'undefined' && HotelBookingAPI.TokenManager) {
        // Monitor token changes
        const originalSetToken = HotelBookingAPI.TokenManager.setToken;
        if (originalSetToken) {
            HotelBookingAPI.TokenManager.setToken = function(token, userInfo) {
                originalSetToken.call(this, token, userInfo);
                setTimeout(updateUserMenu, 100);
            };
        }
    }
})();

