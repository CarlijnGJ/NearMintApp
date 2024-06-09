// lib/session_states.dart
abstract class SessionState {}

class VisitorState extends SessionState {}

class MemberState extends SessionState {
  final String sessionKey;

  MemberState(this.sessionKey);
}

class AdminState extends SessionState {
  final String sessionKey;

  AdminState(this.sessionKey);
}
