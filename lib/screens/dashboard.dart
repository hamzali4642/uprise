import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/auth/signin.dart';
import 'package:uprise/screens/dashboard/profile_details/instruments.dart';
import 'package:uprise/screens/dashboard/radio_preferences.dart';
import 'package:uprise/widgets/chip_widget.dart';
import 'package:uprise/widgets/player_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../generated/assets.dart';
import '../helpers/colors.dart';
import '../helpers/textstyles.dart';
import '../widgets/bottom_nav.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late DashboardProvider provider;

  late DataProvider dataProvider;

  var city = TextEditingController();
  var state = TextEditingController();
  var country = TextEditingController(text: "USA");

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    provider.selectedIndex = 3;
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, p, child) {
      dataProvider = p;
      return Consumer<DashboardProvider>(builder: (context, value, child) {
        provider = value;

        if (city.text.isEmpty) {
          city.text = dataProvider.userModel?.city ?? "";
        }
        if (state.text.isEmpty) {
          state.text = dataProvider.userModel?.state ?? "";
        }
        return WillPopScope(
          onWillPop: () {
            if (provider.selectedIndex == 0) {
              return Future.value(true);
            }
            provider.selectedIndex = 0;
            return Future.value(false);
          },
          child: Scaffold(
            floatingActionButton: provider.showOverlay
                ? InkWell(
                    onTap: () {
                      provider.showOverlay = !provider.showOverlay;
                    },
                    child: SvgPicture.asset(
                      Assets.imagesClose,
                      width: iconSize,
                    ),
                  )
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Scaffold(
                    floatingActionButton: fabWidget(),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: bottomNavigationWidget(),
                    body: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      enablePullDown: provider.selectedIndex == 0 ||
                              provider.selectedIndex == 2
                          ? true
                          : false,
                      header: WaterDropHeader(),
                      child: Column(
                        children: [
                          if (provider.selectedIndex == 0 ||
                              provider.selectedIndex == 2) ...[
                            headerWidget(),
                            locationWidget(),
                            if (provider.selectedIndex != 2) ...[
                              const PlayerWidget(),
                              const Divider(
                                color: CColors.textColor,
                                thickness: 0.4,
                              ),
                            ]
                          ],
                          Expanded(
                              child: provider.pages[provider.selectedIndex]!),
                        ],
                      ),
                    ),
                  ),
                ),
                if (provider.showOverlay) overlayWidget(),
              ],
            ),
          ),
        );
      });
    });
  }

  bool isEditing = false;

  Widget headerWidget() {
    return Container(
      padding: EdgeInsets.only(
        top: context.topPadding + 10,
        left: Constants.horizontalPadding,
        right: Constants.horizontalPadding,
        bottom: 10,
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              provider.selectedIndex = 3;
            },
            child: SizedBox(
              height: 40,
              width: 40,
              child: ClipOval(
                child: Image(
                  image: AssetImage(dataProvider.userModel?.avatar == null
                      ? Assets.imagesUsers
                      : dataProvider.userModel!.avatar!),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.horizontalPadding / 2,
              ),
              child: InkWell(
                onTap: () {
                  provider.selectedIndex = 3;
                },
                child: Text(
                  dataProvider.userModel == null
                      ? ""
                      : dataProvider.userModel!.username,
                  style: AppTextStyles.popins(
                      style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeights.bold,
                  )),
                ),
              ),
            ),
          ),
          const Icon(
            Icons.notifications,
            color: Colors.white,
          ),
          const SizedBox(width: 10),
          PopupMenuButton(
            color: Colors.black,
            child: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onSelected: (value) async {
              if (value == "/logout") {
                await FirebaseAuth.instance.signOut();
                provider.selectedIndex = 0;
                provider.homeSelected = "Feed";
                // ignore: use_build_context_synchronously
                context.push(child: const SignIn());
              } else if (value == "/discovery") {
                provider.selectedIndex = 2;
              } else if (value == "/profile") {
                provider.selectedIndex = 3;
              } else if (value == "/instruments") {
                context.push(child: const Instruments());
              } else if (value == "/favourites") {
                provider.isFavourites = true;
                provider.selectedIndex = 3;
              }
            },
            itemBuilder: (BuildContext bc) {
              return Constants.menuItem;
            },
          ),
        ],
      ),
    );
  }

  Widget locationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Image(
                height: 27,
                image: AssetImage(
                  Assets.imagesRadio,
                ),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  child: Text(
                    dataProvider.userModel?.city ?? "",
                    style: AppTextStyles.message(
                        color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (dataProvider.type == "City") {
                      dataProvider.type = "State";
                    } else if (dataProvider.type == "State") {
                      dataProvider.type = "Country";
                    } else {
                      dataProvider.type = "City";
                    }
                    // radioButtonItem("City"),
                    // radioButtonItem("State"),
                    // radioButtonItem("Country"),
                  });
                  // context.push(child: const RadioPreferences());
                },
                color: Colors.white,
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    radioWidget(),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  // IconButton(
                  //   onPressed: () {
                  //     dataProvider.updateUserPref({
                  //       "city": city.text,
                  //       "country": country.text,
                  //       "state": state.text,
                  //     });
                  //
                  //     isEditing = !isEditing;
                  //     setState(() {});
                  //   },
                  //   color: Colors.white,
                  //   icon: Icon(Icons.check_circle),
                  // ),
                  IconButton(
                    onPressed: () {
                      context.push(child: RadioPreferences());
                    },
                    color: Colors.white,
                    icon: Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var genre in dataProvider.userModel?.selectedGenres ?? [])
                  ChipWidget(
                    text: genre,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget fabWidget() {
    return InkWell(
      onTap: () {
        provider.showOverlay = !provider.showOverlay;
      },
      child: Container(
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: const Image(
          image: AssetImage(Assets.imagesUpriseRadiyoIcon),
          width: 60,
        ),
      ),
    );
  }

  Widget bottomNavigationWidget() {
    return CustomBottomNavigation(
      items: [
        BottomNavItem(
            index: 0,
            title: "Home",
            iconData: Icons.home_outlined,
            isSelected: provider.selectedIndex == 0),
        BottomNavItem(index: 1, isSelected: false),
        BottomNavItem(
            index: 2,
            title: "Discovery",
            iconData: Icons.flag_outlined,
            isSelected: provider.selectedIndex == 2),
      ],
      onSelect: (index) {
        provider.selectedIndex = index;
      },
    );
  }

  Widget overlayWidget() {
    return Positioned.fill(
      child: Container(
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: CColors.Black.withOpacity(0.9),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Builder(builder: (context) {
              bool isBlast = dataProvider.userModel!.blasts
                  .contains(dataProvider.currentSong!.id);

              return overlayItemWidget(
                "Skip",
                "Blast",
                Assets.imagesSkip,
                isBlast ? Assets.imagesUnBlast : Assets.imagesBlast,
                () {
                  while (
                      dataProvider.songs.first == dataProvider.currentSong!) {
                    dataProvider.songs.shuffle();
                  }
                  dataProvider.stop();
                  dataProvider.currentSong = dataProvider.songs.first;

                  // dataProvider.initializePlayer();
                },
                () {
                  var uid = FirebaseAuth.instance.currentUser!.uid;
                  var db = FirebaseFirestore.instance;
                  if (isBlast) {
                    db.collection("users").doc(uid).update({
                      "blasts": FieldValue.arrayRemove(
                          [dataProvider.currentSong!.id]),
                    });
                    db
                        .collection("Songs")
                        .doc(dataProvider.currentSong!.id)
                        .update({
                      "blasts": FieldValue.arrayRemove([uid]),
                    });
                  } else {
                    db.collection("users").doc(uid).update({
                      "favourites":
                          FieldValue.arrayUnion([dataProvider.currentSong!.id]),
                    });
                    db
                        .collection("Songs")
                        .doc(dataProvider.currentSong!.id)
                        .update({
                      "favourites": FieldValue.arrayUnion([uid]),
                    });

                    db.collection("users").doc(uid).update({
                      "blasts":
                          FieldValue.arrayUnion([dataProvider.currentSong!.id]),
                    });
                    db
                        .collection("Songs")
                        .doc(dataProvider.currentSong!.id)
                        .update({
                      "blasts": FieldValue.arrayUnion([uid]),
                    });
                  }
                },
                20.0,
              );
            }),
            Builder(builder: (context) {
              var uid = FirebaseAuth.instance.currentUser!.uid;
              var band = dataProvider.users
                  .where((element) =>
                      element.id == dataProvider.currentSong!.bandId)
                  .first;
              var isFollowed = band.followers.contains(uid);

              return overlayItemWidget(
                "Report",
                isFollowed ? "Unfollow" : "Follow",
                Assets.imagesReport,
                isFollowed ? Assets.imagesUnFollow : Assets.imagesFollow,
                () {},
                () {
                  var my =
                      FirebaseFirestore.instance.collection("users").doc(uid);
                  var other = FirebaseFirestore.instance
                      .collection("users")
                      .doc(band.id);
                  if (isFollowed) {
                    my.update({
                      "following": FieldValue.arrayRemove([other.id])
                    });
                    other.update({
                      "followers": FieldValue.arrayRemove([my.id])
                    });

                    band.followers.remove(my.id);
                    dataProvider.userModel!.following.remove(my.id);

                    dataProvider.notifyListeners();
                  } else {
                    my.update({
                      "following": FieldValue.arrayUnion([other.id])
                    });
                    other.update({
                      "followers": FieldValue.arrayUnion([my.id])
                    });

                    band.followers.add(my.id);
                    dataProvider.userModel!.following.add(my.id);

                    dataProvider.notifyListeners();
                  }
                },
                90.0,
              );
            }),
            Builder(builder: (context) {
              var uid = FirebaseAuth.instance.currentUser!.uid;
              var isUpvote = dataProvider.userModel!.upVotes
                  .contains(dataProvider.currentSong!.id);
              var isDownVote = dataProvider.userModel!.downVotes
                  .contains(dataProvider.currentSong!.id);

              var my = FirebaseFirestore.instance.collection("users").doc(uid);
              var other = FirebaseFirestore.instance
                  .collection("Songs")
                  .doc(dataProvider.currentSong!.id);

              bool isDisable;

              if (isUpvote ||
                  dataProvider.currentSong?.city !=
                      dataProvider.userModel?.city) {
                isDisable = true;
              } else {
                isDisable = false;
              }

              return overlayItemWidget(
                "DownVote",
                "Upvote",
                isDownVote
                    ? Assets.imagesDisableDownvote
                    : Assets.imagesDownvote,
                isDisable
                    ? Assets.imagesDisableUpVoteIcon
                    : Assets.imagesUpvote,
                () {
                  if (!isDownVote) {
                    my.update({
                      "upVotes": FieldValue.arrayRemove(
                          [dataProvider.currentSong!.id]),
                      "downVotes":
                          FieldValue.arrayUnion([dataProvider.currentSong!.id]),
                    });

                    other.update({
                      "upVotes": FieldValue.arrayRemove([uid]),
                      "downVotes": FieldValue.arrayUnion([uid]),
                    });
                  }
                },
                () {
                  if (!isUpvote &&
                      dataProvider.currentSong?.city !=
                          dataProvider.userModel?.city) {
                    my.update({
                      "upVotes":
                          FieldValue.arrayUnion([dataProvider.currentSong!.id]),
                      "downVotes": FieldValue.arrayRemove(
                          [dataProvider.currentSong!.id]),
                    });

                    other.update({
                      "upVotes": FieldValue.arrayUnion([uid]),
                      "downVotes": FieldValue.arrayRemove([uid]),
                    });
                  }
                },
                130.0,
              );
            }),
            SizedBox(
              height: context.bottomPadding + 40,
            ),
          ],
        ),
      ),
    );
  }

  var iconSize = 40.0;

  Widget overlayItemWidget(
    String text1,
    String text2,
    String image1,
    String image2,
    Function() onTap1,
    Function() onTap2,
    double margin,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    text1,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SvgPicture.asset(
                    image1,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: margin,
          ),
          Expanded(
            child: InkWell(
              onTap: onTap2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    image2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    text2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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

  Widget radioWidget() {
    return Row(
      children: [
        radioButtonItem("City"),
        radioButtonItem("State"),
        radioButtonItem("Country"),
      ],
    );
  }

  Widget radioButtonItem(String text) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: text,
            groupValue: dataProvider.type,
            onChanged: (value) {
              dataProvider.type = value!;
            },
          ),
          Text(
            text,
            style: const TextStyle(
              color: CColors.White,
            ),
          ),
        ],
      ),
    );
  }
}
