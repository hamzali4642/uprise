class GenreModel{
  late String name;

  GenreModel.fromMap(Map<String, dynamic> data){
    name = data["name"];
  }
}