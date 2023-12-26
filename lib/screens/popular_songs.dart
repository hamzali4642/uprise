import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/new_song_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import '../helpers/colors.dart';

class PopularSongs extends StatelessWidget {
  const PopularSongs({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: CColors.transparentColor,
            title: const Text(
              "Popular Song",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeights.bold,
              ),
            ),
            centerTitle: false,
          ),
          body: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (ctx, i) {
              return Center(child: NewSongWidget(song: value.songs[i],));
            },
            itemCount: value.songs.length,
          ),
        );
      }
    );
  }
}
