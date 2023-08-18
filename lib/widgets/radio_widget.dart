import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/functions.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/screens/dashboard/radio_details.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../helpers/colors.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget({super.key, required this.name, required this.index});

  final String name;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        onTap: () {
          context.push(
              child: RadioDetails(
            name: name,
            index: index,
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Constants.colors[index % Constants.colors.length],
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
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
