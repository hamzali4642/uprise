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
  }

  var db = FirebaseFirestore.instance;

  UserModel? userModel;

  List<SongModel> songs = [];

  DataStates profileState = DataStates.waiting;
  DataStates songsState = DataStates.waiting;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userSubscriptions;
  StreamSubscription<Duration>? duration;

  AudioPlayer audioPlayer = AudioPlayer();
  int total = 1;
  bool isDisposed = false;
  bool isPlaying = false;
  double completed = 0;
  double bufferedTime = 0;

  authStream() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        cancelStreams();
      } else {
        getUserData();
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

  getSongs() async {
    QuerySnapshot querySnapshot = await db.collection("Songs").get();

    songs = querySnapshot.docs
        .map((doc) => SongModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();

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

  initializePlayer(String url) {
    audioPlayer.setUrl(url);
    audioPlayer.play();
    isPlaying = true;
    total = audioPlayer.duration?.inSeconds ?? 0;

    audioPlayer.positionStream.listen((event) {
      completed = event.inSeconds / total;
      if (!isDisposed) {
        notifyListeners();
      }
    });
    duration = audioPlayer.bufferedPositionStream.listen((event) async {
      bufferedTime = event.inSeconds / total;
      if (!isDisposed) {
        notifyListeners();
      }
    });

    audioPlayer.playingStream.listen((event) {
      print(event);
    });

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
    isPlaying = false;
  }

  stop() async {
    await audioPlayer.stop();
    isPlaying = false;
  }

  cancelStreams() {
    duration?.cancel();
    isDisposed = true;
    userSubscriptions?.cancel();
  }
}
