package com.hotelbooking.hotelbooking.config;

import com.hotelbooking.hotelbooking.exception.BadRequestException;
import com.hotelbooking.hotelbooking.exception.ResourceNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.ModelAndView;

import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
@ControllerAdvice
public class GlobalExceptionHandler {
    
    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<Map<String, String>> handleResourceNotFound(ResourceNotFoundException ex) {
        Map<String, String> error = new HashMap<>();
        error.put("error", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<Map<String, String>> handleBadRequest(BadRequestException ex) {
        Map<String, String> error = new HashMap<>();
        error.put("error", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, Object>> handleValidationExceptions(MethodArgumentNotValidException ex) {
        Map<String, Object> errors = new HashMap<>();
        Map<String, String> fieldErrors = new HashMap<>();
        
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            fieldErrors.put(fieldName, errorMessage);
        });
        
        errors.put("error", "Validation failed");
        errors.put("errors", fieldErrors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errors);
    }

    @ExceptionHandler(RuntimeException.class)
    public Object handleRuntimeException(RuntimeException ex, HttpServletRequest request) {
        logger.error("Runtime exception occurred at {}: {}", request.getRequestURI(), ex.getMessage(), ex);
        
        // Check if this is a view request (JSP) or API request
        String acceptHeader = request.getHeader("Accept");
        boolean isApiRequest = acceptHeader != null && acceptHeader.contains("application/json");
        boolean isViewRequest = request.getRequestURI() != null && 
                               !request.getRequestURI().startsWith("/api/") &&
                               (acceptHeader == null || acceptHeader.contains("text/html"));
        
        if (isViewRequest) {
            // Return error page for JSP views
            ModelAndView modelAndView = new ModelAndView("error");
            modelAndView.addObject("error", ex.getMessage() != null ? ex.getMessage() : "A runtime error occurred");
            modelAndView.addObject("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
            modelAndView.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            return modelAndView;
        }
        
        // Return JSON for API requests
        Map<String, String> error = new HashMap<>();
        error.put("error", ex.getMessage() != null ? ex.getMessage() : "A runtime error occurred");
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }

    @ExceptionHandler(Exception.class)
    public Object handleException(Exception ex, HttpServletRequest request) {
        logger.error("Unexpected error occurred at {}: {}", request.getRequestURI(), ex.getMessage(), ex);
        
        // Check if this is a view request (JSP) or API request
        String acceptHeader = request.getHeader("Accept");
        boolean isApiRequest = acceptHeader != null && acceptHeader.contains("application/json");
        boolean isViewRequest = request.getRequestURI() != null && 
                               !request.getRequestURI().startsWith("/api/") &&
                               (acceptHeader == null || acceptHeader.contains("text/html"));
        
        if (isViewRequest) {
            // Return error page for JSP views
            ModelAndView modelAndView = new ModelAndView("error");
            String errorMessage = ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred";
            modelAndView.addObject("error", errorMessage);
            modelAndView.addObject("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
            modelAndView.setStatus(HttpStatus.INTERNAL_SERVER_ERROR);
            return modelAndView;
        }
        
        // Return JSON for API requests
        Map<String, String> error = new HashMap<>();
        String errorMessage = ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred";
        error.put("error", errorMessage);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}

