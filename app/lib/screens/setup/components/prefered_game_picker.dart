import 'package:flutter/material.dart';

class PreferredGameDropdown extends StatelessWidget {
  final String initialValue;
  final String? errorText;
  final ValueChanged<String?> onChanged;

  PreferredGameDropdown({
    required this.initialValue,
    this.errorText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),  // Set maximum width constraint
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
