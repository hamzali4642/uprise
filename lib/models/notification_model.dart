class NotificationModel {
  late String id;
  late String text;
  late String type;
  late int time;
  late bool isRead;

  NotificationModel(
      {required this.text,
      required this.type,
      required this.time,
      required this.isRead,
      });

  NotificationModel.fromMap(Map<String, dynamic> data) {
    id = data["id"];
    text = data["text"];
    type = data["type"];
    time = data["time"];
    isRead = data["isRead"] ?? false;
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text": text,
      "type": type,
      "time": time,
      "isRead": isRead,
    };
  }
}
