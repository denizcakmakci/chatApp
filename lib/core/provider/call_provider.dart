import 'package:flutter/material.dart';
import '../model/user.dart';

class CallProvider extends ChangeNotifier {
  User? _receiver;
  User? get receiver => _receiver;

  setReceiverUser(
      String uid, String name, String photoUrl, String phoneNumber) {
    _receiver = User(
        userId: uid, name: name, photoUrl: photoUrl, phoneNumber: phoneNumber);
    notifyListeners();
  }

  String? _userName;
  String? get userName => _userName;

  setUserName(String name) {
    _userName = name;
    notifyListeners();
  }

  String? _photoUrl;
  String? get photoUrl => _photoUrl;

  setphotoUrl(String name) {
    _photoUrl = name;
    notifyListeners();
  }
}
