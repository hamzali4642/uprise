import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/models/user_model.dart';

class DataProvider extends ChangeNotifier {
  DataProvider() {
    authStream();
  }

  var db = FirebaseFirestore.instance;

  UserModel? userModel;

  DataStates profileState = DataStates.waiting;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userSubscriptions;

  authStream() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        cancelStreams();
      } else {
        getUserData();
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

  cancelStreams() {
    userSubscriptions?.cancel();
  }

  updateUser(UserModel userModel) {
    try {
      db.collection("users").doc(userModel.id!).update(userModel.toMap());
    } on FirebaseException catch (e) {
      print(e);
    }
  }
}
