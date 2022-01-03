import 'package:flutter/material.dart';

import '../../../../core/constants/navigation/string_constants.dart';
import '../../../../core/helper/premissions.dart';
import '../../../../core/init/extensions/extension_shelf.dart';
import '../../../../core/model/call.dart';
import '../../../../core/services/firebase/calll_service.dart';
import '../calll_view.dart';

class PickupScreen extends StatelessWidget {
  final Call call;
  final CallService callMethods = CallService();
  final Permissions permissions = Permissions();

  PickupScreen({Key? key, required this.call}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _background(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: _body(context),
        ),
      ],
    );
  }

  Container _body(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 70),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _text(),
          const SizedBox(height: 50),
          _picture(),
          const SizedBox(height: 15),
          _callerName(),
          const SizedBox(height: 75),
          _buttons(context),
        ],
      ),
    );
  }

  Material _background(BuildContext context) {
    return Material(
        color: context.backgroundLight,
        child: Image(
          image: const AssetImage('assets/png/verifybg.png'),
          width: context.width * 100,
          height: context.height * 100,
          fit: BoxFit.fill,
        ));
  }

  Row _buttons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _endCall(),
        const SizedBox(width: 70),
        _startCall(context),
      ],
    );
  }

  IconButton _startCall(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.call,
        size: 35,
      ),
      color: Colors.green,
      onPressed: () async => callOnTap(context),
    );
  }

  IconButton _endCall() {
    return IconButton(
      icon: const Icon(
        Icons.call_end,
        size: 40,
      ),
      color: Colors.redAccent,
      onPressed: () async {
        await callMethods.endCall(call);
      },
    );
  }

  Text _callerName() {
    return Text(
      call.callerName ?? '',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  ClipOval _picture() {
    return ClipOval(
      child: SizedBox(
        height: 150,
        width: 150,
        child: Image.network(
          call.callerPic ?? defaultUserPhoto,
        ),
      ),
    );
  }

  Text _text() {
    return Text(
      "incoming".translate,
      style: const TextStyle(
        fontSize: 30,
      ),
    );
  }

  Future<void> callOnTap(BuildContext context) async {
    await permissions.cameraAndMicrophonePermissionsGranted()
        ? Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CallView(call: call),
            ),
          )
        : null;
  }
}
