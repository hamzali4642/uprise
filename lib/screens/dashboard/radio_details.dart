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

class RadioDetails extends StatefulWidget {
  const RadioDetails({super.key, required this.name});
  final String name;
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
          body: Container(
            child: Column(
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
                      fontSize: 16,
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
              ],
            ),
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
        color: Functions.generateColorFromString(widget.name),
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
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      fontSize: 18,
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
