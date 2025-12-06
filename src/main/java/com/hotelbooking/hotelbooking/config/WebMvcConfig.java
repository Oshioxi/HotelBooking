package com.hotelbooking.hotelbooking.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;

import java.util.List;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired(required = false)
    private CurrentUserArgumentResolver currentUserArgumentResolver;

    @Autowired(required = false)
    private LocaleChangeInterceptor localeChangeInterceptor;

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        if (currentUserArgumentResolver != null) {
            resolvers.add(currentUserArgumentResolver);
        }
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        if (localeChangeInterceptor != null) {
            registry.addInterceptor(localeChangeInterceptor);
        }
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/assets/**")
                .addResourceLocations("classpath:/static/assets/", "/assets/");
        
        registry.addResourceHandler("/js/**")
                .addResourceLocations("classpath:/static/js/", "/js/");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("*")
                .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
                .allowedHeaders("*");
    }
}

