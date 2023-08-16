import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';

import '../../../helpers/colors.dart';
import '../../../helpers/constants.dart';
import '../../../widgets/custom_asset_image.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: Constants.horizontalPadding,
          right: Constants.horizontalPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Your Favorites Songs list",
              style: TextStyle(
                fontSize: 18,
                color: CColors.textColor,
              ),
            ),
            const SizedBox(height: 20),
            songWidget(),
            const SizedBox(height: 10),
            songWidget(),
            const SizedBox(height: 10),
            songWidget(),
          ],
        ),
      ),
    );
  }

  Widget songWidget() {
    return  Column(
      children: [
        Row(
          children: [
            CustomAssetImage(height: 50, path: Assets.imagesMiniPlayer),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Over_the_Horizon",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    "the infidels",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.favorite,
              color: CColors.error,
            )
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: CColors.textColor),
      ],
    );
  }
}
