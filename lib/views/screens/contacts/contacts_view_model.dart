import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/helper/premissions.dart';
import '../../../core/services/firebase/database_service.dart';

part 'contacts_view_model.g.dart';

class ContactsViewModel = _ContactsViewModelBase with _$ContactsViewModel;

abstract class _ContactsViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  DatabaseService service = DatabaseService();
  Permissions per = Permissions();
  TextEditingController? controller;
  List<dynamic> contacts = [];
  List? temp;
  String? currentUserId;

  @observable
  List<dynamic> phones = [];

  @action
  setPhones(List<dynamic> temp) {
    phones = temp;
  }

  _initFunction() async {
    var _contacts = await ContactsService.getContacts(withThumbnails: false);

    for (var i = 0; i < _contacts.length; i++) {
      // _contacts.length
      contacts.add('${_contacts[i].phones?.first.value}'
          .replaceAll('-', '')
          .replaceAll('(', '')
          .replaceAll(')', '')
          .replaceAll(' ', ''));
    }
    var res = await service.getPhoneNumber(contacts);
    setPhones(res.docs);
  }

  navigateChatScreen() {
    navigation.navigateToPage(path: NavigationConstants.chat);
  }

  @override
  Future<void> init() async {
    _initFunction();
  }
}
