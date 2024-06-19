import 'package:flutter/material.dart';

class ProfileImagePicker extends StatefulWidget {
  final Map<String, String>? selectedImage;
  final ValueChanged<Map<String, String>?> onImageSelected;

  const ProfileImagePicker({super.key, 
    required this.selectedImage,
    required this.onImageSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProfileImagePickerState createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  late List<Map<String, String>> images;
  Map<String, String>? selectedImage;

  @override
  void initState() {
    super.initState();

    images = [
      {'name': 'Magic', 'path': 'images/profilepics/PFP1.png'},
      {'name': 'Sea', 'path': 'images/profilepics/PFP2.png'},
      {'name': 'Skull', 'path': 'images/profilepics/PFP3.png'},
      {'name': 'Vanguard', 'path': 'images/profilepics/PFP4.png'},
      {'name': 'Lorcana', 'path': 'images/profilepics/PFP5.png'},
      {'name': 'OnePiece', 'path': 'images/profilepics/PFP6.png'},
    ];

    // Ensure selectedImage is valid or fallback to the first image
    selectedImage = widget.selectedImage;
    if (selectedImage != null && !images.any((image) => image['path'] == selectedImage!['path'])) {
      // If the selectedImage is not among predefined images, add it to the list
      images.insert(0, {'name': 'Avatar', 'path': selectedImage!['path']!});
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double pickerWidth = screenWidth > 600 ? 500 : screenWidth * 0.9;

    return Center(
      child: SizedBox(
        width: pickerWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<Map<String, String>>(
              underline: Container(),
              isExpanded: true,
              hint: const Text('Select an image'),
              value: selectedImage,
              items: images.map((image) {
                return DropdownMenuItem<Map<String, String>>(
                  value: image,
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
              onChanged: (value) {
                setState(() {
                  selectedImage = value;
                  widget.onImageSelected(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
