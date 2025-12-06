/**
 * Internationalization (i18n) Handler
 * Handles language switching and dynamic content translation
 */

const I18n = {
    /**
     * Change language by reloading page with lang parameter
     */
    changeLanguage: function(lang) {
        const currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set('lang', lang);
        window.location.href = currentUrl.toString();
    },

    /**
     * Get current language from cookie or default to 'vi'
     */
    getCurrentLanguage: function() {
        const cookies = document.cookie.split(';');
        for (let cookie of cookies) {
            const [name, value] = cookie.trim().split('=');
            if (name === 'locale') {
                return value || 'vi';
            }
        }
        return 'vi'; // Default to Vietnamese
    },

    /**
     * Update language selector to reflect current language
     */
    updateLanguageSelector: function() {
        const currentLang = this.getCurrentLanguage();
        const selector = document.getElementById('languageSelect');
        if (selector) {
            // Handle both 'vi' and 'vi_VN' format
            const langCode = currentLang.split('_')[0];
            if (langCode === 'vi' || langCode === 'en') {
                selector.value = langCode;
            } else {
                selector.value = 'vi'; // Default to Vietnamese
            }
        }
    },

    /**
     * Initialize i18n on page load
     */
    init: function() {
        this.updateLanguageSelector();
    }
};

// Initialize on DOM ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => I18n.init());
} else {
    I18n.init();
}

// Global function for language change (called from select onchange)
function changeLanguage(lang) {
    I18n.changeLanguage(lang);
}

