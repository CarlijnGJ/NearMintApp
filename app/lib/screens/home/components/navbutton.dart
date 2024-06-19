import 'package:app/events/login_events.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/services/api_service.dart';
import 'package:app/util/eventbus_util.dart';

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
    if (btnSize > maxSize) {
      btnSize = maxSize;
    }
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () async {
          if (widget.description == 'Log out') {
            eventBus.fire(LogoutEvent());
          }
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
                style: const TextStyle(
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
