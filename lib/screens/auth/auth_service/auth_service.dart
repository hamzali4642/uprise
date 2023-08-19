import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';

import '../../../helpers/functions.dart';
import '../../../models/user_model.dart';
import '../../dashboard.dart';
import '../signin.dart';

class AuthService {
  static CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");

  static Future<void> signUp(
      BuildContext context, UserModel model, String password) async {
    try {
      Functions.showLoaderDialog(context);

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email, password: password);

      String id = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference doc = userRef.doc(id);
      model.id = id;
      await doc.set(model.toMap());
      await doc.update({
        "joinAt" : DateTime.now().millisecondsSinceEpoch,
      });
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

  static googleLogin(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      var result = await _googleSignIn.signIn();
      if (result == null) {
        return;
      }
      // ignore: use_build_context_synchronously
      Functions.showLoaderDialog(context);
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: userData.accessToken, idToken: userData.idToken);
      FirebaseAuth.instance.signInWithCredential(credential).then((value) {
        var id = value.user!.uid;

        var user = FirebaseAuth.instance.currentUser!;

        context.pop();
        UserModel userModel = UserModel(
          id: id,
          username: user.email!.split('@')[0],
          email: user.email!,
          isBand: false,
        );

        if (user != null) {
          var ref =
              FirebaseFirestore.instance.collection("users").doc(userModel.id);
          ref.get().then((value) async {
            if (!value.exists) {
              await ref.set(userModel.toMap());
              await ref.update({
                "joinAt" : DateTime.now().millisecondsSinceEpoch,
              });
            }
            context.pushAndRemoveUntil(child: const Dashboard());
          });
        } else {
          context.pushAndRemoveUntil(child: const SignIn());
        }
      }).catchError((error) {
        context.pop();
        Functions.showSnackBar(context, error.message!);
      });
    } catch (error) {}
  }
}
