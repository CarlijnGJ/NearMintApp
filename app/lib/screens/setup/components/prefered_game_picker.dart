import 'package:flutter/material.dart';

class PreferredGameDropdown extends StatelessWidget {
  final String initialValue;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  const PreferredGameDropdown({super.key, 
    required this.initialValue,
    this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate the width dynamically based on the screen size
    double screenWidth = MediaQuery.of(context).size.width;
    double dropdownWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;

    return SizedBox(
      width: dropdownWidth, // Use the calculated width here
      child: DropdownButtonFormField<String>(
        value: initialValue,
        decoration: InputDecoration(
          labelText: 'Preferred Game',
          errorText: errorText,
        ),
        items: <String>[
          'None',
          'Magic the Gathering',
          'Warhammer',
          'One piece card game',
          'Vanguard',
          'The Pokemon Trading Card Game',
          'Disney Lorcana',
          'Video Games',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
