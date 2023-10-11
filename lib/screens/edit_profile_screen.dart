import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user.dart' as um;
import 'package:instagram_clone/service/auth_service.dart';
import 'package:instagram_clone/service/user_services.dart';
import 'package:instagram_clone/utils/user_constant.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/utils/validation.dart';
import 'package:instagram_clone/widgets/profile_button.dart';

class EditProfileScreen extends StatefulWidget {
  static const String routeName = '\\edit_profile';

  const EditProfileScreen({super.key});
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with FormValidationMixin {
  AuthService _authService = AuthService();
  UserService _userService = UserService();

  String? username;
  String? bio;
  bool isLoading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final uid = _authService.userID;
      print(username);
      print(bio);
      _formKey.currentState!.save();
      await _userService.updateUser(uid: uid, newData: {
        UserConstant.username: username,
        UserConstant.bio: bio
      }).then((value) {
        Navigator.of(context).pop();
        if (value == 'success') {
          showSnackbar(
              context, 'Update profile successfully', Colors.lightGreen);
        } else {
          showSnackbar(context, value, Colors.red);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)?.settings.arguments as um.User;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(user.avatar!),
                    ),
                  ),
                ),
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 18),
                ),
                TextFormField(
                  initialValue: user.email,
                  enabled: false,
                  decoration: const InputDecoration(
                      // hintText: 'Enter your email',
                      ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 18),
                ),
                TextFormField(
                  initialValue: user.username,
                  onSaved: (value) {
                    username = value;
                  },
                  validator: validateUserName,
                  decoration: const InputDecoration(
                      // hintText: 'Enter your name',
                      ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Bio',
                  style: TextStyle(fontSize: 18),
                ),
                TextFormField(
                  initialValue: user.bio,
                  onSaved: (value) {
                    bio = value;
                  },
                  maxLines: 3,
                  decoration: const InputDecoration(
                      // hintText: 'Tell us about yourself',
                      ),
                ),
                const SizedBox(height: 32.0),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _saveForm,
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30)),
                    child: Text(
                      'Save',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
