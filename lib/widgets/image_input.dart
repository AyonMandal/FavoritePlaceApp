import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key, required this.onImageSelected});

  final void Function(File imageFile) onImageSelected;

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? selectedImage;
  void _takeImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);
    if (pickedImage == null) {
      return;
    }
    setState(() {
      selectedImage = File(pickedImage.path);
    });

    widget.onImageSelected(selectedImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takeImage,
      label: Text(
        'Take Picture',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      icon: Icon(
        Icons.camera,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      style: ButtonStyle(
        side: WidgetStatePropertyAll(
          BorderSide(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ), // Outline color
        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8.0), // Adjust border radius as needed
          ),
        ),
      ),
    );

    if (selectedImage != null) {
      content = GestureDetector(
        onTap: _takeImage,
        child: Image.file(
          selectedImage!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: content,
    );
  }
}
