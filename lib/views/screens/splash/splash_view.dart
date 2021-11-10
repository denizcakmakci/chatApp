import 'package:flutter/material.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../../../core/base/base_view.dart';
import 'splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
        viewModel: SplashViewModel(),
        onPageBuilder: (BuildContext context, SplashViewModel _model) =>
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.primaryColor,
                    context.lightPink,
                  ],
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: FlutterLogo(
                    size: context.width * 40,
                  ),
                ),
              ),
            ),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
        });
  }
}
