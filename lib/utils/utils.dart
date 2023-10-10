import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

import '../service/auth_service.dart';
import '../widgets/auth_rounded_button.dart';

showSnackbar(BuildContext context, String content, Color backGroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: backGroundColor,
    content: Text(
      content,
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
    ),
  ));
}

List<Widget> homeScreens = [
  const HomeScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(
    child: Text('Wishlist'),
  ),
  const ProfileScreen()
];

class NoThumbScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
      };
}
