import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import '../../models/user_model.dart';

class AuthService {
  static CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");

  static Future<void> signUp(BuildContext context, UserModel model) async{
    try {
      DocumentReference doc = userRef.doc();
      model.id = doc.id;

      doc.set(model.toMap());
    } on FirebaseException catch (e) {
      rethrow;
    }
  }
}
