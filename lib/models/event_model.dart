class EventModel {
  String? id;
  late String name;
  late String venue;
  late String description;
  late String posterUrl;
  late DateTime startDate;
  late DateTime endDate;

  EventModel({
    this.id,
    required this.name,
    required this.venue,
    required this.startDate,
    required this.posterUrl,
    required this.endDate,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "venue": venue,
      "posterUrl": posterUrl,
      "startDate": startDate.millisecondsSinceEpoch,
      "endDate": endDate.millisecondsSinceEpoch,
      "description" : description,
    };
  }

  EventModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
    venue = data["venue"];
    posterUrl = data["posterUrl"];
    startDate = DateTime.fromMillisecondsSinceEpoch(data["startDate"]);
    endDate = DateTime.fromMillisecondsSinceEpoch(data["endDate"]);
    description = data["description"];
  }
}
