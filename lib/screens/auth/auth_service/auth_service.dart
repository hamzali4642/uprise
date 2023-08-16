import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';

import '../../../helpers/functions.dart';
import '../../../models/user_model.dart';
import '../../dashboard.dart';

class AuthService {
  static CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");

  static Future<void> signUp(
      BuildContext context, UserModel model, String password) async {
    try {
      Functions.showLoaderDialog(context);

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email, password: password);

      DocumentReference doc = userRef.doc();
      model.id = doc.id;

      await doc.set(model.toMap());
      // ignore: use_build_context_synchronously
      context.pushAndRemoveUntil(child: const Dashboard());

    } on FirebaseException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          Functions.showSnackBar(context, "Your email address is not valid");
          break;
        case 'wrong-password':
          Functions.showSnackBar(context, "Password is incorrect");
          break;
        case 'user-not-found':
          Functions.showSnackBar(context,
              "There is no user account associated with the provided email address");
          break;
        case 'user-disabled':
          Functions.showSnackBar(context, "The user account has been disabled");
          break;
        default:
          Functions.showSnackBar(context, e.message!);
          break;
      }
      context.pop();
      print(e.message);
    }
  }

  static Future<void> signIn(
      BuildContext context, String email, String password) async {
    Functions.showLoaderDialog(context);

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // ignore: use_build_context_synchronously
      context.pushAndRemoveUntil(child: const Dashboard());
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          Functions.showSnackBar(
              context, "Invalid Email. No user found with this email");
          break;

        case "wrong-password":
          Functions.showSnackBar(context, "Wrong password entered");
          break;
        default:
          Functions.showSnackBar(context, e.code);
          break;
      }
      print(e.code);
      context.pop();
    }
  }
}
