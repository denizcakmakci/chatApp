import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_template/views/screens/example_screen.dart';

import '../../../views/screens/auth/signin/signin_view.dart';
import '../../../views/screens/auth/verify/verify_view.dart';
import '../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.home:
        return normalNavigate(const ExampleScreen());
      case NavigationConstants.signin:
        return normalNavigate(const SignIn());
      case NavigationConstants.verify:
        return normalNavigate(const Verify());
      default:
        return normalNavigate(const SignIn());
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
