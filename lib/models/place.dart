import 'dart:io';

import 'package:uuid/uuid.dart';

class Place {
  final String title;
  final String id;
  final File image;

  Place({required this.title, required this.image}) : id = const Uuid().v4();
}
