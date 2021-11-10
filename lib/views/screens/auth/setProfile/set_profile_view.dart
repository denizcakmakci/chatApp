import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/base/base_view.dart';
import '../../../../core/init/extensions/extension_shelf.dart';
import '../components/auth_component_shelf.dart';
import 'set_profile_view_model.dart';

class SetProfileView extends StatelessWidget {
  const SetProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SetProfileViewModel>(
        viewModel: SetProfileViewModel(),
        onPageBuilder: (BuildContext context, SetProfileViewModel _model) =>
            Scaffold(
              body: body(context, _model),
            ),
        onModelReady: (model) {
          model.setContext(context);
          model.init();
        });
  }

  Column body(BuildContext context, SetProfileViewModel _model) {
    return Column(
      children: [
        SizedBox(
          height: context.height * 5,
        ),
        const Expanded(flex: 2, child: TitleText(text: 'signup')),
        const Spacer(flex: 1),
        photo(context, _model),
        const Spacer(flex: 2),
        Expanded(flex: 1, child: subTitle(context)),
        const Spacer(flex: 2),
        field(context, _model),
        const Spacer(flex: 3),
        button(context, _model),
        const Spacer(flex: 7),
      ],
    );
  }

  Stack photo(BuildContext context, SetProfileViewModel _model) {
    return Stack(
      children: [
        Center(child: SvgPicture.asset('setProfileBg'.toBgSVG)),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, left: 30),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                //color: Colors.red,
              ),
              width: 154,
              height: 153,
              child: Observer(builder: (_) {
                return ClipOval(
                  child: _model.isLoading
                      ? Image.asset('assets/gifs/load.gif')
                      : Image.network(
                          _model.photoURL ?? _model.defaultUserPhoto,
                          fit: BoxFit.cover,
                        ),
                );
              }),
            ),
          ),
        ),
        addPhotoButton(context, _model)
      ],
    );
  }

  Positioned addPhotoButton(BuildContext context, SetProfileViewModel _model) {
    return Positioned(
        width: 50,
        left: 240,
        top: 140,
        child: RawMaterialButton(
          onPressed: () async {
            await _model.getImage();
          },
          child: const Icon(
            Icons.add_a_photo,
            color: Colors.black54,
            size: 22,
          ),
          fillColor: context.primaryColor,
          padding: const EdgeInsets.all(10),
          shape: const CircleBorder(),
        ));
  }

  Text subTitle(BuildContext context) {
    return Text(
      'Please enter your name',
      style: context.headline3
          .copyWith(fontSize: (context.width + context.height) / .9),
    );
  }

  Widget field(BuildContext context, SetProfileViewModel _model) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 15),
      child: CustomTextField(
        isPrefix: false,
        hintText: 'Name',
        controller: _model.controller,
        keyboardType: TextInputType.text,
      ),
    );
  }

  CustomButton button(BuildContext context, SetProfileViewModel _model) {
    return CustomButton(
      onpressed: () async {
        await _model.signinSuccess(context);
        _model.goToHome();
      },
      child: Text(
        'Done',
        style: context.headline1
            .copyWith(fontSize: (context.width + context.height) / .85),
      ),
    );
  }
}
