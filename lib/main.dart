import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/responsive/mobile_layout.dart';
import 'package:instagram_clone/responsive/responsive_layout.dart';
import 'package:instagram_clone/responsive/web_layout.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/comment_screen.dart';
import 'package:instagram_clone/screens/edit_profile_screen.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/sign_up_screen.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        scrollBehavior: NoThumbScrollBehavior().copyWith(
            scrollbars: false), //prevent thumb scroll bar on web browsers
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          // colorScheme: ColorScheme.dark(
          //     primary: Colors.black,
          //     secondary: Colors.white30,
          //     tertiary: Colors.grey.shade900),
          scaffoldBackgroundColor: mobileBackgroundColor,
          // useMaterial3: true,
        ),
        themeMode: ThemeMode.dark,
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.connectionState == ConnectionState.active) {
                final userProvider = context.read<UserProvider>();
                userProvider.refreshUser();
                return const ResponsiveLayout(
                    mobileLayout: MobileLayout(), webLayout: WebLayout());
              }
              return const LoginScreen();
            }),
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          SignUpScreen.routeName: (context) => const SignUpScreen(),
          AddPostScreen.routeName: (context) => const AddPostScreen(),
          CommentScreen.routeName: (context) => const CommentScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          EditProfileScreen.routeName:(context) => const EditProfileScreen()
        },
      ),
    );
  }
}
