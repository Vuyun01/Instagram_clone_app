import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/service/auth_service.dart';
import 'package:instagram_clone/utils/validation.dart';

import '../service/storage_service.dart';
import '../utils/constant.dart';
import '../utils/utils.dart';
import '../widgets/auth_rounded_button.dart';
import '../widgets/signin_signup.dart';
import '../widgets/text_input_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String routeName = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with FormValidationMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();
  final StorageService _storageService = StorageService();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passController.text;
      final username = _usernameController.text;
      final bio = _bioController.text;
      setState(() {
        _isLoading = true;
      });
      await _authService
          .register(
              username: username,
              email: email,
              password: password,
              bio: bio,
              image: _image)
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value == 'success') {
          showSnackbar(
              context, 'Registered an account successfully', Colors.lightGreen);
        } else {
          showSnackbar(context, value, Colors.red);
        }
        Navigator.of(context).pop();
      });
    }
  }

  void _pickImage(ImageSource source) async {
    _image = await _storageService.uploadLocalImage(source);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: 30,
            horizontal: size.width > mobileScreenSize ? size.width * 0.25 : 30),
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.07,
              ),
              SvgPicture.asset(
                'assets/icons/ic_instagram.svg',
                color: primaryColor,
              ),
              SizedBox(
                height: size.height * 0.07,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        _image == null
                            ? const CircleAvatar(
                                radius: 60,
                                backgroundImage: AssetImage(
                                  'assets/images/avatar.jpg',
                                ),
                              )
                            : CircleAvatar(
                                radius: 60,
                                backgroundImage: MemoryImage(_image!)),
                        Positioned(
                            bottom: -7,
                            right: -5,
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
                              onSelected: (value) => _pickImage(value),
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
                    SizedBox(
                      height: size.height * 0.07,
                    ),
                    TextInputField(
                      controller: _usernameController,
                      hintText: 'Enter your username',
                      textInputType: TextInputType.text,
                      validator: validateUserName,
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    TextInputField(
                      controller: _emailController,
                      hintText: 'Enter your email',
                      textInputType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    TextInputField(
                      controller: _passController,
                      hintText: 'Enter your password',
                      isPassword: true,
                      textInputType: TextInputType.text,
                      validator: validatePassword,
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    TextInputField(
                      controller: _bioController,
                      hintText: 'Enter your bio',
                      textInputType: TextInputType.text,
                      validator: (value) => null,
                    ),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    AuthRoundedButton(
                      isLoading: _isLoading,
                      text: 'Register',
                      onTap: _submitForm,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
              SignInOrSignUp(
                highlightText: 'Log In',
                onTap: () => Navigator.of(context).pop(),
                text: 'Already have an account?',
              )
            ],
          ),
        ),
      ),
    );
  }
}
