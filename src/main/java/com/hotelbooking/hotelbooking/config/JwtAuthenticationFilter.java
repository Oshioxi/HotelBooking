package com.hotelbooking.hotelbooking.config;

import com.hotelbooking.hotelbooking.util.JwtUtil;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtUtil jwtUtil;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        
        try {
            final String authHeader = request.getHeader("Authorization");
            
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                filterChain.doFilter(request, response);
                return;
            }

            try {
                final String token = authHeader.substring(7);
                
                if (token == null || token.isEmpty()) {
                    filterChain.doFilter(request, response);
                    return;
                }
                
                if (jwtUtil == null) {
                    filterChain.doFilter(request, response);
                    return;
                }
                
                try {
                    final String username = jwtUtil.extractUsername(token);

                    if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                        try {
                            if (jwtUtil.validateToken(token, username)) {
                                // Extract role from token
                                String role = jwtUtil.extractRole(token);
                                
                                if (role != null && !role.isEmpty()) {
                                    List<SimpleGrantedAuthority> authorities = Collections.singletonList(
                                        new SimpleGrantedAuthority("ROLE_" + role)
                                    );

                                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                                        username, null, authorities
                                    );
                                    authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                                    SecurityContextHolder.getContext().setAuthentication(authToken);
                                }
                            }
                        } catch (Exception e) {
                            logger.debug("Token validation failed", e);
                        }
                    }
                } catch (Exception e) {
                    logger.debug("Failed to extract username from token", e);
                }
            } catch (Exception e) {
                logger.debug("JWT filter error", e);
                // Continue with the filter chain even if authentication fails
            }
        } catch (Exception e) {
            logger.error("Unexpected error in JWT filter", e);
            // Continue with the filter chain even if there's an error
        }

        filterChain.doFilter(request, response);
    }
}

