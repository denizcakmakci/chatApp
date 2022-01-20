import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/enums/local_manager_keys.dart';
import '../../../../core/services/firebase/database_service.dart';

part 'verify_view_model.g.dart';

class VerifyViewModel = _VerifyViewModelBase with _$VerifyViewModel;

abstract class _VerifyViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  DatabaseService service = DatabaseService();

  String? verificationId;
  final otp = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _durationTimeOut = const Duration(seconds: 60);

  late final String phoneNumber;

  @observable
  bool isCanResendCode = false;

  @action
  changeResendCode(bool value) {
    isCanResendCode = value;
  }

  @observable
  bool isLoading = true;

  @action
  changeLoading(bool value) {
    isLoading = value;
  }

  getPhoneNumber(String phone) {
    phoneNumber = phone;
  }

  void verifyPhoneNumber() async {
    changeLoading(true);

    changeResendCode(false);

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        log("verify phone number : verification completed");
        await _auth.signInWithCredential(phoneAuthCredential);
        var _uid = _auth.currentUser!.uid;
        await localeManager.setStringValue(LocalManagerKeys.token, _uid);
        await service
            .addUsers(phoneNumber.substring(1, phoneNumber.length - 1));
        navigation.navigateToPage(path: NavigationConstants.setProfile);
      },
      verificationFailed: (FirebaseAuthException e) {
        changeLoading(false);
        changeResendCode(true);
        log(e.toString());
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      },
      codeSent: (verificationId, forceResendingToken) async {
        log("verify phone number : code success send");
        this.verificationId = verificationId;
        changeLoading(false);
        log(isLoading.toString());
      },
      codeAutoRetrievalTimeout: (verificationId) {},
      timeout: _durationTimeOut,
    );
  }

  void verifySmsCode() async {
    if (verificationId != null) {
      changeLoading(true);

      try {
        await _auth.signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verificationId!, smsCode: otp.text));
        if (_auth.currentUser != null) {
          /// authentication success
          var _uid = _auth.currentUser!.uid;

          await localeManager.setStringValue(LocalManagerKeys.token, _uid);
          await service.addUsers(phoneNumber.substring(
              1, phoneNumber.length - 1)); // add user database
          log('eklendi');
          navigation.navigateToPage(path: NavigationConstants.setProfile);
        } else {
          /// authentication failed
          log("authentication failed");
        }
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        // ignore: avoid_print
        print("invalid code");
        ScaffoldMessenger.of(context!).showSnackBar(
          const SnackBar(
            content: Text('Invalid Code Please enter the correct code'),
          ),
        );
      }
    }
  }

  @override
  void init() {
    final phone =
        ModalRoute.of(context!)!.settings.arguments as Map<String, dynamic>;
    getPhoneNumber(phone.values.toString());
    log(phoneNumber);
    verifyPhoneNumber();
  }
}
