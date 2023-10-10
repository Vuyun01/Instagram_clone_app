import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/model/comment.dart' as cm;
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/service/post_service.dart';
import 'package:instagram_clone/utils/firebase_constant.dart';
import 'package:instagram_clone/utils/post_constant.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/comment.dart';
import 'package:instagram_clone/widgets/text_input_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../utils/constant.dart';

class CommentScreen extends StatefulWidget {
  static const String routeName = '/comment';

  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final _commentController = TextEditingController();
  final _postService = PostService();
  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)?.settings.arguments as Post;
    final user = context.read<UserProvider>().getUser;

    void _sendComment() async {
      if (_commentController.text.trim().isNotEmpty) {
        setState(() {
          _isLoading = true;
        });
        final commentId = const Uuid().v1();
        final cm.Comment comment = cm.Comment(
            postId: post.postid,
            userId: user!.uid,
            username: user.username,
            commentId: commentId,
            commentDate: DateTime.now(),
            content: _commentController.text,
            avatar: user.avatar!);
        FocusScope.of(context).unfocus();
        _commentController.clear();
        await _postService
            .sendComment(postId: post.postid, comment: comment)
            .then((value) {
          if (value == 'success') {
            showSnackbar(context, 'Sent!', Colors.lightGreen);
          } else {
            showSnackbar(context, value, Colors.red);
          }
        });

        setState(() {
          _isLoading = false;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
        backgroundColor: mobileBackgroundColor,
        elevation: 5,
        shadowColor: Colors.grey.shade800,
      ),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collectionGroup(FirebaseConstant.commentCollection)
                .where('postId', isEqualTo: post.postid)
                .orderBy('commentDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              final docs = snapshot.data!.docs;
              return docs.isNotEmpty
                  ? ListView.builder(
                      reverse: true,
                      itemCount: docs.length,
                      itemBuilder: (context, index) => Comment(
                            comment: cm.Comment.fromJson(docs[index].data()),
                          ))
                  : const Center(
                      child: Text('Being a person who send the first comment'),
                    );
            },
          )),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(color: mobileBackgroundColor, boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Colors.grey.shade900,
                  blurRadius: 40)
            ]),
            child: Row(
              children: [
                Expanded(
                  child: TextInputField(
                      controller: _commentController,
                      hintText: 'Write a comment...',
                      textInputType: TextInputType.text,
                      validator: (value) => null),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _isLoading
                      ? const CircularProgressIndicator.adaptive()
                      : IconButton(
                          onPressed: _sendComment,
                          icon: const Icon(Icons.send)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
