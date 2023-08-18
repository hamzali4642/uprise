
class PostModel {
  late String id, bandId;
  Map<String, dynamic>? song;
  Map<String, dynamic>? event;

  int createdAt = DateTime.now().millisecondsSinceEpoch;
  PostModel({
    required this.id,
    required this.bandId,
    required this.song,
    required this.event,
  });

  PostModel.fromMap(Map<String, dynamic> data){
    id = data["id"];
    bandId = data["bandId"];
    song = data["song"];
    event = data["event"];
    createdAt = data["createdAt"];
  }

  Map<String, dynamic> toMap(){
    return {
      "id" : id,
      "bandId" : bandId,
      "song" : song,
      "event" : event,
      "createdAt" : createdAt,
    };
  }
}
