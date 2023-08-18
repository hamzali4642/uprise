import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:uprise/models/user_model.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/screens/dashboard/profile_details/change_password.dart';
import 'package:uprise/screens/dashboard/profile_details/instruments.dart';
import 'package:uprise/screens/dashboard/profile_details/profile_details.dart';
import 'package:uprise/widgets/textfield_widget.dart';
import 'package:utility_extensions/utility_extensions.dart';
import '../../../generated/assets.dart';
import '../../../helpers/colors.dart';
import '../../../helpers/constants.dart';
import '../../auth/signin.dart';
import 'avatars.dart';

typedef UserCallBack = void Function(bool);

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key, required this.isEdit, required this.callBack})
      : super(key: key);
  final bool isEdit;
  final UserCallBack callBack;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  TextEditingController facebook = TextEditingController();
  TextEditingController instagram = TextEditingController();
  TextEditingController twitter = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController description = TextEditingController();

  late DataProvider provider;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<DataProvider>(builder: (ctx, value, child) {
        provider = value;
        facebook.text = value.userModel!.facebook ?? "";
        instagram.text = value.userModel!.instagram ?? "";
        twitter.text = value.userModel!.twitter ?? "";
        phone.text = value.userModel!.phone ?? "";
        description.text = value.userModel!.description ?? "";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: Constants.homePadding, right: Constants.homePadding),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  header(value),
                  const SizedBox(height: 30),
                  detailRow(value.userModel!.email, Icons.email_outlined),
                  const SizedBox(height: 10),
                  detailRow(value.userModel?.phone ?? "", Icons.phone),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 1,
              color: CColors.textColor.withOpacity(0.13),
            ),
            if (!widget.isEdit) ...[
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(child: followDetails("Followers",  provider.userModel!.followers.length.toString())),
                    Container(
                      width: 1,
                      color: CColors.textColor.withOpacity(0.13),
                    ),
                    Expanded(child: followDetails("Following", provider.userModel!.following.length.toString())),
                    Container(
                      width: 1,
                      color: CColors.textColor.withOpacity(0.13),
                    ),
                    Expanded(child: followDetails("Total Hours", "0")),
                    Container(
                      width: 1,
                      color: CColors.textColor.withOpacity(0.13),
                    ),
                    Expanded(child: followDetails("Song Blast", "0")),
                    Container(
                      width: 1,
                      color: CColors.textColor.withOpacity(0.13),
                    ),
                    Expanded(child: followDetails("Song Listen", "0")),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: CColors.textColor.withOpacity(0.13),
              ),
            ],
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
                      fontSize: 12,
                      color: CColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  platform("Facebook:", facebook),
                  const SizedBox(height: 20),
                  platform("Instagram:", instagram),
                  const SizedBox(height: 20),
                  platform("Twitter:", twitter),
                  const SizedBox(height: 30),
                  if (widget.isEdit) ...[
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          UserModel user = value.userModel!;
                          user.phone = phone.text;
                          user.facebook = facebook.text;
                          user.instagram = instagram.text;
                          user.twitter = twitter.text;
                          user.description = description.text;
                          value.updateUser(user);
                          widget.callBack(false);
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 20,
                            color: CColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ] else ...[
                    if (FirebaseAuth.instance.currentUser!.providerData
                        .where((element) => element.providerId == "password")
                        .isNotEmpty)
                      btn(
                          "Change Password",
                          context,
                          ChangePassword(
                            email: value.userModel!.email,
                          )),
                    const SizedBox(height: 10),
                    btn("Instruments interested in", context, Instruments()),
                    const SizedBox(
                      height: 10,
                    ),
                    btn(
                      "Logout",
                      context,
                      const SignIn(),
                    ),
                  ]
                ],
              ),
            )
          ],
        );
      }),
    );
  }

  Widget header(DataProvider value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.2),
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              ClipOval(
                child: Image(
                  image: AssetImage(provider.userModel?.avatar == null
                      ? Assets.imagesUsers
                      : provider.userModel!.avatar!),
                ),
              ),
              if (widget.isEdit)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: InkWell(
                    onTap: () {
                      context.push(child: const Avatars());
                    },
                    child: Container(
                      padding: EdgeInsets.all(
                        6,
                      ),
                      decoration: BoxDecoration(
                        color: CColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        Assets.imagesEdit,
                        color: CColors.Black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              headerTitle(value.userModel!.username),
              if (widget.isEdit)
                TextFieldWidget(
                  controller: description,
                  hint: "Add description up to 200 characters",
                  errorText: "",
                  enableBorder: false,
                  maxLength: 200,
                )
            ],
          ),
        ),
      ],
    );
  }

  Widget btn(String str, BuildContext context, Widget widget) {
    return InkWell(
      onTap: () async {
        if (widget is SignIn) {
          await FirebaseAuth.instance.signOut();
          var p = Provider.of<DashboardProvider>(context, listen: false);
          p.selectedIndex = 0;
          p.homeSelected = "Feed";
        }
        context.push(child: widget);
      },
      child: Text(
        str,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  Widget platform(String str, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          str,
          style: const TextStyle(
            color: CColors.Grey,
            fontSize: 12
          ),
        ),
        const SizedBox(height: 10),
        if (widget.isEdit)
          SizedBox(
            height: widget.isEdit ? null : 5,
            width: double.infinity,
            child: TextFieldWidget(
              controller: controller,
              hint: "",
              errorText: "",
              enableBorder: false,
              enable: widget.isEdit,
            ),
          )
        else
          Text(
            controller.text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        const Divider(
          color: CColors.Grey,
        ),
      ],
    );
  }

  Widget followDetails(String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeights.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
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
        if (iconData == Icons.phone && widget.isEdit) ...[
          Expanded(
            child: SizedBox(
              height: widget.isEdit ? null : 0,
              child: TextFieldWidget(
                controller: phone,
                hint: "Add Phone number",
                errorText: "",
                enableBorder: false,
                enable: widget.isEdit,
              ),
            ),
          )
        ] else ...[
          Text(
            str,
            style: const TextStyle(
              color: CColors.textColor,
              fontSize: 16,
            ),
          ),
        ],
      ],
    );
  }

  Widget headerTitle(String name) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
              fontSize: 22,
              color: Colors.white,
              fontWeight: FontWeights.medium),
        ),
        const SizedBox(width: 10,),
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
