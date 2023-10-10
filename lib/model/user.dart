// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:instagram_clone/utils/constant.dart';

class User {
  final String uid;
  final String username;
  final String email;
  final String password;
  final String? avatar;
  final String? bio;
  final List followers;
  final List following;
  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.password,
    this.avatar,
    this.bio,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'password': password,
      'bio': bio,
      'avatar': avatar ?? placeholderProfileImage,
      'followers': followers,
      'following': following
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        uid: json['uid'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        avatar: json['avatar'] ?? placeholderProfileImage,
        bio: json['bio'],
        followers: json['followers'],
        following: json['following']);
  }
}
