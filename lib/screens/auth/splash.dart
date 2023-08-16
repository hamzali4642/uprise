import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

    Timer(
        const Duration(seconds: 1),
        () => context.pushAndRemoveUntil(
            child: FirebaseAuth.instance.currentUser == null
                ? const SignIn()
                : const Dashboard()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CustomAssetImage(
        path: Assets.imagesLogo,
        width: 200,
        height: 200,
      )),
    );
  }
}
