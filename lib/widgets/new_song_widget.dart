import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';

class NewSongWidget extends StatelessWidget {
  const NewSongWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: 150,
            child: const Image(
              image: NetworkImage(Constants.demoCoverImage,),
              fit: BoxFit.cover,
            ),
          ),

          const Text("Simple Plan - I'm just a kid",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),

          Row(
            children: [
              SvgPicture.asset(Assets.imagesBandVector),
              const SizedBox(width: 5,),
              const Expanded(
                child: Text("Jen-Band",
                  style: TextStyle(
                    color: CColors.textColor,
                    fontSize: 12,
                    fontWeight: FontWeights.light
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
