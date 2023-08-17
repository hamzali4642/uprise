class UserModel {
  String? id;
  late String username;
  late String email;
  late bool isBand;
  String? bandName;
  String? phone;
  String? facebook;
  String? instagram;
  String? twitter;
  String? description;

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
      "description" : description
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
  }
}
