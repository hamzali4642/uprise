import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/models/post_model.dart';
import 'package:uprise/models/radio_station.dart';
import 'package:uprise/models/user_model.dart';
import '../models/event_model.dart';
import '../models/notification_model.dart';
import '../models/song_model.dart';
import '../screens/dashboard/home/statistics.dart';

class DataProvider extends ChangeNotifier {
  DataProvider() {
    authStream();
  }

  var db = FirebaseFirestore.instance;

  UserModel? userModel;

  List<SongModel> songs = [];
  List<EventModel> events = [];
  List<PostModel> posts = [];
  List<String> genres = [];
  List<UserModel> users = [];
  List<String> cities = [];
  List<NotificationModel> notifications = [];

  List<RadioStationModel> radioStations = [];

  DataStates profileState = DataStates.waiting;
  DataStates songsState = DataStates.waiting;
  DataStates eventState = DataStates.waiting;
  DataStates postState = DataStates.waiting;
  DataStates radioStationState = DataStates.waiting;
  DataStates notificationState = DataStates.waiting;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userSubscriptions;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? songSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? eventSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? postsSubscription;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? genreSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? userListSubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? citySubscription;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? radioStationsStream;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? notificationstream;

  StreamSubscription<Duration>? duration;

  AudioPlayer audioPlayer = AudioPlayer();
  Duration total = const Duration(seconds: 0);

  // bool isDisposed = false;
  bool isPlaying = false;
  bool isPlayNextSong = false;

  String audioState = "stopped";
  Duration completed = const Duration(seconds: 0);
  Duration? bufferedTime = const Duration(seconds: 0);

  String _type = "City Wide";

  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
    notifyListeners();
  }

  set setAudio(String str) {
    audioState = str;
    notifyListeners();
  }

  authStream() {
    if (genres.isEmpty) {
      getGenres();
    }

    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        cancelStreams();
      } else {
        getUserData();
        getUsers();
        getSongs();
        getEvents();
        getPosts();
        getRadioStations();
        getNotifications();
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
    userListSubscription = db.collection("users").snapshots().listen((event) {
      users = [];
      var docs = event.docs.where((element) => element.exists).toList();

      users = List.generate(
        docs.length,
        (index) => UserModel.fromMap(
          docs[index].data(),
        ),
      );
      notifyListeners();
    });
  }

  checkIsAudioComplete() {
    print("checkIsAudioComplete");
    audioPlayer.positionStream.listen((event) {
      completed = event;
      if (completed.inSeconds == total.inSeconds && completed.inSeconds != const Duration(seconds: 0).inSeconds) {
        isPlayNextSong = true;
        //notifyListeners();
      }else{
        isPlayNextSong = false;
        //notifyListeners();
      }
    });
  }

  audiosStreams() {
    audioPlayer.positionStream.listen((event) {
      completed = event;
      if (completed.inSeconds == total.inSeconds) {
        bufferedTime = const Duration(seconds: 0);
        completed = const Duration(seconds: 0);
        audioState = "stopped";
      }
      notifyListeners();
    });
    duration = audioPlayer.bufferedPositionStream.listen((event) async {
      bufferedTime = event;
      notifyListeners();
    });
  }

  getSongs() async {
    songSubscription = db
        .collection("Songs")
        .where("isLive", isEqualTo: true)
        .snapshots()
        .listen((event) {
      songs = [];
      songs = event.docs.map((doc) => SongModel.fromMap(doc.data())).toList();
      print("songs:${songs.length}");
      this.cities = [];
      var cities = List.generate(songs.length, (index) => songs[index].city);
      this.cities = cities.toSet().toList();
      songsState = DataStates.success;
      notifyListeners();
    });
  }

  getNotifications() async {
    notificationstream = db
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Notification")
        .snapshots()
        .listen((event) {
      notifications = [];
      notifications = event.docs
          .map((doc) => NotificationModel.fromMap(doc.data()))
          .toList();
      notificationState = DataStates.success;
      notifyListeners();
    });
  }

  getRadioStations() async {
    radioStationsStream =
        db.collection("radiostation").snapshots().listen((event) {
      radioStations = [];
      radioStations = event.docs
          .map((doc) => RadioStationModel.fromMap(doc.data()))
          .toList();
      radioStationState = DataStates.success;
      notifyListeners();
    });
  }

  getEvents() async {
    eventSubscription = db.collection("events").snapshots().listen((event) {
      events = [];
      events = event.docs.map((doc) => EventModel.fromMap(doc.data())).toList();
      eventState = DataStates.success;
      notifyListeners();
    });
  }

  void getGenres() {
    db.collection("genre").doc("genre").snapshots().listen((event) {
      var genres = event.data()!["genre"] ?? <String>[];
      this.genres = List.generate(genres.length, (index) => genres[index]);
      notifyListeners();
    });
  }

  getPosts() async {
    postsSubscription = db.collection("feed").snapshots().listen((event) {
      posts = [];
      posts = event.docs.map((doc) => PostModel.fromMap(doc.data())).toList();
      postState = DataStates.success;
      notifyListeners();
    });
  }

  initializePlayer() async {
    audioPlayer.dispose();
    audioPlayer = AudioPlayer();
    if (currentSong != null) {
      audioPlayer.setUrl(currentSong!.songUrl);
      audiosStreams();
      await audioPlayer.play();

      audioState = "playing";
      isPlaying = true;
      if (audioPlayer.duration != null) {
        total = audioPlayer.duration!;
      } else {
        print("null");
      }
    }

    notifyListeners();
  }

  UserModel? getBand(String id) {
    UserModel? userModel;

    for (var user in users) {
      if (user.id == id) {
        userModel = user;
        break;
      }
    }

    return userModel;
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

  Map<String, UserModel> getPopularArtistByGenre() {
    Map<String, UserModel> map = {};
    for (var genre in userModel!.selectedGenres) {
      var band = getPopularBand(genre: genre);

      if (band != null) {
        map[genre] = band;
      }
    }

    return map;
  }

  UserModel? getPopularBand({String? genre}) {
    var max = 0;
    UserModel? band;
    for (var user in users.where((element) => element.isBand)) {
      if (genre == null &&
          user.selectedGenres.isNotEmpty &&
          user.selectedGenres.first == userModel!.selectedGenres.first) {
        if (type == "City Wide" && userModel!.city == user.city ||
            type == "State Wide" && userModel!.state == user.state ||
            type == "Country Wide" && userModel!.country == user.country) {
          user.totalUpVotes = 0;
          for (var song in songs
              .where((element) =>
                  genre == null ? true : element.genreList.contains(genre))
              .where((element) => element.bandId == user.id)) {
            user.totalUpVotes += song.upVotes.length;
          }

          if (user.totalUpVotes > max) {
            band = user;
            max = user.totalUpVotes;
          }
        }
      } else {
        user.totalUpVotes = 0;
        for (var song in songs
            .where((element) =>
                genre == null ? true : element.genreList.contains(genre))
            .where((element) => element.bandId == user.id)) {
          user.totalUpVotes += song.upVotes.length;
        }

        if (user.totalUpVotes > max) {
          band = user;
          max = user.totalUpVotes;
        }
      }
    }

    return band;
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
    songSubscription?.cancel();
    eventSubscription?.cancel();
    postsSubscription?.cancel();
    genreSubscription?.cancel();
    userListSubscription?.cancel();
    citySubscription?.cancel();
    duration?.cancel();
    userSubscriptions?.cancel();
    radioStationsStream?.cancel();
    notificationstream?.cancel();
    _currentSong = null;
    songsState = DataStates.waiting;
    userModel = null;
    profileState = DataStates.waiting;


  }

  SongModel? getSong(String id) {
    try {
      SongModel songModel = songs.firstWhere((element) => element.id == id);
      return songModel;
    } catch (e) {
      // Handle the case where no element matches the condition.
      print("Song with ID $id not found.");
      return null; // You can return null or another appropriate value.
    }
  }

  setSong() {
    _currentSong = null;

    List<SongModel> songList = [];

    if (userModel != null) {
      if (type == "City Wide") {
        for (var element in songs) {
          if (userModel!.selectedGenres.isNotEmpty &&
              element.genreList.first == userModel!.selectedGenres.first) {
            if (element.upVotes.length < 3 && element.city == userModel!.city) {
              songList.add(element);
            } else if (element.upVotes.length == 3 &&
                element.state == userModel!.state &&
                element.city == userModel!.city &&
                element.genreList.first == userModel!.selectedGenres.first) {
              songList.add(element);
            } else if (element.country == userModel!.country &&
                element.upVotes.length > 3 &&
                element.state == userModel!.state &&
                element.city == userModel!.city &&
                element.genreList.first == userModel!.selectedGenres.first) {
              songList.add(element);
            }
          }
        }
      } else if (type == "State Wide") {
        for (var element in songs) {
          if (userModel!.selectedGenres.isNotEmpty &&
              element.genreList.first == userModel!.selectedGenres.first) {
            if (element.upVotes.length == 3 &&
                element.state == userModel!.state) {
              songList.add(element);
            } else if (element.country == userModel!.country &&
                element.upVotes.length > 3 &&
                element.state == userModel!.state &&
                element.genreList.first == userModel!.selectedGenres.first) {
              songList.add(element);
            }
          }
        }
      } else {
        for (var element in songs) {
          if (element.country == userModel!.country &&
              element.upVotes.length > 3 &&
              element.genreList.first == userModel!.selectedGenres.first) {
            songList.add(element);
          }
        }
      }
    }

    if (songList.isEmpty) {
      if (currentSong != null) {
        currentSong = null;
      }
    } else {
      currentSong = songList.first;
    }
  }

  @override
  String toString() {
    return 'DataProvider{db: $db, userModel: $userModel, songs: $songs, events: $events, posts: $posts, genres: $genres, users: $users, cities: $cities, radioStations: $radioStations, profileState: $profileState, songsState: $songsState, eventState: $eventState, postState: $postState, radioStationState: $radioStationState, userSubscriptions: $userSubscriptions, songSubscription: $songSubscription, eventSubscription: $eventSubscription, postsSubscription: $postsSubscription, genreSubscription: $genreSubscription, userListSubscription: $userListSubscription, citySubscription: $citySubscription, radioStationsStream: $radioStationsStream, duration: $duration, audioPlayer: $audioPlayer, total: $total, isPlaying: $isPlaying, audioState: $audioState, completed: $completed, bufferedTime: $bufferedTime, _type: $_type, _currentSong: $_currentSong}';
  }
}
