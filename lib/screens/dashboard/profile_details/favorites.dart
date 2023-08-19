import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/models/song_model.dart';
import 'package:uprise/provider/data_provider.dart';

import '../../../helpers/colors.dart';
import '../../../helpers/constants.dart';
import '../../../widgets/custom_asset_image.dart';

typedef UserCallBack = void Function(int);

class Favorites extends StatefulWidget {
  const Favorites({Key? key, required this.callBack}) : super(key: key);

  final UserCallBack callBack;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late DataProvider dataProvider;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 20), () {
      widget.callBack(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      dataProvider = value;

      return Padding(
        padding: const EdgeInsets.only(
            left: Constants.horizontalPadding,
            right: Constants.horizontalPadding),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Your Favorites Songs list",
              style: TextStyle(
                fontSize: 14,
                color: CColors.textColor,
              ),
            ),
            const SizedBox(height: 20),
            songs(),
          ],
        ),
      );
    });
  }

  Widget songs() {
    List<SongModel> songs = dataProvider.userModel!.favourites
        .map((e) => dataProvider.getSong(e))
        .toList();

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: songs.length,
        itemBuilder: (ctx, index) {
          return songWidget(songs[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }

  Widget songWidget(SongModel model) {
    return InkWell(
      onTap: () {
        dataProvider.currentSong = model;
        dataProvider.initializePlayer();
      },
      child: Column(
        children: [
          Row(
            children: [
              Image(
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                image: NetworkImage(model.posterUrl),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.title,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      dataProvider.getBandName(model.bandId),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.favorite,
                color: CColors.error,
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: CColors.textColor),
        ],
      ),
    );
  }
}
