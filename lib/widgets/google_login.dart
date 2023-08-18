import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../generated/assets.dart';
import '../helpers/colors.dart';
import '../helpers/textstyles.dart';
import 'custom_asset_image.dart';

class GoogleLogin extends StatelessWidget {
  const GoogleLogin({Key? key, required this.onTap}) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(border: Border.all(color: CColors.primary, width: 0.8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomAssetImage(
                width: 20, height: 20, path: Assets.imagesGoogleIcon),
            const SizedBox(width: 6),
            Text(
              "Continue with Google",
              style: AppTextStyles.popins(
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeights.normal,
                fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
