import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/textstyles.dart';

import '../helpers/colors.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget({super.key, this.index = 0});

  final int index;
  @override
  Widget build(BuildContext context) {

    return AspectRatio(
      aspectRatio: 1,
      child: Container(

        decoration: BoxDecoration(
          color: index % 2 == 0 ? CColors.bandslineStrokeColor : Colors.red,
        ),
        child: Stack(
          children: [

            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SvgPicture.asset(
                Assets.imagesRadioStations,
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: Text(
                "title",
                textAlign: TextAlign.center,
                style: AppTextStyles.clickable(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
