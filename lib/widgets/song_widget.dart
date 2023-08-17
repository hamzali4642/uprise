import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:uprise/generated/assets.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';
import '../helpers/constants.dart';

class SongWidget extends StatelessWidget {
  const SongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding, vertical: 10),
      child: Row(
        children: [
          const Image(
            image: NetworkImage(
              Constants.demoCoverImage,
            ),
            fit: BoxFit.cover,
            height: 80,
            width: 80,
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            const Text(
                              'Some sample text that takes some space.',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                SvgPicture.asset(Assets.imagesBandVector),
                                SizedBox(width: 10,),
                                const Text(
                                  "Gytes",
                                  style: TextStyle(
                                    color: CColors.textColor,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "03:45",
                        style: TextStyle(
                          color: CColors.textColor,
                          fontWeight: FontWeights.medium,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
