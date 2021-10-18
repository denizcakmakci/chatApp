import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';

part 'verify_view_model.g.dart';

class VerifyViewModel = _VerifyViewModelBase with _$VerifyViewModel;

abstract class _VerifyViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String? verificationId;

  final otp = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _durationTimeOut = const Duration(seconds: 60);

  bool isCanResendCode = false;

  @observable
  late String phoneNumber;

  getPhoneNumber(String phone) {
    phoneNumber = phone;
  }

  @observable
  late bool isLoading;

  @action
  changeLoading(bool value) {
    isLoading = value;
  }

  void verifyPhoneNumber() async {
    changeLoading(true);

    isCanResendCode = false;

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        log("verify phone number : verification completed");
        await _auth.signInWithCredential(phoneAuthCredential);
        navigation.navigateToPage(path: NavigationConstants.home);
      },
      verificationFailed: (FirebaseAuthException e) {
        changeLoading(false);
        isCanResendCode = true;
        log(e.toString());
        ScaffoldMessenger.of(context!).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      },
      codeSent: (verificationId, forceResendingToken) async {
        log("verify phone number : code success send");
        this.verificationId = verificationId;
        changeLoading(false);
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
        // ignore: avoid_catches_without_on_clauses
      } catch (e) {
        // ignore: avoid_print
        print("invalid code");
      } finally {
        isLoading = false;

        if (_auth.currentUser != null) {
          /// authentication success

          navigation.navigateToPage(path: NavigationConstants.home);
        } else {
          /// authentication failed
          ScaffoldMessenger.of(context!).showSnackBar(
            const SnackBar(
              content: Text('Invalid Code Please enter the correct code'),
            ),
          );
        }
      }
    }
  }

  @override
  void init() {
    final phone =
        ModalRoute.of(context!)!.settings.arguments as Map<String, dynamic>;
    //phoneNumber = phone.values.toString();
    getPhoneNumber(phone.values.toString());
    print(phoneNumber);
    verifyPhoneNumber();
  }
}
