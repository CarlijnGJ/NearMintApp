import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final controller;
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
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (labelText != null) // Add optional text above the input field
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    labelText!,
                    style: TextStyle(
                      color: Colors.white, // Change the color to white
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              TextField(
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
                  hintStyle: const TextStyle(color: Colors.grey), // Change the hint text color to light gray
                  errorText: errorText,
                  errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
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
            ],
          ),
        ),
      ),
    );
  }
}
