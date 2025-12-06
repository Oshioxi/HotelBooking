	/*-------------------------
        Ajax Contact Form 
    ---------------------------*/
    $(function() {

        // Get the form.
        var form = $('#contact-form');

        // Get the messages div.
        var formMessages = $('.form-messege');

        // Set up an event listener for the contact form.
        $(form).submit(function(e) {
            // Stop the browser from submitting the form.
            e.preventDefault();

            // Disable submit button to prevent double submission
            var submitBtn = $(form).find('button[type="submit"]');
            var originalText = submitBtn.html();
            submitBtn.prop('disabled', true);
            submitBtn.html('<i class="far fa-spinner fa-spin"></i> Sending...');

            // Get form data
            var formData = {
                name: $(form).find('input[name="name"]').val(),
                email: $(form).find('input[name="email"]').val(),
                subject: $(form).find('input[name="subject"]').val(),
                message: $(form).find('textarea[name="message"]').val()
            };

            // Submit the form using AJAX.
            $.ajax({
                type: 'POST',
                url: $(form).attr('action'),
                contentType: 'application/json',
                data: JSON.stringify(formData),
                dataType: 'json'
            })
            .done(function(response) {
                // Make sure that the formMessages div has the 'success' class.
                $(formMessages).removeClass('error');
                $(formMessages).addClass('success');

                // Set the message text.
                $(formMessages).text(response.message || 'Thank you for contacting us! We will get back to you soon.');

                // Clear the form.
                $(form)[0].reset();

                // Re-enable submit button
                submitBtn.prop('disabled', false);
                submitBtn.html(originalText);
            })
            .fail(function(xhr) {
                // Make sure that the formMessages div has the 'error' class.
                $(formMessages).removeClass('success');
                $(formMessages).addClass('error');

                // Set the message text.
                var errorMessage = 'Oops! An error occurred and your message could not be sent.';
                if (xhr.responseJSON) {
                    if (xhr.responseJSON.error) {
                        errorMessage = xhr.responseJSON.error;
                    } else if (xhr.responseJSON.message) {
                        errorMessage = xhr.responseJSON.message;
                    } else if (typeof xhr.responseJSON === 'object') {
                        // Validation errors
                        var errors = Object.values(xhr.responseJSON).join(', ');
                        if (errors) {
                            errorMessage = errors;
                        }
                    }
                } else if (xhr.responseText) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response.error) {
                            errorMessage = response.error;
                        }
                    } catch (e) {
                        errorMessage = xhr.responseText;
                    }
                }
                $(formMessages).text(errorMessage);

                // Re-enable submit button
                submitBtn.prop('disabled', false);
                submitBtn.html(originalText);
            });
        });

    });