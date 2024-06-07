import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:flutter/material.dart';

class ErrorUtil {

  static List<String?> generateSetupErrors(List<TextEditingController> controllers) {
    List<String?> errors = List.filled(5, null);
    if (!ValidateUser.validateBasicString(controllers[0].text)) {
      errors[0] = 'Invalid username';
    }

    if (!ValidateUser.validatePassword(controllers[1].text)) {
      errors[1] = 'Invalid password';
    }

    if (controllers[1].text != controllers[2].text) {
      errors[2] = 'Passwords don\'t match';
    }

    if (!ValidateUser.validateBasicString(controllers[3].text) && controllers[3].text != '') {
      errors[3] = 'Invalid gender';
    }

    if (!ValidateUser.validateBasicString(controllers[4].text) && controllers[4].text != '') {
      errors[4] = 'Invalid prefered game';
    }

    return errors;
  }

  static List<String?> generateEditErrors(List<TextEditingController> controllers) {
    List<String?> errors = List.filled(5, null);

    return errors;
  }

}