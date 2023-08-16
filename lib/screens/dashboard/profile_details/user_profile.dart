import 'package:flutter/material.dart';
import 'package:uprise/screens/dashboard/profile_details/profile_details.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import '../../../generated/assets.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/constants.dart';

class User_Profile extends StatelessWidget {
  const User_Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: Constants.homePadding, right: Constants.homePadding),
            child: Column(
              children: [
                const SizedBox(height: 30),
                Row(
                  children: [
                    Container(
                      height: 70,
                      width: 70,
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
                    const SizedBox(width: 20),
                    headerTitle(),
                  ],
                ),
                const SizedBox(height: 30),
                detailRow("fahad.codingsquare@gmail.com", Icons.email_outlined),
                const SizedBox(height: 10),
                detailRow("", Icons.phone),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            height: 1,
            color: CColors.textColor.withOpacity(0.13),
          ),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(child: followDetails()),
                Container(
                  width: 1,
                  color: CColors.textColor.withOpacity(0.13),
                ),
                Expanded(child: followDetails()),
              ],
            ),
          ),
          Container(
            height: 1,
            color: CColors.textColor.withOpacity(0.13),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(
                left: Constants.homePadding, right: Constants.homePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SOCIAL PLATFORMS",
                  style: TextStyle(
                    color: CColors.textColor,
                  ),
                ),
                const SizedBox(height: 20),
                platform("Facebook:"),
                const SizedBox(height: 20),
                platform("Instagram:"),
                const SizedBox(height: 20),
                platform("Twitter:"),
                const SizedBox(height: 30),
                btn("Change Password"),
                const SizedBox(height: 10),
                btn("Instruments interested in"),
                const SizedBox(height: 10),
                btn("Logout"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget btn(String str) {
    return InkWell(
      onTap: () {},
      child: Text(
        str,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget platform(String str) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str,
          style: const TextStyle(
            color: CColors.Grey,
          ),
        ),
        const SizedBox(height: 20),
        const Divider(
          color: CColors.Grey,
        ),
      ],
    );
  }

  Widget followDetails() {
    return const Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Text(
            "0",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeights.bold,
            ),
          ),
          Text(
            "Followers",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeights.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget detailRow(String str, IconData iconData) {
    return Row(
      children: [
        Icon(
          iconData,
          color: CColors.textColor,
        ),
        const SizedBox(width: 15),
        Text(
          str,
          style: const TextStyle(
            color: CColors.textColor,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
