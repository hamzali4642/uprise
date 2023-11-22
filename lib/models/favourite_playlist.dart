class FavouritePlayList {
  String? city;
  String? state;
  String? country;
  late String genre;

  FavouritePlayList({this.city, this.state, this.country, required this.genre});

  FavouritePlayList.fromMap(Map<String, dynamic> data) {
    city = data["city"];
    state = data["state"];
    country = data["country"];
    genre = data["genre"];
  }

  Map<String, dynamic> toMap() {
    return {
      "city": city ?? "",
      "state": state ?? "",
      "country": country ?? "",
      "genre": genre,
    };
  }
}
