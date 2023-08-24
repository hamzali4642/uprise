class EventModel {
  String? id;
  late String name;
  late String venue;
  late String bandId;
  late String description;
  late String posterUrl;
  late DateTime startDate;
  late DateTime endDate;
  late double latitude;
  late double longitude;

  EventModel({
    this.id,
    required this.name,
    required this.venue,
    required this.startDate,
    required this.posterUrl,
    required this.endDate,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "venue": venue,
      "bandId" : bandId,
      "posterUrl": posterUrl,
      "startDate": startDate.millisecondsSinceEpoch,
      "endDate": endDate.millisecondsSinceEpoch,
      "description" : description,
      "latitude": latitude,
      "longitude": longitude,
    };
  }

  EventModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    venue = data["venue"];
    bandId = data["bandId"];
    posterUrl = data["posterUrl"];
    startDate = DateTime.fromMillisecondsSinceEpoch(data["startDate"]);
    endDate = DateTime.fromMillisecondsSinceEpoch(data["endDate"]);
    description = data["description"];
    latitude = data["latitude"];
    longitude = data["longitude"];
  }
}
