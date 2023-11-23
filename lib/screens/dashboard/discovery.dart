import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/discovery/map_view_section.dart';
import 'package:uprise/screens/popular_songs.dart';
import 'package:uprise/widgets/cupertino_textfield.dart';
import 'package:uprise/widgets/discovery_event_cover.dart';
import 'package:uprise/widgets/event_widget.dart';
import 'package:uprise/widgets/margin_widget.dart';
import 'package:uprise/widgets/playlist_songs.dart';
import 'package:uprise/widgets/radio_station_cover.dart';
import 'package:uprise/widgets/songs_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../helpers/constants.dart';
import '../../models/event_model.dart';
import '../../models/radio_station.dart';
import '../../widgets/band_widget.dart';
import '../../widgets/heading_widget.dart';
import '../../widgets/player_widget.dart';
import '../../widgets/radio_widget.dart';

class Discovery extends StatefulWidget {
  const Discovery({super.key});

  @override
  State<Discovery> createState() => _DiscoveryState();
}

class _DiscoveryState extends State<Discovery> {
  var controller = TextEditingController();
  late DataProvider dataProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      dataProvider = value;
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoTextFieldWidget(
                        controller: controller,
                        hint: "Search",
                        errorText: "",
                        onChange: (value) {
                          setState(() {});
                        },
                      ),
                      popularBandsWidget(),
                      playList(),
                      popularRadioWidget(),
                      popularSongsWidget(),
                      events(),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context.push(child: const MapViewSection());
                          },
                          child: Text(
                            "Map View Section",
                            style: AppTextStyles.clickable(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const PlayerWidget(),
            ],
          ),
        ),
      );
    });
  }

  Widget events() {
    List<EventModel> events = [];

    for (var element in dataProvider.events) {
      if (element.genre == dataProvider.userModel!.selectedGenres.first) {
        if (dataProvider.type == "City" &&
            dataProvider.userModel!.city == element.city) {
          events.add(element);
        } else if (dataProvider.type == "State" &&
            dataProvider.userModel!.state == element.state) {
          events.add(element);
        } else if (dataProvider.type == "Country" &&
            dataProvider.userModel!.country == element.country) {
          events.add(element);
        }
      }
    }
    return events.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingWidget(
                text: "Events",
              ),
              const SizedBox(height: 20),
              CarouselSlider.builder(
                itemCount: events.length,
                itemBuilder: (ctx, i, j) {
                  return DiscoveryEventCover(
                    eventModel: events[i],
                  );
                },
                options: CarouselOptions(
                    initialPage: 0,
                    height: height,
                    viewportFraction: 0.5,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    enableInfiniteScroll: false),
              ),
            ],
          );
  }

  // Widget events(DataProvider value) {
  //   List<EventModel> events = [];
  //
  //   for (var element in value.events) {
  //     if (element.genre == value.userModel!.selectedGenres.first) {
  //       if (value.type == "City" && value.userModel!.city == element.city) {
  //         events.add(element);
  //       } else if (value.type == "State" &&
  //           value.userModel!.state == element.state) {
  //         events.add(element);
  //       } else if (value.type == "Country" &&
  //           value.userModel!.country == element.country) {
  //         events.add(element);
  //       }
  //     }
  //   }
  //   // value.events.where((element) => element.genre == value.userModel!.selectedGenres.first).toList();
  //
  //   return SliverList(
  //     delegate: SliverChildBuilderDelegate((ctx, i) {
  //       return EventWidget(eventModel: events[i]);
  //     }, childCount: events.length),
  //   );
  // }

  Widget playList() {
    String playList = "";
    if (dataProvider.type == "City") {
      playList = dataProvider.userModel!.city!;
    } else if (dataProvider.type == "State") {
      playList = dataProvider.userModel!.state;
    } else {
      playList = dataProvider.userModel!.country;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingWidget(
          text: "Playlist",
        ),
        const SizedBox(height: 20),
        Center(
          child: InkWell(
            onTap: () {
              context.push(child: const PlaylistSongs());
            },
            child: SizedBox(
              height: 170,
              width: 170,
              child: RadioStationCover(
                name:
                    "$playList : ${dataProvider.userModel!.selectedGenres.first}",
                color: Colors.white,
                textColor: Colors.black,
              ),
            ),
          ),
        ),
        const MarginWidget(factor: 1.5),
      ],
    );
  }

  var height = 250.0;

  Widget popularBandsWidget() {
    var bands = [];

    bands = dataProvider.users
        .where((element) =>
            element.isBand &&
            element.bandName!
                .toLowerCase()
                .contains(controller.text.toLowerCase()))
        .toList();

    return bands.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingWidget(
                text: "Popular Bands",
              ),
              const SizedBox(
                height: 20,
              ),
              CarouselSlider.builder(
                itemCount: bands.length,
                itemBuilder: (ctx, i, j) {
                  return BandWidget(
                    band: bands[i],
                  );
                },
                options: CarouselOptions(
                    initialPage: 0,
                    height: height,
                    viewportFraction: 0.5,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    enableInfiniteScroll: false),
              ),
            ],
          );
  }

  Widget popularRadioWidget() {
    var s = dataProvider.radioStations;
    var radioStations = s
        .where((element) =>
            // element.genre == dataProvider.userModel!.selectedGenres.first &&
            element.name.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();

    List<RadioStationModel> updateStations = [];

    for (var element in radioStations) {
      var songs = dataProvider.songs
          .where((songElement) =>
      songElement.city == element.name ||
          songElement.genreList.contains(element.name))
          .toList();
      if (songs.isNotEmpty) {
        updateStations.add(element);
      }
    }
    return updateStations.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeadingWidget(
                text: "Popular Radio Stations",
              ),
              const SizedBox(
                height: 20,
              ),
              CarouselSlider.builder(
                itemCount: updateStations.length,
                itemBuilder: (ctx, i, j) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: RadioWidget(
                      radioStationModel: updateStations[i],
                      index: i,
                    ),
                  );
                },

                options: CarouselOptions(
                    initialPage: 0,
                    height: height,
                    viewportFraction: 0.5,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    enableInfiniteScroll: false),
              ),
            ],
          );
  }

  Widget popularSongsWidget() {
    var s = dataProvider.songs;
    var songs = s
        .where((element) =>
            // element.genreList.first ==
            // dataProvider.userModel!.selectedGenres.first &&
            element.title.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
    return songs.isEmpty
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: HeadingWidget(text: "Popular Songs"),
                  ),
                  InkWell(
                    onTap: () {
                      context.push(child: const PopularSongs());
                    },
                    child: const Text(
                      "See all",
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeights.normal),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              CarouselSlider.builder(
                itemCount: songs.length,
                itemBuilder: (ctx, i, j) {
                  return SongsWidget(
                    fromCarousel: true,
                    song: songs[i],
                  );
                },
                options: CarouselOptions(
                    initialPage: 0,
                    height: height,
                    viewportFraction: 0.5,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.5,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    enableInfiniteScroll: false),
              ),
            ],
          );
  }
}
