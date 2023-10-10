import 'package:flutter/material.dart';
import 'package:instagram_clone/model/comment.dart' as cm;
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class Comment extends StatelessWidget {
  const Comment({
    super.key,
    required this.comment,
  });
  final cm.Comment comment;
  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().getUser;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: user!.uid == comment.userId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (user.uid != comment.userId)
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(ProfileScreen.routeName,
                      arguments: comment.userId);
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(comment.avatar),
                )),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: user.uid != comment.userId
                        ? [
                            Colors.grey.shade800,
                            Colors.grey.shade700,
                          ]
                        : [
                            Colors.blue.shade400,
                            Colors.deepPurpleAccent.shade200,
                          ])),
            child: Text(comment.content),
          )
        ],
      ),
    );
  }
}
