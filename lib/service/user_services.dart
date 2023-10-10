import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/utils/firebase_constant.dart';
import 'package:instagram_clone/utils/post_constant.dart';
import 'package:instagram_clone/utils/user_constant.dart';
import 'package:instagram_clone/model/user.dart' as um;

class UserService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<QuerySnapshot<Map<String, dynamic>>?> searchUsersByKeyword(
      {required String keyword}) async {
    try {
      final res = await _firestore
          .collection(FirebaseConstant.userCollection)
          .where(UserConstant.username, isGreaterThanOrEqualTo: keyword)
          .get();
      print(res.docs.length);
      return res;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchUsersExceptId(
      {required String uid, int limit = 7}) async {
    try {
      final res = await _firestore
          .collection(FirebaseConstant.userCollection)
          .where(UserConstant.uid, isNotEqualTo: uid)
          .limit(limit)
          .get();
      // print(res.docs.length);
      return res;
    } catch (e) {
      print(e.toString());
    }

    return null;
  }

  Future<um.User?> getUserById({required String uid}) async {
    try {
      final res = await _firestore
          .collection(FirebaseConstant.userCollection)
          .doc(uid)
          .get();
      final user = res.exists ? um.User.fromJson(res.data()!) : null;
      return user;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<String> followUser(
      {required String uid, required String followerId}) async {
    var res = 'Something went wrong';
    // print('success');
    try {
      final user = await _firestore
          .collection(FirebaseConstant.userCollection)
          .doc(uid)
          .get();
      final userData = user.exists ? um.User.fromJson(user.data()!) : null;
      if (userData != null && userData.following.contains(followerId)) {
        await user.reference.update({
          UserConstant.following: FieldValue.arrayRemove([followerId])
        });
        await _firestore
            .collection(FirebaseConstant.userCollection)
            .doc(followerId)
            .update({
          UserConstant.followers: FieldValue.arrayRemove([uid])
        });
        res = 'unfollowed';
      } else {
        await user.reference.update({
          UserConstant.following: FieldValue.arrayUnion([followerId])
        });
        await _firestore
            .collection(FirebaseConstant.userCollection)
            .doc(followerId)
            .update({
          UserConstant.followers: FieldValue.arrayUnion([uid])
        });
        res = 'followed';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updateUser(
      {required String uid, required Map<String, dynamic> newData}) async {
    var res = 'Something went wrong';
    try {
      if (newData.isNotEmpty) {
        await _firestore
            .collection(FirebaseConstant.userCollection)
            .doc(uid)
            .update(newData);
        await _firestore
            .collection(FirebaseConstant.postCollection)
            .doc(uid)
            .collection(FirebaseConstant.subPostCollection)
            .where(PostConstant.uid, isEqualTo: uid)
            .get()
            .then((query) => query.docs.forEach((doc) {
                  doc.reference.update(newData);
                }));
        res = 'success';
      } else {
        res = 'Unable to update image profile';
      }
    } on FirebaseException catch (e) {
      res = e.message!;
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  
}
