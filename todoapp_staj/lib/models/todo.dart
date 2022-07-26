class ToDo{
  int? id;
  late int? categoryId;
  late String? name;
  late String? description;

  ToDo({this.categoryId, this.name, this.description});
  ToDo.withId({this.id, this.categoryId, this.name, this.description});

  Map<String, dynamic> toMapToDo() {
    Map<String, dynamic> map = Map();

    map["categoryId"] = categoryId;
    map["name"] = name;
    map["description"] = description;
    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  ToDo.fromObject(dynamic o){
    this.id = int.tryParse(o["id"].toString())!;
    this.categoryId = int.tryParse(o["categoryId"].toString());
    this.name = o["name"];
    this.description = o["description"];
  }
}