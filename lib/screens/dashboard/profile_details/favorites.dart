import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';

import '../../../helpers/colors.dart';
import '../../../helpers/constants.dart';
import '../../../widgets/custom_asset_image.dart';


typedef UserCallBack = void Function(int);


class Favorites extends StatefulWidget {
  const Favorites({Key? key, required this.callBack}) : super(key: key);


  final UserCallBack callBack;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {


  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 20), (){
      widget.callBack(2);
    });

  }
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
                fontSize: 14,
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
    return  const Column(
      children: [
        Row(
          children: [
            CustomAssetImage(height: 50,width: 50, path: Assets.imagesMiniPlayer, fit: BoxFit.cover,),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Over_the_Horizon",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "the infidels",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.favorite,
              color: CColors.error,
            )
          ],
        ),
        SizedBox(height: 10),
        Divider(color: CColors.textColor),
      ],
    );
  }
}
