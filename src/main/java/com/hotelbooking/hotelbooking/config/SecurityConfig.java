package com.hotelbooking.hotelbooking.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired(required = false)
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                // Public API endpoints (must be first, more specific rules)
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/rooms/search").permitAll()
                .requestMatchers("/api/rooms").permitAll() // Allow GET all rooms for public viewing
                .requestMatchers(HttpMethod.GET, "/api/rooms/{id}").permitAll() // Allow GET individual room for public viewing
                .requestMatchers(HttpMethod.GET, "/api/rooms/hotel/{hotelId}").permitAll() // Allow GET rooms by hotel for public viewing
                .requestMatchers("/api/hotels").permitAll() // Allow GET all hotels for public viewing
                .requestMatchers(HttpMethod.GET, "/api/hotels/{id}").permitAll() // Allow GET individual hotel for public viewing
                .requestMatchers("/api/hotels/search").permitAll() // Allow search hotels
                .requestMatchers(HttpMethod.GET, "/api/hotels/{hotelId}/amenities").permitAll() // Allow GET hotel amenities for public viewing
                .requestMatchers(HttpMethod.GET, "/api/hotels/{hotelId}/images").permitAll() // Allow GET hotel images for public viewing
                .requestMatchers(HttpMethod.GET, "/api/room-types/{roomTypeId}/amenities").permitAll() // Allow GET room type amenities for public viewing
                .requestMatchers(HttpMethod.GET, "/api/room-types/{roomTypeId}/images").permitAll() // Allow GET room type images for public viewing
                .requestMatchers("/api/amenities/**").permitAll() // Allow GET all amenities for public viewing
                .requestMatchers("/api/provinces/**").permitAll() // Allow GET provinces API (proxy for external API)
                
                // Public pages (view pages are protected by client-side JWT checks)
                .requestMatchers("/", "/index", "/login", "/register", 
                               "/hotel-search-result", "/hotel-single", "/hotel-booking",
                               "/assets/**", "/js/**", "/css/**", "/img/**").permitAll()
                
                // Protected API endpoints (require JWT token in header)
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                .requestMatchers("/api/owner/**").hasAnyRole("HOTEL_OWNER", "ADMIN")
                .requestMatchers("/api/user/**").hasAnyRole("USER", "HOTEL_OWNER", "ADMIN")
                .requestMatchers("/api/bookings/**").hasAnyRole("USER", "HOTEL_OWNER", "ADMIN")
                .requestMatchers("/api/hotels/**").hasAnyRole("HOTEL_OWNER", "ADMIN")
                .requestMatchers("/api/rooms/**").hasAnyRole("HOTEL_OWNER", "ADMIN")
                
                // Allow all view pages (HTML/JSP) - authentication is handled by JavaScript
                // This includes /admin/**, /owner/**, /user/**, /dashboard, etc.
                .anyRequest().permitAll()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            );
        
        if (jwtAuthenticationFilter != null) {
            http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        }

        return http.build();
    }
}

