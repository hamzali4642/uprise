import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/screens/auth/onboarding_screen.dart';
import 'package:uprise/screens/dashboard.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/utility_extensions.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    goNext(context);
    return Scaffold(
      body: Center(
          child: SvgPicture.asset(
        Assets.imagesURNavigationIcon,
        width: 200,
        height: 200,
      )),
    );
  }

  goNext(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    context.pushAndRemoveUntil(child: const OnboardingScreen());
  }
}
