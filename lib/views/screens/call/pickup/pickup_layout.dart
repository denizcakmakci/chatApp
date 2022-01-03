import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/model/call.dart';
import '../../../../core/provider/user_provider.dart';
import '../../../../core/services/firebase/calll_service.dart';
import 'pickup_screen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallService service = CallService();

  PickupLayout({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context);
    // print(provider.user?.userId);
    return (provider.user != null)
        ? StreamBuilder<DocumentSnapshot>(
            stream: service.callStream(provider.user?.userId ?? ' '),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData && snapshot.data?.data() != null) {
                  var call = Call.fromMap(
                      snapshot.data!.data()! as Map<dynamic, dynamic>);

                  if (call.hasDialled != null) {
                    if (!call.hasDialled!) {
                      return PickupScreen(call: call);
                    }
                  }
                }
              }
              return scaffold;
            },
          )
        : const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
