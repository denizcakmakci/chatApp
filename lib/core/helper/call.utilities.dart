import 'dart:math';

import 'package:flutter/material.dart';

import '../../views/screens/call/calll_view.dart';
import '../model/call.dart';
import '../model/user.dart';
import '../services/firebase/calll_service.dart';

class CallUtils {
  final CallService callService = CallService();

  dial({required User from, required User to, context}) async {
    var call = Call(
      callerId: from.userId,
      callerName: from.name,
      callerPic: from.photoUrl,
      receiverId: to.userId,
      receiverName: to.name,
      receiverPic: to.photoUrl,
      channelId: Random().nextInt(1000).toString(),
    );

    var callMade = await callService.makeCall(call);

    call.hasDialled = true;

    if (callMade) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CallView(
              call: call,
            ),
          ));
    }
  }
}
