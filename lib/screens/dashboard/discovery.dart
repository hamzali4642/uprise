import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/songs_widget.dart';
import 'package:uprise/widgets/textfield_widget.dart';

import '../../helpers/constants.dart';
import '../../widgets/band_widget.dart';
import '../../widgets/heading_widget.dart';
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
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        dataProvider = value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                TextFieldWidget(controller: controller, hint: "Search", errorText: "",),
                const HeadingWidget(
                  text: "Popular Bands",
                ),
                const SizedBox(
                  height: 20,
                ),
                popularBandsWidget(),
                const HeadingWidget(
                  text: "Popular Radio Stations",
                ),
                const SizedBox(
                  height: 20,
                ),
                popularRadioWidget(),
                HeadingWidget(
                  text: "Popular Songs",
                ),
                const SizedBox(
                  height: 20,
                ),
                popularSongsWidget(),

              ],
            ),
          ),
        );
      }
    );
  }

  var height = 250.0;

  Widget popularBandsWidget() {
    var bands = dataProvider.users.where((element) => element.isBand).toList();
    return CarouselSlider.builder(
      itemCount: bands.length,
      itemBuilder: (ctx, i, j) {
        return BandWidget(band: bands[i],);
      },
      options: CarouselOptions(
          initialPage: 0,
          height: height,
          viewportFraction: 0.5,
          enlargeCenterPage: true,
          enlargeFactor: 0.5,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          enableInfiniteScroll: false),
    );
  }

  Widget popularRadioWidget() {
    var cities = dataProvider.cities;
    return CarouselSlider.builder(
      itemCount: cities.length,
      itemBuilder: (ctx, i, j) {
        return Align(
          alignment: Alignment.topCenter,
          child: RadioWidget(name: cities[i],index: i,),
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
    );
  }

  Widget popularSongsWidget() {
    var songs = dataProvider.songs;
    return CarouselSlider.builder(
      itemCount: songs.length,
      itemBuilder: (ctx, i, j) {
        return SongsWidget(fromCarousel: true, song: songs[i],);
      },
      options: CarouselOptions(
          initialPage: 0,
          height: height,
          viewportFraction: 0.5,
          enlargeCenterPage: true,
          enlargeFactor: 0.5,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          enableInfiniteScroll: false),
    );
  }
}
