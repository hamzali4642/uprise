import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/models/song_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';

class NewSongWidget extends StatelessWidget {
  const NewSongWidget({super.key, required this.song});
  final SongModel song;
  @override
  Widget build(BuildContext context) {

    return Consumer<DataProvider>(
      builder: (context, value, child) {
        var band = value.users.where((element) => element.id == song.bandId).first;
        return SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image(
                  image: NetworkImage(song.posterUrl,),
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 7),
              Text(song.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeights.light
                ),
              ),

              Row(
                children: [
                  SvgPicture.asset(Assets.imagesBandVector),
                  const SizedBox(width: 5,),
                  Expanded(
                    child: Text(band.username,
                      style: const TextStyle(
                        color: CColors.Grey,
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
    );
  }
}
