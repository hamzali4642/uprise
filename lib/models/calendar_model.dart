class CalendarModel {
  late DateTime date;
  late String event;

  CalendarModel({
    required this.date,
    required this.event,
  });

  CalendarModel.fromMap(Map<String, dynamic> data){
    date = DateTime.fromMillisecondsSinceEpoch(data["date"]);
    event = data["event"];
  }

  Map<String, dynamic> toMap(){
    return {
      "date" : date.millisecondsSinceEpoch,
      "event" : event,
    };
  }
}
