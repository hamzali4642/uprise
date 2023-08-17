import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/provider/data_provider.dart';
import '../helpers/colors.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      if (value.songsState == DataStates.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      String imageUrl = value.songs.first.posterUrl;
      String songUrl = value.songs.first.songUrl;

      return Container(
        margin: const EdgeInsets.symmetric(
            horizontal: Constants.horizontalPadding, vertical: 10),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                imageUrl,
              ),
              fit: BoxFit.cover,
              height: 80,
              width: 80,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 30,
                            child: Marquee(
                              text: 'Some sample text that takes some space.',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20),
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 20.0,
                              velocity: 50.0,
                              pauseAfterRound: const Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: const Duration(seconds: 3),
                              accelerationCurve: Curves.linear,
                              decelerationDuration:
                                  const Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            if (value.isPlaying) {
                              value.stop();
                            } else {
                              value.initializePlayer(songUrl);
                            }
                          },
                          child: SvgPicture.asset(
                            Assets.imagesPlayBtn,
                            width: 30,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(
                          Assets.imagesDisableNext,
                          width: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const Text(
                      "Gytes",
                      style: TextStyle(
                        color: CColors.primary,
                        fontSize: 10,
                      ),
                    ),
                    ProgressBar(
                      progress: const Duration(milliseconds: 1000),
                      buffered: const Duration(milliseconds: 2000),
                      total: const Duration(milliseconds: 5000),
                      timeLabelTextStyle: const TextStyle(
                        color: CColors.primary,
                        fontSize: 10,
                      ),
                      onSeek: (duration) {
                        print('User selected a new time: $duration');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
