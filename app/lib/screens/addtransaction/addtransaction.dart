import 'package:app/components/button.dart';
import 'package:app/components/textfield.dart';
import 'package:app/screens/addmember/inputvalidation.dart';
import 'package:app/services/api_service.dart';
import 'package:app/util/auth_check_util.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/members/components/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTransactionPage extends StatefulWidget {
  final User? member;

  const AddTransactionPage({Key? key, required this.member}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddTransactionPageState createState() =>
      // ignore: no_logic_in_create_state
      _AddTransactionPageState(member: member);
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  String? amountError;
  String? desciptionError;
  final User? member;
  String? role;

  _AddTransactionPageState({required this.member});

  @override
  void initState() {
    CheckAuthUtil.Admin(context);
    super.initState();
    fetchRole().then((value) {
      setState(() {
        role = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == null) {
      return const CircularProgressIndicator();
    }

    if (role != 'Admin' || member == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text(
            'Unauthorized access or invalid member',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add transaction to ${member!.name}'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Member ID:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text(
              member!.id.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CustomTextField(
              controller: amountController,
              labelText: 'Amount:',
              obscureText: false,
              errorText: amountError,
            ),
            CustomTextField(
                controller: descriptionController,
                labelText: 'Description:',
                obscureText: false,
                errorText: desciptionError),
            const SizedBox(height: 10),
            CustomButton(
              text: 'Add Transaction',
              onTap: () async {
                bool success = await addTransaction(member!);
                if (success) {
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  Navigator.pushNamed(context, '/members'); 
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String> fetchRole() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final sessionKey = prefs.getString('session_key');
      if (sessionKey != null) {
        return APIService.getRole(sessionKey);
      }
      throw 'User';
    } catch (e) {
      setState(() {});
    }
    return 'User';
  }

  Future<bool> addTransaction(User member) async {
    amountError = null;
    desciptionError = null;
//convert ,s to .s
    amountController.text = amountController.text.replaceAll(',', '.');
    if (!ValidateUser.validateFloatingPointNumber(amountController.text)) {
      setState(() {
        amountError = 'Invalid amount';
      });
    }
    if (descriptionController.text != '' &&
        !ValidateUser.validateLongString(descriptionController.text)) {
      setState(() {
        desciptionError = 'Invalid description';
      });
    }
    if (amountError != null || desciptionError != null) {
      return false;
    }
    final prefs = await SharedPreferences.getInstance();
    final sessionKey = prefs.getString('session_key');
    try {
      await APIService.addTransaction(
          member.id,
          double.parse(amountController.text),
          descriptionController.text,
          DateTime.now().toString(),
          sessionKey!);
    } catch (e) {
      amountError = 'Failed to add transaction';
      return false;
    }
    return true;
  }
}
