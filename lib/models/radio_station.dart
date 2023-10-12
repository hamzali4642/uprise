class RadioStationModel {
  late String id;
  late String name;
  late String state;
  late String city;
  late String color;
  late String country;
  late String genre;

  List<String> favourites = [];

  RadioStationModel(
      {required this.id,
      required this.country,
      required this.state,
      required this.city,
      required this.name,
      required this.color,
      required this.genre});

  RadioStationModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    state = data["state"];
    city = data["city"];
    color = data["color"];
    country = data["country"];
    genre = data["genre"];
    List favourites = data["favourites"] ?? [];
    this.favourites =
        List<String>.generate(favourites.length, (index) => favourites[index]);
  }
}
