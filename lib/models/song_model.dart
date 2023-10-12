class SongModel {
  String? id;
  late String title;
  late String city;
  List<String> genreList = [];
  late String posterUrl;
  late String songUrl;
  late String bandId;
   String? rid;
  late DateTime createdAt;
  late DateTime updatedAt;
  List<String> favourites = [];
  List<String> blasts = [];

  late String state;
  late String country;

  List<String> upVotes = [];
  List<String> downVotes = [];

  SongModel({
    this.id,
    required this.title,
    required this.city,
    required this.createdAt,
    required this.genreList,
    required this.posterUrl,
    required this.songUrl,
    required this.updatedAt,
    required this.state,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "city": city,
      "genre": genreList,
      "bandId": bandId,
      "posterUrl": posterUrl,
      "songUrl": songUrl,
      "state": state,
      "country": country,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
    };
  }

  SongModel.fromMap(Map<String, dynamic> data) {
    // print(data);
    id = data["id"];
    title = data["title"];
    city = data["city"];

    state = data["state"];
    country = data["country"];

    bandId = data["bandId"];
    rid = data["rid"];
    // print(id);
    genreList = List<String>.from(
        data["genre"]); // Assuming data["genre"] is a List<dynamic>
    posterUrl = data["posterUrl"];
    songUrl = data["songUrl"];
    createdAt = DateTime.fromMillisecondsSinceEpoch(data["createdAt"]);
    updatedAt = DateTime.fromMillisecondsSinceEpoch(data["updatedAt"]);
    List favourites = data["favourites"] ?? [];
    this.favourites =
        List.generate(favourites.length, (index) => favourites[index]);
    List blasts = data["blasts"] ?? [];
    this.blasts = List.generate(blasts.length, (index) => blasts[index]);

    List upVotes = data["upVotes"] ?? [];
    this.upVotes = List.generate(upVotes.length, (index) => upVotes[index]);
    List downVotes = data["downVotes"] ?? [];
    this.downVotes =
        List.generate(downVotes.length, (index) => downVotes[index]);
  }
}
