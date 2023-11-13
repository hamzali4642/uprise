import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/models/radio_station.dart';
import 'package:uprise/models/song_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/feed_widget.dart';
import 'package:uprise/widgets/heading_widget.dart';
import 'package:uprise/widgets/radio_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../../widgets/new_song_widget.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  late DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, provider, value) {
      dataProvider = provider;

      var posts = dataProvider.posts;
      return CustomScrollView(
        slivers: [
          recommendedRadioWidget().toSliver,
          if (posts.isNotEmpty)
            FeedWidget(
              post: posts[0],
            ).toSliver,
          const SizedBox(height: 10).toSliver,
          newReleasesWidget().toSliver,
          blastedSongs().toSliver,
          SliverList(
            delegate: SliverChildBuilderDelegate((ctx, i) {
              return FeedWidget(
                post: posts[i + 1],
              );
            }, childCount: posts.length - 1),
          ),
        ],
      );
    });
  }

  Widget recommendedRadioWidget() {
    if (dataProvider.radioStationState == DataStates.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    List<RadioStationModel> radioStations = dataProvider.radioStations
        .where((element) =>
            element.name == dataProvider.userModel!.selectedGenres.first ||
            element.name == dataProvider.userModel!.city)
        .toList();

    // if (dataProvider.userModel?.selectedGenres != null) {
    //   radioStations = dataProvider.radioStations
    //       .where((element) =>
    //           dataProvider.userModel!.selectedGenres.isNotEmpty &&
    //           element.genre == dataProvider.userModel!.selectedGenres.first)
    //       .toList();
    // }
    //
    // if (radioStations.isNotEmpty) {
    //   if (dataProvider.type == "City") {
    //     radioStations = radioStations
    //         .where((element) => element.city == dataProvider.userModel!.city)
    //         .toList();
    //   } else if (dataProvider.type == "State") {
    //     radioStations = radioStations
    //         .where((element) => element.state == dataProvider.userModel!.state)
    //         .toList();
    //   } else {
    //     radioStations = radioStations
    //         .where(
    //             (element) => element.country == dataProvider.userModel!.country)
    //         .toList();
    //   }
    // }

    if (radioStations.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingWidget(
          text: "Recommended Radio Stations",
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 150,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return RadioWidget(
                index: i,
                radioStationModel: radioStations[i],
              );
            },
            itemCount: radioStations.length,
            separatorBuilder: (ctx, i) {
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  Widget newReleasesWidget() {
    List<SongModel> songs = [];

    // songs = dataProvider.songs
    //     .where((element) => dataProvider.userModel!.following
    //         .any((follow) => follow == element.bandId))
    //     .toList();

    if (dataProvider.type == "City") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length < 3 &&
              element.city == dataProvider.userModel!.city) {
            songs.add(element);
          } else if (element.upVotes.length == 3 &&
              element.state == dataProvider.userModel!.state) {
            songs.add(element);
          } else if (element.country == dataProvider.userModel!.country &&
              element.upVotes.length > 3) {
            songs.add(element);
          }
        }
      }
      // songs = dataProvider.songs
      //     .where((element) =>
      //         element.genreList.isNotEmpty &&
      //         element.genreList.any((genre) =>
      //             dataProvider.userModel!.selectedGenres.isNotEmpty &&
      //             genre == dataProvider.userModel!.selectedGenres.first) &&
      //         element.upVotes.length < 25)
      //     .toList();
      //
      // for (var song in songs) {
      //   print(song.id);
      //   print(song.genreList);
      // }
    } else if (dataProvider.type == "State") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length == 3 &&
              element.state == dataProvider.userModel!.state) {
            songs.add(element);
          } else if (element.country == dataProvider.userModel!.country &&
              element.upVotes.length > 3) {
            songs.add(element);
          }
        }
      }
      // songs = dataProvider.songs
      //     .where((element) =>
      //         element.genreList.any((genre) =>
      //             dataProvider.userModel!.selectedGenres.isNotEmpty &&
      //             genre == dataProvider.userModel!.selectedGenres.first) &&
      //         (element.upVotes.length >= 25 && element.upVotes.length < 75))
      //     .toList();
    } else {
      for (var element in dataProvider.songs) {
        if (element.country == dataProvider.userModel!.country &&
            element.upVotes.length > 3) {
          print("here");
          songs.add(element);
        }
      }
      // songs = dataProvider.songs
      //     .where((element) =>
      //         element.genreList.any((genre) =>
      //             dataProvider.userModel!.selectedGenres.isNotEmpty &&
      //             genre == dataProvider.userModel!.selectedGenres.first) &&
      //         element.upVotes.length >= 75)
      //     .toList();
    }

    songs.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (songs.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingWidget(
          text: "New Releases",
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return NewSongWidget(
                song: songs[i],
              );
            },
            itemCount: songs.length,
            separatorBuilder: (ctx, i) {
              return const SizedBox(
                width: 20,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget blastedSongs() {
    List<SongModel> songs = [];

    if (dataProvider.type == "City") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length < 3 &&
              element.city == dataProvider.userModel!.city) {
            songs.add(element);
          } else if (element.upVotes.length == 3 &&
              element.state == dataProvider.userModel!.state) {
            songs.add(element);
          } else if (element.country == dataProvider.userModel!.country &&
              element.upVotes.length > 3) {
            songs.add(element);
          }
        }
      }
    } else if (dataProvider.type == "State") {
      for (var element in dataProvider.songs) {
        if (element.genreList.first ==
            dataProvider.userModel!.selectedGenres.first) {
          if (element.upVotes.length == 3 &&
              element.state == dataProvider.userModel!.state) {
            songs.add(element);
          } else if (element.country == dataProvider.userModel!.country &&
              element.upVotes.length > 3) {
            songs.add(element);
          }
        }
      }
    } else {
      for (var element in dataProvider.songs) {
        if (element.country == dataProvider.userModel!.country &&
            element.upVotes.length > 3) {
          songs.add(element);
        }
      }
    }

    songs = songs.where((element) => element.blasts.isNotEmpty).toList();

    if (songs.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const HeadingWidget(
          text: "Blasted Songs",
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return NewSongWidget(
                isBlasted: true,
                song: songs[i],
              );
            },
            itemCount: songs.length,
            separatorBuilder: (ctx, i) {
              return const SizedBox(
                width: 20,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
