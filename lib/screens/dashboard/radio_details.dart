import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/models/radio_station.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/song_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../helpers/colors.dart';
import '../../widgets/player_widget.dart';

class RadioDetails extends StatefulWidget {
  const RadioDetails({
    super.key,
    required this.index,
    required this.radioStationModel,
  });

  final int index;
  final RadioStationModel radioStationModel;

  @override
  State<RadioDetails> createState() => _RadioDetailsState();
}

class _RadioDetailsState extends State<RadioDetails> {
  late DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, provider, child) {
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
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.radioStationModel.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeights.bold,
                      ),
                    ),
                  ),
                  Builder(builder: (context) {
                    bool isFavourite = dataProvider
                        .userModel!.favouriteRadioStations
                        .contains(widget.radioStationModel.id);
                    return InkWell(
                      onTap: () {
                        var uid = FirebaseAuth.instance.currentUser!.uid;
                        var db = FirebaseFirestore.instance;
                        if (isFavourite) {
                          db.collection("users").doc(uid).update({
                            "favouriteRadioStations": FieldValue.arrayRemove(
                                [widget.radioStationModel.id]),
                          });
                          db
                              .collection("radiostation")
                              .doc(widget.radioStationModel.id)
                              .update({
                            "favourites": FieldValue.arrayRemove([uid]),
                          });
                        } else {
                          db.collection("users").doc(uid).update({
                            "favouriteRadioStations": FieldValue.arrayUnion(
                                [widget.radioStationModel.id]),
                          });
                          db
                              .collection("radiostation")
                              .doc(widget.radioStationModel.id)
                              .update({
                            "favourites": FieldValue.arrayUnion([uid]),
                          });
                        }
                      },
                      child: Icon(
                        isFavourite
                            ? Icons.favorite
                            : Icons.favorite_outline_outlined,
                        color: isFavourite ? Colors.red : CColors.textColor,
                        size: 30,
                      ),
                    );
                  })
                ],
              ),
            ),
            Builder(builder: (context) {
              var songs = dataProvider.songs
                  .where(
                      (element) => element.rid == widget.radioStationModel.id)
                  .toList();
              return Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemBuilder: (ctx, i) {
                    return SongWidget(song: songs[i]);
                  },
                  itemCount: songs.length,
                ),
              );
            }),
            const PlayerWidget(),
            const SizedBox(height: 20),
          ],
        ),
      );
    });
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
                    widget.radioStationModel.name,
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
