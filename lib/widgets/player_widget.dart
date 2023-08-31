import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:uprise/widgets/player_detail_screen.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../helpers/colors.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      dataProvider = value;

      if (value.songsState == DataStates.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (value.songsState == DataStates.success) {
        Future.delayed(
          const Duration(milliseconds: 10),
        ).then((v) {
          value.currentSong ??= value.songs.first;
        });
      }

      if (value.currentSong == null) {
        return const Center(child: CircularProgressIndicator());
      }

      return GestureDetector(
        onTap: () {
          Provider.of<DashboardProvider>(context, listen: false).selectedIndex =
              4;
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
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
                              child: Marquee(
                                text: "${value.currentSong!.title}            ",
                                style: const TextStyle(
                                  fontWeight: FontWeights.normal,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                                scrollAxis: Axis.horizontal,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                blankSpace: 10.0,
                                velocity: 50.0,
                                pauseAfterRound: const Duration(seconds: 1),
                                startPadding: 10.0,
                                accelerationDuration:
                                    const Duration(seconds: 3),
                                accelerationCurve: Curves.linear,
                                decelerationDuration: const Duration(
                                  milliseconds: 500,
                                ),
                                decelerationCurve: Curves.easeOut,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 60,
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
                            width: 17,
                          ),
                          InkWell(
                            onTap: () {
                              dataProvider.stop();

                              dataProvider.setAudio = "stopped";
                              int index = dataProvider.songs
                                  .indexOf(dataProvider.currentSong!);
                              int nextIndex = index;
                              if (index + 1 < dataProvider.songs.length) {
                                nextIndex++;
                              } else {
                                nextIndex = 0;
                              }
                              dataProvider.currentSong =
                                  dataProvider.songs[nextIndex];
                              dataProvider.initializePlayer();
                            },
                            child: Image.asset(
                              Assets.imagesNext,
                              width: 20,
                              color: CColors.primary,
                            ),
                          ),
                          const SizedBox(
                            width: 17,
                          ),
                          Builder(builder: (context) {
                            bool isFavourite = dataProvider
                                .userModel!.favourites
                                .contains(dataProvider.currentSong!.id);
                            return InkWell(
                              onTap: () {
                                var uid =
                                    FirebaseAuth.instance.currentUser!.uid;
                                var db = FirebaseFirestore.instance;
                                if (isFavourite) {
                                  db.collection("users").doc(uid).update({
                                    "favourites": FieldValue.arrayRemove(
                                        [dataProvider.currentSong!.id]),
                                  });
                                  db
                                      .collection("Songs")
                                      .doc(dataProvider.currentSong!.id)
                                      .update({
                                    "favourites": FieldValue.arrayRemove([uid]),
                                  });
                                } else {
                                  db.collection("users").doc(uid).update({
                                    "favourites": FieldValue.arrayUnion(
                                        [dataProvider.currentSong!.id]),
                                  });
                                  db
                                      .collection("Songs")
                                      .doc(dataProvider.currentSong!.id)
                                      .update({
                                    "favourites": FieldValue.arrayUnion([uid]),
                                  });
                                }
                              },
                              child: Icon(
                                isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_outline_outlined,
                                color: isFavourite
                                    ? Colors.red
                                    : CColors.textColor,
                                size: 30,
                              ),
                            );
                          }),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Text(
                        dataProvider
                            .getBand(dataProvider.currentSong!.bandId)!.bandName!,
                        style: const TextStyle(
                          color: CColors.primary,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 5),
                      ProgressBar(
                        thumbRadius: 5,
                        barHeight: 2,
                        baseBarColor: CColors.placeholderTextColor,
                        bufferedBarColor: CColors.placeholderTextColor,
                        progress: value.completed,
                        buffered: value.bufferedTime!,
                        total: value.total,
                        timeLabelTextStyle: const TextStyle(
                          color: CColors.primary,
                          fontSize: 10,
                        ),
                        onSeek: (duration) {
                          value.seek(duration);
                          // print('User selected a new time: $duration');
                        },
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
