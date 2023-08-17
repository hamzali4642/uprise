class SongModel {
  String? id;
  late String title;
  late String city;
  late String genre;
  late String posterUrl;
  late String songUrl;
  late DateTime createdAt;
  late DateTime updatedAt;

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
    genre = data["genre"];
    posterUrl = data["posterUrl"];
    songUrl = data["songUrl"];
    createdAt = DateTime.fromMillisecondsSinceEpoch(data["createdAt"]);
    updatedAt = DateTime.fromMillisecondsSinceEpoch(data["updatedAt"]);
  }
}
