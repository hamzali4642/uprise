import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/functions.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/song_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../../widgets/player_widget.dart';

class RadioDetails extends StatefulWidget {
  const RadioDetails({super.key, required this.name, required this.index});
  final String name;
  final int index;
  @override
  State<RadioDetails> createState() => _RadioDetailsState();
}

class _RadioDetailsState extends State<RadioDetails> {
  late DataProvider dataProvider;
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
        dataProvider = provider;
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerWidget(),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.horizontalPadding,
                ),
                child: Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeights.bold,
                  ),
                ),
              ),
              Builder(
                builder: (context) {
                  var songs = dataProvider.songs.where((element) => element.city == widget.name).toList();
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (ctx, i) {
                        return SongWidget(song: songs[i]);
                      },
                      itemCount: songs.length,
                    ),
                  );
                }
              ),
              const PlayerWidget(),
              const SizedBox(height: 20),

            ],
          ),
        );
      }
    );
  }

  Widget headerWidget() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: context.topPadding),
      decoration: BoxDecoration(
        color: Constants.colors[widget.index % Constants.colors.length],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const BackButton(
                    color: Colors.white,
                  ),
                  Text(
                    widget.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeights.bold,
                    ),
                  ),
                  const SizedBox(
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
