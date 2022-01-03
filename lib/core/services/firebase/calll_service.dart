import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/call.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> callStream(String uid) {
    var ref = _firestore.collection('call').doc(uid).snapshots();
    return ref;
  }

  Future<bool> makeCall(Call call) async {
    try {
      call.hasDialled = true;
      var hasDialledMap = call.toMap(call);

      call.hasDialled = false;
      var hasNotDialledMap = call.toMap(call);

      await _firestore.collection('call').doc(call.callerId).set(hasDialledMap);
      await _firestore
          .collection('call')
          .doc(call.receiverId)
          .set(hasNotDialledMap);
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> endCall(Call call) async {
    try {
      await _firestore.collection('call').doc(call.callerId).delete();
      await _firestore.collection('call').doc(call.receiverId).delete();
      return true;
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
