import 'package:app/util/role_util.dart';
import 'package:flutter/material.dart';

class CheckAuthUtil {
   // ignore: non_constant_identifier_names
   static void Admin(BuildContext context) async {
    var role = await RoleUtil.fetchRole();
    if (role != 'Admin') {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/error');
    }
  }
  // ignore: non_constant_identifier_names
  static void MemberOrAdmin(BuildContext context) async {
    var role = await RoleUtil.fetchRole();
    if (!(role == 'Admin' || role == 'Member')) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/error');
    }
  }
  // ignore: non_constant_identifier_names
  static void Visitor(BuildContext context) async {
    var role = await RoleUtil.fetchRole();
    if (!(role == 'Visitor')) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, '/error');
    }
  }
}
