class ValidationService {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters long';
    }

    if (value.length > 50) {
      return 'Name must be less than 50 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }

    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 10) {
      return 'Phone number must be at least 10 digits';
    }

    if (digitsOnly.length > 15) {
      return 'Phone number must be less than 15 digits';
    }

    return null;
  }

  // Price validation
  static String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Price is required';
    }

    final price = double.tryParse(value);
    if (price == null) {
      return 'Please enter a valid number';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    if (price > 10000) {
      return 'Price cannot exceed \$10,000';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Minimum length validation
  static String? validateMinLength(
    String? value,
    int minLength,
    String fieldName,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters long';
    }

    return null;
  }

  // Maximum length validation
  static String? validateMaxLength(
    String? value,
    int maxLength,
    String fieldName,
  ) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must be less than $maxLength characters';
    }

    return null;
  }

  // Number validation
  static String? validateNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return 'Please enter a valid number for $fieldName';
    }

    return null;
  }

  // Integer validation
  static String? validateInteger(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (int.tryParse(value) == null) {
      return 'Please enter a valid whole number for $fieldName';
    }

    return null;
  }

  // URL validation
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  // Address validation
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address is required';
    }

    if (value.length < 10) {
      return 'Address must be at least 10 characters long';
    }

    if (value.length > 200) {
      return 'Address must be less than 200 characters';
    }

    return null;
  }

  // Service description validation
  static String? validateDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Description is required';
    }

    if (value.length < 20) {
      return 'Description must be at least 20 characters long';
    }

    if (value.length > 500) {
      return 'Description must be less than 500 characters';
    }

    return null;
  }

  // Rating validation
  static String? validateRating(double? value) {
    if (value == null) {
      return 'Rating is required';
    }

    if (value < 1 || value > 5) {
      return 'Rating must be between 1 and 5';
    }

    return null;
  }

  // Date validation
  static String? validateFutureDate(DateTime? value) {
    if (value == null) {
      return 'Date is required';
    }

    if (value.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }

    return null;
  }

  // Time validation
  static String? validateBusinessHours(String? value) {
    if (value == null || value.isEmpty) {
      return 'Time is required';
    }

    final timeRegex = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(value)) {
      return 'Please enter time in HH:MM format';
    }

    return null;
  }

  // Credit card validation (basic)
  static String? validateCreditCard(String? value) {
    if (value == null || value.isEmpty) {
      return 'Credit card number is required';
    }

    // Remove spaces and dashes
    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Invalid credit card number length';
    }

    // Basic Luhn algorithm check
    if (!_isValidCreditCard(cardNumber)) {
      return 'Invalid credit card number';
    }

    return null;
  }

  // CVV validation
  static String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'CVV is required';
    }

    if (value.length < 3 || value.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'CVV must contain only numbers';
    }

    return null;
  }

  // Expiry date validation
  static String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Expiry date is required';
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Expiry date must be in MM/YY format';
    }

    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || month < 1 || month > 12) {
      return 'Invalid month';
    }

    if (year == null) {
      return 'Invalid year';
    }

    final now = DateTime.now();
    final expiryDate = DateTime(2000 + year, month);

    if (expiryDate.isBefore(DateTime(now.year, now.month))) {
      return 'Card has expired';
    }

    return null;
  }

  // Helper method for credit card validation using Luhn algorithm
  static bool _isValidCreditCard(String cardNumber) {
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.tryParse(cardNumber[i]) ?? 0;

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  // Combine multiple validators
  static String? validateMultiple(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result;
      }
    }
    return null;
  }

  // Clean and format phone number
  static String formatPhoneNumber(String phoneNumber) {
    final digitsOnly = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length == 10) {
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      return '+1 (${digitsOnly.substring(1, 4)}) ${digitsOnly.substring(4, 7)}-${digitsOnly.substring(7)}';
    }

    return phoneNumber; // Return original if format is not recognized
  }

  // Clean and format price
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
}
