import 'package:flutter/material.dart';
import 'package:todoapp_staj/blocks/category_bloc.dart';
import 'package:todoapp_staj/blocks/todo_bloc.dart';
import 'package:todoapp_staj/models/category.dart';
import 'package:todoapp_staj/models/todo.dart';
import 'package:todoapp_staj/screens/category_id_list.dart';

class AddToDo extends StatelessWidget{

  var txtName = TextEditingController();
  var txtDescription = TextEditingController();
  var txtNewCategory = TextEditingController();

  CategoryBloc categoryBloc = CategoryBloc();
  ToDoBloc toDoBloc = ToDoBloc();

  late int? selectedId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          buildSaveFeild(context),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildNameFeild(context),
            SizedBox(height: 8,),
            buildDescriptionFeild(context),
            SizedBox(height: 8,),
            Row(
              children: [
                Flexible(child: Padding(
                  padding: EdgeInsets.only(right: 5.0),
                    child: buildCategoryAdd(),
                ),
                    flex: 3),
                Flexible(child: buildNewCategory(context), flex: 2)
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildNameFeild(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        style: TextStyle(
          color: Theme.of(context).iconTheme.color,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 8.0),
            labelText: "Görev Başlığı",
            border: InputBorder.none,
        ),
        controller: txtName,
      ),
    );
  }

  buildDescriptionFeild(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        maxLines: null,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 8.0),
            labelText: "Açıklama",
            border: InputBorder.none,
        ),
        controller: txtDescription,
      ),
    );
  }

  buildCategoryAdd() {
    return StreamBuilder(
        initialData: categoryBloc.getCategory(),
        stream: categoryBloc.getStream,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return FutureBuilder(
          future: categoryBloc.getCategory(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.hasData ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                ),
              child: DropdownButtonFormField<Category>(
                decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 8.0,),),
                hint: Text("Kategori Seçiniz",),
                items: snapshot.data.map<DropdownMenuItem<Category>>((category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.name),
              );
                }).toList(),
          onChanged: (value) {
            selectedId = value!.id;
            toDoBloc.toDoStreamController.sink.add(toDoBloc.getToDo());
          })
          )
              : Container(
                child: Center(
                  child: Text('Loading...'),
          ),
          );
          });
        }
    );
  }

  buildNewCategory(BuildContext context) {
    return TextButton(
      child: Row(
        children: [
          Icon(Icons.add, color: Theme.of(context).iconTheme.color, size: 21.0),
          Text("Yeni Kategori", style: TextStyle(color: Theme.of(context).iconTheme.color),),
        ],
      ),
    onPressed: () {
        addCategory(context);
      },

    );
  }

  void addCategory(BuildContext context) {
    var alert = AlertDialog(
      title: Text("Yeni Kategori Ekle"),
      content: addCategoryFeild(),
      actions: [
        addCategoryButton(context)
      ],
    );

    showDialog(context: context, builder: (BuildContext) => alert);
  }

  addCategoryFeild() {
    return TextField(
      decoration: InputDecoration(labelText: "Yeni Kategori"),
      controller: txtNewCategory,
    );
  }

  addCategoryButton(BuildContext context) {
    return TextButton(
      child: Text("Tamam"),
      onPressed: () {
        categoryBloc.addCategory(Category(txtNewCategory.text));
        Navigator.pop(context);
      },
    );
  }

  buildSaveFeild(BuildContext context) {
    return TextButton(
        onPressed: () {
          addToDo(context);
        },
        child: Text("Tamam", style: TextStyle(color: Theme.of(context).iconTheme.color),)
    );
  }

  void addToDo(BuildContext context) {
    toDoBloc.addToDo(ToDo(categoryId: selectedId, name: txtName.text, description: txtDescription.text,));
    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryIdListScreen(selectedId!)));

  }
}