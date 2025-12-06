package com.hotelbooking.hotelbooking.controller;

import com.hotelbooking.hotelbooking.dto.ContactRequest;
import com.hotelbooking.hotelbooking.model.Contact;
import com.hotelbooking.hotelbooking.repository.ContactRepository;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/contact")
@CrossOrigin(origins = "*")
public class ContactController {
    
    @Autowired
    private ContactRepository contactRepository;

    @PostMapping
    public ResponseEntity<?> submitContact(@Valid @RequestBody ContactRequest request, BindingResult bindingResult) {
        if (bindingResult.hasErrors()) {
            Map<String, String> errors = new HashMap<>();
            bindingResult.getFieldErrors().forEach(error -> 
                errors.put(error.getField(), error.getDefaultMessage())
            );
            return ResponseEntity.badRequest().body(errors);
        }

        try {
            Contact contact = new Contact();
            contact.setName(request.getName());
            contact.setEmail(request.getEmail());
            contact.setSubject(request.getSubject());
            contact.setMessage(request.getMessage());
            contact.setIsRead(false);

            contactRepository.save(contact);

            Map<String, String> response = new HashMap<>();
            response.put("message", "Thank you for contacting us! We will get back to you soon.");
            return ResponseEntity.ok(response);
        } catch (Exception e) {
            Map<String, String> error = new HashMap<>();
            error.put("error", "An error occurred while submitting your message. Please try again later.");
            return ResponseEntity.status(500).body(error);
        }
    }
}



