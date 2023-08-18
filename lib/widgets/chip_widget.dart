import 'package:flutter/material.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';

class ChipWidget extends StatelessWidget {
  const ChipWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5,),
      decoration: BoxDecoration(
        color: CColors.URbtnBgColor,
        borderRadius: BorderRadius.circular(4,),
      ),
      child: Text(
        text,
        style: AppTextStyles.popins(
          style: const TextStyle(
            color: CColors.primary,
            fontSize: 12,
            fontWeight: FontWeights.medium,
          )
        ),
      ),
    );
  }
}
