import 'package:app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoleUtil {
    static Future<String> fetchRole() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        return APIService.getRole(sessionKey);
      }
      throw 'User';
    } catch (e) {
      return 'User';
      // setState(() {
      //   isError = true;
      //   errorMessage = 'Failed to fetch member data: $e';
      // });
    }
    return 'User';
  }
}