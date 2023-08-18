import 'package:flutter/material.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/models/post_model.dart';
import 'package:uprise/models/song_model.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/band_details.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';

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
  late UserModel band;

  @override
  Widget build(BuildContext context) {
    if (widget.post.event != null) {
      event = EventModel.fromMap(widget.post.event!);
    }
    if (widget.post.song != null) {
      song = SongModel.fromMap(widget.post.song!);
    }

    return Consumer<DataProvider>(builder: (context, value, child) {
      var b = value.users.where((element) => element.id == widget.post.bandId);
      if (b.isNotEmpty) {
        band = b.first;
      } else {
        return const SizedBox();
      }

      return InkWell(
        onTap: (){
          context.push(child: BandDetails(band: band,));
        },
        child: Container(
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
              if (event != null)
                RichText(
                  text: TextSpan(
                    text: "${band.username} has hosting an event ",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeights.bold,
                    ),
                    children: [
                      TextSpan(
                        text: event!.name,
                        style: const TextStyle(
                          color: CColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeights.bold,
                        ),
                      ),
                      TextSpan(text: " on ${DateFormat("MMMM dd, yyyy").format(DateTime.fromMillisecondsSinceEpoch(widget.post.createdAt))} in ${event!.venue}",),
                    ],
                  ),
                )
              else if (song != null)
                RichText(
                  text: TextSpan(
                      text: "Hey there!! ${band.username} have released a song ",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeights.bold,
                      ),
                      children: [
                        TextSpan(
                          text: song!.title,
                          style: const TextStyle(
                            color: CColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeights.bold,
                          ),
                        )
                      ]),
                ),
            ],
          ),
        ),
      );
    });
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
                  band.username,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                Text(
                  GetTimeAgo.parse(
                    DateTime.fromMillisecondsSinceEpoch(widget.post.createdAt),
                  ),
                  style: const TextStyle(
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
