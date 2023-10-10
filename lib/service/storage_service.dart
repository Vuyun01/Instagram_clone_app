import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Uint8List?> uploadLocalImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      final selectedImage = await image.readAsBytes();
      return selectedImage;
    }
    return null;
  }

  Future<String?> uploadImageToStorage(
      String uid, String path, Uint8List? image,
      [bool isPost = false]) async {
    if (image != null) {
      late Reference ref;
      if (isPost) {
        final timestamp = Timestamp.now().seconds;
        ref = _storage.ref().child(path).child('$uid-$timestamp');
      } else {
        ref = _storage.ref().child(path).child(uid);
      }
      TaskSnapshot task = await ref.putData(image);
      final imageLink = await task.ref.getDownloadURL();
      return imageLink;
    }
    return null;
  }
}
