import 'package:flutter/material.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/user_model.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../screens/dashboard/band_details.dart';

class BandWidget extends StatelessWidget {
  const BandWidget({super.key, required this.band});

  final UserModel band;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        context.push(
          child: BandDetails(band: band,),
        );
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10,),
              child: const Image(
                image: NetworkImage(
                  Constants.demoCoverImage,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10,),
          Text(
            band.username,
            style: AppTextStyles.clickable(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
