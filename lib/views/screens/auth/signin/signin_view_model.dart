import 'package:flutter/material.dart';
import 'package:flutter_template/core/services/firebase/database_service.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/base_view_model.dart';
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
        if (controller.text.trim().isNotEmpty &&
            controller.text.trim().length == 10) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Verify(),
                  settings: RouteSettings(
                    arguments: {'type': phoneNumber},
                  )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Telefon numarasi gecersiz')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Telefon numarasi zaten kayitli')),
        );
      }
    });
  }

  @override
  void init() {}
}
