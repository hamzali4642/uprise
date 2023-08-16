import 'package:flutter/material.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../screens/dashboard/band_details.dart';

class SongsWidget extends StatelessWidget {
  const SongsWidget({super.key, this.fromCarousel = false});

  final bool fromCarousel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: null,
      child: Column(
        children: [
          fromCarousel
              ? AspectRatio(
                  aspectRatio: 1,
                  child: imageWidget(),
                )
              : Container(
                  width: 150,
                  height: 150,
                  child: imageWidget(),
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
    );
  }

  Widget imageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        10,
      ),
      child: const Image(
        image: NetworkImage(
          Constants.demoCoverImage,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
