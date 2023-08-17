import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/profile_details/profile_calendar.dart';
import 'package:uprise/screens/dashboard/profile_details/user_profile.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import '../../../generated/assets.dart';
import 'favorites.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  late DataProvider provider;

  bool editProfile = false;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  late List<Widget> tabBarViews;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      provider = value;
      tabBarViews = [
        UserProfile(
          callBack: (value) {
            setState(() {
              editProfile = value;
            });
          },
          isEdit: editProfile,
        ),
        const ProfileCalendar(),
        const Favorites(),
      ];
      return Scaffold(
        body: details(),
      );
    });
  }

  Widget details() {
    if (provider.profileState == DataStates.waiting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (provider.profileState == DataStates.fail) {
      return const Center(
        child:
            Text("Something Went wrong", style: TextStyle(color: Colors.white)),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: Constants.horizontalPadding,
              right: Constants.horizontalPadding),
          child: Column(
            children: [
              const SizedBox(height: 40),
              headerWidget(),
              const SizedBox(height: 30),
            ],
          ),
        ),
        TabBar(
          physics: const NeverScrollableScrollPhysics(),
          indicatorColor: Colors.white,
          isScrollable: false,
          unselectedLabelColor: CColors.textColor,
          labelColor: CColors.primary,
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 3.0, color: CColors.primary),
          ),
          tabs: [
            buildText("Profile"),
            buildText("Calendar"),
            buildText("Favorites"),
          ],
          controller: controller,
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller,
            children: tabBarViews,
          ),
        ),
      ],
    );
  }

  Widget headerWidget() {
    return Row(
      children: [
        Container(
          height: 30,
          width: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.2),
            shape: BoxShape.circle,
          ),
          child: const ClipOval(
            child: Image(
              image: AssetImage(Assets.imagesUsers),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: headerTitle(provider.userModel!.username),
        ),
        if(!editProfile)
        InkWell(
          onTap: () {
            setState(() {
              editProfile = true;
            });
          },
          child: Container(
            height: 30,
            width: 30,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              Assets.imagesEdit,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildText(String str) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        str,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}

Widget headerTitle(String name) {
  return Text(
    name,
    style: const TextStyle(
        fontSize: 25, color: Colors.white, fontWeight: FontWeights.medium),
  );
}
