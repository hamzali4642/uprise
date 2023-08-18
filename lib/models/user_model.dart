class UserModel {
  String? id;
  late String username;
  late String email;
  late bool isBand;
  String? bandName;
  String? phone;
  String? facebook;
  String? instagram;
  String? avatar;
  int? instrument;
  String? twitter;
  String? description;
  late String city;
  late String state;
  late String country;

  List<String> selectedGenres = [];
  List<String> followers = [];
  List<String> following = [];

  UserModel({
    this.id,
    required this.username,
    required this.email,
    required this.isBand,
    this.bandName,
    this.phone,
    this.facebook,
    this.instagram,
    this.twitter,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "isBand": isBand,
      "bandName": bandName,
      "phone": phone,
      "facebook": facebook,
      "instagram": instagram,
      "twitter": twitter,
      "description": description
    };
  }

  UserModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    username = data["username"];
    email = data["email"];
    isBand = data["isBand"];
    bandName = data["bandName"];
    phone = data["phone"];
    facebook = data["facebook"];
    instagram = data["instagram"];
    twitter = data["twitter"];
    description = data["description"];
    city = data["city"] ?? "";
    state = data["state"] ?? "";
    country = data["country"] ?? "";
    avatar = data["avatar"];
    instrument = data["instrument"];

    List selectedGenres = data["selectedGenres"] ?? [];
    this.selectedGenres =
        List.generate(selectedGenres.length, (index) => selectedGenres[index]);


    List followers = data["followers"] ?? [];
    this.followers =
        List.generate(followers.length, (index) => followers[index]);


    List following = data["following"] ?? [];
    this.following =
        List.generate(following.length, (index) => following[index]);
  }
}
