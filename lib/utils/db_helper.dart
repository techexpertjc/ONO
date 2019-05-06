import 'dart:async';
import 'dart:io';

//import 'package:ono/models/cartItem.dart';
import 'package:ono/models/cartItem2.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper{
  static final DbHelper _instance = new DbHelper.internal();

  factory DbHelper()=>_instance;

  final String tableCart = "cartTable";
  final String columnId = "id";
  final String columnItem = "itemname";
  final String columnQty = "qty";
  final String columnPrice = "price";
  final String columnUrl="url";

  static Database _db;


  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DbHelper.internal();
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(
        documentDirectory.path, "maindb.db"); //home://directory/files/maindb.db

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $tableCart($columnId INTEGER PRIMARY KEY, $columnItem TEXT, $columnPrice INTEGER,$columnQty INTEGER,$columnUrl TEXT)");
  }

  Future<int> saveItem(Item item)async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableCart", item.toMap());
    return res;
  }

  Future<List> getItems() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableCart");

    return result.toList();
  }

  Future<Item> getItem(String name) async{
    var dbClient = await db;
    var result=await dbClient.rawQuery("SELECT * FROM $tableCart WHERE $columnItem = ?",[name]);
    if(result.length==0) return null;
    else{return Item.fromMap(result.first);}
  }

  Future<int> deleteItem(int id) async {
    var dbClient = await db;

    return await dbClient.delete(tableCart,
    where: "$columnId = ?", whereArgs: [id]);
  }

  Future<int> updateItem(Item item) async {
    var dbClient = await db;
    return await dbClient.update(tableCart,
     item.toMap(), where: "$columnId = ?", whereArgs: [item.id]);
  }

  Future<int> deleteAll() async{
    var dbClient=await db;
    return await dbClient.delete(tableCart);
  }

  Future close() async {
     var dbClient = await db;
     return dbClient.close();
  }

}