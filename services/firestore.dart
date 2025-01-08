import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:internshala_assignment/utils/utils.dart';

class FirestoreService {
  final CollectionReference dataRef =
      FirebaseFirestore.instance.collection('savedData');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> saveData(
      {required String? text,
      required String? imgUrl,
      required BuildContext context}) async {
    if (text == null && imgUrl == null) {
      showSnackbar(context, "Cannot save empty data");
      return;
    }
    try {
      await dataRef.add({
        'text': text,
        'imgUrl': imgUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });
      showSnackbar(context, "Data saved successfully!");
    } catch (e) {
      showSnackbar(context, "Error saving data: $e");
    }
  }

  Future<String> uploadImageToStore(
      String childName, Uint8List file, String uid) async {
    try {
      Reference reference = _storage.ref(childName).child(uid);
      UploadTask uploadTask = reference.putData(
        file,
        SettableMetadata(
          contentType: "image/jpg",
        ),
      );

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }
}
