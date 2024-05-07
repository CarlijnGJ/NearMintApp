import 'package:app/home.dart';
import 'package:flutter/material.dart';

/// Flutter code sample for [AppBar].

void main() => runApp(const AppBarApp());

class AppBarApp extends StatelessWidget {
  const AppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TopBar(),
    );
  }
}

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Near Mint Gaming'),
        actions: const <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 5),
              child: Icon(Icons.more_horiz)),
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 20),
              child: Text('Login')),
        ],
      ),
      body: const Center(
        child: HomePage(),
      ),
    );
  }
}
