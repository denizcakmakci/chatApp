import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/init/extensions/extension_shelf.dart';
import '../components/button.dart';
import '../components/text_field.dart';
import '../components/title_text.dart';
import 'signin_view_model.dart';

class SignIn extends StatelessWidget {
  final _model = SigninViewModel();

  SignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        background(context),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: body(context),
        )
      ],
    );
  }

  Column body(BuildContext context) => Column(
        children: [
          const Spacer(flex: 2),
          const Expanded(flex: 1, child: TitleText(text: 'signup')),
          const Spacer(flex: 1),
          Expanded(
              flex: 6, child: SvgPicture.asset('/illustration/signin'.toSVG)),
          const Spacer(flex: 2),
          Expanded(flex: 1, child: subTitle(context)),
          Expanded(flex: 1, child: subsubTitle(context)),
          const Spacer(flex: 2),
          phoneInput(context),
          const Spacer(flex: 3),
          CustomButton(
            onpressed: () {},
            buttonText: 'Send OTP',
          ),
          const Spacer(flex: 8),
        ],
      );

  Row phoneInput(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: context.width * 4,
        ),
        countryPicker(context),
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

  Widget countryPicker(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: context.width * 27,
        child: CountryCodePicker(
          onChanged: (e) => print(e.toString()),
          initialSelection: 'TR',
          textStyle: context.headline1
              .copyWith(fontSize: (context.width + context.height) / .8),
          flagWidth: context.width * 6,
          alignLeft: true,
          padding: EdgeInsets.zero,
          showCountryOnly: false,
          favorite: const ['US', 'TR'],
        ),
      ),
    );
  }

  Text subTitle(BuildContext context) {
    return Text(
      'Enter your mobile number',
      style: context.headline2
          .copyWith(fontSize: (context.width + context.height) / .7),
    );
  }

  Text subsubTitle(BuildContext context) {
    return Text(
      'We will send you a OTP code',
      style: context.headline3
          .copyWith(fontSize: (context.width + context.height) / .9),
    );
  }

  Material background(BuildContext context) {
    return Material(
      color: context.backgroundLight,
      child: SvgPicture.asset(
        'signinbg'.toBgSVG,
        width: context.width * 100,
        height: context.height * 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
