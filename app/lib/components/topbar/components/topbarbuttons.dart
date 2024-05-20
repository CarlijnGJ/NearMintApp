import 'package:flutter/material.dart';

class TopbarLoginButton extends StatelessWidget {

  final Function()? onTap;

  const TopbarLoginButton({super.key, this.onTap});


  @override
  Widget build(BuildContext context){
    return TextButton(
          onPressed: () {
            Navigator.pop(context);
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
      onPressed: onTap != null ? () async {
        // Call onTap asynchronously if it's not null
        if (onTap != null) {
          await onTap!();
        }
        Navigator.pop(context);
        Navigator.pushNamed(context, '/');
      } : null, // Disable the button if onTap is null
      child: const Text('Logout'),
    );
  }
}

class TopbarHomeButton extends StatelessWidget {

  final Function()? onTap;

  const TopbarHomeButton({super.key, this.onTap});


  @override
  Widget build(BuildContext context){
    return SizedBox(
      width: 60, // Adjust the width as needed
      height: 60, // Adjust the height as needed
      child: IconButton(
        icon: Transform.scale(
          scale: 1.2, // Adjust the scale factor as needed
          child: Image.asset('near_mint_logo.png'),
        ),
        onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/');
        },
      ),
    );
  
  }
}

class TopbarMembersButton extends StatelessWidget {

  final Function()? onTap;

  const TopbarMembersButton({super.key, this.onTap});


  @override
  Widget build(BuildContext context){
    return TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/members');
          },
          child: const Text('members'),
        );
  
  }
}

class TopbarProfileButton extends StatelessWidget {

  final Function()? onTap;

  const TopbarProfileButton({super.key, this.onTap});


  @override
  Widget build(BuildContext context){
    return         TextButton(
  onPressed: () {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/profile');
  },
  child: const Column(
    children: [
      Icon(
        Icons.account_circle, // Change the icon to a profile icon
        size: 30, // Adjust the size of the icon as needed
      ),
      Text(
        'Profile',
        style: TextStyle(fontSize: 14), // Adjust the font size of the text as needed
      ),
    ],
  ),
);
  
  }
}