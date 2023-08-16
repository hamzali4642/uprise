import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';

class FeedWidget extends StatelessWidget {
  const FeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding, vertical: 10),
      decoration: const BoxDecoration(
        color: CColors.feedContainerViewColor,
      ),
      child: Column(
        children: [
          profileWidget(),
          const SizedBox(
            height: 10,
          ),
          const Image(
            image: AssetImage(
              Assets.imagesEvent,
            ),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          SizedBox(
            height: 10,
          ),
          RichText(
            text: const TextSpan(
                text: "Hey there!! Jen-Band have released a song ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeights.bold,
                ),
                children: [
                  TextSpan(
                    text: "Addicted - Simple Pain",
                    style: TextStyle(
                      color: CColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeights.bold,
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  Widget profileWidget() {
    return Row(
      children: [
        ClipOval(
          child: Image(
            image: AssetImage(
              Assets.imagesUsers,
            ),
            width: 30,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "2 days ago",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
