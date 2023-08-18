import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import '../helpers/colors.dart';

class PlayerWidget extends StatelessWidget {
  const PlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {



      if (value.songsState == DataStates.waiting) {
        return const Center(child: CircularProgressIndicator());
      }


      if(value.songsState == DataStates.success){
        Future.delayed(const Duration(milliseconds: 10),).then((v){
          value.currentSong ??= value.songs.first;
        });
      }


      if (value.currentSong ==null) {
        return const Center(child: CircularProgressIndicator());
      }


      return Container(
        margin: const EdgeInsets.symmetric( vertical: 10),
        child: Row(
          children: [
            Image(
              image: NetworkImage(
                value.currentSong!.posterUrl,
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
                            width: 30,
                            child: Marquee(
                              text: value.currentSong!.title,
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
                            switch (value.audioState) {
                              case "stopped":
                                value.initializePlayer();
                                break;
                              case "pause":
                                value.play();
                                break;
                              case "playing":
                                value.pause();
                                break;
                              default:
                                value.stop();
                                break;
                            }

                          },
                          child: Container(
                            height: 22,
                            width: 22,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CColors.primary,
                            ),
                            child: CustomAssetImage(
                              path: (value.audioState != "playing")
                                  ? Assets.imagesPlayBtn
                                  : Assets.imagesPauseBtn,
                              height: 9,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SvgPicture.asset(
                          Assets.imagesDisableNext,
                          width: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                        const SizedBox(
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
                      progress: value.completed,
                      buffered: value.bufferedTime!,
                      total: value.total,
                      timeLabelTextStyle: const TextStyle(
                        color: CColors.primary,
                        fontSize: 10,
                      ),
                      onSeek: (duration) {

                        value.seek(duration);
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
