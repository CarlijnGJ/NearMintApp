import 'dart:async';
import 'package:app/events/refrest_widget_after_session_update_event.dart';
import 'package:app/services/api_service.dart';
import 'package:app/events/login_events.dart';
import 'package:app/util/eventbus_util.dart';
import 'package:app/util/navigate_util.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserActivityTracker extends StatefulWidget {
  final Widget child;

  const UserActivityTracker({super.key, required this.child});

  @override
  // ignore: library_private_types_in_public_api
  _UserActivityTrackerState createState() => _UserActivityTrackerState();
}

class _UserActivityTrackerState extends State<UserActivityTracker> {
  bool _isUserActive = false;
  bool _isUserLoggedIn = false;

  //Double to make sure the timers are started correctlys
  final Duration _activityCheckInterval = const Duration(minutes: 10);
  final Duration _idleCheckInterval = const Duration(minutes: 10);
  final Duration _keepAliveInterval = const Duration(hours: 1);

  Timer _activityTimer = Timer(const Duration(minutes: 10), () {});
  Timer _idleTimer = Timer(const Duration(minutes: 10), () {});
  Timer _keepAliveTimer = Timer(const Duration(hours: 1), () {});

  @override
  void initState() {
    _initUserState();
    super.initState();
    // Subscribe to login and logout events
    eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        _isUserLoggedIn = true;
        _startKeepAliveTimer();
      });
    });
    eventBus.on<LogoutEvent>().listen((event) {
      setState(() {
        _isUserLoggedIn = false;
        _idleTimer.cancel();
        _activityTimer.cancel();
        _keepAliveTimer.cancel();
      });
      NavigateUtil.navigateToHome(context);
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
      }
      eventBus.fire(RefreshWidgetAfterSessionUpdateEvent());
    } catch (e) {
      // Handle error logic
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
    _idleTimer = Timer(_idleCheckInterval, _onUserIdle);
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
    } else {}
    // Navigate to the home page
    eventBus.fire(RefreshWidgetAfterSessionUpdateEvent());
  }

  void _onUserActivity(PointerEvent details) {
    if (!_activityTimer.isActive && _isUserLoggedIn) {
      setState(() {
        _isUserActive = true;
      });
      _resetActivityTimer();
    }
  }

  void _checkUserActivity() {
    if (_isUserActive && _isUserLoggedIn) {
      _startIdleTimer();
      _isUserActive = false;
    }
  }

  void _startKeepAliveTimer() {
    _keepAliveTimer.cancel();
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
