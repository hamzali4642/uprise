import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import '../generated/assets.dart';
import '../helpers/constants.dart';
import '../helpers/textstyles.dart';

class RadioStationCover extends StatelessWidget {
  const RadioStationCover(
      {Key? key, required this.name, required this.color, this.textColor})
      : super(key: key);
  final Color color;
  final String name;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
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
            bottom: 22,
            child: Text(
              name,
              textAlign: TextAlign.center,
              style: AppTextStyles.clickable(
                fontSize: 15,
                weight: FontWeights.normal,
                color: textColor ?? Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
