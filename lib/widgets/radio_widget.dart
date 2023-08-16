import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/textstyles.dart';

import '../helpers/colors.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: CColors.bandslineStrokeColor,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: SvgPicture.asset(
                  Assets.imagesRadioStations,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "title",
                style: AppTextStyles.clickable(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
