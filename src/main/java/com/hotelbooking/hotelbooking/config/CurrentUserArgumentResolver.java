package com.hotelbooking.hotelbooking.config;

import com.hotelbooking.hotelbooking.annotation.CurrentUser;
import com.hotelbooking.hotelbooking.util.TokenExtractor;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.MethodParameter;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

@Component
public class CurrentUserArgumentResolver implements HandlerMethodArgumentResolver {

    @Autowired
    private TokenExtractor tokenExtractor;

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(CurrentUser.class) 
            && parameter.getParameterType().equals(Long.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) {
        try {
            HttpServletRequest request = webRequest.getNativeRequest(HttpServletRequest.class);
            if (request != null && tokenExtractor != null) {
                return tokenExtractor.extractUserIdFromRequest(request);
            }
        } catch (Exception e) {
            // Log error but don't throw - return null to allow request to continue
            // This allows pages without authentication to work normally
        }
        return null;
    }
}

