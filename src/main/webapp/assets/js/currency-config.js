// Currency Configuration for Hotel Booking System

const CurrencyConfig = {
    // Exchange rate: 1 USD = X VND
    VND_TO_USD_RATE: 25000,
    
    // Display currency
    DISPLAY_CURRENCY: 'USD',
    
    // Base currency in database
    BASE_CURRENCY: 'VND',
    
    // Convert VND to display currency
    convertToDisplayCurrency: function(amountInVND) {
        return amountInVND / this.VND_TO_USD_RATE;
    },
    
    // Convert display currency to VND
    convertToVND: function(amountInDisplayCurrency) {
        return amountInDisplayCurrency * this.VND_TO_USD_RATE;
    },
    
    // Format for display
    formatCurrency: function(amountInVND, options = {}) {
        const amountInDisplayCurrency = this.convertToDisplayCurrency(amountInVND);
        
        const defaultOptions = {
            style: 'currency',
            currency: this.DISPLAY_CURRENCY,
            minimumFractionDigits: 0,
            maximumFractionDigits: 0
        };
        
        const formatOptions = { ...defaultOptions, ...options };
        
        return new Intl.NumberFormat('en-US', formatOptions).format(amountInDisplayCurrency);
    }
};

// Make available globally
window.CurrencyConfig = CurrencyConfig;



