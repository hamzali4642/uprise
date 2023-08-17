import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/screens/auth/onboarding_screen.dart';
import 'package:uprise/screens/auth/signin.dart';
import 'package:uprise/screens/dashboard.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/utility_extensions.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkScreen();
  }

  checkScreen() async {
    Timer(const Duration(seconds: 1), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool check = prefs.getBool("onboard") ?? true;

      if (check) {
        prefs.setBool("onboard", false);
        // ignore: use_build_context_synchronously
        context.pushAndRemoveUntil(child: const OnboardingScreen());
      } else {
        // ignore: use_build_context_synchronously
        context.pushAndRemoveUntil(
            child: FirebaseAuth.instance.currentUser == null
                ? const SignIn()
                : const Dashboard());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CustomAssetImage(
        path: Assets.imagesLogoText,
        width: 200,
        height: 200,
      )),
    );
  }
}
