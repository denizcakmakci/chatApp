import '../services/sqflite/database_model.dart';

class ChatModel extends DatabaseModel<ChatModel> {
  String? sender;
  String? receiver;
  String? time;
  String? message;

  ChatModel({this.sender, this.receiver, this.time, this.message});

  T? _check<T>(T? data) => data is T ? data : null;

  ChatModel.fromJson(Map<String, dynamic> json) {
    sender = _check<String>(json['sender']);
    receiver = _check<String>(json['receiver']);
    time = _check<String>(json['time']);
    message = _check<String>(json['message']);
  }

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sender'] = sender;
    data['receiver'] = receiver;
    data['time'] = time;
    data['message'] = message;
    return data;
  }

  @override
  ChatModel fromJson(Map<String, dynamic> json) {
    return ChatModel.fromJson(json);
  }
}
