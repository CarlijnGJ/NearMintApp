import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/screens/setup/components/textfield.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  _SetupPageState createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {

  final nicknameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Stack(
                children: [
                  const TealGradLeft(),
                  const TealGradRight(),
                  SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          const Text(
                            'Credentials',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // username textfield
                          CustomTextField(
                            controller: nicknameController,
                            hintText: 'Nickname',
                            obscureText: false,
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: passwordController,
                            hintText: 'Password',
                            obscureText: true,
                          ),

                          const SizedBox(height: 10),

                          CustomTextField(
                            controller: passwordController,
                            hintText: 'Repeat Password',
                            obscureText: true,
                          ),

                          const SizedBox(height: 10),

                          const Divider(),

                          const Text('or use the QR code'),

                          const Icon(Icons.qr_code_2_rounded, size: 180),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}