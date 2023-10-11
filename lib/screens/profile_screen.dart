import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/service/post_service.dart';
import 'package:instagram_clone/service/storage_service.dart';
import 'package:instagram_clone/service/user_services.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/utils/firebase_constant.dart';
import 'package:instagram_clone/utils/post_constant.dart';
import 'package:instagram_clone/utils/user_constant.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/post.dart';
import '../service/auth_service.dart';
import '../widgets/follow_people_card.dart';
import '../widgets/headline_section.dart';
import '../widgets/profile_button.dart';
import 'package:instagram_clone/model/user.dart' as um;

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final StorageService _storageService = StorageService();

  @override
  void initState() {
    // print('init');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // print('data');
      getUserData(context);
    });
    super.initState();
  }

  void getUserData(BuildContext context) async {
    final guestUid = ModalRoute.of(context)!.settings.arguments as String?;
    if (guestUid != null) {
      final checkUser = await _authService.getUserDetails();
      _isFollowing = checkUser!.following.contains(guestUid);
      uid = guestUid;
    }
    _isUser = uid == _authService.userID;
    _user = await _userService.getUserById(uid: uid);
    _users = await _userService.fetchUsersExceptId(uid: uid).then(
          (value) =>
              value!.docs.map((e) => um.User.fromJson(e.data())).toList(),
        );
    _posts = await _postService.fetchLikePostsById(uid: uid).then(
        (value) => value!.docs.map((e) => Post.fromJson(e.data())).toList());
    final query = await _postService.fetchPostsById(uid: uid);
    _userPostsSize = query?.size ?? 0;
    _followers = _user!.followers.length;
    _following = _user!.following.length;
    // print(_user!.username);
    // print(_users[0]!.username);
    // print(_posts[0]!.likes);
    setState(() {
      _isLoading = false;
    });
  }

  void showFollowSnackBar(BuildContext context, String response) {
    if (response == 'followed') {
      showSnackbar(context, 'You followed this user', Colors.lightGreen);
    } else if (response == 'unfollowed') {
      showSnackbar(context, 'You unfollowed this user', Colors.grey.shade600);
    } else {
      showSnackbar(context, response, Colors.lightGreen);
    }
  }

  void _pickAndUpdateImage(ImageSource source) async {
    _image = await _storageService.uploadLocalImage(source).then((value) async {
      setState(() {
        _isLoading = true;
      });
      return await _storageService.uploadImageToStorage(
          _authService.userID, FirebaseConstant.profileImageStorage, value);
    });
    if (_image != null) {
      await _postService.updatePostUserProfileImage(
          uid: uid, newData: {PostConstant.profileUrl: _image});
      await _userService.updateUser(
          uid: uid, newData: {UserConstant.avatar: _image}).then((value) {
        if (value == 'success') {
          showSnackbar(context, 'Updated image profile successfully!',
              Colors.lightGreen);
        } else {
          showSnackbar(context, value, Colors.red);
        }
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  String? _image;
  var uid = AuthService().userID;
  um.User? _user;
  List<um.User?> _users = [];
  List<Post?> _posts = [];
  int _userPostsSize = 0;
  int _followers = 0;
  int _following = 0;
  bool _isUser = false;
  bool _isLoading = true;
  bool _isFollowing = false;
  @override
  Widget build(BuildContext context) {
    // print(user?.username);
    // print('build')
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: size.width > mobileScreenSize
          ? AppBar(
              backgroundColor: mobileBackgroundColor,
            )
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(_user?.username ?? 'N/A'),
              actions: [
                IconButton(
                    splashColor: Colors.transparent,
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await AuthService().logout();
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal:
                    size.width > mobileScreenSize ? size.width * 0.25 : 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(_image!),
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(_user?.avatar ??
                                      'https://images.unsplash.com/photo-1693917566028-c0f204817a97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80'),
                                ),
                          Positioned(
                              bottom: -5,
                              right: -3,
                              child: PopupMenuButton(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                icon: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 3)),
                                  child: const Icon(Icons.camera_alt),
                                ),
                                onSelected: (value) =>
                                    _pickAndUpdateImage(value),
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: ImageSource.camera,
                                    child: Text('Take a photo'),
                                  ),
                                  PopupMenuItem(
                                    value: ImageSource.gallery,
                                    child: Text('Select from gallery'),
                                  ),
                                ],
                              ))
                        ],
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DetailProfileColumnItem(
                                    label: 'Posts', value: _userPostsSize),
                                DetailProfileColumnItem(
                                    label: 'Following', value: _following),
                                DetailProfileColumnItem(
                                    label: 'Followers', value: _followers),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 10),
                              child: Row(
                                children: [
                                  _isUser
                                      ? ProfileButton(
                                          label: 'Edit profile',
                                          onTap: () {
                                            Navigator.of(context)
                                                .pushNamed(
                                                    EditProfileScreen.routeName,
                                                    arguments: _user)
                                                .then((value) {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              getUserData(context);
                                            });
                                          })
                                      : (_isFollowing
                                          ? ProfileButton(
                                              label: 'Following',
                                              onTap: () async {
                                                await _userService
                                                    .followUser(
                                                        uid:
                                                            _authService.userID,
                                                        followerId: uid)
                                                    .then((value) =>
                                                        showFollowSnackBar(
                                                            context, value));
                                                setState(() {
                                                  _isFollowing = false;
                                                  _followers--;
                                                });
                                              })
                                          : ProfileButton(
                                              color: Colors.lightBlue,
                                              label: 'Follow',
                                              onTap: () async {
                                                await _userService
                                                    .followUser(
                                                        uid:
                                                            _authService.userID,
                                                        followerId: uid)
                                                    .then((value) =>
                                                        showFollowSnackBar(
                                                            context, value));
                                                setState(() {
                                                  _isFollowing = true;
                                                  _followers++;
                                                });
                                              })),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ProfileButton(
                                    label: 'Share profile',
                                    onTap: () {
                                      print('anc');
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Text.rich(TextSpan(children: [
                    TextSpan(
                        text: '${_user?.username ?? 'N/A'}\n',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    TextSpan(
                        text: _user?.bio ?? 'N/A',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white60))
                  ])),
                ),
                _isUser
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HeadlineSection(
                            label: 'See all',
                            onTap: () {},
                            title: 'Discover people',
                          ),
                          SizedBox(
                            height: size.height * 0.3,
                            // color: Colors.cyan,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _users.length,
                                itemBuilder: (context, index) =>
                                    FollowPeopleCard(
                                        user: _users[index],
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              ProfileScreen.routeName,
                                              arguments: _users[index]!.uid);
                                        })),
                          )
                        ],
                      )
                    : const SizedBox(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Text(
                    'Discover published posts',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _posts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 2,
                            childAspectRatio: 1,
                            crossAxisCount: 3),
                    itemBuilder: (context, index) => Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _posts[index]!.postUrl,
                            fit: BoxFit.cover,
                          ),
                        )))
              ],
            ),
          ),
          if (_isLoading)
            Container(
              width: size.width,
              height: size.height,
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            )
        ]),
      ),
    );
  }
}

class DetailProfileColumnItem extends StatelessWidget {
  const DetailProfileColumnItem({
    super.key,
    required this.label,
    required this.value,
  });
  final String label;
  final int value;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white54),
        ),
      ],
    );
  }
}
