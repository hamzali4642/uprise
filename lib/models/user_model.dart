class UserModel {
  String? id;
  late String username;
  late String email;
  late bool isBand;
  String? bandName;
  String? phone;

  UserModel(
      {required this.username,
      required this.email,
      required this.isBand,
      this.bandName,
      this.phone});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "username": username,
      "email": email,
      "isBand": isBand,
      "bandName": bandName,
      "phone": phone,
    };
  }

  UserModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    username = data["username"];
    email = data["email"];
    isBand = data["isBand"];
    bandName = data["bandName"];
    phone = data["phone"];
  }
}
