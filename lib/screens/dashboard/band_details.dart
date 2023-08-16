import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/widgets/songs_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../helpers/colors.dart';

class BandDetails extends StatelessWidget {
  const BandDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.transparentColor,
        title: const Text(
          "Band Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeights.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        child: Column(
          children: [
            const Image(
              image: NetworkImage(
                Constants.demoCoverImage,
              ),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            brandInfoWidget(),
            memberWidget(),
            songsWidget(),
          ],
        ),
      ),
    );
  }

  Widget brandInfoWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: 10,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Brand Name:",
                  style: TextStyle(
                    color: CColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "gytes",
                  style: TextStyle(
                    color: CColors.White,
                    fontSize: 16,
                    fontWeight: FontWeights.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Members",
                  style: TextStyle(
                    color: CColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20,
                ),
                color: CColors.calendarBtnBg,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    Assets.imagesBlackUserAdd,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Unfollow",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget memberWidget() {
    return Container(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding,
        ),
        itemBuilder: (ctx, i) {
          return Column(
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: const ClipOval(
                    child: Image(
                  image: NetworkImage(Constants.demoImage),
                )),
              ),
              Text(
                "Gytes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeights.medium,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (ctx, i) {
          return SizedBox(
            width: 10,
          );
        },
        itemCount: 2,
      ),
    );
  }

  Widget songsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constants.horizontalPadding,),
          child: Text(
            "Members",
            style: TextStyle(
              color: CColors.textColor,
              fontSize: 16,
              fontWeight: FontWeights.medium,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Constants.horizontalPadding,),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return SongsWidget();
            },
            separatorBuilder: (ctx, i) {
              return SizedBox(width: 10,);
            },
            itemCount: 4,
          ),
        )
      ],
    );
  }
}
