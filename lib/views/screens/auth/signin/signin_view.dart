import 'dart:developer';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/base/base_view.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../components/auth_component_shelf.dart';
import 'signin_view_model.dart';

class SignIn extends StatelessWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SigninViewModel>(
        viewModel: SigninViewModel(),
        onPageBuilder: (BuildContext context, SigninViewModel _model) => Stack(
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

  Material background(BuildContext context, SigninViewModel _model) {
    return Material(
        color: context.backgroundLight,
        child: Image(
          image: const AssetImage('assets/png/signinbg.png'),
          width: context.width * 100,
          height: context.height * 100,
          fit: BoxFit.fill,
        ));
  }

  Column body(BuildContext context, SigninViewModel _model) => Column(
        children: [
          SizedBox(
            height: context.height * 7,
          ),
          const Expanded(flex: 1, child: TitleText(text: 'signup')),
          const Spacer(flex: 1),
          Expanded(
              flex: 6,
              child: SvgPicture.asset(
                'illustration/signin'.toSVG,
              )),
          const Spacer(flex: 2),
          Expanded(flex: 1, child: subTitle(context, _model)),
          Expanded(flex: 1, child: subsubTitle(context, _model)),
          const Spacer(flex: 2),
          phoneInput(context, _model),
          const Spacer(flex: 3),
          button(_model, context),
          const Spacer(flex: 8),
        ],
      );

  Text subTitle(BuildContext context, SigninViewModel _model) {
    return Text(
      'Enter your mobile number',
      style: context.headline2
          .copyWith(fontSize: (context.width + context.height) / .7),
    );
  }

  Text subsubTitle(BuildContext context, SigninViewModel _model) {
    return Text(
      'We will send you a OTP code',
      style: context.headline3
          .copyWith(fontSize: (context.width + context.height) / .9),
    );
  }

  Row phoneInput(BuildContext context, SigninViewModel _model) {
    return Row(
      children: [
        SizedBox(
          width: context.width * 4,
        ),
        countryPicker(context, _model),
        Flexible(
            child: CustomTextField(
          hintText: 'hint',
          controller: _model.controller,
        )),
        SizedBox(
          width: context.width * 4,
        ),
      ],
    );
  }

  Widget countryPicker(BuildContext context, SigninViewModel _model) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
          width: context.width * 27,
          child: CountryCodePicker(
            onChanged: (e) {
              _model.changeLangCode(e.dialCode);
              log(_model.phoneNumber);
            },
            initialSelection: 'TR',
            textStyle: context.headline1
                .copyWith(fontSize: (context.width + context.height) / .8),
            flagWidth: context.width * 6,
            alignLeft: true,
            padding: EdgeInsets.zero,
            showCountryOnly: false,
            favorite: const ['US', 'TR'],
          )),
    );
  }

  CustomButton button(SigninViewModel _model, BuildContext context) {
    return CustomButton(
      onpressed: () {
        _model.register(context);
      },
      child: Text(
        'Send OTP',
        style: context.headline1
            .copyWith(fontSize: (context.width + context.height) / .85),
      ),
    );
  }
}
