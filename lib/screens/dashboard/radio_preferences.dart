import 'package:flutter/material.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/widgets/genere_tile_widget.dart';
import 'package:uprise/widgets/textfield_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../helpers/colors.dart';

class RadioPreferences extends StatefulWidget {
  const RadioPreferences({super.key});

  @override
  State<RadioPreferences> createState() => _RadioPreferencesState();
}

class _RadioPreferencesState extends State<RadioPreferences> {
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.transparentColor,
        title: Text(
          "Radio Preferences",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeights.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Location",
              style: TextStyle(
                color: CColors.textColor,
                fontSize: 12,
              ),
            ),
            radioWidget(),
            TextFieldWidget(
              controller: controller,
              hint: "Manually Enter Location",
              errorText: "errorText",
              onChange: (value){

              },
            ),
            SizedBox(
              height: 10,
            ),
            const Text(
              "Pick your favourite Genere",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeights.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Wrap(
              children: [
                GenreTileWidget(
                  text: "Blues",
                ),
                GenreTileWidget(
                  text: "Rock Music",
                ),
                GenreTileWidget(
                  text: "Pop",
                ),
                GenreTileWidget(
                  text: "Jazz",
                ),
                GenreTileWidget(
                  text: "Classical",
                ),
                GenreTileWidget(
                  text: "Country",
                ),
                GenreTileWidget(
                  text: "Dubstep",
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: Text("Save",),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String type = "City";

  Widget radioWidget() {
    return Row(
      children: [
        radioButtonItem("City"),
        radioButtonItem("State"),
        radioButtonItem("Country"),
      ],
    );
  }

  Widget radioButtonItem(String text) {
    return Expanded(
      child: Row(
        children: [
          Radio(
            value: text,
            groupValue: type,
            onChanged: (value) {
              setState(
                () {
                  type = text;
                },
              );
            },
          ),
          Text(
            text,
            style: TextStyle(
              color: CColors.White,
            ),
          ),
        ],
      ),
    );
  }
}
