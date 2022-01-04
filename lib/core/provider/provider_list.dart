import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/init/navigation/navigation_service.dart';
import 'call_provider.dart';
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
    Provider.value(value: NavigationService.instance)
  ];
}
