import 'package:flutter/material.dart';

class SignInOrSignUp extends StatelessWidget {
  const SignInOrSignUp({
    super.key,
    required this.onTap,
    required this.text,
    required this.highlightText,
  });
  final VoidCallback onTap;
  final String text;
  final String highlightText;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        const SizedBox(
          width: 10,
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            highlightText,
            style: const TextStyle(
                color: Colors.lightBlue,
                fontWeight: FontWeight.bold,
                fontSize: 16),
          ),
        )
      ],
    );
  }
}
