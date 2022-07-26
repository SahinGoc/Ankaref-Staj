import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp_staj/models/category.dart';

class CategoryService{

  static CategoryService _singleton = CategoryService.internal();

  factory CategoryService(){
    return _singleton;
  }

  CategoryService.internal();

  Database? _db;

  Future<Database?> get db async{
    if(_db == null){
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(),"trade.db");
    var tradeDb = await openDatabase(dbPath,version: 1,onCreate: createDb);
    return tradeDb;
  }

  void createDb(Database db, int version) async{
    db.execute("create table categories(id integer primary key, name text)");
  }

  Future<List<Category>> getCategories() async {
    Database? db = await this.db;
    var result = await db!.query("categories");
    return List.generate(result.length, (i) {
      return Category.fromObject(result[i]);
    });
  }

  Future<int> insertCategory(Category category) async{
    Database? db = await this.db;
    var result = db!.insert("categories", category.toMapCategory());
    return result;
  }

  Future<int> deleteCategory(int id) async{
    Database? db = await this.db;
    var result = db!.rawDelete("delete from categories where id= $id");
    return result;
  }

  Future<int> updateCategory(Category  category) async{
    Database? db = await this.db;
    var result = db!.update("categories", category.toMapCategory(),where: "id=?",whereArgs: [category.id]);
    return result;
  }

}