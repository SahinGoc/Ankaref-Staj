import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoapp_staj/data/category_service.dart';
import 'package:todoapp_staj/models/category.dart';

class CategoryBloc{
  CategoryService service = CategoryService();

  final categoryStreamController = StreamController.broadcast();

  Stream get getStream => categoryStreamController.stream;

  void addCategory(Category category){
    service.insertCategory(category);
    categoryStreamController.sink.add(service.getCategories());
  }

  void removeCategory(Category category){
    service.deleteCategory(category.id!);
    categoryStreamController.sink.add(service.getCategories());
  }

  void updateCategory(Category category){
    service.updateCategory(category);
    categoryStreamController.sink.add(service.getCategories());
  }

  Future<List<Category>> getCategory(){
    return service.getCategories();
  }

}

final categoryBloc = CategoryBloc();