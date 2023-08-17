import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/widgets/song_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';

class RadioDetails extends StatefulWidget {
  const RadioDetails({super.key});

  @override
  State<RadioDetails> createState() => _RadioDetailsState();
}

class _RadioDetailsState extends State<RadioDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget(),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.horizontalPadding,
              ),
              child: Text(
                "Texas",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeights.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (ctx, i) {
                  return SongWidget();
                },
                itemCount: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headerWidget() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: context.topPadding),
      decoration: BoxDecoration(
        color: Colors.amber,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              Assets.imagesFullRadioStation,
            ),
          ),
          Positioned.fill(
            left: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(
                    color: Colors.white,
                  ),
                  Text(
                    "Texas",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeights.bold,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
