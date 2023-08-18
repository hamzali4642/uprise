import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/data_state.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/profile_details/profile_calendar.dart';
import 'package:uprise/screens/dashboard/profile_details/user_profile.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import '../../../generated/assets.dart';
import 'favorites.dart';

class ProfileDetails extends StatefulWidget {
  const ProfileDetails({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileDetails> createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  late DataProvider provider;

  bool editProfile = false;

  late DashboardProvider dashboardProvider;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);

    dashboardProvider = context.read<DashboardProvider>();

    if (dashboardProvider.isFavourites) {
      controller.animateTo(2);
      dashboardProvider.isFavourites = false;
    }
  }

  late List<Widget> tabBarViews;

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      provider = value;
      tabBarViews = [
        UserProfile(
          callBack1: (val) {
            setState(() {
              currentIndex = val;
            });
          },
          callBack: (value) {
            setState(() {
              editProfile = value;
            });
          },
          isEdit: editProfile,
        ),
        ProfileCalendar(
          callBack: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
        Favorites(
          callBack: (val) {
            setState(() {
              currentIndex = val;
            });
          },
        ),
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
              headerWidget(),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
    return Container(
      padding: EdgeInsets.only(
        top: context.topPadding + 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Container(

            height: 30,
            width: 30,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 0.2),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image(
                image: AssetImage(provider.userModel?.avatar == null
                    ? Assets.imagesUsers
                    : provider.userModel!.avatar!),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: headerTitle(provider.userModel!.username),
          ),
          if (!editProfile && currentIndex == 0)
            TextButton(
              onPressed: () {
                setState(() {
                  editProfile = true;
                });
              },
              child: Container(

                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5,),
                decoration: BoxDecoration(
                  border: Border.all(color: CColors.White, width: 1,),
                  borderRadius: BorderRadius.circular(20,),
                ),
                child: const Text("Edit", style: TextStyle(
                  color: Colors.white
                ),),
              ),
            ),
        ],
      ),
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

  Widget headerTitle(String name) {
    return Row(
      children: [
        Text(
          name,
          style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeights.medium),
        ),
        const SizedBox(
          width: 10,
        ),
        if (provider.userModel!.instrument != null)
          Image(
            image: AssetImage(
                "assets/instruments/Instrument_${provider.userModel!.instrument! + 1}.png"),
            width: 30,
          ),
      ],
    );
  }


}
