import 'dart:developer';

import 'package:sqflite/sqflite.dart';

import '../../model/chat.dart';
import 'database_provider.dart';

class ChatDatabaseProvider extends DatabaseProvider<ChatModel> {
  final String _userDatabaseName = "chatDatabase";
  final String _userTableName = "chats";

  String columnId = "id";
  String columnSender = "sender";
  String columnReceiver = "receiver";
  String columnMessage = "message";
  String columnTime = "time";
  final int _version = 1;

  Database? database;

  Future<void> close() async {
    if (database == null) await open();
    await database!.close();
  }

  @override
  Future open() async {
    database = await openDatabase(
      _userDatabaseName,
      version: _version,
      onCreate: (db, version) {
        createTable(db);
      },
    );
    log('database open');
  }

  Future<void> createTable(Database db) async {
    await db.execute(
      '''CREATE TABLE $_userTableName (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $columnSender VARCHAR(20), 
        $columnReceiver VARCHAR(20),
        $columnMessage VARCHAR(280),
        $columnTime VARCHAR(20) )
        ''',
    );
  }

  @override
  Future<ChatModel> getItem(int id) async {
    if (database == null) await open();
    final userMaps = await database!.query(
      _userTableName,
      where: '$columnId = ?',
      columns: [columnId],
      whereArgs: [id],
    );

    return ChatModel.fromJson(userMaps.first);
  }

  @override
  Future<List<ChatModel>> getList(String receiver, String sender) async {
    if (database == null) await open();
    List<Map<String, dynamic>> chatMaps = await database!.query(
      _userTableName,
      where:
          "$columnSender = ? AND $columnReceiver = ? OR $columnSender = ? AND $columnReceiver = ?",
      whereArgs: [sender, receiver, receiver, sender],
    );
    return chatMaps.map((e) => ChatModel.fromJson(e)).toList();
  }

  Future<bool> removeMessage(String receiver, String sender) async {
    if (database == null) await open();
    final userMaps = await database!.delete(_userTableName,
        where:
            "$columnSender = ? AND $columnReceiver = ? OR $columnSender = ? AND $columnReceiver = ?",
        whereArgs: [sender, receiver, receiver, sender]);
    // ignore: unnecessary_null_comparison
    return userMaps != null;
  }

  Future<List<ChatModel>> getMessages(String receiver, String sender) async {
    if (database == null) await open();
    List<Map<String, dynamic>> chatMaps = await database!.query(_userTableName,
        where:
            "$columnSender = ? AND $columnReceiver = ? OR $columnSender = ? AND $columnReceiver = ?",
        whereArgs: [sender, receiver, receiver, sender],
        orderBy: "$columnId DESC",
        limit: 1);
    log('message ${chatMaps.length}');
    return chatMaps.map((e) => ChatModel.fromJson(e)).toList();
  }

  Future<List<String>> getUsers(String sender) async {
    if (database == null) await open();
    List<Map<String, dynamic>> chatMaps = await database!.query(_userTableName,
        where: "$columnReceiver = ?", whereArgs: [sender], distinct: true);

    final unique = chatMaps.map((e) => ChatModel.fromJson(e)).toList();
    var set = <String>{};
    for (var i = 0; i < unique.length; i++) {
      set.add(unique[i].sender!);
    }
    log(set.length.toString());
    return set.toList();
  }

  @override
  Future<bool> insertItem(ChatModel model) async {
    if (database == null) await open();
    final userMaps = await database!.insert(
      _userTableName,
      model.toJson(),
    );

    // ignore: unnecessary_null_comparison
    return userMaps != null;
  }

  @override
  Future<bool> removeItem(int id) async {
    if (database == null) await open();
    final userMaps = await database!.delete(
      _userTableName,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    // ignore: unnecessary_null_comparison
    return userMaps != null;
  }

  @override
  Future<bool> updateItem(int id, ChatModel model) async {
    if (database == null) await open();
    final userMaps = await database!.update(
      _userTableName,
      model.toJson(),
      where: '$columnId = ?',
      whereArgs: [id],
    );

    // ignore: unnecessary_null_comparison
    return userMaps != null;
  }
}
