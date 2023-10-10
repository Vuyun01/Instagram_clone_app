import 'package:flutter/material.dart';

class ProfileButton extends StatelessWidget {
  const ProfileButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Colors.white12
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: color,
              padding:
                  const EdgeInsets.symmetric(vertical: 10)),
          child: FittedBox(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          )),
    );
  }
}
