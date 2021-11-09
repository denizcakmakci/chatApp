import 'dart:developer';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/services/firebase/database_service.dart';

part 'contacts_view_model.g.dart';

class ContactsViewModel = _ContactsViewModelBase with _$ContactsViewModel;

abstract class _ContactsViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  DatabaseService service = DatabaseService();
  List? temp;
  TextEditingController? controller;

  List<dynamic> contacts = [];

  @observable
  List<dynamic> phones = [];

  @action
  setPhones(List<dynamic> temp) {
    phones = temp;
  }

  @override
  Future<void> init() async {
    var _contacts = await ContactsService.getContacts(withThumbnails: false);
    for (var i = 0; i < _contacts.length; i++) {
      contacts.add('${_contacts[i].phones?.elementAt(0).value}'
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll(' ', ''));
      log(contacts[i]);
    }
    var res = await service.getPhoneNumber(contacts);
    setPhones(res.docs);
  }
}
