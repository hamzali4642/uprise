import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/models/favourite_playlist.dart';
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
  const PlaylistSongs({Key? key, this.favouritePlayList}) : super(key: key);

  final FavouritePlayList? favouritePlayList;

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
              widget.favouritePlayList?.genre ??
                  dataProvider.userModel!.selectedGenres.first,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeights.bold,
              ),
            ),
          ),
          if (!(widget.favouritePlayList == null &&
              discoverySongs().isEmpty)) ...[
            Builder(builder: (context) {
              bool isFavourite = isPlaylistFavourite();
              return InkWell(
                onTap: () {
                  if (widget.favouritePlayList == null) {
                    clickFavouriteIconDiscoveryScreen(isFavourite);
                  } else {
                    clickFavouriteIconFavourteScreen(isFavourite);
                  }
                },
                child: Icon(
                  isFavourite
                      ? Icons.favorite
                      : Icons.favorite_outline_outlined,
                  color: isFavourite ? Colors.red : CColors.textColor,
                  size: 30,
                ),
              );
            })
          ]
        ],
      ),
    );
  }

  clickFavouriteIconFavourteScreen(bool isFavourite) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var db = FirebaseFirestore.instance;

    List<FavouritePlayList> updatedPlayList = dataProvider
        .userModel!.favouritePlayLists
        .map((e) => FavouritePlayList.fromMap(e.toMap()))
        .toList();
    FavouritePlayList fPlaylist =
        FavouritePlayList(genre: dataProvider.userModel!.selectedGenres.first);
    if (dataProvider.type == "City") {
      fPlaylist.city = dataProvider.userModel!.city;
    } else if (dataProvider.type == "State") {
      fPlaylist.state = dataProvider.userModel!.state;
    } else {
      fPlaylist.country = dataProvider.userModel!.country;
    }
    if (isFavourite) {
      int index = -1;
      for (int i = 0;
          i < dataProvider.userModel!.favouritePlayLists.length;
          i++) {
        if (dataProvider.userModel!.favouritePlayLists[i].genre ==
            widget.favouritePlayList!.genre) {
          if (dataProvider.type == "City" &&
              widget.favouritePlayList!.city ==
                  dataProvider.userModel!.favouritePlayLists[i].city) {
            index = i;
          } else if (dataProvider.type == "State" &&
              widget.favouritePlayList!.state ==
                  dataProvider.userModel!.favouritePlayLists[i].state) {
            index = i;
          } else if (dataProvider.type == "Country" &&
              widget.favouritePlayList!.country ==
                  dataProvider.userModel!.favouritePlayLists[i].country) {
            index = i;
          }
        }
      }
      if (index != -1) {
        updatedPlayList.removeAt(index);
      }
    } else {
      updatedPlayList.add(fPlaylist);
    }
    db.collection("users").doc(uid).update({
      "favouritePlaylists": updatedPlayList.map((e) => e.toMap()).toList(),
    });
  }

  clickFavouriteIconDiscoveryScreen(bool isFavourite) {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    var db = FirebaseFirestore.instance;

    List<FavouritePlayList> updatedPlayList = dataProvider
        .userModel!.favouritePlayLists
        .map((e) => FavouritePlayList.fromMap(e.toMap()))
        .toList();
    FavouritePlayList fPlaylist =
        FavouritePlayList(genre: dataProvider.userModel!.selectedGenres.first);
    if (dataProvider.type == "City") {
      fPlaylist.city = dataProvider.userModel!.city;
    } else if (dataProvider.type == "State") {
      fPlaylist.state = dataProvider.userModel!.state;
    } else {
      fPlaylist.country = dataProvider.userModel!.country;
    }
    if (isFavourite) {
      int index = -1;
      for (int i = 0;
          i < dataProvider.userModel!.favouritePlayLists.length;
          i++) {
        if (dataProvider.userModel!.favouritePlayLists[i].genre ==
            dataProvider.userModel!.selectedGenres.first) {
          if (dataProvider.type == "City" &&
              dataProvider.userModel!.city ==
                  dataProvider.userModel!.favouritePlayLists[i].city) {
            index = i;
          } else if (dataProvider.type == "State" &&
              dataProvider.userModel!.state ==
                  dataProvider.userModel!.favouritePlayLists[i].state) {
            index = i;
          } else if (dataProvider.type == "Country" &&
              dataProvider.userModel!.country ==
                  dataProvider.userModel!.favouritePlayLists[i].country) {
            index = i;
          }
        }
      }
      if (index != -1) {
        updatedPlayList.removeAt(index);
      }
    } else {
      updatedPlayList.add(fPlaylist);
    }
    db.collection("users").doc(uid).update({
      "favouritePlaylists": updatedPlayList.map((e) => e.toMap()).toList(),
    });
  }

  List<SongModel> discoverySongs() {
    List<SongModel> songList = [];
    if (dataProvider.type == "City") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
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
      }
    } else if (dataProvider.type == "State") {
      for (var element in dataProvider.songs) {
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
      for (var element in dataProvider.songs) {
        if (element.country == dataProvider.userModel!.country) {
          songList.add(element);
        }
      }
    }
    return songList;
  }

  List<SongModel> favouriteSongs() {
    List<SongModel> songList = [];
    if (dataProvider.type == "City") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first == widget.favouritePlayList!.genre) {
          print(element.city);
          if (element.city == widget.favouritePlayList!.city) {
            print('djsn');
            songList.add(element);
          } else if (element.state == widget.favouritePlayList!.state) {
            songList.add(element);
          } else if (element.country == widget.favouritePlayList!.country) {
            songList.add(element);
          }
        }
      }
    } else if (dataProvider.type == "State") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first == widget.favouritePlayList!.genre) {
          if (element.state == widget.favouritePlayList!.state) {
            songList.add(element);
          } else if (element.country == widget.favouritePlayList!.country) {
            songList.add(element);
          }
        }
      }
    } else {
      for (var element in dataProvider.songs) {
        if (element.country == widget.favouritePlayList!.country) {
          songList.add(element);
        }
      }
    }
    print(songList.length);
    return songList;
  }

  bool isPlaylistFavourite() {
    bool isFavourite = false;
    if (widget.favouritePlayList != null) {
      for (var element in dataProvider.userModel!.favouritePlayLists) {
        if (element.genre == widget.favouritePlayList!.genre) {
          if (dataProvider.type == "City" &&
              widget.favouritePlayList!.city == element.city) {
            isFavourite = true;
          } else if (dataProvider.type == "State" &&
              widget.favouritePlayList!.state == element.state) {
            isFavourite = true;
          } else if (dataProvider.type == "Country" &&
              widget.favouritePlayList!.country == element.country) {
            isFavourite = true;
          }
        }
      }
    } else {
      for (var element in dataProvider.userModel!.favouritePlayLists) {
        if (element.genre == dataProvider.userModel!.selectedGenres.first) {
          if (dataProvider.type == "City" &&
              dataProvider.userModel!.city == element.city) {
            isFavourite = true;
          } else if (dataProvider.type == "State" &&
              dataProvider.userModel!.state == element.state) {
            isFavourite = true;
          } else if (dataProvider.type == "Country" &&
              dataProvider.userModel!.country == element.country) {
            isFavourite = true;
          }
        }
      }
    }

    return isFavourite;
  }

  Widget songsWidget(DataProvider dataProvider) {
    List<SongModel> songList =
        widget.favouritePlayList == null ? discoverySongs() : favouriteSongs();

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemBuilder: (ctx, i) {
          return SongWidget(song: songList[i]);
        },
        itemCount: songList.length,
        separatorBuilder: (BuildContext context, int index) {
          return const MarginWidget();
        },
      ),
    );
  }

  Widget headerWidget() {
    String name = "";
    if (widget.favouritePlayList != null) {
      name =
          "${widget.favouritePlayList?.city ?? widget.favouritePlayList?.state ?? widget.favouritePlayList?.country}: ${widget.favouritePlayList?.genre}";
    } else {
      if (dataProvider.type == "City") {
        name =
            "${dataProvider.userModel!.city}: ${dataProvider.userModel!.selectedGenres.first}";
      } else if (dataProvider.type == "State") {
        name =
            "${dataProvider.userModel!.state}: ${dataProvider.userModel!.selectedGenres.first}";
      } else {
        name =
            "${dataProvider.userModel!.country}: ${dataProvider.userModel!.selectedGenres.first}";
      }
    }

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
            child: SvgPicture.asset(Assets.imagesFullRadioStation),
          ),
          Positioned.fill(
            left: 0,
            bottom: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(color: Colors.black),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeights.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
