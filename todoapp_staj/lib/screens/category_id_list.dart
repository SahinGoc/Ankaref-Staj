import 'package:flutter/material.dart';
import 'package:todoapp_staj/blocks/category_bloc.dart';
import 'package:todoapp_staj/blocks/todo_bloc.dart';
import 'package:todoapp_staj/models/todo.dart';
import 'package:todoapp_staj/screens/add_to_do.dart';
import 'package:todoapp_staj/screens/to_do_details.dart';
import 'package:todoapp_staj/widgets/change_theme_widget.dart';

class CategoryIdListScreen extends StatefulWidget{
  late int id;
  CategoryIdListScreen(this.id);

  @override
  _CategoryIdListScreenState createState() => _CategoryIdListScreenState();
}

class _CategoryIdListScreenState extends State<CategoryIdListScreen> {
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
            ChangeThemeWidget()
          ],
        ),
      ),

      body: buildCategoryIdListBody(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(255,127,0,0.9),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddToDo()));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawerEnableOpenDragGesture: false,
    );
  }

  void buildBottomDrawer(BuildContext context){
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
                    : Center(child: Text("Burada görülecek bir şey yok..."));
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
                  widget.id = list[index].id;
                  toDoBloc.toDoStreamController.sink.add(toDoBloc.getToDo());
                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryIdListScreen(widget.id)));
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

  buildCategoryIdListBody() {
    return Column(
      children: [
        Expanded(
          child: buildCategoryIdList(),
        ),
      ],
    );
  }

  buildCategoryIdList() {
    return StreamBuilder(
      initialData: toDoBloc.getToDo(),
      stream: toDoBloc.getStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return FutureBuilder(
            initialData: [],
            future: toDoBloc.getTodosByCategoryId(widget.id),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.data!.length > 0
                  ? buildCategoryIdListItem(context, snapshot)
                  : Center(child: Text("Burada görülecek bir şey yok..."));
            });
      },
    );
  }

  buildCategoryIdListItem(BuildContext context, AsyncSnapshot snapshot) {
    final list = snapshot.data;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: List.generate(list.length, (index){
          return buildCategoryIdItemCard(context,list[index]);
        }),
      ),
    );
  }

  buildCategoryIdItemCard(BuildContext context, ToDo toDo) {
    return Container(
      width: MediaQuery.of(context).size.width/3,
      child: InkWell(
        child: Card(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(toDo.name!, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 10.0,),
                    Container(
                      child: IntrinsicHeight(
                          child: Text(toDo.description!, textAlign: TextAlign.center)
                      ),
                      width: MediaQuery.of(context).size.width/2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ToDoDetails(toDo)));
          toDoBloc.toDoStreamController.sink.add(toDoBloc.getToDo());
          },
      ),
    );
  }

}
