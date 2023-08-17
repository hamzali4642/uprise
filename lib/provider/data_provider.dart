import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/models/user_model.dart';
import '../models/song_model.dart';

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

  DataStates profileState = DataStates.waiting;
  DataStates songsState = DataStates.waiting;

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

  List<UserModel> users = [];

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


  List<String> cities = [];
  getSongs() async {
    QuerySnapshot querySnapshot = await db.collection("Songs").get();

    songs = querySnapshot.docs
        .map((doc) => SongModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

    var cities = List.generate(songs.length, (index) => songs[index].city);
    this.cities = cities.toSet().toList();
    songsState = DataStates.success;
  }

  List<String> genres = [];

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

  initializePlayer(String url) async {
    audioPlayer.setUrl(url);
    await audioPlayer.play();
    audioState = "playing";
    isPlaying = true;
    if (audioPlayer.duration != null) {
      total = audioPlayer.duration!;
    }

    notifyListeners();

    // total = audioPlayer.duration?.inSeconds ?? 0;
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


