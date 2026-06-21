import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  static String? email(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;

    final pattern = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,}$');
    if (!pattern.hasMatch(value!.trim())) {
      return AppStrings.invalidEmail;
    }
    return null;
  }

  static String? password(String? value) {
    final requiredError = required(value);
    if (requiredError != null) return requiredError;

    if (value!.length < 6) {
      return AppStrings.passwordTooShort;
    }
    return null;
  }

  static String? Function(String?) confirmPassword(String original) {
    return (value) {
      final requiredError = required(value);
      if (requiredError != null) return requiredError;

      if (value != original) {
        return AppStrings.passwordMismatch;
      }
      return null;
    };
  }
}