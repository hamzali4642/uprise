import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/widgets/animated_text.dart';

import '../helpers/colors.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image(
            image: NetworkImage(
              Constants.demoCoverImage,
            ),
            fit: BoxFit.cover,
            height: 80,
            width: 80,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 30,
                        child: Marquee(
                          text: 'Some sample text that takes some space.',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          scrollAxis: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          blankSpace: 20.0,
                          velocity: 100.0,
                          pauseAfterRound: Duration(seconds: 1),
                          startPadding: 10.0,
                          accelerationDuration: Duration(seconds: 3),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),

                      ),

                    ),
                    SizedBox(width: 30,),
                    SvgPicture.asset(
                      Assets.imagesPlayBtn,
                      width: 30,
                    ),
                    SizedBox(width: 10,),

                    SvgPicture.asset(
                      Assets.imagesDisableNext,
                      width: 30,
                    ),

                    SizedBox(width: 10,),
                    Icon(Icons.favorite, color: Colors.red,),
                    SizedBox(width: 10,),

                  ],
                ),
                const Text(
                  "Gytes",
                  style: TextStyle(
                    color: CColors.primary,
                    fontSize: 10,
                  ),
                ),
                Slider(
                  min: 0,
                  max: 10,
                  value: 1,
                  onChanged: (value) {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "00:00",
                      style: TextStyle(
                        color: CColors.primary,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      "04:00",
                      style: TextStyle(
                        color: CColors.primary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
