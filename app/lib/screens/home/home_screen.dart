import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';
import 'package:app/screens/home/components/titlesection.dart';
import 'package:app/screens/home/components/navbutton.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoggedIn = false;
  String role = 'Visitor';
  bool isLoading = true;

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
            isLoading = false;
          });
        }
      } catch (e) {
        log('Error: $e');
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          isLoggedIn = false;
          role = 'Visitor';
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoleAndInitialize();
  }

  List<Widget> buildButtonsForRole() {
    if (role == 'Visitor') {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
      return [];
    } else if (role == 'Member') {
      return [
        NavButtonWithHover(
          assetname: '../assets/images/user-3-xxl.png',
          description: 'Profile',
          url: '/profile',
        ),
        NavButtonWithHover(
          assetname: '../assets/images/account-login-xxl.png',
          description: 'Log out',
          url: '/',
        ),
      ];
    } else if (role == 'Admin') {
      return [
        NavButtonWithHover(
          assetname: '../assets/images/user-3-xxl.png',
          description: 'Profile',
          url: '/profile',
        ),
        NavButtonWithHover(
          assetname: '../assets/images/add-user-2-xxl.png',
          description: 'Members',
          url: '/members',
        ),
        NavButtonWithHover(
          assetname: '../assets/images/account-login-xxl.png',
          description: 'Log out',
          url: '/',
        ),
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxBtnSize = screenWidth * 0.7;
    final double constrainedBtnSize = maxBtnSize > 250 ? 250 : maxBtnSize;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top + kToolbarHeight,
              ),
              const TitleSection(name: 'Welcome!'),
              const SizedBox(height: 16.0),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 950) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: buildButtonsForRole().map((button) {
                        return Flexible(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: button,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildButtonsForRole().map((button) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: button,
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavButtonWithHover extends StatefulWidget {
  final String assetname;
  final String description;
  final String url;

  const NavButtonWithHover({
    Key? key,
    required this.assetname,
    required this.description,
    required this.url,
  }) : super(key: key);

  @override
  _NavButtonWithHoverState createState() => _NavButtonWithHoverState();
}

class _NavButtonWithHoverState extends State<NavButtonWithHover> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    double maxSize = 250;
    double btnSize = MediaQuery.of(context).size.width * 0.8;
    if(btnSize > maxSize) {
      btnSize = maxSize;
    }
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, widget.url);
        },
        child: AnimatedContainer(

          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: isHovered ? btnSize * 1.1 : btnSize,
          height: isHovered ? btnSize * 1.1 : btnSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: isHovered ? Colors.grey.withOpacity(0.1) : Colors.white.withOpacity(0.1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                widget.assetname,
                height: btnSize * 0.6,
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
