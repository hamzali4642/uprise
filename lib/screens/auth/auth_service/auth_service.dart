import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';

import '../../../helpers/functions.dart';
import '../../../models/address_model.dart';
import '../../../models/user_model.dart';
import '../../dashboard.dart';
import '../../select_location.dart';
import '../signin.dart';

class AuthService {
  static CollectionReference userRef =
      FirebaseFirestore.instance.collection("users");

  static Future<void> signUp(BuildContext context, UserModel model,
      String password) async {
    try {
      Functions.showLoaderDialog(context);

      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: model.email, password: password);

      String id = user.user!.uid;

      // Map<String, dynamic> location = await Functions.getCityFromLatLong(
      //     addressModel.latitude!, addressModel.longitude!);
      //
      // model.city = location["city"];
      // model.state = location["state"];
      // model.country = location["country"];

      DocumentReference doc = userRef.doc(id);
      model.id = id;
      await doc.set(model.toMap());
      await doc.update({
        "joinAt": DateTime.now().millisecondsSinceEpoch,
      });
      // ignore: use_build_context_synchronously

      if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: model.email, password: password);
        print("Null user. Signing Again");
      }
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
  //
  // static Future<Map<String, double>> determinePosition(
  //     BuildContext context) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     showError('Location services are disabled.', context);
  //   }
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       if (permission == LocationPermission.deniedForever) {
  //         showError('Location permissions are denied', context);
  //       }
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     showError(
  //         'Location permissions are permanently denied, we cannot request permissions. Turn these on from settings',
  //         context);
  //   }
  //
  //   var position = await Geolocator.getCurrentPosition();
  //
  //   return {"lat": position.latitude, "long": position.longitude};
  // }

  static showError(String message, BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(
              message,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  // determinePosition(context);
                },
                child: Text("Retry"),
              ),
            ],
          );
        });
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
      FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        var id = value.user!.uid;

        var user = FirebaseAuth.instance.currentUser!;

        context.pop();
        UserModel userModel = UserModel(
          id: id,
          username: user.email!.split('@')[0],
          email: user.email!,
          isBand: false,
        );

        bool isExist = false;

        if (user != null) {
          var ref = FirebaseFirestore.instance.collection("users").doc(id);

          DocumentSnapshot snapshot = await ref.get();

          if (!snapshot.exists) {
            userModel.joinAt = DateTime.now();
            print("Here");
            await ref.set(userModel.toMap());
            print("Here");
          }
          context.pushAndRemoveUntil(child: const Dashboard());
        } else {
          context.pushAndRemoveUntil(child: const SignIn());
        }
      }).catchError((error) {
        print("Error");
        print(error);
        context.pop();
        Functions.showSnackBar(context, error.message!);
      });
    } catch (error) {
      print(error);
    }
  }
}
