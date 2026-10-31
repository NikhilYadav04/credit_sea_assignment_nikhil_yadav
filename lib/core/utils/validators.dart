class Validators {
  Validators._();

  static final _mobile = RegExp(r'^[6-9]\d{9}$');
  static final _email = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final _pan = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
  static final _special = RegExp(r'[^A-Za-z0-9]');

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return 'Please enter $fieldName';
    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.isEmpty) return 'Enter your mobile number';
    if (!_mobile.hasMatch(value)) return 'Enter a valid 10 digit mobile number';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your email ID';
    if (!_email.hasMatch(value.trim())) return 'Enter a valid email ID';
    return null;
  }

  static String? pan(String? value) {
    final pan = (value ?? '').toUpperCase();
    if (pan.isEmpty) return 'Enter your PAN number';
    if (pan.length < 10) return 'PAN must be 10 characters';
    if (!_pan.hasMatch(pan)) return 'PAN format is 5 letters, 4 digits, 1 letter';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Enter a password';
    if (value.length < 8) return 'Use at least 8 characters';
    if (!_special.hasMatch(value)) return 'Include at least 1 special character';
    return null;
  }

  static String? Function(String?) confirmPassword(String Function() original) {
    return (value) {
      if (value == null || value.isEmpty) return 'Re-enter your password';
      if (value != original()) return 'Passwords do not match';
      return null;
    };
  }

  static int ageOn(DateTime dob, DateTime today) {
    var age = today.year - dob.year;
    final hadBirthday =
        today.month > dob.month || (today.month == dob.month && today.day >= dob.day);
    if (!hadBirthday) age--;
    return age;
  }
}
