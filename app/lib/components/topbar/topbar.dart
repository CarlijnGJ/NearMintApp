import 'dart:async';

import 'package:app/components/topbar/components/topbarbuttons.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home/home_screen.dart';
import 'package:event_bus/event_bus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';


EventBus eventBus = EventBus();

class RefreshTopbarEvent {
  final bool isLoggedIn;

  RefreshTopbarEvent(this.isLoggedIn);
}

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  _TopBarState createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  late Widget currentScreen;
  bool isLoggedIn = false;
  String role = 'Visitor';
  String loginButtonText = 'Login'; // Default text for login button

  late StreamSubscription<RefreshTopbarEvent> _eventSubscription;

  @override
  void initState() {
    _eventSubscription = eventBus.on<RefreshTopbarEvent>().listen((event) {
      if (event.isLoggedIn != isLoggedIn) {
        fetchRoleAndInitialize();
      } else {
        if (mounted) {
          setState(() {
            isLoggedIn = event.isLoggedIn;
            loginButtonText = isLoggedIn ? 'Logout' : 'Login';
          });
        }
      }
    });
    fetchRoleAndInitialize();
    super.initState();
    currentScreen = const HomePage();
  }

  @override
  void dispose() {
    _eventSubscription.cancel(); // Remove the event listener
    super.dispose();
  }

  Future<void> fetchRoleAndInitialize() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    if (sessionKey != null) {
      try {
        final newRole = await APIService.getRole(sessionKey);
        if (mounted) {
          setState(() {
            isLoggedIn = true;
            role = newRole;
            loginButtonText = 'Logout';
          });
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      if (mounted) {
        setState(() {
          isLoggedIn = false;
          role = 'Visitor';
          loginButtonText = 'Login';
        });
      }
    }
  }

  Future<void> onTap() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    if(sessionKey != null){
      await APIService.logout(sessionKey);
      await prefs.remove('session_key'); // Remove the session key from SharedPreferences
    }
    else{
      print('session key not found');
    }
    eventBus.fire(RefreshTopbarEvent(false));
  } catch (e) {
    print("Logout failed: $e");
  }

    //     try {
    //   // Call the login method from APIService
    //   // final token = 
    //   await APIService.login(username, password);
    //   // SharedPreferences prefs = await SharedPreferences.getInstance();
    //   // final sessionKey = token['session_key'];
    //   // prefs.setString('session_key', sessionKey);

    //   eventBus.fire(RefreshTopbarEvent(true));
    // } catch (e) {
    //   // Handle login error (e.g., show an error message)
    //   print('Login failed: $e');
    
  }

  Future<List<Widget>> getTopbarButtons(String role) async {
  if (role == 'Admin') {
    return <Widget>[
      TopbarMembersButton(),
      TopbarProfileButton(),
      TopbarLogoutButton(onTap: onTap), // Remove await here
    ];
  } else if (role == 'Member') {
    return <Widget>[
      TopbarProfileButton(),
      TopbarLogoutButton(onTap: onTap), // Remove await here
    ];
  } else {
    return <Widget>[
      TopbarLoginButton(),
    ];
  }
}

@override
Widget build(BuildContext context) {
  return FutureBuilder<List<Widget>>(
    future: getTopbarButtons(role),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Display a loading indicator if data is still loading
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        // Display an error message if an error occurred
        return Text('Error: ${snapshot.error}');
      } else {
        // Display the AppBar with fetched top bar buttons
        return AppBar(
          title: const TopbarHomeButton(),
          actions: snapshot.data ?? [], // Use snapshot data as the actions
        );
      }
    },
  );
}
}