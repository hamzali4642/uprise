import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/player_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../../generated/assets.dart';
import '../../../models/song_model.dart';

class BandMemberDetail extends StatefulWidget {
  const BandMemberDetail({Key? key, required this.model}) : super(key: key);

  final UserModel model;

  @override
  State<BandMemberDetail> createState() => _BandMemberDetailState();
}

class _BandMemberDetailState extends State<BandMemberDetail> {
  late DataProvider dataProvider;
  late bool isFollowed;

  @override
  void initState() {
    super.initState();
    dataProvider = Provider.of<DataProvider>(context, listen: false);
    var uid = FirebaseAuth.instance.currentUser!.uid;
    isFollowed = widget.model.followers.contains(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "${widget.model.bandName}",
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: Constants.homePadding, right: Constants.homePadding),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    avatartWidget(),
                    const SizedBox(height: 10),
                    Text(
                      widget.model.bandName ?? "band",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeights.bold),
                    ),
                    Text(
                      "Comparison Score:\t${getComparisonScore()}",
                      style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeights.medium),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Appears in band",
                        style: TextStyle(
                          fontSize: 16,
                          color: CColors.placeholder,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    brandInfo(),
                    const Text(
                      "SOCIAL PLATFORMS",
                      style: TextStyle(
                        fontSize: 12,
                        color: CColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    platform("Facebook:", widget.model.facebook ?? ""),
                    const SizedBox(height: 20),
                    platform("Instagram:", widget.model.instagram ?? ""),
                    const SizedBox(height: 20),
                    platform("Twitter:", widget.model.twitter ?? ""),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            const PlayerWidget(),
          ],
        ),
      ),
    );
  }

  Widget platform(String header, String detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: const TextStyle(color: CColors.Grey, fontSize: 12),
        ),
        const SizedBox(height: 5),
        Text(
          detail,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 0.3,
          width: double.infinity,
          color: CColors.placeholder,
        ),
      ],
    );
  }

  Widget brandInfo() {
    return Container(
      decoration: BoxDecoration(
        color: CColors.screenContainer,
        borderRadius: BorderRadius.circular(5),
      ),
      height: 220,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: const Image(
              image: NetworkImage(
                Constants.demoCoverImage,
              ),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.model.bandName ?? "band",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeights.bold),
                  ),
                  Builder(builder: (context) {
                    return InkWell(
                      onTap: () {
                        var my = FirebaseFirestore.instance
                            .collection("users")
                            .doc(FirebaseAuth.instance.currentUser!.uid);
                        var other = FirebaseFirestore.instance
                            .collection("users")
                            .doc(widget.model.id);
                        if (isFollowed) {
                          my.update({
                            "following": FieldValue.arrayRemove([other.id])
                          });
                          other.update({
                            "followers": FieldValue.arrayRemove([my.id])
                          });

                          widget.model.followers.remove(my.id);
                          dataProvider.userModel!.following.remove(my.id);

                          dataProvider.notifyListeners();
                        } else {
                          my.update({
                            "following": FieldValue.arrayUnion([other.id])
                          });
                          other.update({
                            "followers": FieldValue.arrayUnion([my.id])
                          });

                          widget.model.followers.add(my.id);
                          dataProvider.userModel!.following.add(my.id);

                          dataProvider.notifyListeners();
                        }

                        setState(() {
                          isFollowed = !isFollowed;
                        });
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
                            const SizedBox(
                              width: 10,
                            ),
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
                  })
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ClipOval avatartWidget() {
    return ClipOval(
      child: SizedBox(
        height: 80,
        child: Stack(children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: CColors.placeholderTextColor.withOpacity(0.4),
            ),
          ),
          Positioned.fill(
            bottom: -30,
            right: 0,
            left: 0,
            child: Image(
              image: AssetImage(
                widget.model.avatar == null
                    ? Assets.imagesUsers
                    : widget.model.avatar!,
              ),
            ),
          )
        ]),
      ),
    );
  }

  int getComparisonScore() {
    int comparisonScore = 0;
    for (var g in dataProvider.userModel!.selectedGenres) {
      List<SongModel> strength = dataProvider.songs
          .where((element) => element.genreList.any((s) => s.contains(g)))
          .toList();
      comparisonScore += strength.length;
    }

    return comparisonScore;
  }
}
