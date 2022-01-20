import 'database_model.dart';

abstract class DatabaseProvider<T extends DatabaseModel> {
  Future open();
  Future<T> getItem(int id);
  Future<List<T>> getList(String receiver, String sender);
  Future<bool> updateItem(int id, T model);
  Future<bool> removeItem(int id);
  Future<bool> insertItem(T model);
}
