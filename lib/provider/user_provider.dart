import 'package:flutter/material.dart';
import 'package:instagram_clone/service/auth_service.dart';

import '../model/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;
  User? get getUser => _user;

  void refreshUser() async {
    final user = await AuthService().getUserDetails();
    _user = user;
    notifyListeners();
  }

  void clear() {
    _user = null;
  }
}
