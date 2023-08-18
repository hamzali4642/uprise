import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/models/post_model.dart';
import 'package:uprise/models/song_model.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';
import '../models/event_model.dart';

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key, required this.post});
  final PostModel post;

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {

  EventModel? event;
  SongModel? song;
  @override
  Widget build(BuildContext context) {

    if(widget.post.event != null){
      event = EventModel.fromMap(widget.post.event!);
    }
    if(widget.post.song !=  null){
      song = SongModel.fromMap(widget.post.song!);
    }
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding, vertical: 10),
      decoration: const BoxDecoration(
        color: CColors.feedContainerViewColor,
      ),
      child: Column(
        children: [
          profileWidget(),
          const SizedBox(
            height: 10,
          ),
          Image(
            height: 140,
            image: NetworkImage(
              song == null ? event!.posterUrl : song!.posterUrl,
            ),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const SizedBox(
            height: 10,
          ),
          RichText(
            text: const TextSpan(
                text: "Hey there!! Jen-Band have released a song ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeights.bold,
                ),
                children: [
                  TextSpan(
                    text: "Addicted - Simple Pain",
                    style: TextStyle(
                      color: CColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeights.bold,
                    ),
                  )
                ]),
          ),
        ],
      ),
    );
  }

  Widget profileWidget() {
    return Row(
      children: [
        ClipOval(
          child: Image(
            image: AssetImage(
              Assets.imagesUsers,
            ),
            width: 30,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "2 days ago",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
