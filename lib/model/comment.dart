// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String content;
  final String userId;
  final String username;
  final String avatar;
  final String postId;
  final DateTime commentDate;
  Comment({
    required this.commentId,
    required this.content,
    required this.userId,
    required this.username,
    required this.avatar,
    required this.postId,
    required this.commentDate,
  });
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'commentId': commentId,
      'content': content,
      'userId': userId,
      'username': username,
      'avatar': avatar,
      'postId': postId,
      'commentDate': commentDate,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    print(json['commentDate'].runtimeType);
    return Comment(
      commentId: json['commentId'] as String,
      content: json['content'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String,
      postId: json['postId'] as String,
      commentDate: (json['commentDate'] as Timestamp).toDate(),
    );
  }
}
