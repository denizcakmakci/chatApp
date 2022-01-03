import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../../enums/local_manager_keys.dart';
import '../../init/cache/locale_manager.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  Future<auth.User?> getCurrentUser() async {
    auth.User? currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<void> addUsers(String phone) async {
    var user = LocaleManager.instance
        .getStringValue(LocalManagerKeys.token); // user uid
    var ref = _firestore.collection("users").doc(user);

    ref
        .set({'user_id': user, 'phone_number': phone}, SetOptions(merge: true))
        .then((value) => log("User Added"))
        .catchError((error) => log("Failed to add user: $error"));
  }

  Future<void> updateUsers(String name, String photoUrl) async {
    var user = LocaleManager.instance
        .getStringValue(LocalManagerKeys.token); // user uid
    var ref = _firestore.collection("users").doc(user);

    ref
        .update({'name': name, 'photo_url': photoUrl})
        .then((value) => log("User Updated"))
        .catchError((error) => log("Failed to update user: $error"));
  }

  /// return true if phone number already exists
  Future<bool> phoneNumberExists(String phoneNumber) async {
    var isValidUser = false;

    await _firestore
        .collection('users')
        .where('phone_number', isEqualTo: phoneNumber)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        isValidUser = true;
      }
    }).catchError(
      (_) {
        log("checking phone number : failed");
      },
    );

    return isValidUser;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    var user = LocaleManager.instance.getStringValue(LocalManagerKeys.token);
    var ref = _firestore.collection('users').doc(user).get();
    return ref;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPhoneNumber(
      List<dynamic> tempContact) async {
    var user = LocaleManager.instance.getStringValue(LocalManagerKeys.token);
    var ref = await _firestore
        .collection('users')
        .where('phone_number', whereIn: tempContact)
        .where('user_id', isNotEqualTo: user)
        .get();
    for (var res in ref.docs) {
      log(res.data().toString());
    }
    return ref;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> phoneNumberSearchQuery(
      List<dynamic> tempContact, String type) {
    var ref = _firestore
        .collection('users')
        .where('phone_number', whereIn: tempContact)
        .where('searchKey', isGreaterThanOrEqualTo: type)
        .where('searchKey', isLessThan: '${type}z')
        .snapshots();
    return ref;
  }
}
