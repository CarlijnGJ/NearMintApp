class ValidateUser {
  // Method to validate the username
  bool validateBasicString(String basicString) {
    String pattern = r'^[a-zA-Z0-9_]{3,128}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(basicString);
  }

  // Method to validate the email
  bool validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  // Method to validate the phone number
  bool validatePhoneNumber(String phoneNumber) {
    String pattern = r'^(?:\+|00)?(?:\d\s?){10,15}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(phoneNumber);
  }

  // Method to validate the password
  bool validatePassword(String password) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{12,128}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }
}