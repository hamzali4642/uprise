class SongModel {
  String? id;
  late String title;
  late String city;
  late String genre;
  late String posterUrl;
  late String songUrl;
  late String bandId;
  late DateTime createdAt;
  late DateTime updatedAt;
  List<String> favourites = [];
  List<String> blasts = [];

  SongModel({
    this.id,
    required this.title,
    required this.city,
    required this.createdAt,
    required this.genre,
    required this.posterUrl,
    required this.songUrl,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "city": city,
      "genre": genre,
      "bandId": bandId,
      "posterUrl": posterUrl,
      "songUrl": songUrl,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
    };
  }

  SongModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    title = data["title"];
    city = data["city"];
    bandId = data["bandId"];
    genre = data["genre"];
    posterUrl = data["posterUrl"];
    songUrl = data["songUrl"];
    createdAt = DateTime.fromMillisecondsSinceEpoch(data["createdAt"]);
    updatedAt = DateTime.fromMillisecondsSinceEpoch(data["updatedAt"]);

    List favourites = data["favourites"] ?? [];
    this.favourites =
        List.generate(favourites.length, (index) => favourites[index]);
    List blasts = data["blasts"] ?? [];
    this.blasts =
        List.generate(blasts.length, (index) => blasts[index]);

  }
}
