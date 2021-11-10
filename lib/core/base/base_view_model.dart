import 'package:flutter/material.dart';

import '../init/cache/locale_manager.dart';
import '../init/navigation/navigation_service.dart';

abstract class BaseViewModel {
  BuildContext? context;

  LocaleManager localeManager = LocaleManager.instance;
  NavigationService navigation = NavigationService.instance;

  void setContext(BuildContext context);

  // final _auth = FirebaseAuth.instance;

  // getImageURL(dynamic func) async {
  //   var ref = firebase_storage.FirebaseStorage.instance
  //       .ref()
  //       .child('images')
  //       .child(_auth.currentUser!.uid)
  //       .child('profileImage.png');
  //   var url = await ref.getDownloadURL();
  //   log(url);
  //   await func;
  // }

  void init();
}
