import 'dart:math';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/models/song_model.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../helpers/colors.dart';

class PlayerWidget extends StatefulWidget {
  const PlayerWidget({super.key, this.isRadio = false, this.songs});

  final bool isRadio;
  final List<SongModel>? songs;
  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  late DataProvider dataProvider;
  late DashboardProvider dp;

  bool isLeftToRightDrag = false;
  double startX = 0.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      dataProvider = value;

      if (value.songsState == DataStates.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (value.songsState == DataStates.success && value.currentSong == null) {
        Future.delayed(
          const Duration(milliseconds: 10),
        ).then((v) {
          dataProvider.setSong();
        });
      }

      dataProvider.checkIsAudioComplete();
      if (value.songsState == DataStates.success &&
          dataProvider.isPlayNextSong) {
        if (widget.isRadio) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            print("NExt radio");
            nextRadio();
          });
        } else if (dp.selectedIndex == 2) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            print("Next Genere");
            nextGenre();
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            print("Next City");
            nextCity();
          });
        }
      }

      return dataProvider.currentSong == null
          ? const Center(
              child: Text(
              "No Song Available",
              style: TextStyle(color: Colors.white),
            ))
          : Consumer<DashboardProvider>(builder: (context, dp, child) {
              this.dp = dp;
              return GestureDetector(
                onHorizontalDragEnd: (dragEndDetails) {
                  if (dp.selectedIndex == 2) {
                    if (dragEndDetails.primaryVelocity! < 0) {
                      // nextGenre();
                    } else if (dragEndDetails.primaryVelocity! > 0) {
                      nextGenre();
                    }
                  }
                },
                onPanUpdate: (details) {
                  if (details.delta.dx < 0) {
                    //'Right-to-left swipe detected!'
                  }
                },

                onTap: () {
                  Provider.of<DashboardProvider>(context, listen: false)
                      .selectedIndex = 4;
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
                                        text:
                                            "${value.currentSong!.title}                    ${value.currentSong!.title}                    ${value.currentSong!.title}                    ${value.currentSong!.title}                    ${value.currentSong!.title}                    ${value.currentSong!.title}                    ${value.currentSong!.title}                    ${value.currentSong!.title}                    ",
                                        style: const TextStyle(
                                          fontWeight: FontWeights.normal,
                                          color: Colors.white,
                                          fontSize: 18,
                                        ),
                                        scrollAxis: Axis.horizontal,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        blankSpace: 10.0,
                                        velocity: 50.0,
                                        pauseAfterRound:
                                            const Duration(seconds: 1),
                                        startPadding: 10.0,
                                        accelerationDuration:
                                            const Duration(seconds: 3),
                                        accelerationCurve: Curves.linear,
                                        decelerationDuration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        decelerationCurve: Curves.easeOut,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 60),
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
                                      if (widget.isRadio) {
                                        print("NEXT RADIO");
                                        nextRadio();
                                        return;
                                      }
                                      if (dp.selectedIndex == 2) {
                                        print("NEXTGENERE");
                                        nextGenre();
                                      } else {
                                        print("NEXTCITY");
                                        nextCity();
                                      }
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
                                        UserModel? band = dataProvider.getBand(
                                            dataProvider.currentSong!.bandId);

                                        var uid = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        var db = FirebaseFirestore.instance;
                                        if (isFavourite) {
                                          db
                                              .collection("users")
                                              .doc(uid)
                                              .update({
                                            "favourites":
                                                FieldValue.arrayRemove([
                                              dataProvider.currentSong!.id
                                            ]),
                                          });
                                          db
                                              .collection("Songs")
                                              .doc(dataProvider.currentSong!.id)
                                              .update({
                                            "favourites":
                                                FieldValue.arrayRemove([uid]),
                                          });
                                        } else {
                                          db
                                              .collection("users")
                                              .doc(uid)
                                              .update({
                                            "favourites": FieldValue.arrayUnion(
                                                [dataProvider.currentSong!.id]),
                                          });
                                          db
                                              .collection("Songs")
                                              .doc(dataProvider.currentSong!.id)
                                              .update({
                                            "favourites":
                                                FieldValue.arrayUnion([uid]),
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
                                  const SizedBox(width: 10),
                                ],
                              ),
                              Builder(builder: (context) {
                                UserModel? band = dataProvider
                                    .getBand(dataProvider.currentSong!.bandId);

                                return Text(
                                  "${band!.bandName!}: ${dataProvider.currentSong!.city}",
                                  style: const TextStyle(
                                    color: CColors.primary,
                                    fontSize: 10,
                                  ),
                                );
                              }),
                              const SizedBox(height: 5),
                              AbsorbPointer(
                                absorbing: true,
                                child: ProgressBar(
                                  thumbRadius: 5,
                                  barHeight: 2,
                                  baseBarColor: CColors.placeholderTextColor,
                                  bufferedBarColor:
                                      CColors.placeholderTextColor,
                                  progress: value.audioState == "stopped"
                                      ? const Duration(seconds: 0)
                                      : value.completed,
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
    });
  }

  SongModel getRandomValue(List<SongModel> songs, SongModel previous) {
    Random random = Random();
    int randomIndex;
    List<SongModel> filteredSongs = songs.where((song) {
      if (dataProvider.type == "City Wide") {
        return song.city != previous.city;
      } else if (dataProvider.type == "State Wide") {
        return song.state != previous.state;
      } else {
        return song.country != previous.country;
      }
    }).toList();

    if (filteredSongs.isNotEmpty) {
      randomIndex = random.nextInt(filteredSongs.length);
      return filteredSongs[randomIndex];
    } else {
      if (songs.length > 1) {
        do {
          randomIndex = random.nextInt(songs.length);
        } while (songs[randomIndex] == previous && songs.length > 1);

        return songs[randomIndex];
      } else {
        return previous;
      }
    }
  }

  // SongModel getRandomValue(List<SongModel> songs, SongModel previous) {
  //   Random random = Random();
  //   int randomIndex;
  //
  //   do {
  //     randomIndex = random.nextInt(songs.length);
  //   } while (songs[randomIndex] == previous && songs.length > 1);
  //
  //   return songs[randomIndex];
  // }

  nextCity() {
    dataProvider.stop();

    dataProvider.setAudio = "stopped";

    List<SongModel> songList = [];

    List<SongModel> temp = dataProvider.songs
        .where((element) => element.genreList.any(
            (genre) => genre == dataProvider.userModel!.selectedGenres.first))
        .toList();

    if (dataProvider.type == "City Wide") {
      for (var element in temp) {
        if (element.upVotes.length < 3 &&
            element.city == dataProvider.userModel!.city) {
          songList.add(element);
        } else if (element.upVotes.length == 3 &&
            element.state == dataProvider.userModel!.state &&
            element.city == dataProvider.userModel!.city) {
          songList.add(element);
        } else if (element.country == dataProvider.userModel!.country &&
            element.upVotes.length > 3 &&
            element.state == dataProvider.userModel!.state &&
            element.city == dataProvider.userModel!.city) {
          songList.add(element);
        }
      }
    } else if (dataProvider.type == "State Wide") {
      for (var element in temp) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length == 3 &&
              element.state == dataProvider.userModel!.state) {
            songList.add(element);
          } else if (element.country == dataProvider.userModel!.country &&
              element.upVotes.length > 3 &&
              element.state == dataProvider.userModel!.state) {
            songList.add(element);
          }
        }
      }
    } else {
      for (var element in temp) {
        if (element.country == dataProvider.userModel!.country &&
            element.upVotes.length > 3) {
          songList.add(element);
        }
      }
    }

    if (dataProvider.index + 1 < songList.length) {
      dataProvider.index++;
    } else {
      dataProvider.index = 0;
    }
    if (songList.isEmpty) {
      dataProvider.currentSong = null;
    } else {
      dataProvider.currentSong = songList[dataProvider.index];
      dataProvider.initializePlayer();
    }
  }

  nextGenre() {
    dataProvider.stop();
    dataProvider.setAudio = "stopped";

    List<SongModel> songList = [];
    List<SongModel> temp = dataProvider.songs
        .where((element) => element.genreList.any(
            (genre) => genre == dataProvider.userModel!.selectedGenres.first))
        .toList();

    if (dataProvider.type == "City Wide") {
      for (var element in temp) {
        songList.add(element);
      }
    } else if (dataProvider.type == "State Wide") {
      for (var element in temp) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length >= 3) {
            songList.add(element);
          }
        }
      }
    } else {
      for (var element in temp) {
        if (element.upVotes.length > 3) {
          songList.add(element);
        }
      }
    }

    songList.shuffle();

    if (songList.isNotEmpty) {
      dataProvider.stop();
      dataProvider.setAudio = "stopped";
      SongModel prev = dataProvider.currentSong!;
      SongModel songModel = getRandomValue(songList, prev);
      dataProvider.currentSong = songModel;
      dataProvider.initializePlayer();
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void nextRadio() {
    dataProvider.stop();
    dataProvider.setAudio = "stopped";

    var index = widget.songs!
        .indexWhere((element) => element.id == dataProvider.currentSong!.id);
    var i = 0;
    if (index != -1) {
      i = index;
    }

    SongModel song;

    song = (index == -1 || i + 1 == widget.songs!.length)
        ? widget.songs![0]
        : widget.songs![i + 1];

    dataProvider.currentSong = song;
    dataProvider.initializePlayer();
    setState(() {});
  }
}
