import 'package:flutter/material.dart';

import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/init/extensions/extension_shelf.dart';
import '../../../core/init/navigation/navigation_service.dart';
import '../auth/components/auth_component_shelf.dart';

class NoInternetView extends StatelessWidget {
  const NoInternetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigation = NavigationService.instance;
    return Scaffold(
      backgroundColor: context.canvasColor,
      body: Column(
        children: [
          SizedBox(height: context.height * 10),
          Center(
            child: Image.asset(
              'assets/gifs/noInternet.gif',
              width: 350,
              height: 300,
            ),
          ),
          SizedBox(height: context.height * 10),
          Text(
            'Oooops!',
            style: context.headline3
                .copyWith(fontSize: (context.width + context.height) / .4),
          ),
          SizedBox(height: context.height * 3),
          Text(
            'no_internet'.translate,
            textAlign: TextAlign.center,
            style: context.headline4
                .copyWith(fontSize: (context.width + context.height) / .6),
          ),
          SizedBox(height: context.height * 6),
          CustomButton(
              child: Text('try_again'.translate, style: context.headline6),
              onpressed: () => navigation.navigateToPageClear(
                  path: NavigationConstants.splash))
        ],
      ),
    );
  }
}
