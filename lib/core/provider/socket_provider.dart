// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart';

class SocketProvider extends ChangeNotifier {
  var socket = io('https://leveret-chat.herokuapp.com', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  late BuildContext context;

  registerUser(String id) {
    socket.connect();
    socket.emit('registerUser', id);
    //socket.on('onlineUsers', print);
    notifyListeners();
  }

  List? _userList;
  List? get userList => _userList;

  setUserName(List list) {
    _userList = list;
    notifyListeners();
  }

  onSocket() {
    // ignore: unnecessary_lambdas
    socket.on('onlineUsers', (data) {
      print(data);
      setUserName(data);
    });
    notifyListeners();
  }

  sendMessage(String receiver, String sender, String message) {
    //var chat = <String,String>{};
    socket.emit('sendMessage', {
      "receiverId": receiver,
      "senderId": sender,
      "message": message,
    });
    notifyListeners();
  }

//   var sender = Provider.of<UserProvider>(context!, listen: false).user;
//     var socket = io('http://192.168.1.25:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//     socket.connect();
//     socket.emit('registerUser', sender!.userId);
//     socket.on('onlineUsers', (data) => print(data));
}
