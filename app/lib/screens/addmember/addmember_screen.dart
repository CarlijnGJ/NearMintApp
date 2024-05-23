
import 'package:app/components/tealgradleft.dart';
import 'package:app/components/tealgradright.dart';
import 'package:app/components/topbar/topbar.dart';
import 'package:app/components/textfield.dart';
import 'package:app/components/button.dart';
import 'package:flutter/material.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({Key? key}) : super(key: key);

  @override
  _AddMemberPageState createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final phonenumberController = TextEditingController();


  void addMember() async {
    final username = usernameController.text;
    final email = emailController.text;
    final phonenumber = phonenumberController.text;

    try{
      //add to database
      //send email
    }

    catch(e){
      print('Adding member failed!');
    }
  }

    @override
  void initState() {
    super.initState();
    // check role
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TopBar(),
        body: Stack(
          children: [
            const TealGradLeft(),
            const TealGradRight(),
            SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      'Add Member',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // username textfield
                    CustomTextField(
                      controller: usernameController,
                      hintText: 'Username',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    // password textfield
                    CustomTextField(
                      controller: emailController,
                      hintText: 'Email',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    CustomTextField(
                      controller: phonenumberController,
                      hintText: 'Phone number',
                      obscureText: false,
                    ),

                    const SizedBox(height: 10),

                    CustomButton(text: 'Send code', onTap: addMember),
                  ],
                ),
              ),
            ),
          ],
        ));
  }


}