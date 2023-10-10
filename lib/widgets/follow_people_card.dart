import 'package:flutter/material.dart';

import '../model/user.dart';

class FollowPeopleCard extends StatelessWidget {
  const FollowPeopleCard({
    super.key,
    required this.user,
    required this.onTap,
  });
  final User? user;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade900,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade800)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user?.avatar ??
                  'https://images.unsplash.com/photo-1693917566028-c0f204817a97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1974&q=80'),
            ),
            const SizedBox(
              height: 15,
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: '${user?.username ?? 'N/A'}\n',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextSpan(
                  text: 'Suggested for you',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                      fontSize: 12),
                )
              ]),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10)),
                  onPressed: onTap,
                  child: Text(
                    'View',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
