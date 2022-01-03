import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/helper/premissions.dart';
import '../../../core/model/user.dart';
import '../../../core/provider/user_provider.dart';
import '../../../core/services/firebase/database_service.dart';

part 'contacts_view_model.g.dart';

class ContactsViewModel = _ContactsViewModelBase with _$ContactsViewModel;

abstract class _ContactsViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  DatabaseService service = DatabaseService();
  Permissions per = Permissions();
  List? temp;
  TextEditingController? controller;
  String? currentUserId;
  User? sender;
  List<dynamic> contacts = [];

  @observable
  User? receiver;

  @action
  setReceiverUser(
      String uid, String name, String photoUrl, String phoneNumber) {
    receiver = User(
        userId: uid, name: name, photoUrl: photoUrl, phoneNumber: phoneNumber);
    return receiver;
  }

  @observable
  List<dynamic> phones = [];

  @action
  setPhones(List<dynamic> temp) {
    phones = temp;
  }

  @override
  Future<void> init() async {
    var _contacts = await ContactsService.getContacts(withThumbnails: false);
    // _contacts.length
    for (var i = 0; i < 10; i++) {
      contacts.add('${_contacts[i].phones?.first.value}'
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll(' ', ''));
    }
    var res = await service.getPhoneNumber(contacts);
    setPhones(res.docs);

    var user = Provider.of<UserProvider>(context!, listen: false).user;

    sender = user;
  }
}
