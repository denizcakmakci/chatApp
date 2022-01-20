import 'package:flutter/material.dart';

import '../model/chat.dart';
import '../model/user.dart';
import '../services/sqflite/chat_database_provider.dart';

class MessageProvider extends ChangeNotifier {
  ChatDatabaseProvider databaseProvider = ChatDatabaseProvider();

  List<ChatModel> _userList = [];
  List<ChatModel> get userList => _userList;

  setMessage(String receiver, String sender) async {
    await databaseProvider
        .getList(receiver, sender)
        .then((value) => _userList = value);
    notifyListeners();
  }

  List<String> _messagesUserList = [];
  List<String> get messagesUserList => _messagesUserList;

  setMessagesUserList(String uid) async {
    _messagesUserList.add(uid);
    notifyListeners();
  }

  onlyMessageUserClear() async {
    _messagesUserList.clear();
    notifyListeners();
  }

  List<String> _getOnlyMessage = [];
  List<String> get getOnlyMessage => _getOnlyMessage;

  setGetOnlyMessage(String message) async {
    _getOnlyMessage.add(message);
    notifyListeners();
  }

  onlyMessageClear() async {
    _getOnlyMessage.clear();
    notifyListeners();
  }

  List<User> _user = [];
  List<User> get user => _user;

  setUser(User user) {
    _user.add(user);
    notifyListeners();
  }

  userClear() async {
    _user.clear();
    notifyListeners();
  }
}
