import 'package:flutter/material.dart';

class LifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Handle application lifecycle state changes here
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // The application is now visible and responding to user input.
        // You can handle session management logic here.
        print('App resumed');
        break;
      case AppLifecycleState.paused:
        // The application is not currently visible to the user.
        // You can pause ongoing tasks or save app state here.
        print('App paused');
        break;
      case AppLifecycleState.inactive:
        // The application is in an inactive state and is not receiving user input.
        // This state is entered before an application enters the 'paused' state.
        print('App inactive');
        break;
      case AppLifecycleState.detached:
        // The application is detached from the view hierarchy.
        // This is equivalent to the application being terminated.
        print('App detached');
        break;
      default:
        print('Default state');

        break;
    }
  }
}
