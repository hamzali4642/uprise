import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/auth/signin.dart';
import 'package:uprise/screens/dashboard/home/notification_screen.dart';
import 'package:uprise/screens/dashboard/profile_details/instruments.dart';
import 'package:uprise/screens/dashboard/radio_preferences.dart';
import 'package:uprise/widgets/chip_widget.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:uprise/widgets/player_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../generated/assets.dart';
import '../helpers/colors.dart';
import '../helpers/textstyles.dart';
import '../models/song_model.dart';
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

  var hasCheck = false;

  goNext() {
    if (dataProvider.userModel != null &&
        dataProvider.userModel!.selectedGenres.isEmpty) {
      hasCheck = true;
      Future.delayed(const Duration(seconds: 1)).then((value) {
        context.push(child: const RadioPreferences()).then((value) {
          goNext();
        });
      });
    }
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

        if (!hasCheck) {
          goNext();
        }

        if (dataProvider.userModel == null ||
            dataProvider.userModel!.selectedGenres.isEmpty) {
          return Container(
            width: double.infinity,
            color: Colors.black,
          );
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
                      // if (dataProvider.currentSong != null) {
                      provider.showOverlay = !provider.showOverlay;
                      // }
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
                      header: const WaterDropHeader(),
                      child: Column(
                        children: [
                          if (provider.selectedIndex == 0 ||
                              provider.selectedIndex == 2) ...[
                            headerWidget(),
                            locationTitle(),
                            locationSelection(),
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
          InkWell(
            onTap: () {
              for (var element in dataProvider.notifications) {
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .collection("Notification")
                    .doc(element.id)
                    .update({
                  "isRead": true,
                });
              }
              context.push(child: NotificationScreen());
            },
            child: Badge(
              isLabelVisible: dataProvider.notifications
                  .where((element) => !element.isRead)
                  .toList()
                  .isNotEmpty,
              child: const Icon(
                Icons.notifications,
                color: Colors.white,
              ),
            ),
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
                dataProvider.currentSong = null;
                await dataProvider.audioPlayer.stop();
                dataProvider.setAudio = "stopped";
                await FirebaseAuth.instance.signOut();
                provider.selectedIndex = 0;
                provider.homeSelected = "Feed";
                // ignore: use_build_context_synchronously
                context.pushAndRemoveUntil(child: const SignIn());
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

  Widget locationTitle() {
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
                    getTitle(),
                    style: AppTextStyles.message(
                        color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (dataProvider.type == "City Wide") {
                      dataProvider.type = "State Wide";
                    } else if (dataProvider.type == "State Wide") {
                      dataProvider.type = "Country Wide";
                    } else {
                      dataProvider.type = "City Wide";
                    }

                    dataProvider.setSong();
                    dataProvider.stop();
                    dataProvider.initializePlayer();
                  });
                },
                color: Colors.white,
                icon: const Icon(Icons.share_location_sharp),
              ),
            ],
          ),
          true
              ? const SizedBox()
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var genre
                          in dataProvider.userModel?.selectedGenres ?? [])
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

  Widget locationSelection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding - 5,
      ),
      child: Row(
        children: [
          Expanded(
            child: radioWidget(),
          ),
          IconButton(
            onPressed: () {
              context.push(child: const RadioPreferences());
            },
            color: Colors.white,
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }

  String getTitle() {
    String city = dataProvider.userModel!.city!;
    String state = dataProvider.userModel!.state??"";
    String country = dataProvider.userModel!.country??"";
    String genre = dataProvider.userModel!.selectedGenres.first;

    if (dataProvider.type == "City Wide") {
      return "$city, $state $genre Uprise";
    } else if (dataProvider.type == "State Wide") {
      return "$state $genre Uprise";
    } else {
      return "$country $genre Uprise";
    }
  }

  Widget fabWidget() {
    return InkWell(
      onTap: () {
        // if (dataProvider.currentSong != null) {
        provider.showOverlay = !provider.showOverlay;
        // }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
        child: const CustomAssetImage(
          path: Assets.imagesUpriseRadiyoIcon,
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
              bool isBlast = false;
              if (dataProvider.currentSong != null) {
                isBlast = dataProvider.userModel!.blasts
                    .contains(dataProvider.currentSong!.id);
              }

              return overlayItemWidget(
                "Skip",
                "Blast",
                Assets.imagesSkip,
                isBlast ? Assets.imagesUnBlast : Assets.imagesBlast,
                () {
                  if (dataProvider.currentSong != null) {
                    dataProvider.stop();

                    dataProvider.setAudio = "stopped";

                    List<SongModel> songList = [];

                    List<SongModel> temp = dataProvider.songs
                        .where((element) => element.genreList.any((genre) =>
                            genre ==
                            dataProvider.userModel!.selectedGenres.first))
                        .toList();

                    if (provider.selectedIndex == 0) {
                      if (dataProvider.type == "City Wide") {
                        for (var element in temp) {
                          if (element.upVotes.length < 3 &&
                              element.city == dataProvider.userModel!.city) {
                            songList.add(element);
                          } else if (element.upVotes.length == 3 &&
                              element.state == dataProvider.userModel!.state &&
                              element.city == dataProvider.userModel!.city) {
                            songList.add(element);
                          } else if (element.country ==
                                  dataProvider.userModel!.country &&
                              element.upVotes.length > 3 &&
                              element.state == dataProvider.userModel!.state &&
                              element.city == dataProvider.userModel!.city) {
                            songList.add(element);
                          }
                        }
                      } else if (dataProvider.type == "State Wide") {
                        for (var element in temp) {
                          if (element.genreList.first ==
                              dataProvider.userModel!.selectedGenres.first) {
                            if (element.upVotes.length == 3 &&
                                element.state ==
                                    dataProvider.userModel!.state) {
                              songList.add(element);
                            } else if (element.country ==
                                    dataProvider.userModel!.country &&
                                element.upVotes.length > 3 &&
                                element.state ==
                                    dataProvider.userModel!.state) {
                              songList.add(element);
                            }
                          }
                        }
                      } else {
                        for (var element in temp) {
                          if (element.country ==
                                  dataProvider.userModel!.country &&
                              element.upVotes.length > 3) {
                            songList.add(element);
                          }
                        }
                      }
                    } else if (provider.selectedIndex == 2) {
                      if (dataProvider.type == "City Wide") {
                        for (var element in temp) {
                          songList.add(element);
                        }
                      } else if (dataProvider.type == "State Wide") {
                        for (var element in temp) {
                          if (element.genreList.first ==
                              dataProvider.userModel!.selectedGenres.first) {
                            if (element.upVotes.length >= 3) {
                              songList.add(element);
                            }
                          }
                        }
                      } else {
                        for (var element in temp) {
                          if (element.upVotes.length > 3) {
                            songList.add(element);
                          }
                        }
                      }
                    }

                    if (dataProvider.index + 1 < songList.length) {
                      dataProvider.index++;
                    } else {
                      dataProvider.index = 0;
                    }
                    if (songList.isEmpty) {
                      dataProvider.currentSong = null;
                    } else {
                      dataProvider.currentSong = songList[dataProvider.index];
                      dataProvider.initializePlayer();
                    }
                  }
                },
                () {
                  var uid = FirebaseAuth.instance.currentUser!.uid;
                  if (dataProvider.currentSong != null) {
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
                        "favourites": FieldValue.arrayUnion(
                            [dataProvider.currentSong!.id]),
                      });
                      db
                          .collection("Songs")
                          .doc(dataProvider.currentSong!.id)
                          .update({
                        "favourites": FieldValue.arrayUnion([uid]),
                      });

                      db.collection("users").doc(uid).update({
                        "blasts": FieldValue.arrayUnion(
                            [dataProvider.currentSong!.id]),
                      });
                      db
                          .collection("Songs")
                          .doc(dataProvider.currentSong!.id)
                          .update({
                        "blasts": FieldValue.arrayUnion([uid]),
                      });
                    }
                  }
                },
                20.0,
              );
            }),
            Builder(builder: (context) {
              var uid = FirebaseAuth.instance.currentUser!.uid;

              var isFollowed = false;
              var band;
              if (dataProvider.currentSong != null) {
                band = dataProvider.users
                    .where((element) =>
                        element.id == dataProvider.currentSong!.bandId)
                    .first;
                isFollowed = band.followers.contains(uid);
              }
              return overlayItemWidget(
                "Report",
                isFollowed ? "Unfollow" : "Follow",
                Assets.imagesReport,
                isFollowed ? Assets.imagesUnFollow : Assets.imagesFollow,
                () {},
                () {
                  if (dataProvider.currentSong != null) {
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
                  }
                },
                90.0,
              );
            }),
            Builder(builder: (context) {
              bool isDisable = false;
              bool isDisable1 = false;

              var other;
              var my;
              var isUpvote;
              var isDownVote;
              // var uid;

              var uid = FirebaseAuth.instance.currentUser!.uid;

              if (dataProvider.currentSong != null) {
                isUpvote = dataProvider.userModel!.upVotes
                    .contains(dataProvider.currentSong!.id);
                isDownVote = dataProvider.userModel!.downVotes
                    .contains(dataProvider.currentSong!.id);

                my = FirebaseFirestore.instance.collection("users").doc(uid);
                other = FirebaseFirestore.instance
                    .collection("Songs")
                    .doc(dataProvider.currentSong!.id);

                if (isUpvote ||
                    dataProvider.currentSong?.city !=
                        dataProvider.userModel?.city) {
                  isDisable = true;
                } else {
                  isDisable = false;
                }

                if (isDownVote ||
                    dataProvider.currentSong?.city !=
                        dataProvider.userModel?.city) {
                  isDisable1 = true;
                } else {
                  isDisable1 = false;
                }
              }

              return overlayItemWidget(
                "DownVote",
                "Upvote",
                isDisable1
                    ? Assets.imagesDisableDownvote
                    : Assets.imagesDownvote,
                isDisable
                    ? Assets.imagesDisableUpVoteIcon
                    : Assets.imagesUpvote,
                () {
                  if (dataProvider.currentSong != null &&
                      !isDownVote &&
                      dataProvider.currentSong?.city ==
                          dataProvider.userModel?.city) {
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
                  if (dataProvider.currentSong != null &&
                      !isUpvote &&
                      dataProvider.currentSong?.city ==
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
      margin: const EdgeInsets.symmetric(vertical: 5),
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
                  const SizedBox(width: 10),
                  Opacity(
                    opacity: dataProvider.currentSong == null ? 0.4 : 1,
                    child: SvgPicture.asset(
                      image1,
                    ),
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
                  Opacity(
                    opacity: dataProvider.currentSong == null ? 0.4 : 1,
                    child: SvgPicture.asset(
                      image2,
                    ),
                  ),
                  const SizedBox(width: 10),
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
        radioButtonItem("City Wide"),
        radioButtonItem("State Wide"),
        radioButtonItem("Country Wide"),
      ],
    );
  }

  Widget radioButtonItem(String text) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            value: text,
            groupValue: dataProvider.type,
            onChanged: (value) {
              dataProvider.type = value!;
              dataProvider.setSong();
              dataProvider.stop();
              dataProvider.initializePlayer();
            },
          ),
          Text(
            text,
            style: const TextStyle(color: CColors.White, fontSize: 12),
          ),
        ],
      ),
    );
  }

}
