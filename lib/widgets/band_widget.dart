import 'package:flutter/material.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/user_model.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../generated/assets.dart';
import '../screens/dashboard/band_details.dart';

class BandWidget extends StatelessWidget {
  const BandWidget({super.key, required this.band});

  final UserModel band;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          child: BandDetails(band: band),
        );
      },
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                4,
              ),
              child: Image(
                image: band.bandProfile == null
                    ? const AssetImage(Assets.imagesBandImg)
                    : NetworkImage(
                        band.bandProfile!,
                      ) as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            band.bandName!,
            style: AppTextStyles.clickable(
                color: Colors.white, fontSize: 14, weight: FontWeights.normal),
          ),
        ],
      ),
    );
  }
}
