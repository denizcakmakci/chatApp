import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../views/screens/auth/setProfile/set_profile_view.dart';
import '../../../views/screens/auth/signin/signin_view.dart';
import '../../../views/screens/auth/verify/verify_view.dart';
import '../../../views/screens/chat/chat_view.dart';
import '../../../views/screens/contacts/contacts_view.dart';
import '../../../views/screens/example_screen.dart';
import '../../../views/screens/noInternet/no_internet.dart';
import '../../../views/screens/splash/splash_view.dart';
import '../../constants/navigation/navigation_constants.dart';

class NavigationRoute {
  static final NavigationRoute _instance = NavigationRoute._init();
  static NavigationRoute get instance => _instance;

  NavigationRoute._init();

  Route<dynamic> generateRoute(RouteSettings args) {
    switch (args.name) {
      case NavigationConstants.splash:
        return normalNavigate(const SplashView());
      case NavigationConstants.home:
        return normalNavigate(const ExampleScreen());
      case NavigationConstants.signin:
        return normalNavigate(const SignIn());
      case NavigationConstants.verify:
        return normalNavigate(const Verify());
      case NavigationConstants.setProfile:
        return normalNavigate(const SetProfileView());
      case NavigationConstants.contacts:
        return normalNavigate(const ContactsView());
      case NavigationConstants.chat:
        return normalNavigate(const ChatView());
      case NavigationConstants.noInternet:
        return normalNavigate(const NoInternetView());
      default:
        return normalNavigate(const SplashView());
    }
  }

  MaterialPageRoute normalNavigate(Widget widget) {
    return MaterialPageRoute(
      builder: (context) => widget,
    );
  }
}
