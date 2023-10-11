import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/service/auth_service.dart';
import 'package:instagram_clone/utils/constant.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout(
      {super.key,
      required this.mobileLayout,
      // required this.tabletLayout,
      required this.webLayout});

  final Widget mobileLayout;
  // final Widget tabletLayout;
  final Widget webLayout;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      if (constraints.maxWidth < mobileScreenSize) {
        return mobileLayout;
      }
      //  else if (constraints.maxWidth >= mobileScreenSize &&
      //     constraints.maxWidth < tabletScreenSize) {
      //   return tabletLayout;
      // }
      else {
        return webLayout;
      }
    }));
  }
}
