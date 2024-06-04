class ValidateUser {
  // Method to validate the username
  static bool validateBasicString(String basicString) {
    String pattern = r'^[a-zA-Z0-9_ ]{3,128}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(basicString);
  }

  static bool validateLongString(String longString) {
    String pattern = r'^[\w !@#$%^&*()-+=\[\]{};:\"|<>,.?/]{3,255}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(longString);
  }

  // Method to validate the email
  bool validateEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,128}$';
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
  static bool validatePassword(String password) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{12,128}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }
  
  static bool validateToken(String token){
    String pattern = r'^[0-9a-zA-Z]{6}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(token);
  }

  static bool validateFloatingPointNumber(String number){
    //number from 0 to 999.99 
    String pattern = r'^\d{1,3}(\.\d{1,2})?$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(number);
  }
}