import 'package:app/components/button.dart';
import 'package:app/components/textfield.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/members/components/user.dart';

class AddTransactionPage extends StatelessWidget {
  final User member;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();


  AddTransactionPage({required this.member});

  @override
  Widget build(BuildContext context) {
    // Check if the user is an admin and a valid member ID exists
    if (!isAdminUser() || member.id == null) {
      // Show a message or navigate back to previous screen if conditions are not met
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text(
            'Unauthorized access or invalid member',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add transaction to ${this.member.name}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Member ID:',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              member.id.toString(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            CustomTextField(controller: amountController, labelText: 'amount:', obscureText: false),       
            CustomTextField(controller: descriptionController, labelText: 'description:', obscureText: false),      
            CustomButton(text: 'Add transaction', onTap: addTransaction()),

          ],
        ),
      ),
    );
  }

  bool isAdminUser() {
    // Implement your logic to check if the user is an admin
    // Return true if user is admin, false otherwise
    return true; // Example: Always returns true for demonstration
  }
  
  addTransaction() {
    //api call
  }
}
