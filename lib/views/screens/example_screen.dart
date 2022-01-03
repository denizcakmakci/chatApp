import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../../core/constants/navigation/navigation_constants.dart';
import '../../core/helper/premissions.dart';
import '../../core/init/navigation/navigation_service.dart';
import '../../core/provider/user_provider.dart';
import 'call/pickup/pickup_layout.dart';

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  _ExampleScreenState createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser();
    });
  }

  NavigationService navigation = NavigationService.instance;
  Permissions per = Permissions();
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: WillPopScope(
      onWillPop: () async => exit(0),
      child: Scaffold(
        appBar: _appBar(),
        floatingActionButton: _floatingActionButton(context),
        body: const Center(child: Text('Chat Screen')),
      ),
    ));
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 3,
      shadowColor: context.lightPink,
      title: Text(
        'Flutter Template',
        style: context.headline3
            .copyWith(fontSize: (context.width + context.height) / .7),
      ),
      automaticallyImplyLeading: false,
    );
  }

  FloatingActionButton _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: _floatButtonOnPressed,
      child: _buttonIcon(context),
      backgroundColor: context.primaryColor,
    );
  }

  Icon _buttonIcon(BuildContext context) {
    return Icon(
      Icons.group_sharp,
      color: context.primaryDarkColor,
    );
  }

  Future<void> _floatButtonOnPressed() async {
    {
      await per.contactPermissionsGranted()
          ? navigation.navigateToPage(path: NavigationConstants.contacts)
          : null;
    }
  }
}
