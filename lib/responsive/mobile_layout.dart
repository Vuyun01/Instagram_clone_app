import 'package:flutter/material.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/auth_rounded_button.dart';
import 'package:provider/provider.dart';


class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _currentPage = 0;
  PageController _pageController = PageController();
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
        // appBar: AppBar(
        //   title: Text(user?.email ?? 'N/A'),
        // ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: homeScreens,
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(color: mobileBackgroundColor, boxShadow: [
            BoxShadow(
                offset: const Offset(0, 5),
                color: Colors.grey.shade900,
                blurRadius: 40)
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavigationButton(icon: Icons.home, index: 0),
              _buildNavigationButton(icon: Icons.search_rounded, index: 1),
              _buildNavigationButton(icon: Icons.add_circle_rounded, index: 2),
              _buildNavigationButton(icon: Icons.favorite, index: 3),
              _buildNavigationButton(icon: Icons.person, index: 4),
            ],
          ),
        ));
  }

  Widget _buildNavigationButton({required IconData icon, required int index}) {
    return IconButton(
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
