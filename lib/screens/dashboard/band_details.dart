import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/event_widget.dart';
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
        body: Container(
          child: CustomScrollView(
            slivers: [
              const Image(
                image: NetworkImage(
                  Constants.demoCoverImage,
                ),
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
                labelStyle: const TextStyle(
                  color: CColors.primary,
                ),
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
                  "Brand Name:",
                  style: TextStyle(
                    color: CColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeights.medium,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  widget.band.username,
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
          TextButton(
            onPressed: () {},
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
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Follow",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget memberWidget() {
    return Container(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding,
        ),
        itemBuilder: (ctx, i) {
          return Column(
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
                widget.band.username,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeights.medium,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (ctx, i) {
          return const SizedBox(
            width: 10,
          );
        },
        itemCount: 1,
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
              return SizedBox(
                width: 10,
              );
            },
            itemCount: songs.length,
          ),
        )
      ],
    );
  }

  Widget eventsWidget() {
    Widget? check = stateCheck(dataProvider.eventState, dataProvider.events);

    return check != null
        ? check.toSliver
        : SliverList(
            delegate: SliverChildBuilderDelegate((ctx, i) {
              return EventWidget(
                eventModel: dataProvider.events[i],
              );
            }, childCount: dataProvider.events.length),
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
              child: const Image(
                image: NetworkImage(
                  Constants.demoCoverImage,
                ),
                fit: BoxFit.cover,
              ),
            );
          },
          childCount: 5,
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
