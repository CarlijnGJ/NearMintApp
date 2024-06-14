import 'package:flutter/material.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? selectedImage;
  final List<Map<String, String>> images;
  final ValueChanged<String?> onImageSelected;

  ProfileImagePicker({
    required this.selectedImage,
    required this.images,
    required this.onImageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (selectedImage != null && selectedImage!.isNotEmpty)
          Image.asset(selectedImage!, width: 200, height: 200)
        else
          const SizedBox.shrink(),
        const SizedBox(height: 10),
        DropdownButton<String>(
          hint: const Text('Select an image'),
          value: selectedImage,
          items: images.map((image) {
            return DropdownMenuItem<String>(
              value: image['path'],
              child: Row(
                children: [
                  Image.asset(
                    image['path']!,
                    width: 50,
                    height: 50,
                  ),
                  const SizedBox(width: 10),
                  Text(image['name']!),
                ],
              ),
            );  
          }).toList(),
          onChanged: onImageSelected,
        ),
      ],
    );
  }
}
