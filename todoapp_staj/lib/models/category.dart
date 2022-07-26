class Category {
  int? id;
  late String name;

  Category(this.name);

  Category.withId(this.id, this.name);

  Map<String, dynamic> toMapCategory() {
    Map<String, dynamic> map = Map();

    map["name"] = name;
    if(id != null){
      map["id"] = id;
    }
    return map;
  }

  Category.fromObject(dynamic o){
    this.id = int.tryParse(o["id"].toString())!;
    this.name = o["name"];
  }

}