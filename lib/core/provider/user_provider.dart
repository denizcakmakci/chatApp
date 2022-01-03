import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/firebase/database_service.dart';

class UserProvider extends ChangeNotifier {
  DatabaseService service = DatabaseService();
  User? user;

  Future<void> refreshUser() async {
    await service.getUserDetails().then((value) {
      user = User.fromJson(value.data()!);
      notifyListeners();
    });
  }
}
