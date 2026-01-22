import 'dart:developer';

import 'package:dronees/features/authorized/leave/models/selected_day.dart';

class TValidator {
  static String? validateFirstNameInput(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final RegExp regex = RegExp(r"^[a-zA-Z0-9 .'-]{2,50}$");

    if (!regex.hasMatch(value)) {
      return '$fieldName must be between 2 and 50 characters and can include letters, apostrophes, hyphens, and full stops.';
    }
    return null;
  }

  static String? validateDecimalInput(String fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    final decimalRegExp = RegExp(r'^\d+(\.\d+)?$');
    if (!decimalRegExp.hasMatch(value)) {
      return "Invalid $fieldName";
    }

    return null;
  }

  static String? leaveCategoryValidator(value) {
    if (value == null || value.isEmpty) {
      return "Please select leave category";
    }
    return null;
  }

  static String? validateEquipment(value) {
    if (value == null) {
      return "Please select equipment";
    }
    return null;
  }

  static String? validateTeamMember(value) {
    // log(
    //   "TValodator file line number ${value.toString()}",
    //   stackTrace: StackTrace.current,
    // );
    if (value == null || value.isEmpty) {
      return "Select at least one team member";
    }
    return null;
  }

  static String? validateAmount(value) {
    if (value == null || value.isEmpty) {
      return "Please enter amount";
    }
    // ^(?:\d+|\d*\.\d+)$
    final exp = RegExp(r'^(?:\d+|\d*\.\d+)$');
    if (exp.hasMatch(value)) {
      return null;
    }
    return "Invalid amount";
  }

  static String? validateNull(dynamic value, String message) {
    if (value == null) {
      return message;
    }
    return null;
  }

  static String? leavePurposeValidator(value) {
    if (value == null || value.isEmpty) {
      return "Please provide leave purpose";
    }
    return null;
  }

  static String? validateLeaveDuration(List<SelectedDay>? selectedDays) {
    if (selectedDays == null || selectedDays.isEmpty) {
      return 'Please select at least one day';
    }
    return null;
  }

  static String? dropdownValidator(
    String forDropdown,
    bool isVisible,
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return isVisible ? '$forDropdown is required' : null;
    }
    return null;
  }

  static String? validEmptyTextFieldOnVisible(
    String fieldName,
    isVisible,
    String? value,
  ) {
    if (value == null || value.isEmpty) {
      return isVisible ? '$fieldName is required' : null;
    }
    return null;
  }

  static String? validEmptyTextField(String fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateCaloriesInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Value is required';
    }
    if (int.parse(value) > 10000) {
      return "Value cannot be greater than 10000";
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(
      r'^((?!\.)[\w\-_.]*[^.])(@\w+)(\.\w+(\.\w+)?[^.\W])$',
    );

    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length (8 characters)
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }

    if (value.length > 32) {
      return 'Password must be at most 32 characters long.';
    }

    if (!value.contains(
      RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[ -\/:-@\[-\`{-~]{1,}).{8,32}$',
      ),
    )) {
      return 'Password must contain at least one number, uppercase, lowercase and special character.';
    }

    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required.';
    }
    if (password != value) {
      return "The password and confirmation password do not match.";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    String? subString = value?.substring(3);
    if (subString == null || subString.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^[6-9]\d{9}$');
    log(subString);
    log(phoneRegExp.hasMatch(subString).toString());
    if (!phoneRegExp.hasMatch(subString)) {
      return 'Invalid phone number format.';
    }

    return null;
  }

  static validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required.';
    } else if (value.length < 6) {
      return 'Invalid OTP!';
    }
    return null;
  }

  // Add more custom validators as needed for your specific requirements.

  static String? emptyValidator(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    if (value.length < 3) {
      return '$fieldName must be at least 3 characters';
    }
    return null;
  }

  static String? emailOrPhoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter Email or Phone';
    }
    // Basic validation example:
    if (RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value) ||
        RegExp(r'^\d{10}$').hasMatch(value)) {
      return null;
    }
    return 'Enter a valid Email or Phone Number';
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }
}
