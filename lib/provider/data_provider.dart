import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:uprise/models/user_model.dart';

class DataProvider extends ChangeNotifier {
  DataProvider() {
    authStream();
  }

  var db = FirebaseFirestore.instance;

  UserModel? userModel;

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
      if (event.exists && event.data() != null) {
        userModel = UserModel.fromMap(event.data()!);
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
}
