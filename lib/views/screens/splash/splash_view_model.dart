import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/enums/local_manager_keys.dart';

part 'splash_view_model.g.dart';

class SplashViewModel = _SplashViewModelBase with _$SplashViewModel;

abstract class _SplashViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  //internet connection check
  checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        log('connected');
        goToHome();
      }
    } on SocketException catch (_) {
      log('not connected');
      navigation.navigateToPageClear(path: NavigationConstants.noInternet);
    }
  }

  goToHome() {
    var isFirstApp = localeManager.getBoolValue(LocalManagerKeys.isFirstApp);
    if (isFirstApp) {
      navigation.navigateToPage(path: NavigationConstants.home);
    } else {
      navigation.navigateToPage(path: NavigationConstants.signin);
    }
  }

  @override
  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 3), checkInternet);
  }
}
