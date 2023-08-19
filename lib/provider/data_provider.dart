import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/models/post_model.dart';
import 'package:uprise/models/user_model.dart';
import '../models/event_model.dart';
import '../models/song_model.dart';
import '../screens/dashboard/home/statistics.dart';

class DataProvider extends ChangeNotifier {
  DataProvider() {
    authStream();

    audioPlayer.positionStream.listen((event) {
      completed = event;
      if (completed.inSeconds == total.inSeconds) {
        bufferedTime = const Duration(seconds: 0);
        completed = const Duration(seconds: 0);
        audioState = "stopped";
      }
      if (!isDisposed) {
        notifyListeners();
      }
    });
    duration = audioPlayer.bufferedPositionStream.listen((event) async {
      bufferedTime = event;
      if (!isDisposed) {
        notifyListeners();
      }
    });
  }

  var db = FirebaseFirestore.instance;

  UserModel? userModel;

  List<SongModel> songs = [];
  List<EventModel> events = [];
  List<PostModel> posts = [];
  List<String> genres = [];
  List<UserModel> users = [];
  List<String> cities = [];

  DataStates profileState = DataStates.waiting;
  DataStates songsState = DataStates.waiting;
  DataStates eventState = DataStates.waiting;
  DataStates postState = DataStates.waiting;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userSubscriptions;
  StreamSubscription<Duration>? duration;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration total = const Duration(seconds: 0);
  bool isDisposed = false;
  bool isPlaying = false;
  String audioState = "stopped";
  Duration completed = const Duration(seconds: 0);
  Duration? bufferedTime = const Duration(seconds: 0);

  authStream() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        cancelStreams();
      } else {
        getUserData();
        getUsers();
        getGenres();
        getSongs();
        getEvents();
        getPosts();
      }
    });
  }

  void getUserData() {
    userSubscriptions = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      profileState = DataStates.waiting;
      if (event.exists && event.data() != null) {
        userModel = UserModel.fromMap(event.data()!);
        profileState = DataStates.success;
      } else {
        userModel = null;
        FirebaseAuth.instance.signOut();
      }
      notifyListeners();
    });
  }

  void getUsers() {
    db.collection("users").get().then((snapshot) {
      var docs = snapshot.docs.where((element) => element.exists).toList();
      users = List.generate(
        docs.length,
        (index) => UserModel.fromMap(
          docs[index].data(),
        ),
      );
      notifyListeners();
    });
  }

  getSongs() async {
    QuerySnapshot querySnapshot = await db.collection("Songs").get();

    songs = querySnapshot.docs
        .map((doc) => SongModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    var cities = List.generate(songs.length, (index) => songs[index].city);
    this.cities = cities.toSet().toList();
    songsState = DataStates.success;
    notifyListeners();
  }

  getEvents() async {
    QuerySnapshot querySnapshot = await db.collection("events").get();

    events = querySnapshot.docs
        .map((doc) => EventModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    eventState = DataStates.success;
    notifyListeners();
  }

  void getGenres() {
    FirebaseFirestore.instance
        .collection("genre")
        .doc("genre")
        .get()
        .then((value) {
      var genres = value.data()!["genre"] ?? <String>[];
      this.genres = List.generate(genres.length, (index) => genres[index]);
      notifyListeners();
    });
  }

  getPosts() async {
    QuerySnapshot querySnapshot = await db.collection("feed").get();

    posts = querySnapshot.docs
        .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
    postState = DataStates.success;
    notifyListeners();
  }

  initializePlayer() async {
    audioPlayer.setUrl(currentSong!.songUrl);
    await audioPlayer.play();
    audioState = "playing";
    isPlaying = true;
    if (audioPlayer.duration != null) {
      total = audioPlayer.duration!;
    }
    notifyListeners();
  }

  String getBandName(String id) {
    late UserModel userModel;

    for (var user in users) {
      if (user.id == id) {
        userModel = user;
        break;
      }
    }

    return userModel.bandName ?? "";
  }

  List<ChartData> getEventChartData() {
    List<ChartData> eventChart = [];

    var now = DateTime.now();
    DateTime previous = DateTime(now.year, now.month - 11, 1);
    int index = 0;
    while (index < 12) {
      List eventList = events
          .where((element) =>
              element.startDate.year == previous.year &&
              element.startDate.month == previous.month)
          .toList();
      eventChart.add(ChartData(previous, eventList.length));
      index++;
      previous = DateTime(previous.year, previous.month + 1, 1);
    }
    return eventChart;
  }

  HashMap<String, int> getGenrePref() {
    int total = 0;

    HashMap<String, int> values = HashMap<String, int>();

    for (var genre in genres) {
      List userList = users
          .where((element) => element.selectedGenres.contains(genre))
          .toList();

      if (userList.isNotEmpty) {
        values[genre] = userList.length;
        total += users.length;
      }
    }

    for (var entry in values.entries) {
      String key = entry.key;
      int value = entry.value;
      int newValue = ((value / total) * 100).toInt();
      values[key] = newValue;
    }

    return values;
  }

  List<ChartData> getBandsChartData() {
    List<ChartData> bandChartData = [];

    var now = DateTime.now();
    DateTime previous = DateTime(now.year, now.month - 5, 1);
    int index = 0;
    while (index < 6) {
      List userList = users
          .where((element) =>
              element.isBand &&
              element.joinAt.year == previous.year &&
              element.joinAt.month == previous.month)
          .toList();

      bandChartData.add(ChartData(previous, userList.length));
      index++;
      previous = DateTime(previous.year, previous.month + 1, 1);
    }

    return bandChartData;
  }

  updateUser(UserModel userModel) {
    try {
      db.collection("users").doc(userModel.id!).update(userModel.toMap());
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  updateUserPref(Map<String, dynamic> map) {
    try {
      db.collection("users").doc(userModel!.id!).update(map);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  SongModel getSong(String id) {
    SongModel songModel = songs.firstWhere((element) => element.id == id);
    print(songModel == null);

    return songModel;
  }

  SongModel? _currentSong;

  SongModel? get currentSong => _currentSong;

  set currentSong(SongModel? value) {
    _currentSong = value;
    notifyListeners();
  }

  pause() async {
    await audioPlayer.pause();
    audioState = "pause";
    isPlaying = false;
    notifyListeners();
  }

  seek(Duration duration) async {
    completed = duration;
    audioPlayer.seek(duration);

    notifyListeners();
  }

  play() async {
    audioState = "playing";
    isPlaying = true;
    notifyListeners();
    await audioPlayer.play();
  }

  stop() async {
    await audioPlayer.stop();
    audioState = "stopped";
    isPlaying = false;
    notifyListeners();
  }

  cancelStreams() {
    duration?.cancel();
    isDisposed = true;
    userSubscriptions?.cancel();
  }
}
