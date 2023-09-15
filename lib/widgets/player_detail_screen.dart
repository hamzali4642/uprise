import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/band_details.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../generated/assets.dart';
import '../helpers/colors.dart';

class PlayerDetailScreen extends StatefulWidget {
  const PlayerDetailScreen({Key? key}) : super(key: key);

  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  late DataProvider dataProvider;

  bool isBlast = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      dataProvider = value;

      bool isFavourite = dataProvider.userModel!.favourites
          .contains(dataProvider.currentSong!.id);

      isBlast =
          dataProvider.userModel!.blasts.contains(dataProvider.currentSong!.id);

      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Uprise",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
              left: Constants.horizontalPadding,
              right: Constants.horizontalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              GestureDetector(
                onHorizontalDragEnd: (dragEndDetail) {
                  while (
                      dataProvider.songs.first == dataProvider.currentSong!) {
                    dataProvider.songs.shuffle();
                  }

                  dataProvider.currentSong = dataProvider.songs.first;
                  dataProvider.initializePlayer();
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Image(
                    image: NetworkImage(
                      dataProvider.currentSong!.posterUrl,
                    ),
                    fit: BoxFit.cover,
                    height: 250,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dataProvider.currentSong!.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  favouriteWidget(isFavourite),
                ],
              ),
              const SizedBox(height: 5),
              Builder(
                builder: (context) {
                  var band = dataProvider.getBand(dataProvider.currentSong!.bandId)!;
                  return InkWell(
                    onTap: (){
                      context.push(child: BandDetails(band: band));
                    },
                    child: Text(
                      band.bandName!,
                      style: const TextStyle(
                        color: CColors.primary,
                        fontSize: 18,
                      ),
                    ),
                  );
                }
              ),
              const SizedBox(height: 40),
              ProgressBar(
                thumbRadius: 10,
                barHeight: 5,
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
                  print('User selected a new time: $duration');
                },
              ),
              const SizedBox(height: 40),
              controllers(value),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dataProvider.currentSong!.city,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Container(),
            ],
          ),
        ),
      );
    });
  }

  Widget controllers(DataProvider value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            dataProvider.stop();

            dataProvider.setAudio = "stopped";
            int index = dataProvider.songs.indexOf(dataProvider.currentSong!);
            int nextIndex = index;
            if (index + 1 < dataProvider.songs.length) {
              nextIndex++;
            } else {
              nextIndex = 0;
            }
            dataProvider.currentSong = dataProvider.songs[nextIndex];
            dataProvider.initializePlayer();
          },
          child: Image.asset(
            Assets.imagesNext,
            width: 20,
            color: CColors.primary,
          ),
        ),
        InkWell(
          onTap: () {
            var uid = FirebaseAuth.instance.currentUser!.uid;
            var db = FirebaseFirestore.instance;
            if (isBlast) {
              db.collection("users").doc(uid).update({
                "blasts":
                    FieldValue.arrayRemove([dataProvider.currentSong!.id]),
              });
              db.collection("Songs").doc(dataProvider.currentSong!.id).update({
                "blasts": FieldValue.arrayRemove([uid]),
              });
            } else {
              db.collection("users").doc(uid).update({
                "blasts": FieldValue.arrayUnion([dataProvider.currentSong!.id]),
              });
              db.collection("Songs").doc(dataProvider.currentSong!.id).update({
                "blasts": FieldValue.arrayUnion([uid]),
              });
            }
          },
          child: const CustomAssetImage(
            height: 30,
            path: Assets.imagesBlastMain,
            color: CColors.primary,
          ),
        ),
        InkWell(
          onTap: () {
            switch (dataProvider.audioState) {
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
          child: Icon(
            dataProvider.audioState == "playing"
                ? Icons.pause
                : Icons.play_arrow,
            color: Colors.white,
            size: 35,
          ),
        ),
      ],
    );
  }

  Widget favouriteWidget(bool isFavourite) {
    return InkWell(
      onTap: () {
        var uid = FirebaseAuth.instance.currentUser!.uid;
        var db = FirebaseFirestore.instance;
        if (isFavourite) {
          db.collection("users").doc(uid).update({
            "favourites":
                FieldValue.arrayRemove([dataProvider.currentSong!.id]),
          });
          db.collection("Songs").doc(dataProvider.currentSong!.id).update({
            "favourites": FieldValue.arrayRemove([uid]),
          });
        } else {
          db.collection("users").doc(uid).update({
            "favourites": FieldValue.arrayUnion([dataProvider.currentSong!.id]),
          });
          db.collection("Songs").doc(dataProvider.currentSong!.id).update({
            "favourites": FieldValue.arrayUnion([uid]),
          });
        }
      },
      child: Icon(
        isFavourite ? Icons.favorite : Icons.favorite_outline_outlined,
        color: isFavourite ? Colors.red : CColors.textColor,
        size: 30,
      ),
    );
  }
}
