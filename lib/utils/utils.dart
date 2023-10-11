import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/home_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';
import 'package:intl/intl.dart';

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

String timeAgo(DateTime time) {
  final now = DateTime.now();
  final diff = now.difference(time);
  if (diff.inDays >= 8) {
    return DateFormat.yMMMEd().add_jm().format(time);
  } else if ((diff.inDays / 7).floor() >= 1) {
    return 'Last week';
  } else if (diff.inHours >= 1) {
    return '${diff.inHours} hours ago';
  } else if (diff.inMinutes >= 1) {
    return '${diff.inMinutes} minutes ago';
  }
  return 'Just now';
}

List<Widget> homeScreens = [
  const HomeScreen(),
  const SearchScreen(),
  const AddPostScreen(),
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
