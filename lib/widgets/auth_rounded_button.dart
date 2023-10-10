import 'package:flutter/material.dart';

class AuthRoundedButton extends StatelessWidget {
  const AuthRoundedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });
  final String text;
  final VoidCallback onTap;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          minimumSize: const Size(double.infinity, 0),
          padding: const EdgeInsets.symmetric(vertical: 20)),
      child: isLoading
          ? const CircularProgressIndicator.adaptive()
          : Text(
              text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
    );
  }
}
