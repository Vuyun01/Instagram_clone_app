import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/screens/edit_post_screen.dart';
import 'package:instagram_clone/service/post_service.dart';
import 'package:instagram_clone/utils/enums.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/post.dart';
import '../service/auth_service.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
  });
  final Post post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;
  @override
  Widget build(BuildContext context) {
    final uid = AuthService().userID;
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.05),
      child: Column(
        children: [
          PostCardHeader(
            post: widget.post,
          ),
          GestureDetector(
            onDoubleTap: () async {
              await PostService().likePost(
                  postId: widget.post.postid,
                  likes: widget.post.likes,
                  userId: uid);
              setState(() {
                isAnimating = true;
              });
            },
            child: Stack(alignment: Alignment.center, children: [
              Container(
                height: size.height * 0.45,
                width: size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: widget.post.postUrl.isNotEmpty
                            ? NetworkImage(widget.post.postUrl)
                            : const NetworkImage(
                                'https://images.unsplash.com/photo-1694428275090-c8668a271519?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1932&q=80'))),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isAnimating ? 1 : 0,
                child: LikeAnimation(
                    isAnimating: isAnimating,
                    duration: const Duration(milliseconds: 400),
                    onEnd: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 70)),
              )
            ]),
          ),
          PostCardBody(
            post: widget.post,
          )
        ],
      ),
    );
  }
}

class PostCardHeader extends StatelessWidget {
  const PostCardHeader({
    super.key,
    required this.post,
  });
  final Post post;
  @override
  Widget build(BuildContext context) {
    final uid = AuthService().userID;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              post.profileUrl,
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              post.username,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          )),
          PopupMenuButton(
              onSelected: uid == post.uid
                  ? (value) {
                      if (value == PostPopUpOptions.delete) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text(
                                      'Do you want to delete this post?'),
                                  actions: [
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(10),
                                            backgroundColor: Colors.red),
                                        onPressed: () async {
                                          await PostService()
                                              .deletePost(
                                            postId: post.postid,
                                            userId: uid,
                                          )
                                              .then((value) {
                                            if (value == 'success') {
                                              showSnackbar(
                                                  context,
                                                  'Deleted this post successfully!',
                                                  Colors.lightGreen);
                                            } else {
                                              showSnackbar(context, value,
                                                  Colors.lightGreen);
                                            }
                                            Navigator.of(context).pop();
                                          });
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900),
                                        )),
                                    TextButton(
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.all(10),
                                            backgroundColor:
                                                Colors.grey.shade600),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Close',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900),
                                        )),
                                  ],
                                ));
                      } else {
                        Navigator.of(context).pushNamed(
                            EditPostScreen.routeName,
                            arguments: post);
                        print('Edit post');
                      }
                    }
                  : (value) {},
              icon: const Icon(Icons.more_horiz),
              itemBuilder: (context) => uid == post.uid
                  ? const [
                      PopupMenuItem(
                          value: PostPopUpOptions.delete,
                          child: Text('Delete')),
                      PopupMenuItem(
                          value: PostPopUpOptions.edit, child: Text('Edit')),
                    ]
                  : const [
                      PopupMenuItem(
                          value: PostPopUpOptions.report,
                          child: Text('Report')),
                    ])
        ],
      ),
    );
  }
}

class PostCardBody extends StatelessWidget {
  const PostCardBody({
    super.key,
    required this.post,
  });
  final Post post;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final uid = AuthService().userID;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            LikeAnimation(
              isAnimating: post.likes.contains(uid),
              smallLike: true,
              child: IconButton(
                  splashColor: Colors.transparent,
                  onPressed: () async {
                    await PostService().likePost(
                        postId: post.postid,
                        likes: post.likes,
                        userId: uid);
                  },
                  icon: post.likes.contains(uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.white,
                        )
                      : const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                        )),
            ),
            IconButton(
              splashColor: Colors.transparent,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(CommentScreen.routeName, arguments: post);
              },
              icon: const Icon(CupertinoIcons.chat_bubble),
            ),
            IconButton(
              splashColor: Colors.transparent,
              onPressed: () {},
              icon: const Icon(CupertinoIcons.location),
            ),
            const Spacer(),
            IconButton(
                splashColor: Colors.transparent,
                onPressed: () {},
                icon: const Icon(Icons.bookmark_outline))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            '${post.likes.length} likes',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 5),
          child: Text.rich(TextSpan(children: [
            TextSpan(
              text: '${post.username}: ',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: post.description,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w300),
            ),
          ])),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Text(
            'Posted: ${timeAgo(post.datePublished)}',
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w500, color: Colors.white70),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(CommentScreen.routeName, arguments: post);
            },
            child: Text(
              'View all comments',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.w500, color: Colors.white54),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 20),
          child: Row(
            children: [
              CircleAvatar(
                radius: size.width * 0.035,
                backgroundImage: NetworkImage(post.profileUrl),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'Add a comment...',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.white54),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
