import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/song_model.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../provider/data_provider.dart';
import '../screens/dashboard/band_details.dart';

class SongsWidget extends StatelessWidget {
  const SongsWidget({super.key, this.fromCarousel = false, required this.song});

  final bool fromCarousel;

  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var p = Provider.of<DataProvider>(context, listen: false);
        p.currentSong = song;
        p.initializePlayer();
      },
      child: Column(
        children: [
          fromCarousel
              ? AspectRatio(
                  aspectRatio: 1,
                  child: imageWidget(),
                )
              : SizedBox(
                  width: 150,
                  height: 150,
                  child: imageWidget(),
                ),
          const SizedBox(
            height: 10,
          ),
          Text(
            song.title,
            style: AppTextStyles.clickable(color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget imageWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        4,
      ),
      child: Image(
        image: NetworkImage(
          song.posterUrl,
        ),
        fit: BoxFit.cover,
      ),
    );
  }
}
