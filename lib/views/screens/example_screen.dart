import 'dart:developer';
import 'dart:io';

// ignore: implementation_imports
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../../core/constants/navigation/navigation_constants.dart';
import '../../core/enums/local_manager_keys.dart';
import '../../core/helper/premissions.dart';
import '../../core/init/cache/locale_manager.dart';
import '../../core/init/language/lang_manager.dart';
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
        body: Center(child: Text('resend'.translate)),
      ),
    ));
  }

  AppBar _appBar() {
    return AppBar(
      centerTitle: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text(
          'Chat App',
          style: context.headline3.copyWith(
              fontSize: (context.width + context.height) / .5,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
      ),
      actions: [_langChangeButton()],
      automaticallyImplyLeading: false,
    );
  }

  TextButton _langChangeButton() {
    return TextButton(
        onPressed: () {
          context.locale.languageCode == 'en'
              ? context.setLocale(LanguageManager.instance.trLocale)
              : context.setLocale(LanguageManager.instance.enLocale);
          LocaleManager.instance.setStringValue(
              LocalManagerKeys.lang, context.locale.languageCode);
          log(context.locale.languageCode);
        },
        child: Text(
          context.locale.languageCode.translate,
          style: TextStyle(
              color: context.primaryDarkColor,
              fontWeight: FontWeight.w500,
              fontSize: (context.width + context.height) / .7),
        ));
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
