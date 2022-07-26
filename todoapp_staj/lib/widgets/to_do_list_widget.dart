import 'package:flutter/material.dart';
import 'package:todoapp_staj/blocks/todo_bloc.dart';
import 'package:todoapp_staj/models/todo.dart';
import 'package:todoapp_staj/screens/to_do_details.dart';

class ToDoListWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return buildToDoListBody();
  }

  buildToDoListBody() {
    return Column(
      children: [
        Expanded(
          child: buildToDoList(),
        ),
      ],
    );
  }

  buildToDoList() {
    return StreamBuilder(
      initialData: toDoBloc.getToDo(),
      stream: toDoBloc.getStream,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        return FutureBuilder(
            initialData: [],
            future: toDoBloc.getToDo(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              return snapshot.data!.length > 0
                  ? buildToDoListItem(context, snapshot)
                  : Center(child: Text("Burada görülecek bir şey yok..."));
            });
      },
    );
  }

  buildToDoListItem(BuildContext context, AsyncSnapshot snapshot) {
    final list = snapshot.data;
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: GridView.count(
        crossAxisCount: 2,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: List.generate(list.length, (index){
          return buildToDoItemCard(context,list[index]);
        }),
      ),
    );
  }

  buildToDoItemCard(BuildContext context, ToDo toDo) {
    return Container(
      child: InkWell(
        child: Card(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(toDo.name!, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,)),
                    SizedBox(height: 10.0,),
                    Container(
                      child: IntrinsicHeight(
                        child: Text(toDo.description!, textAlign: TextAlign.center,),
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