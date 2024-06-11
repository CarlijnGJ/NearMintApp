import 'package:flutter/material.dart';

class TopbarLoginButton extends StatelessWidget {
  final Function()? onTap;

  const TopbarLoginButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/login');
      },
      child: const Text('login'),
    );
  }
}

class TopbarLogoutButton extends StatelessWidget {
  final Function()? onTap;

  const TopbarLogoutButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap != null
          ? () async {
              if (onTap != null) {
                await onTap!();
              }
              Navigator.pop(context); // Close the current screen
              Navigator.pushNamed(context, '/');
            }
          : null,
      child: const Text('Logout'),
    );
  }
}

class TopbarHomeButton extends StatelessWidget {
  final Function()? onTap;

  const TopbarHomeButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: IconButton(
        icon: Transform.scale(
          scale: 1.2,
          child: Image.asset('near_mint_logo.png'),
        ),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/',
            (route) => false, // Remove all routes except the home route
          );
        },
      ),
    );
  }
}

class TopbarMembersButton extends StatelessWidget {
  final Function()? onTap;

  const TopbarMembersButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/members');
      },
      child: const Text('members'),
    );
  }
}

class TopbarProfileButton extends StatelessWidget {
  final Function()? onTap;

  const TopbarProfileButton({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushNamed(context, '/profile');
      },
      child: Column(
        children: [
          Icon(
            Icons.account_circle,
            size: 30,
          ),
          Text(
            'Profile',
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
