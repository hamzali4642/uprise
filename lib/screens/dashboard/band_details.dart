import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/models/event_model.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/band_member_detail/band_member_detail.dart';
import 'package:uprise/widgets/event_widget.dart';
import 'package:uprise/widgets/player_widget.dart';
import 'package:uprise/widgets/songs_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../helpers/colors.dart';
import '../../widgets/state_check.dart';

class BandDetails extends StatefulWidget {
  const BandDetails({super.key, required this.band});

  final UserModel band;

  @override
  State<BandDetails> createState() => _BandDetailsState();
}

class _BandDetailsState extends State<BandDetails>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      if (!controller.indexIsChanging) {
        setState(() {
          print(controller.index);
        });
      }
    });
  }

  late DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      dataProvider = value;
      return Scaffold(
        appBar: AppBar(
          backgroundColor: CColors.transparentColor,
          title: const Text(
            "Band Details",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeights.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  Image(
                    image: widget.band.bandProfile == null
                        ? const AssetImage(Assets.imagesBandImg)
                        : NetworkImage(
                            widget.band.bandProfile!,
                          ) as ImageProvider,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ).toSliver,
                  brandInfoWidget().toSliver,
                  memberWidget().toSliver,
                  songsWidget().toSliver,
                  TabBar(
                    controller: controller,
                    labelColor: CColors.primary,
                    unselectedLabelColor: CColors.textColor,
                    labelStyle: const TextStyle(color: CColors.primary),
                    unselectedLabelStyle: const TextStyle(
                      color: CColors.textColor,
                    ),
                    tabs: const [
                      Tab(
                        child: Text(
                          "Gallery",
                        ),
                      ),
                      Tab(
                        child: Text(
                          "Events",
                        ),
                      ),
                    ],
                  ).toSliver,
                  controller.index == 0 ? galleryWidget() : eventsWidget(),
                ],
              ),
            ),
            const PlayerWidget(),
          ],
        ),
      );
    });
  }

  Widget brandInfoWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Band Name:",
                  style: TextStyle(
                    color: CColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.band.bandName!,
                  style: const TextStyle(
                    color: CColors.White,
                    fontSize: 16,
                    fontWeight: FontWeights.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Members",
                  style: TextStyle(
                    color: CColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          Builder(builder: (context) {
            var uid = FirebaseAuth.instance.currentUser!.uid;
            var isFollowed = widget.band.followers.contains(uid);
            return TextButton(
              onPressed: () {
                var my =
                    FirebaseFirestore.instance.collection("users").doc(uid);
                var other = FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.band.id);
                if (isFollowed) {
                  my.update({
                    "following": FieldValue.arrayRemove([other.id])
                  });
                  other.update({
                    "followers": FieldValue.arrayRemove([my.id])
                  });

                  widget.band.followers.remove(my.id);
                  dataProvider.userModel!.following.remove(my.id);

                  dataProvider.notifyListeners();
                } else {
                  my.update({
                    "following": FieldValue.arrayUnion([other.id])
                  });
                  other.update({
                    "followers": FieldValue.arrayUnion([my.id])
                  });

                  widget.band.followers.add(my.id);
                  dataProvider.userModel!.following.add(my.id);

                  dataProvider.notifyListeners();
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                  color: CColors.calendarBtnBg,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.imagesBlackUserAdd,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      isFollowed ? "Unfollow" : "Follow",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget memberWidget() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding,
        ),
        itemBuilder: (ctx, i) {
          UserModel? userModel =
              dataProvider.getBand(widget.band.bandMembers[i]);

          return InkWell(
            onTap: () {
              context.push(child: BandMemberDetail(model: userModel));
            },
            child: Column(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: ClipOval(
                    child: Image(
                      image: AssetImage(
                        widget.band.avatar == null
                            ? Assets.imagesUsers
                            : widget.band.avatar!,
                      ),
                    ),
                  ),
                ),
                Text(
                  userModel!.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeights.medium,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (ctx, i) {
          return const SizedBox(
            width: 10,
          );
        },
        itemCount: widget.band.bandMembers.length,
      ),
    );
  }

  Widget songsWidget() {
    var songs = dataProvider.songs
        .where((element) => element.bandId == widget.band.id)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.horizontalPadding,
          ),
          child: Text(
            "Songs",
            style: TextStyle(
              color: CColors.textColor,
              fontSize: 16,
              fontWeight: FontWeights.medium,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: Constants.horizontalPadding,
            ),
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, i) {
              return SongsWidget(
                song: songs[i],
              );
            },
            separatorBuilder: (ctx, i) {
              return const SizedBox(width: 10);
            },
            itemCount: songs.length,
          ),
        )
      ],
    );
  }

  Widget eventsWidget() {

    DateTime now = DateTime.now();
    List<EventModel> events = dataProvider.events.where((element) => element.bandId == widget.band.id && element.startDate.difference(now).inHours >= -24).toList();

    Widget? check = stateCheck(dataProvider.eventState, events);

    return check != null
        ? SliverPadding(sliver: check.toSliver, padding: const EdgeInsets.all(40),)
        : SliverList(
            delegate: SliverChildBuilderDelegate((ctx, i) {
              return EventWidget(
                eventModel: events[i],
              );
            }, childCount: events.length),
          );
  }

  Widget galleryWidget() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding, vertical: 15),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (ctx, i) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(
                10,
              ),
              child: Image(
                image: NetworkImage(
                  widget.band.gallery[i],
                ),
                fit: BoxFit.cover,
              ),
            );
          },
          childCount: widget.band.gallery.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
      ),
    );
  }
}
