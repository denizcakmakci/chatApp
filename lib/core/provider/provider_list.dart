import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/init/navigation/navigation_service.dart';
import 'call_provider.dart';
import 'message_provider.dart';
import 'scroll_provider.dart';
import 'socket_provider.dart';
import 'theme_provider.dart';
import 'user_provider.dart';

class ApplicationProvider {
  static ApplicationProvider? _instance;
  static ApplicationProvider? get instance {
    _instance ??= ApplicationProvider._init();
    return _instance;
  }

  ApplicationProvider._init();

  List<SingleChildWidget> dependItems = [
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => CallProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => SocketProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => MessageProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => ScrollProvider(),
    ),
    Provider.value(value: NavigationService.instance)
  ];
}
