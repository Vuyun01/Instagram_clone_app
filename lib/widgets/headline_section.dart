import 'package:flutter/material.dart';

class HeadlineSection extends StatelessWidget {
  const HeadlineSection({
    super.key,
    required this.title,
    required this.label,
    required this.onTap,
  });
  final String title;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.cyan),
            ),
          )
        ],
      ),
    );
  }
}
