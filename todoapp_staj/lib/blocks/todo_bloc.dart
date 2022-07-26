import 'dart:async';

import 'package:todoapp_staj/data/todo_service.dart';
import 'package:todoapp_staj/models/todo.dart';

class ToDoBloc{

  ToDoService service = ToDoService();

  final toDoStreamController = StreamController.broadcast();

  Stream get getStream => toDoStreamController.stream;

  void addToDo(ToDo toDo){
    service.insertToDo(toDo);
    toDoStreamController.sink.add(service.getToDos());
  }

  void removeToDo(ToDo toDo){
    service.deleteToDo(toDo.id);
    toDoStreamController.sink.add(service.getToDos());
  }

  void updateToDo(ToDo toDo){
    service.updateToDo(toDo);
    toDoStreamController.sink.add(service.getToDos());
  }

  Future<List<ToDo>> getToDo() async{
    return await service.getToDos();
  }

  Future<List<ToDo>> getTodosByCategoryId(int id){
    return service.getToDoByCategoryId(id);
  }

  Future<List<ToDo>> getTodosById(int id){
    return service.getToDoById(id);
  }
}

final toDoBloc = ToDoBloc();