class AddressModel {
  double? latitude, longitude;

  //address controllers
  String address = "";
  String city = "";
  String postalCode = "";
  String country = "";
  String state = "";

  AddressModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.state,
  });

  AddressModel.fromMap(Map<String, dynamic> data) {
    latitude = data["latitude"];
    longitude = data["longitude"];
    address = data["address"];
    city = data["city"];
    postalCode = data["postalCode"];
    country = data["country"];
    state = data["state"];
  }

  Map<String, dynamic> toMap() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
      "city": city,
      "postalCode": postalCode,
      "country": country,
      "state": state,
    };
  }
}