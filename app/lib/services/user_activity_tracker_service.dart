import 'dart:async';
import 'package:flutter/material.dart';

class UserActivityTracker extends StatefulWidget {
  final Widget child;
  final Duration idleTimeout;

  UserActivityTracker({required this.child, required this.idleTimeout});

  @override
  _UserActivityTrackerState createState() => _UserActivityTrackerState();
}

class _UserActivityTrackerState extends State<UserActivityTracker> {
  Timer _activityTimer = Timer(Duration(seconds: 5), () {});
  Timer _idleTimer = Timer(Duration(seconds: 5), () {});
  bool _isUserActive = false;
  Duration _activityCheckInterval = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _startIdleTimer();
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

  void _onUserIdle() {
    // Perform logout or other actions when user is idle
    setState(() {
      _isUserActive = false;
    });
    print('User is idle. Logging out...');
  }

  void _onUserActivity(PointerEvent details) {
    if (!_isUserActive) {
      setState(() {
        _isUserActive = true;
      });
      print('User is active.');
    }
    _resetActivityTimer();
  }

  void _checkUserActivity() {
    if (_isUserActive) {
      _startIdleTimer();
      print('User is idle for a bit');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: _onUserActivity,
      child: widget.child,
    );
  }
}
