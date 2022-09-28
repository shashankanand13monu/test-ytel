import 'package:flutter/cupertino.dart';

import '../domain/user_models.dart';

class UserProvider with ChangeNotifier {
  // User _user= User(userId: userId , name: name, email: email, phone: phone, type: type, token: token, refreshToken: refreshToken)
  // User get user => _user;
  User _user = User();
  User get user => _user;


  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
