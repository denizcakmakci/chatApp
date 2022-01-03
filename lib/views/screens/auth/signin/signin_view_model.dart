import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/init/extensions/string/locale_text_extensions.dart';
import '../../../../core/services/firebase/database_service.dart';
import '../verify/verify_view.dart';

part 'signin_view_model.g.dart';

class SigninViewModel = _SigninViewModelBase with _$SigninViewModel;

abstract class _SigninViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  DatabaseService service = DatabaseService();

  bool isLoading = false;
  final TextEditingController controller = TextEditingController();

  @observable
  String langCode = '+90';

  @computed
  String get phoneNumber => langCode + controller.text;

  @action
  changeLangCode(String? code) {
    langCode = code ?? '+90';
  }

  void register(BuildContext context) async {
    service.phoneNumberExists(phoneNumber.trim()).then((exist) {
      if (!exist) {
        if (controller.text.replaceAll(' ', '').isNotEmpty &&
            controller.text.replaceAll(' ', '').length == 10) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Verify(),
                  settings: RouteSettings(
                    arguments: {'type': phoneNumber},
                  )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('invalid_phone'.translate)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('already_phone'.translate)),
        );
      }
    });
  }

  @override
  void init() {}
}
