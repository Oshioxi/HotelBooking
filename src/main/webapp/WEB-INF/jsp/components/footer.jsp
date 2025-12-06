<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- footer area -->
<footer class="footer-area ft-bg">
    <div class="footer-widget pt-60">
        <div class="container">
            <div class="row footer-widget-wrapper pt-100 pb-70">
                <div class="col-md-6 col-lg-3">
                    <div class="footer-widget-box about-us">
                        <a href="${pageContext.request.contextPath}/" class="footer-logo">
                            <img src="${pageContext.request.contextPath}/assets/img/logo/logo.png" alt="">
                        </a>
                        <p class="mb-4">
                            <spring:message code="footer.about_us"/>
                        </p>
                        <ul class="footer-contact">
                            <li>
                                <div class="footer-call">
                                    <div class="footer-call-icon">
                                        <i class="fal fa-headset"></i>
                                    </div>
                                    <div class="footer-call-info">
                                        <h6>24/7 Call Service</h6>
                                        <a href="tel:+21236547898">+2 123 654 7898</a>
                                    </div>
                                </div>
                            </li>
                            <li><i class="far fa-map-marker-alt"></i>25/B Milford Road, New York</li>
                            <li><a href="mailto:info@hotelbooking.com"><i
                                        class="far fa-envelopes"></i>info@hotelbooking.com</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6 col-lg-2">
                    <div class="footer-widget-box list">
                        <h4 class="footer-widget-title"><spring:message code="footer.quick_links"/></h4>
                        <ul class="footer-list">
                            <li><a href="about.html"><i class="fas fa-angle-double-right"></i> About Us</a></li>
                            <li><a href="team.html"><i class="fas fa-angle-double-right"></i> Meet Our Team</a></li>
                            <li><a href="contact.html"><i class="fas fa-angle-double-right"></i> Contact Us</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Affiliate Program</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Advertising With Us</a></li>
                            <li><a href="career.html"><i class="fas fa-angle-double-right"></i> Careers</a></li>
                            <li><a href="blog.html"><i class="fas fa-angle-double-right"></i> Our Blog</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6 col-lg-2">
                    <div class="footer-widget-box list">
                        <h4 class="footer-widget-title">Other Services</h4>
                        <ul class="footer-list">
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Rewards Program</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Partners</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Community Program</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Investor Relations</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Developer Guide</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Travel API</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> PointsPLUS</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6 col-lg-2">
                    <div class="footer-widget-box list">
                        <h4 class="footer-widget-title">Help Center</h4>
                        <ul class="footer-list">
                            <li><a href="${pageContext.request.contextPath}/dashboard"><i class="fas fa-angle-double-right"></i> Account</a></li>
                            <li><a href="faq.html"><i class="fas fa-angle-double-right"></i> FAQ's</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Legal Notice</a></li>
                            <li><a href="privacy.html"><i class="fas fa-angle-double-right"></i> Privacy Policy</a></li>
                            <li><a href="terms.html"><i class="fas fa-angle-double-right"></i> Terms & Conditions</a></li>
                            <li><a href="contact.html"><i class="fas fa-angle-double-right"></i> Live Chat</a></li>
                            <li><a href="#"><i class="fas fa-angle-double-right"></i> Sitemap</a></li>
                        </ul>
                    </div>
                </div>
                <div class="col-md-6 col-lg-3">
                    <div class="footer-widget-box list">
                        <h4 class="footer-widget-title"><spring:message code="footer.newsletter"/></h4>
                        <div class="footer-newsletter">
                            <p><spring:message code="footer.newsletter_desc"/></p>
                            <div class="subscribe-form">
                                <form action="#" id="newsletterForm">
                                    <div class="form-group">
                                        <div class="form-group-icon">
                                            <input type="email" class="form-control" placeholder="Email" required>
                                            <i class="far fa-envelopes"></i>
                                        </div>
                                    </div>
                                    <button class="theme-btn" type="submit">
                                        <spring:message code="footer.subscribe"/> <i class="far fa-paper-plane"></i>
                                    </button>
                                    <p><i class="far fa-lock"></i> <spring:message code="footer.all_rights_reserved"/></p>
                                </form>
                            </div>
                        </div>
                        <div class="footer-payment-method">
                            <h6>We Accept:</h6>
                            <div class="payment-method-img">
                                <img src="${pageContext.request.contextPath}/assets/img/payment/paypal.svg" alt="">
                                <img src="${pageContext.request.contextPath}/assets/img/payment/mastercard.svg" alt="">
                                <img src="${pageContext.request.contextPath}/assets/img/payment/visa.svg" alt="">
                                <img src="${pageContext.request.contextPath}/assets/img/payment/discover.svg" alt="">
                                <img src="${pageContext.request.contextPath}/assets/img/payment/american-express.svg" alt="">
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="copyright">
        <div class="container">
            <div class="row">
                <div class="col-md-6 align-self-center">
                    <p class="copyright-text">
                        &copy; <spring:message code="footer.copyright"/> <span id="currentYear"><%= java.util.Calendar.getInstance().get(java.util.Calendar.YEAR) %></span> <a href="${pageContext.request.contextPath}/"> Hotel Booking </a> <spring:message code="footer.all_rights_reserved"/>.
                    </p>
                </div>
                <div class="col-md-6 align-self-center">
                    <ul class="footer-social">
                        <li><a href="#"><i class="fab fa-facebook-f"></i></a></li>
                        <li><a href="#"><i class="fab fa-x-twitter"></i></a></li>
                        <li><a href="#"><i class="fab fa-linkedin-in"></i></a></li>
                        <li><a href="#"><i class="fab fa-youtube"></i></a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</footer>
<!-- footer area end -->

<!-- scroll-top -->
<a href="#" id="scroll-top"><i class="far fa-angle-up"></i></a>
<!-- scroll-top end -->

<script>
// Setup newsletter form
(function() {
    const newsletterForm = document.getElementById('newsletterForm');
    if (newsletterForm) {
        newsletterForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const email = this.querySelector('input[type="email"]').value;
            alert('Thank you for subscribing! We will send updates to ' + email);
            this.reset();
        });
    }
})();
</script>

