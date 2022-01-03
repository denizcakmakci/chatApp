import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/init/extensions/extension_shelf.dart';
import '../components/auth_component_shelf.dart';
import 'verify_view_model.dart';

class Verify extends StatelessWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<VerifyViewModel>(
        viewModel: VerifyViewModel(),
        onPageBuilder: (BuildContext context, VerifyViewModel _model) => Stack(
              children: [
                background(context),
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

  Material background(BuildContext context) {
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
          SizedBox(
            height: context.height * 5,
          ),
          Expanded(flex: 1, child: TitleText(text: 'verify_otp'.translate)),
          const Spacer(flex: 1),
          Expanded(flex: 6, child: illustration()),
          const Spacer(flex: 2),
          Expanded(flex: 1, child: subTitle(context, _model)),
          const Spacer(flex: 2),
          pinAutoField(context, _model),
          const Spacer(flex: 1),
          Expanded(flex: 2, child: resendCode(context, _model)),
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
    return RichText(
        text: TextSpan(
      style: context.headline3
          .copyWith(fontSize: (context.width + context.height) / .9),
      children: <TextSpan>[
        TextSpan(text: 'send_code_number'.translate),
        TextSpan(
            text:
                _model.phoneNumber.substring(1, _model.phoneNumber.length - 1),
            style: context.headline2
                .copyWith(fontSize: (context.width + context.height) / .9)),
      ],
    ));
  }

  Widget resendCode(BuildContext context, VerifyViewModel _model) {
    return TextButton(
      onPressed: () {
        !_model.isCanResendCode ? _model.verifyPhoneNumber() : null;
      },
      child: RichText(
          text: TextSpan(
        style: context.headline3
            .copyWith(fontSize: (context.width + context.height) / .9),
        children: <TextSpan>[
          TextSpan(text: 'did_send_code'.translate),
          TextSpan(
              text: 'resend'.translate,
              style: context.headline2
                  .copyWith(fontSize: (context.width + context.height) / .9)),
        ],
      )),
    );
  }

  Widget pinAutoField(BuildContext context, VerifyViewModel _model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 10),
      child: PinFieldAutoFill(
        controller: _model.otp,
        codeLength: 6,
        onCodeSubmitted: (code) {
          _model.verifySmsCode();
        },
        decoration: BoxLooseDecoration(
          bgColorBuilder: FixedColorBuilder(context.canvasColor),
          strokeColorBuilder: FixedColorBuilder(context.canvasColor),
          gapSpace: context.width * 4,
        ),
      ),
    );
  }

  Widget button(VerifyViewModel _model, BuildContext context) {
    return CustomButton(
      onpressed: () {
        _model.verifySmsCode();
      },
      child: Text(
        'verify_otp_button'.translate,
        style: context.headline1
            .copyWith(fontSize: (context.width + context.height) / .85),
      ),
    );
  }
}
