import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/screens/auth/signin.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../../helpers/colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CarouselSlider(

              items: const [
                ScreenWidget(
                  title1: "Discover new music",
                  title2: "Explore the taste of local music through Uprise.",
                  path: Assets.imagesStepOne,
                ),
                ScreenWidget(
                  title1: "Explore the music",
                  title2:
                      "Every piece of music has its own encourage. Listen to the best local and international music",
                  path: Assets.imagesStepTwo,
                ),
              ],
              options: CarouselOptions(
                viewportFraction : 1,
                height: 520,
                // aspectRatio: 0.6,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [0, 1].map((index) {
              return Container(
                width: 10,
                height: 10,
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: CColors.primary),
                  shape: BoxShape.circle,
                  color:
                      _currentIndex == index ? CColors.primary : Colors.black,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          bottomButton(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget bottomButton() {
    return ElevatedButton(
      onPressed: () {
        context.push(child: const SignIn());
      },
      child: _currentIndex == 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Skip",
                  style: AppTextStyles.popins(
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeights.medium)),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.black,
                )
              ],
            )
          : Text(
              "Let's Get Started",
              style: AppTextStyles.popins(
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeights.medium)),
            ),
    );
  }
}

class ScreenWidget extends StatelessWidget {
  const ScreenWidget(
      {Key? key,
      required this.path,
      required this.title1,
      required this.title2})
      : super(key: key);

  final String title1;
  final String title2;
  final String path;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 45, right: 45),
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            CustomAssetImage(
              height: 200,
              path: path,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 40),
            Text(
              title1,
              style: AppTextStyles.popins(
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeights.bold),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title2,
              textAlign: TextAlign.center,
              style: AppTextStyles.popins(
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeights.medium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
