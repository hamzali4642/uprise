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
        .where(
            (element) => element.city == radioStationModel.name || element.genreList.contains(radioStationModel.name))
        .toList();

    if(songs.isEmpty){
      return SizedBox();
    }
    return Container(
      margin: EdgeInsets.only(right: 20),
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
          child: Container(
            decoration: BoxDecoration(
              color: Constants.colors[index % Constants.colors.length],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: SvgPicture.asset(
                    Assets.imagesRadioStations,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 22,
                  child: Text(
                    radioStationModel.name,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.clickable(
                      fontSize: 15,
                      weight: FontWeights.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
