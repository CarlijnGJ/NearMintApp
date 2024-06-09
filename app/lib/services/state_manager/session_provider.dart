import 'package:flutter/material.dart';
import 'session_manager.dart';
import 'session_events.dart';
import 'session_states.dart';

class SessionProvider with ChangeNotifier {
  final SessionManager _sessionManager = SessionManager();

  SessionState get currentState => _sessionManager.currentState;

  SessionProvider() {
    _sessionManager.handleEvent(AppStarted());
  }

  void handleEvent(SessionEvent event) {
    _sessionManager.handleEvent(event);
    notifyListeners();
  }

  void resetTimer() {
    _sessionManager.resetTimer();
    notifyListeners();
  }
}
