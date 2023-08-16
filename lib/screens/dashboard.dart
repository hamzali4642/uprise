import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/screens/dashboard/radio_preferences.dart';
import 'package:uprise/widgets/chip_widget.dart';
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

  @override
  Widget build(BuildContext context) {
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            child: const SizedBox(
              height: 40,
              width: 40,
              child: ClipOval(
                child: Image(
                  image: AssetImage(Assets.imagesUsers),
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
                  "UserName",
                  style: AppTextStyles.popins(
                      style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeights.bold,
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget locationWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Image(
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
                    "Name",
                    style: AppTextStyles.message(color: Colors.white),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  context.push(child: const RadioPreferences());
                },
                color: Colors.white,
                icon: Icon(
                  Icons.edit,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                ChipWidget(text: "Blues"),
                ChipWidget(text: "Blues"),
                ChipWidget(text: "Blues"),
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
            title: "Socializing",
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
          children: [],
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
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Text(text1,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [

            ],
          ),
        ),
      ],
    );
  }
}
