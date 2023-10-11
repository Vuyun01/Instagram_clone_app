import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/service/post_service.dart';
import 'package:instagram_clone/service/storage_service.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:provider/provider.dart';

import '../utils/utils.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});
  static const String routeName = '/edit_post';

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  TextEditingController _captionController = TextEditingController();
  PostService _postService = PostService();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Uint8List? _image;
  String? postId;
  bool _isLoading = false;
  void _pickImage() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Take a photo',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                      ),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _image = await StorageService()
                      .uploadLocalImage(ImageSource.camera);

                  setState(() {});
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: Text('Choose from gallery',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16,
                        )),
                onPressed: () async {
                  Navigator.of(context).pop();
                  _image = await StorageService()
                      .uploadLocalImage(ImageSource.gallery);
                  setState(() {});
                },
              )
            ],
          );
        });
  }

  void _publishPost() async {
    setState(() {
      _isLoading = true;
    });
    final caption = _captionController.text;
    await _postService
        .updatePost(
      description: caption,
      image: _image,
      postid: postId!,
    )
        .then((value) {
      // print(_image);

      if (value == 'success') {
        _image = null;
        _captionController.clear();
        showSnackbar(context, 'You\'ve just published a post. Check it out',
            Colors.lightGreen);
        Navigator.of(context).pop();
      } else {
        showSnackbar(context, value, Colors.red);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().getUser;
    final post = ModalRoute.of(context)?.settings.arguments as Post?;
    postId = post!.postid;
    final size = MediaQuery.of(context).size;
    final inputBorder = OutlineInputBorder(
        borderSide: Divider.createBorderSide(context, color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(10));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        backgroundColor: mobileBackgroundColor,
        elevation: 5,
        shadowColor: Colors.grey.shade800,
        // centerTitle: true,
        actions: [
          TextButton(
              onPressed: _isLoading ? null : _publishPost,
              child: Text(
                'Publish',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.cyan,
                    fontWeight: FontWeight.w700,
                    fontSize: 16),
              ))
        ],
      ),
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal:
                  size.width > mobileScreenSize ? size.width * 0.25 : 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 20),
                        child: user?.avatar != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(user!.avatar!))
                            : const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/avatar.jpg'),
                              ),
                      ),
                      Expanded(
                          child: TextField(
                        controller: _captionController,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                          focusedBorder: inputBorder,
                          enabledBorder: inputBorder,
                          filled: true,
                          fillColor: Colors.white12,
                        ),
                      ))
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  width: size.width,
                  height: size.height * 0.4,
                  decoration: BoxDecoration(
                      image: _image != null
                          ? DecorationImage(image: MemoryImage(_image!))
                          : null,
                      color: Colors.white12,
                      border: Border.all(color: Colors.blueGrey),
                      borderRadius: BorderRadius.circular(10)),
                  child: _image != null
                      ? null
                      : const Center(child: Text('No selected image')),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30)),
                  child: Text(
                    'Add a photo',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                )
              ],
            ),
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
    );
  }
}
