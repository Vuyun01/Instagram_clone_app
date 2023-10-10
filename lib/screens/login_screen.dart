import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/utils/validation.dart';

import '../service/auth_service.dart';
import '../widgets/auth_rounded_button.dart';
import '../widgets/signin_signup.dart';
import '../widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FormValidationMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var email = _emailController.text;
      var password = _passController.text;
      setState(() {
        _isLoading = true;
      });
      await _authService.login(email: email, password: password).then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value == 'success') {
          showSnackbar(
              context, 'You logged in successfully', Colors.lightGreen);
        } else {
          showSnackbar(context, value, Colors.red);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: 30,
              horizontal:
                  size.width > mobileScreenSize ? size.width * 0.25 : 30),
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
                  height: size.height * 0.2,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      AuthRoundedButton(
                        isLoading: _isLoading,
                        text: 'Log In',
                        onTap: _submitForm,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.2,
                ),
                SignInOrSignUp(
                  highlightText: 'Sign Up',
                  onTap: () =>
                      Navigator.of(context).pushNamed(SignUpScreen.routeName),
                  text: 'Don\'t have an account?',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
