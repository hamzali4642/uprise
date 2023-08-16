import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/screens/dashboard/radio_preferences.dart';
import 'package:uprise/widgets/chip_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../generated/assets.dart';
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
        floatingActionButton: fabWidget(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: bottomNavigationWidget(),
        body: Column(
          children: [
            if(provider.selectedIndex == 0 || provider.selectedIndex == 2)...[
              headerWidget(),
              locationWidget(),
            ],
            Expanded(child: provider.pages[provider.selectedIndex]!),
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
            onTap: (){
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
                onTap: (){
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
              Image(
                image: AssetImage(
                  Assets.imagesRadio,
                ),
                color: Colors.white,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
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
                  context.push(child: RadioPreferences());
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
    return const Image(
      image: AssetImage(Assets.imagesUpriseRadiyoIcon),
      width: 70,
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
}
