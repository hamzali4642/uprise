import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/favourite_playlist.dart';
import 'package:uprise/models/radio_station.dart';
import 'package:uprise/models/song_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/margin_widget.dart';
import 'package:uprise/widgets/player_widget.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/constants.dart';
import '../../../widgets/playlist_songs.dart';
import '../radio_details.dart';

typedef UserCallBack = void Function(int);

class Favorites extends StatefulWidget {
  const Favorites({Key? key, required this.callBack}) : super(key: key);

  final UserCallBack callBack;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late DataProvider dataProvider;

  String selected = "Songs";

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
            IntrinsicHeight(
              child: Row(
                children: [
                  tab("Songs"),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  tab("Communities"),
                  Container(
                    width: 1,
                    color: Colors.black,
                  ),
                  // tab("PlayList"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (selected == "Songs") ...[
              const Text(
                "Your Favorites Songs list",
                style: TextStyle(
                  fontSize: 14,
                  color: CColors.textColor,
                ),
              ),
              const SizedBox(height: 20),
              songs(),
              const SizedBox(height: 20),
            ] else if (selected == "RadioStations") ...[
              const Text(
                "Your Favorites RadioStation list",
                style: TextStyle(
                  fontSize: 14,
                  color: CColors.textColor,
                ),
              ),
              const SizedBox(height: 20),
              radioStations(),
              const SizedBox(height: 20),
            ] else ...[
              if (dataProvider.userModel!.favouritePlayLists.isNotEmpty) ...[
                const Text(
                  "Your Favorites Playlist",
                  style: TextStyle(
                    fontSize: 14,
                    color: CColors.textColor,
                  ),
                ),
                listSongs(),
              ] else ...[
                const Text(
                  "No Favorite Playlist",
                  style: TextStyle(
                    fontSize: 14,
                    color: CColors.textColor,
                  ),
                ),
              ],
            ],
          ],
        ),
      );
    });
  }

  Widget listSongs() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, index) {
                FavouritePlayList playList =
                    dataProvider.userModel!.favouritePlayLists[index];
                // return  FavouritePlaylistSongs(fList: playList,);
                return InkWell(
                  onTap: () {
                    context.push(
                        child: PlaylistSongs(
                      favouritePlayList: playList,
                    ));
                  },
                  child: row(index,
                      "${playList.city ?? playList.state ?? playList.country}: ${playList.genre}"),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 20);
              },
              itemCount: dataProvider.userModel!.favouritePlayLists.length,
            ),
          ),
          const PlayerWidget(),
          const MarginWidget(),
        ],
      ),
    );
  }

  Widget tab(String header) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selected = header;
          });
        },
        child: Container(
          width: double.infinity,
          color: selected == header ? CColors.primary : CColors.placeholder,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          child: Text(
            header,
            style: AppTextStyles.message(
                color: selected == header ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }

  Widget songs() {
    List<SongModel?> songs = dataProvider.userModel!.favourites
        .map((e) => dataProvider.getSong(e))
        .toList();
    songs = songs.where((element) => element != null).toList();

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: songs.length,
        itemBuilder: (ctx, index) {
          return songWidget(songs[index]!);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
      ),
    );
  }

  Widget radioStations() {
    List<RadioStationModel> radioStations = dataProvider.radioStations
        .where((element) => element.favourites
            .any((fvrt) => fvrt == FirebaseAuth.instance.currentUser!.uid))
        .toList();

    return Expanded(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: radioStations.length,
        itemBuilder: (ctx, index) {
          return radioWidget(radioStations[index], index);
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
          widgetTile(model),
          const SizedBox(height: 10),
          const Divider(color: CColors.textColor),
        ],
      ),
    );
  }

  Widget widgetTile(SongModel model) {
    return Row(
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
                dataProvider.getBand(model.bandId)!.bandName!,
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
    );
  }

  Widget radioWidget(RadioStationModel model, int index) {
    return InkWell(
      onTap: () {
        context.push(
          child: RadioDetails(
            radioStationModel: model,
            index: index,
          ),
        );
      },
      child: Column(
        children: [
          row(index, model.name),
          const SizedBox(height: 10),
          const Divider(color: CColors.textColor),
        ],
      ),
    );
  }

  Widget row(int index, String name) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Constants.colors[index % Constants.colors.length],
          ),
          alignment: Alignment.topCenter,
          child: SizedBox(
            height: 50,
            width: 50,
            child: SvgPicture.asset(
              Assets.imagesRadioStations,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        Builder(builder: (context) {
          return Icon(
            Icons.favorite,
            color: Colors.red,
          );
        })
      ],
    );
  }
}
