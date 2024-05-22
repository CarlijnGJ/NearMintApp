import 'package:app/screens/members/components/user.dart';

class UserService {
  final List<User> membersList;
  final int pageSize;

  UserService({required this.membersList, required this.pageSize});

    List<User> getUsersPerPage(int page) {
    final startIndex = (page * pageSize).clamp(0, membersList.length);
    final endIndex = (startIndex + pageSize).clamp(startIndex, membersList.length);
    return membersList.sublist(startIndex, endIndex);
  }
}
