import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/functions.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/radio_station.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/radio_details.dart';
import 'package:uprise/widgets/radio_station_cover.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../helpers/colors.dart';

class RadioWidget extends StatelessWidget {
  const RadioWidget(
      {super.key, required this.index, required this.radioStationModel});

  final int index;
  final RadioStationModel radioStationModel;

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);
    var songs = dataProvider.songs
        .where((element) =>
            element.city == radioStationModel.name ||
            element.genreList.contains(radioStationModel.name))
        .toList();

    if (songs.isEmpty) {
      return SizedBox();
    }
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
            onTap: () {
              context.push(
                  child: RadioDetails(
                radioStationModel: radioStationModel,
                index: index,
              ));
            },
            child: RadioStationCover(
                key: Key(radioStationModel.id),
                name: radioStationModel.name,
                color: Constants.colors[index % Constants.colors.length])),
      ),
    );
  }
}
