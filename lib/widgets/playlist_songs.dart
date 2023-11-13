import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/margin_widget.dart';
import 'package:uprise/widgets/player_widget.dart';
import 'package:uprise/widgets/song_widget.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import '../generated/assets.dart';
import '../helpers/colors.dart';
import '../helpers/constants.dart';
import '../models/song_model.dart';

class PlaylistSongs extends StatefulWidget {
  const PlaylistSongs({Key? key}) : super(key: key);

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  late DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      dataProvider = value;

      return Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerWidget(),
            const MarginWidget(),
            favouriteRow(),
            songsWidget(value),
            const PlayerWidget(),
            const MarginWidget(),
          ],
        ),
      );
    });
  }

  Widget favouriteRow() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              dataProvider.userModel!.selectedGenres.first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeights.bold,
              ),
            ),
          ),
          Builder(builder: (context) {
            bool isFavourite = dataProvider.userModel!.isFPlaylist;
            return InkWell(
              onTap: () {
                var uid = FirebaseAuth.instance.currentUser!.uid;
                var db = FirebaseFirestore.instance;
                db.collection("users").doc(uid).update({
                  "isFPlaylist": !isFavourite,
                });
              },
              child: Icon(
                isFavourite ? Icons.favorite : Icons.favorite_outline_outlined,
                color: isFavourite ? Colors.red : CColors.textColor,
                size: 30,
              ),
            );
          })
        ],
      ),
    );
  }

  Widget songsWidget(DataProvider dataProvider) {
    List<SongModel> songList = [];

    if (dataProvider.type == "City") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length < 3 &&
              element.city == dataProvider.userModel!.city) {
            songList.add(element);
          } else if (element.upVotes.length == 3 &&
              element.state == dataProvider.userModel!.state) {
            songList.add(element);
          } else if (element.country == dataProvider.userModel!.country &&
              element.upVotes.length > 3) {
            songList.add(element);
          }
        }
      }
    } else if (dataProvider.type == "State") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length == 3 &&
              element.state == dataProvider.userModel!.state) {
            songList.add(element);
          } else if (element.country == dataProvider.userModel!.country &&
              element.upVotes.length > 3) {
            songList.add(element);
          }
        }
      }
    } else {
      for (var element in dataProvider.songs) {
        if (element.country == dataProvider.userModel!.country &&
            element.upVotes.length > 3) {
          songList.add(element);
        }
      }
    }
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemBuilder: (ctx, i) {
          return SongWidget(song: songList[i]);
        },
        itemCount: songList.length,
      ),
    );
  }

  Widget headerWidget() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: context.topPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              Assets.imagesFullRadioStation,
            ),
          ),
          Positioned.fill(
            left: 0,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: Colors.black),
                  Text(
                    "Songs Playlist",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeights.bold,
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
