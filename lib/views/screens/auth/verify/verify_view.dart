import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/init/extensions/extension_shelf.dart';
import '../components/button.dart';
import '../components/title_text.dart';
import 'verify_view_model.dart';

class Verify extends StatelessWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<VerifyViewModel>(
        viewModel: VerifyViewModel(),
        onPageBuilder: (BuildContext context, VerifyViewModel _model) => Stack(
              children: [
                background(context, _model),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: body(context, _model),
                )
              ],
            ),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
        });
  }

  Material background(BuildContext context, VerifyViewModel _model) {
    return Material(
        color: context.backgroundLight,
        child: Image(
          image: const AssetImage('assets/png/verifybg.png'),
          width: context.width * 100,
          height: context.height * 100,
          fit: BoxFit.fill,
        ));
  }

  Column body(BuildContext context, VerifyViewModel _model) => Column(
        children: [
          const Spacer(flex: 2),
          const Expanded(flex: 1, child: TitleText(text: 'OTP Verification')),
          const Spacer(flex: 1),
          Expanded(flex: 6, child: illustration()),
          const Spacer(flex: 2),
          Expanded(flex: 1, child: subTitle(context, _model)),
          pinAutoField(context, _model),
          button(_model, context),
          const Spacer(flex: 8),
        ],
      );

  SvgPicture illustration() {
    return SvgPicture.asset(
      'illustration/verify'.toSVG,
    );
  }

  Widget subTitle(BuildContext context, VerifyViewModel _model) {
    return Text(
      'Please enter the code send to ${_model.phoneNumber}',
      style: context.headline3
          .copyWith(fontSize: (context.width + context.height) / .9),
    );
  }

  Widget pinAutoField(BuildContext context, VerifyViewModel _model) {
    return PinFieldAutoFill(
      controller: _model.otp,
      codeLength: 6,
      decoration: BoxLooseDecoration(
        bgColorBuilder: FixedColorBuilder(context.canvasColor),
        strokeColorBuilder: FixedColorBuilder(context.canvasColor),
        gapSpace: 10,
      ),
    );
  }

  CustomButton button(VerifyViewModel _model, BuildContext context) {
    return CustomButton(
      onpressed: _model.isLoading ? null : () => _model.verifySmsCode(),
      child: _model.isLoading
          ? const SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(),
            )
          : Text(
              'Verify OTP',
              style: context.headline1
                  .copyWith(fontSize: (context.width + context.height) / .85),
            ),
    );
  }
}
