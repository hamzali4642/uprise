import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/models/song_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/player_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';
import '../helpers/constants.dart';

class SongWidget extends StatelessWidget {
  const SongWidget({super.key, required this.song});

  final SongModel song;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var p = Provider.of<DataProvider>(context, listen: false);
        p.currentSong = song;
        p.initializePlayer();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Constants.horizontalPadding, vertical: 10),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                song.posterUrl,
              ),
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                song.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 20),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  SvgPicture.asset(Assets.imagesBandVector),
                                  SizedBox(width: 10,),
                                  const Text(
                                    "Gytes",
                                    style: TextStyle(
                                      color: CColors.textColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "03:45",
                          style: TextStyle(
                            color: CColors.textColor,
                            fontWeight: FontWeights.medium,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
