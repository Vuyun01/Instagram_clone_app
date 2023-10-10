// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String uid;
  final String username;
  final String postid;
  final String description;
  final List likes;
  final DateTime datePublished;
  final String postUrl;
  final String profileUrl;
  Post({
    required this.uid,
    required this.username,
    required this.postid,
    required this.description,
    required this.likes,
    required this.datePublished,
    required this.postUrl,
    required this.profileUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'username': username,
      'postid': postid,
      'description': description,
      'likes': likes,
      'datePublished': datePublished,
      'postUrl': postUrl,
      'profileUrl': profileUrl,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    // print(json['datePublished'].runtimeType);

    return Post(
      uid: json['uid'] as String,
      username: json['username'] as String,
      postid: json['postid'] as String,
      description: json['description'] as String,
      likes: json['likes'] as List,
      datePublished: (json['datePublished'] as Timestamp).toDate(),
      postUrl: json['postUrl'] as String,
      profileUrl: json['profileUrl'] as String,
    );
  }
}
