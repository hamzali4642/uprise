import 'package:flutter/material.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/textstyles.dart';

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.title(
        fontSize: 20,
        fontWeight: FontWeights.medium,
        color: Colors.white,
      ),
    );
  }
}
