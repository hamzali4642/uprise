import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/popular_songs.dart';
import 'package:uprise/widgets/cupertino_textfield.dart';
import 'package:uprise/widgets/songs_widget.dart';
import 'package:uprise/widgets/textfield_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../../helpers/constants.dart';
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
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      dataProvider = value;
      return Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
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
                    popularRadioWidget(),
                    popularSongsWidget(),
                  ],
                ),
              ),
            ),
            const PlayerWidget(),
          ],
        ),
      );
    });
  }

  var height = 250.0;

  Widget popularBandsWidget() {
    var b = dataProvider.users.where((element) => element.isBand).toList();
    var bands = b
        .where((element) =>
            element.bandName!.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();

    return bands.isEmpty ? const SizedBox() : Column(
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
    ) ;
  }

  Widget popularRadioWidget() {
    var c = dataProvider.cities;
    var cities = c
        .where((element) => element.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
    return cities.isEmpty ? const SizedBox() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingWidget(
          text: "Popular Radio Stations",
        ),
        const SizedBox(
          height: 20,
        ),
        CarouselSlider.builder(
          itemCount: cities.length,
          itemBuilder: (ctx, i, j) {
            return Align(
              alignment: Alignment.topCenter,
              child: RadioWidget(
                name: cities[i],
                index: i,
              ),
            );
          },
          options: CarouselOptions(
              initialPage: 0,
              height: height - 30,
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
        .where(
            (element) => element.title.toLowerCase().contains(controller.text.toLowerCase()))
        .toList();
    return  songs.isEmpty ? const SizedBox() :  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: HeadingWidget(
                text: "Popular Songs",
              ),
            ),
            InkWell(
              onTap: (){
                context.push(child: const PopularSongs());
              },
              child: const Text("See all",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeights.normal
                ),),
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
