import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp_staj/blocks/todo_bloc.dart';
import 'package:todoapp_staj/models/todo.dart';

class ToDoService{

  static ToDoService _singleton = ToDoService._internal();

  factory ToDoService(){
    return _singleton;
  }

  ToDoService._internal();


  Database? _db;

  Future<Database?> get db async{
    if(_db == null){
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(),"eTrade.db");
    var eTradeDb = await openDatabase(dbPath,version: 1,onCreate: createDb);
    return eTradeDb;
  }

  void createDb(Database db, int version) async{
    db.execute("create table todos(id integer primary key, categoryId integer, name text, description text)");
  }

   Future<List<ToDo>> getToDos() async {
    Database? db = await this.db;
    var result = await db!.query("todos");
    return List.generate(result.length, (i) {
      return ToDo.fromObject(result[i]);
    });
  }

   Future<int> insertToDo(ToDo toDo) async{
    Database? db = await this.db;
    var result = db!.insert("todos", toDo.toMapToDo());
    return result;
  }

   Future<int> deleteToDo(int? id) async{
    Database? db = await this.db;
    var result = db!.rawDelete("delete from todos where id= $id");
    return result;
  }

   Future<int> updateToDo(ToDo toDo) async{
    Database? db = await this.db;
    var result = db!.update("todos", toDo.toMapToDo(),where: "id=?",whereArgs: [toDo.id]);
    return result;
  }

  Future<List<ToDo>> getToDoByCategoryId(int id) async {
    Database? db = await this.db;
    var result = await db!.rawQuery("select * from todos where categoryId= $id");
    return List.generate(result.length, (i) {
      return ToDo.fromObject(result[i]);
    });
  }

  Future<List<ToDo>> getToDoById(int id) async {
    Database? db = await this.db;
    var result = await db!.rawQuery("select * from todos where id= $id");
    return List.generate(result.length, (i) {
      return ToDo.fromObject(result[i]);
    });
  }
}