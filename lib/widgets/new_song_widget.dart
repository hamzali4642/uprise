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

  const NewSongWidget({super.key, required this.song, this.isBlasted = false});

  final SongModel song;
  final bool isBlasted;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      var band =
          value.users.where((element) => element.id == song.bandId).first;
      return InkWell(
        onTap: () {
          var p = Provider.of<DataProvider>(context, listen: false);
          p.currentSong = song;
          p.initializePlayer();
        },
        child: SizedBox(
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image(
                  image: NetworkImage(
                    song.posterUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 7),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      song.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeights.light),
                    ),
                  ),
                  if(isBlasted)...[
                    Text(
                      "Blasts: ${song.blasts.length}",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeights.light),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  SvgPicture.asset(Assets.imagesBandVector),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: Text(
                      band.bandName!,
                      style: const TextStyle(
                          color: CColors.Grey,
                          fontSize: 12,
                          fontWeight: FontWeights.light),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
    });
  }
}
