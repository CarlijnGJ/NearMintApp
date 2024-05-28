class ValidateUser {
  // Method to validate the username
  bool validateUsername(String username) {
    String pattern = r'^[a-zA-Z0-9_]{3,16}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(username);
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

}