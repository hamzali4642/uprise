import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:uprise/helpers/textstyles.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeadingWidget(
              text: "Popular Brands",
            ),
            const SizedBox(height: 20,),
            popularBandsWidget(),
            HeadingWidget(
              text: "Popular Radio Stations",
            ),
            const SizedBox(height: 20,),
            popularRadioWidget(),
            HeadingWidget(
              text: "Popular Songs",
            ),
            const SizedBox(height: 20,),
            popularSongsWidget(),
          ],
        ),
      ),
    );
  }


  var height = 250.0;

  Widget popularBandsWidget() {
    return CarouselSlider.builder(
      itemCount: 10,
      itemBuilder: (ctx, i, j) {
        return const BandWidget();
      },
      options: CarouselOptions(
        initialPage: 0,
        height: height,
        viewportFraction: 0.5,
        enlargeCenterPage: true,
          enlargeFactor: 0.5,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enableInfiniteScroll: false
      ),
    );
  }

  Widget popularRadioWidget() {
    return CarouselSlider.builder(
      itemCount: 10,
      itemBuilder: (ctx, i, j) {
        return const RadioWidget();
      },
      options: CarouselOptions(
        initialPage: 0,
        height: height - 30,
        viewportFraction: 0.5,
        enlargeCenterPage: true,
        enlargeFactor: 0.5,
        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enableInfiniteScroll: false
      ),
    );
  }

  Widget popularSongsWidget() {
    return CarouselSlider.builder(
      itemCount: 10,
      itemBuilder: (ctx, i, j) {
        return const BandWidget();
      },
      options: CarouselOptions(
        initialPage: 0,
        height: height,
        viewportFraction: 0.5,
        enlargeCenterPage: true,
          enlargeFactor: 0.5,

        enlargeStrategy: CenterPageEnlargeStrategy.scale,
        enableInfiniteScroll: false
      ),
    );
  }
}
