import 'package:flutter/material.dart';
import 'navigation_service_interface.dart';

class NavigationService implements INavigationService {
  static final NavigationService _instance = NavigationService._init();
  static NavigationService get instance => _instance;

  NavigationService._init();

  GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  get removeAllOldRoutes => (route) => false;

  @override
  Future<void> navigateToPage(
      {String path = '/', Object data = const {}}) async {
    await navigatorKey.currentState?.pushNamed(path, arguments: data);
  }

  @override
  Future<void> navigateToPageClear(
      {String path = '/', Object data = const {}}) async {
    await navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(path, removeAllOldRoutes, arguments: data);
  }
}
