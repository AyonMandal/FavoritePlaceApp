import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(BuildContext context) {
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
      child: TextButton.icon(
        onPressed: null,
        label: Text(
          'Take Picture',
          style:
              TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
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
      ),
    );
  }
}
