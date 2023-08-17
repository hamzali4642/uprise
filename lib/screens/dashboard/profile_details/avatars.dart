import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../../../generated/assets.dart';
import '../../../helpers/colors.dart';

class Avatars extends StatefulWidget {
  const Avatars({super.key});

  @override
  State<Avatars> createState() => _AvatarsState();
}

class _AvatarsState extends State<Avatars> {
  String? selected;

  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {

        if(!checked){
          selected = value.userModel?.avatar;
          checked = true;
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "Choose your avatar",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeights.bold,
              ),
            ),
            centerTitle: false,
          ),
          body: Container(
            child: Column(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  margin: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: CColors.textColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image(
                      image: AssetImage(selected ?? Assets.imagesUsers),
                    ),
                  ),
                ),
                gridWidget(),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    value.updateUserPref({
                      "avatar" : selected,
                    });

                    context.pop();
                  },
                  child: Text(
                    "Save",
                  ),
                ),
                SizedBox(
                  height: context.bottomPadding + 20,
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget gridWidget() {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1),
        itemBuilder: (ctx, i) {
          var path = "assets/avatar/avatar_${i + 1}.png";
          return Center(
            child: InkWell(
              onTap: () {
                setState(() {
                  selected = path;
                });
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: CColors.textColor,
                    shape: BoxShape.circle,
                    border: selected == path
                        ? Border.all(
                            color: CColors.primary,
                            width: 2,
                          )
                        : null),
                child: Image(
                  image: AssetImage(path),
                ),
              ),
            ),
          );
        },
        itemCount: 62,
      ),
    );
  }
}
