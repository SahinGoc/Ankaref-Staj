import 'package:flutter/material.dart';
import 'package:todoapp_staj/blocks/category_bloc.dart';
import 'package:todoapp_staj/blocks/todo_bloc.dart';
import 'package:todoapp_staj/screens/add_to_do.dart';
import 'package:todoapp_staj/screens/category_id_list.dart';
import 'package:todoapp_staj/widgets/change_theme_widget.dart';
import 'package:todoapp_staj/widgets/to_do_list_widget.dart';

class ToDoListScreen extends StatelessWidget {

  ToDoBloc toDoBloc = ToDoBloc();
  CategoryBloc categoryBloc = CategoryBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).bottomAppBarColor,
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.menu), onPressed: () {
              buildBottomDrawer(context);
            }),
            Spacer(),
            ChangeThemeWidget(),
          ],
        ),
      ),
      body: ToDoListWidget(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(255,127,0,0.9),
        foregroundColor: Colors.white,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddToDo()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  buildBottomDrawer(BuildContext context){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              )
          ),
          child: buildDrawer(),
        );
      },
    );
  }

  buildDrawer() {
    return StreamBuilder(
      initialData: categoryBloc.getCategory(),
      stream: categoryBloc.getStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return FutureBuilder(
            initialData: [],
            future: categoryBloc.getCategory(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.data!.length > 0
                  ? buildDrawerList(snapshot)
                  : Center(child: Text("Henüz burada gösterilecek kategori yok..."));
            }
        );
      },
    );
  }

  buildDrawerList(AsyncSnapshot snapshot){
    return Container(
      height: double.maxFinite,
      child: ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (BuildContext context, index){
            final list = snapshot.data;
            return ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryIdListScreen(list[index].id)));
              },
              title: Text(list[index].name, style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: (){
                  categoryBloc.removeCategory(list[index]);
                },
              ),
            );
          }),
    );
  }
}

