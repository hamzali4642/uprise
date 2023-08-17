import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    return Consumer<DataProvider>(
      builder: (context, provider, value) {
        dataProvider = provider;

        return CustomScrollView(
          slivers: [
            recommendedRadioWidget().toSliver,
            FeedWidget().toSliver,
            newReleasesWidget().toSliver,
            SliverList(
              delegate: SliverChildBuilderDelegate((ctx, i) {
                return FeedWidget();
              }, childCount: 4),
            ),
          ],
        );
      }
    );
  }

  Widget recommendedRadioWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingWidget(
          text: "Recommended Radio Stations",
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 150,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              if(i == 0){
                return SizedBox(width: 1,);
              }
              return RadioWidget(
                name: dataProvider.cities[i - 1],
              );
            },
            itemCount: dataProvider.cities.length + 1,
            separatorBuilder: (ctx, i) {
              if(i == 0){
                return SizedBox();
              }
              return SizedBox(
                width: 20,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget newReleasesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingWidget(
          text: "New Releases",
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 200,
          width: double.infinity,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return NewSongWidget();
            },
            itemCount: 4,
            separatorBuilder: (ctx, i) {
              return SizedBox(
                width: 20,
              );
            },
          ),
        ),
      ],
    );
  }
}
