import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/service/post_service.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/utils/firebase_constant.dart';

import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: size.width > mobileScreenSize
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              title: SvgPicture.asset(
                'assets/icons/ic_instagram.svg',
                width: size.width * 0.3,
                color: primaryColor,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                      onPressed: () {
                        // await PostService().fetchAllPosts();
                      },
                      icon: const Icon(Icons.chat_bubble)),
                )
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collectionGroup(FirebaseConstant.subPostCollection)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          // print(snapshot.data!.docs.length);
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          final docs = snapshot.data!.docs;
          return docs.isEmpty
              ? const Center(
                  child: Text('No post available'),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width > mobileScreenSize
                          ? size.width * 0.25
                          : 0),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final post = Post.fromJson(docs[index].data());
                      return PostCard(post: post);
                    },
                  ),
                );
        },
      ),
    );
  }
}
