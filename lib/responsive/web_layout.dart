import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:provider/provider.dart';

import '../service/auth_service.dart';
import '../utils/constant.dart';
import '../utils/utils.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> {
  int _currentPage = 0;
  PageController _pageController = PageController();
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).refreshUser();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged() {
    _pageController.animateToPage(_currentPage,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: SvgPicture.asset(
          'assets/icons/ic_instagram.svg',
          // width: size.width * 0.2,
          color: primaryColor,
        ),
        actions: [
          _buildNavigationButton(icon: Icons.home, index: 0),
          _buildNavigationButton(icon: Icons.search_rounded, index: 1),
          _buildNavigationButton(icon: Icons.add_circle_rounded, index: 2),
          _buildNavigationButton(icon: Icons.person, index: 3),
          IconButton(
              splashColor: Colors.transparent,
              onPressed: () async {
                await AuthService().logout();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreens,
      ),
    );
  }

  Widget _buildNavigationButton({required IconData icon, required int index}) {
    return IconButton(
        splashColor: Colors.transparent,
        iconSize: 30,
        onPressed: () {
          setState(() {
            _currentPage = index;
            onPageChanged();
          });
        },
        icon: Icon(
          icon,
          color: _currentPage == index ? Colors.white : Colors.grey.shade700,
        ));
  }
}
