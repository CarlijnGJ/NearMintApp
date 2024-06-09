// lib/session_manager.dart
import 'dart:async';
import 'session_events.dart';
import 'session_states.dart';

class SessionManager {
  Timer? _timer;
  SessionState _currentState = VisitorState();
  final int _timeoutDuration = 1800; // 30 minutes

  SessionState get currentState => _currentState;

  void handleEvent(SessionEvent event) {
    if (event is AppStarted) {
      _onAppStarted();
    } else if (event is LoggedIn) {
      _onLoggedIn(event);
    } else if (event is LoggedOut) {
      _onLoggedOut();
    }
  }

  void _onAppStarted() {
    _currentState = VisitorState();
    // Additional logic if needed
  }

  void _onLoggedIn(LoggedIn event) {
    switch (event.role) {
      case 'Member':
        _currentState = MemberState(event.sessionKey.toString());
        break;
      case 'Admin':
        _currentState = AdminState(event.sessionKey.toString());
        break;
      default:
        _currentState = VisitorState();
    }
    _startTimer();
  }

  void _onLoggedOut() {
    _currentState = VisitorState();
    _cancelTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(Duration(seconds: _timeoutDuration), _handleTimeout);
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  void _handleTimeout() {
    handleEvent(LoggedOut());
  }

  void resetTimer() {
    if (_currentState is! VisitorState) {
      _startTimer();
    }
  }
}
