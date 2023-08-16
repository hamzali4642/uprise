class UserModel {
  String? id;
  late String username;
  late String email;
  late bool isBand;
  String? bandName;

  UserModel(
      {required this.username,
      required this.email,
      required this.isBand,
      this.bandName});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "isBand": isBand,
      "bandName": bandName,
    };
  }

  UserModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    username = data["username"];
    email = data["email"];
    isBand = data["isBand"];
    bandName = data["bandName"];
  }
}
