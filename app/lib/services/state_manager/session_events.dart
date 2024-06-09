// lib/session_events.dart
abstract class SessionEvent {}

class AppStarted extends SessionEvent {}

class LoggedIn extends SessionEvent {
  String? role;
  String? sessionKey;

  LoggedIn(this.role, this.sessionKey);
}

class LoggedOut extends SessionEvent {}
