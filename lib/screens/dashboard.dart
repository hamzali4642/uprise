import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, p, child) {
      dataProvider = p;
      return Consumer<DashboardProvider>(builder: (context, value, child) {
        provider = value;
        return Scaffold(
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
                  body: Column(
                    children: [
                      if (provider.selectedIndex == 0 ||
                          provider.selectedIndex == 2) ...[
                        headerWidget(),
                        locationWidget(),
                        if(provider.selectedIndex != 2)...[
                          const PlayerWidget(),
                          const Divider(color: CColors.textColor,thickness: 0.4,),
                        ]
                      ],
                      Expanded(child: provider.pages[provider.selectedIndex]!),
                    ],
                  ),
                ),
              ),
              if (provider.showOverlay) overlayWidget(),
            ],
          ),
        );
      });
    });
  }

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
          PopupMenuButton(
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
              }else if (value == "/favourites") {
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
                    style: AppTextStyles.message(color: Colors.white,fontSize: 15),

                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.push(child: const RadioPreferences());
                },
                color: Colors.white,
                icon: const Icon(
                  Icons.edit,
                ),
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
      child: const Image(
        image: AssetImage(Assets.imagesUpriseRadiyoIcon),
        width: 70,
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
            overlayItemWidget(
                "Skip", "Blast", Assets.imagesSkip, Assets.imagesBlast, 20.0),
            overlayItemWidget("Report", "Unfollow", Assets.imagesReport,
                Assets.imagesUnFollow, 90.0),
            overlayItemWidget("Downvote", "Upvote", Assets.imagesDownvote,
                Assets.imagesUpvote, 130.0),
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
    double margin,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
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
          SizedBox(
            width: margin,
          ),
          Expanded(
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
        ],
      ),
    );
  }
}
