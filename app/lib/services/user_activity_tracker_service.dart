import 'dart:async';
import 'package:app/events/refrest_widget_after_session_update_event.dart';
import 'package:app/services/api_service.dart';
import 'package:app/events/login_events.dart';
import 'package:app/util/eventbus_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserActivityTracker extends StatefulWidget {
  final Widget child;
  final Duration idleTimeout;

  const UserActivityTracker({required this.child, required this.idleTimeout});

  @override
  _UserActivityTrackerState createState() => _UserActivityTrackerState();
}

class _UserActivityTrackerState extends State<UserActivityTracker> {
  Timer _activityTimer = Timer(Duration(seconds: 5), () {});
  Timer _idleTimer = Timer(Duration(seconds: 5), () {});
  Timer? _keepAliveTimer;

  bool _isUserActive = false;
  bool _isUserLoggedIn = false;
  Duration _activityCheckInterval = Duration(seconds: 5);
  Duration _keepAliveInterval = Duration(minutes: 1);

  @override
  void initState() {
    _initUserState();
    super.initState();
    // Subscribe to login and logout events
    eventBus.on<LoginEvent>().listen((event) {
      print("fire login event");
      setState(() {
        _isUserLoggedIn = true;
        _startKeepAliveTimer();
      });
    });
    eventBus.on<LogoutEvent>().listen((event) {
      print("fire logout event");
      setState(() {
        _isUserLoggedIn = false;
        _idleTimer.cancel();
        _activityTimer.cancel();
        _keepAliveTimer?.cancel();
      });
    });
  }

  Future<void> _initUserState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        setState(() {
          _isUserLoggedIn = true;
        });
      } else {
        print('session key not found');
      }
      eventBus.fire(RefreshWidgetAfterSessionUpdateEvent());
    } catch (e) {
      print("Logout failed: $e");
    }

    if (_isUserLoggedIn) {
      _resetActivityTimer();
    }
  }

  @override
  void dispose() {
    _activityTimer.cancel();
    _idleTimer.cancel();
    super.dispose();
  }

  void _startIdleTimer() {
    _idleTimer.cancel();
    _idleTimer = Timer(widget.idleTimeout, _onUserIdle);
  }

  void _resetActivityTimer() {
    _activityTimer.cancel();
    _activityTimer = Timer(_activityCheckInterval, _checkUserActivity);
  }

  Future<void> _onUserIdle() async {
    // Perform logout or other actions when user is idle
    setState(() {
      _isUserActive = false;
      _isUserLoggedIn = false;
    });
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    if (sessionKey != null) {
      await APIService.logout(sessionKey);
      await prefs.remove(
          'session_key'); // Remove the session key from SharedPreferences
      eventBus.fire(LogoutEvent());
    } else {
      print('session key not found');
    }
    // Navigate to the home page
    print("Refresh buttons homepage");
    eventBus.fire(RefreshWidgetAfterSessionUpdateEvent());
    print('User is idle. Logging out...');
  }

  void _onUserActivity(PointerEvent details) {
    if (!_activityTimer.isActive && _isUserLoggedIn) {
      setState(() {
        _isUserActive = true;
      });
      print('User is active.');
      _resetActivityTimer();
    }
  }

  void _checkUserActivity() {
    if (_isUserActive && _isUserLoggedIn) {
      _startIdleTimer();
      _isUserActive = false;
      print('User is idle for a bit');
    }
  }

  void _startKeepAliveTimer() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(_keepAliveInterval, (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        bool isAlive = await APIService.keepSessionAlive(sessionKey);
        if (!isAlive) {
          eventBus.fire(LogoutEvent());
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onUserActivity,
      child: widget.child,
    );
  }
}
