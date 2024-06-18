import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final String? errorText;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.labelText,
    this.hintText,
    required this.obscureText,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Calculate width based on screen size, scaling between 500 and 350
    double textFieldWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;

    return Center(
      child: Container(
        width: textFieldWidth,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelText != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    labelText!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: Colors.blue, // Set selection color to blue
                  ),
                ),
                child: TextField(
                  cursorColor: Colors.black, // Set cursor color to black

                  controller: controller,
                  obscureText: obscureText,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Colors.grey),
                    errorText: errorText,
                    errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)),
                    suffixIcon: errorText != null
                        ? const Icon(
                            Icons.error,
                            color: Colors.red,
                          )
                        : null,
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(128),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
