import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_template/core/constants/navigation/string_constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/services/firebase/database_service.dart';

part 'set_profile_view_model.g.dart';

class SetProfileViewModel = _SetProfileViewModelBase with _$SetProfileViewModel;

abstract class _SetProfileViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  DatabaseService service = DatabaseService();

  final TextEditingController controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  File? imagePath;

  @observable
  bool isLoading = false;

  @action
  changeIsLoading() {
    isLoading = !isLoading;
  }

  @observable
  String? photoURL;

  @action
  changePhotoURL(String url) {
    photoURL = url;
  }

  getImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    imagePath = File(image!.path);
    changeIsLoading();
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child(_auth.currentUser!.uid)
        .child('profileImage.png');

    try {
      await ref.putFile(imagePath ?? File(defaultUserPhoto));
    } on firebase_storage.FirebaseException catch (e) {
      log(e.toString());
    }
    var url = await ref.getDownloadURL();
    await changePhotoURL(url);
    changeIsLoading();
  }

  signinSuccess(BuildContext context) {
    if (controller.text.isEmpty || controller.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giris alani bos birakilamaz.')),
      );
    } else {
      service.updateUsers(controller.text, photoURL ?? defaultUserPhoto);
    }
  }

  goToHome() {
    navigation.navigateToPage(path: NavigationConstants.contacts);
  }

  @override
  void init() {}
}
