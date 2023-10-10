import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/service/auth_service.dart';
import 'package:instagram_clone/service/storage_service.dart';
import 'package:instagram_clone/utils/firebase_constant.dart';
import 'package:instagram_clone/utils/post_constant.dart';
import 'package:instagram_clone/model/comment.dart' as cm;
import 'package:uuid/uuid.dart';

class PostService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> uploadPost(
      {required String description, required Uint8List? image}) async {
    var res = 'Something went wrong';
    try {
      if (description.isNotEmpty && image != null) {
        final user = await AuthService().getUserDetails();
        final postUrl = await StorageService().uploadImageToStorage(
            user!.uid, FirebaseConstant.postImageStorage, image, true);
        final postid = Uuid().v1();
        final post = Post(
            uid: user.uid,
            username: user.username,
            postid: postid,
            description: description,
            likes: [],
            datePublished: DateTime.now(),
            postUrl: postUrl!,
            profileUrl: user.avatar!);
        final timestamp = Timestamp.now().seconds;
        await _firestore
            .collection(FirebaseConstant.postCollection)
            .doc(user.uid)
            .collection(FirebaseConstant.subPostCollection)
            .doc('${user.uid}-$timestamp')
            .set(post.toMap());
        res = 'success';
      } else {
        res = 'Please meet required fields before publish your post';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(
      {required String postId,
      required String userId,
      required List likes}) async {
    try {
      if (likes.contains(userId)) {
        await _firestore
            .collectionGroup(FirebaseConstant.subPostCollection)
            .where(PostConstant.postid, isEqualTo: postId)
            .get()
            .then((doc) {
          doc.docs.first.reference.update({
            PostConstant.likes: FieldValue.arrayRemove([userId])
          });
          print('removed');
        });
      } else {
        await _firestore
            .collectionGroup(FirebaseConstant.subPostCollection)
            .where(PostConstant.postid, isEqualTo: postId)
            .get()
            .then((doc) {
          doc.docs.first.reference.update({
            PostConstant.likes: FieldValue.arrayUnion([userId])
          });
          print('added');
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> sendComment(
      {required String postId, required cm.Comment comment}) async {
    var res = 'Something went wrong';
    try {
      await _firestore
          .collectionGroup(FirebaseConstant.subPostCollection)
          .where(PostConstant.postid, isEqualTo: postId)
          .get()
          .then((query) {
        query.docs.first.reference
            .collection(FirebaseConstant.commentCollection)
            .doc(comment.commentId)
            .set(comment.toMap());
      });
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deletePost(
      {required String postId, required String userId}) async {
    var res = 'Something went wrong';
    try {
      await _firestore
          .collection(FirebaseConstant.postCollection)
          .doc(userId)
          .collection(FirebaseConstant.subPostCollection)
          .where(PostConstant.postid, isEqualTo: postId)
          .get()
          .then((query) => query.docs.first.reference.delete());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> updatePost(
      {required String postId,
      required String userId,
      required Post post}) async {
    var res = 'Something went wrong';
    try {
      await _firestore
          .collection(FirebaseConstant.postCollection)
          .doc(userId)
          .collection(FirebaseConstant.subPostCollection)
          .where(PostConstant.postid, isEqualTo: postId)
          .get()
          .then((query) => query.docs.first.reference.update(post.toMap()));
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchPosts(
      [int limit = 10]) async {
    try {
      final res = await _firestore
          .collectionGroup(FirebaseConstant.subPostCollection)
          .limit(limit)
          .get();
      return res;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchPostsById(
      {required String uid}) async {
    try {
      final res = await _firestore
          .collectionGroup(FirebaseConstant.subPostCollection)
          .where(PostConstant.uid, isEqualTo: uid)
          .get();
      return res;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>?> fetchLikePostsById(
      {required String uid, int limit = 10}) async {
    try {
      final res = await _firestore
          .collectionGroup(FirebaseConstant.subPostCollection)
          .where(PostConstant.likes, arrayContains: uid)
          .limit(limit)
          .get();
      // print(res.size);
      return res;
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<void> updatePostUserProfileImage(
      {required String uid, required Map<String, dynamic> newData}) async {
    try {
      if (newData.isNotEmpty) {
        await _firestore
            .collection(FirebaseConstant.postCollection)
            .doc(uid)
            .collection(FirebaseConstant.subPostCollection)
            .where(PostConstant.uid, isEqualTo: uid)
            .get()
            .then((query) => query.docs.forEach((doc) {
                  doc.reference.update(newData);
                }));
      } 
    } on FirebaseException catch (e) {
      print(e.message!);
    } catch (e) {
      print(e.toString());
    }
  }
}
