import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

import '../../../core/base/base_view_model.dart';
import '../../../core/constants/navigation/navigation_constants.dart';
import '../../../core/helper/premissions.dart';
import '../../../core/model/chat.dart';
import '../../../core/provider/call_provider.dart';
import '../../../core/provider/message_provider.dart';
import '../../../core/provider/scroll_provider.dart';
import '../../../core/provider/user_provider.dart';
import '../../../core/services/firebase/database_service.dart';
import '../../../core/services/sqflite/chat_database_provider.dart';

part 'chat_view_model.g.dart';

class ChatViewModel = _ChatViewModelBase with _$ChatViewModel;

abstract class _ChatViewModelBase with Store, BaseViewModel {
  @override
  void setContext(BuildContext context) => this.context = context;

  Permissions per = Permissions();
  ChatDatabaseProvider databaseProvider = ChatDatabaseProvider();

  TextEditingController controller = TextEditingController();

  ChatModel chatModel = ChatModel();
  DatabaseService service = DatabaseService();

  bool isFirstMessage = true;

  Future<void> saveModel() async {
    final result = await databaseProvider.insertItem(chatModel);
    log(result.toString());
    await Provider.of<ScrollProvider>(context!, listen: false)
        .scrollToBottom(300);
  }

  navigateHomeScreen() {
    navigation.navigateToPage(path: NavigationConstants.home);
  }

  @override
  Future<void> init() async {
    var receiver = Provider.of<CallProvider>(context!, listen: false).receiver;
    var sender = Provider.of<UserProvider>(context!, listen: false).user;
    await Provider.of<MessageProvider>(context!)
        .setMessage(receiver!.userId!, sender!.userId!);
    Provider.of<ScrollProvider>(context!, listen: false).scrollToBottom(50);
    isFirstMessage =
        Provider.of<MessageProvider>(context!, listen: false).userList.isEmpty;
  }
}
