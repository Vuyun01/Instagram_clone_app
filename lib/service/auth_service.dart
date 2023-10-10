// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/model/user.dart' as um;
import 'package:instagram_clone/service/storage_service.dart';
import 'package:instagram_clone/utils/firebase_constant.dart';
import 'package:instagram_clone/utils/user_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<um.User?> getUserDetails() async {
    final doc = await _firestore
        .collection(FirebaseConstant.userCollection)
        .doc(userID)
        .get();
    final user = doc.exists ? um.User.fromJson(doc.data()!) : null;
    return user;
  }

  Future<String> register(
      {required String username,
      required String email,
      required String password,
      Uint8List? image,
      String? bio}) async {
    var res = "Something went wrong!";
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) async {
          final imageProfile = await StorageService().uploadImageToStorage(
              value.user!.uid, FirebaseConstant.profileImageStorage, image);
          var userCredentials = um.User(
              uid: value.user!.uid,
              username: username,
              email: email,
              password: password,
              avatar: imageProfile,
              bio: bio,
              followers: [],
              following: []);
          await _firestore
              .collection(FirebaseConstant.userCollection)
              .doc(value.user!.uid)
              .set(userCredentials.toMap());
          res = 'success';
        });
      }
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    var res = "Something went wrong!";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _firebaseAuth
            .signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  String get userID => _firebaseAuth.currentUser!.uid;
}
