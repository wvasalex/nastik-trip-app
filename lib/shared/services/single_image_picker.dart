import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:journey/shared/shared.dart';
import 'package:image_picker/image_picker.dart';

class SingleImagePicker {
  static Future<String> pick(BuildContext context) {
    final StreamController<String> stream = StreamController<String>();

    BottomActionSheet.modal(context, [
      BottomActionSheetItem(
        onTap: () => _camera(context, stream),
        label: 'Сделать фото',
        icon: Icon(Icons.photo_camera),
      ),
      BottomActionSheetItem(
        onTap: () => _gallery(context, stream),
        label: 'Выбрать из галереи',
        icon: Icon(Icons.photo),
      ),
    ]);

    return stream.stream.firstWhere((_) {
      stream.close();
      return true;
    });
  }

  static void _camera(BuildContext context, StreamController<String> stream) async {
    final File file = await ImagePicker.pickImage(source: ImageSource.camera);
    if (file != null) {
      stream.add(file.path);
    }
  }

  static void _gallery(BuildContext context, StreamController<String> stream) async {
    final File file = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      stream.add(file.path);
    }
  }
}
