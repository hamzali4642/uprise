import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

class Instruments extends StatefulWidget {
  const Instruments({Key? key}) : super(key: key);

  @override
  _InstrumentsState createState() => _InstrumentsState();
}

class _InstrumentsState extends State<Instruments> {
  int? selectedIndex;

  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, value, child) {
      if (!checked) {
        selectedIndex = value.userModel?.instrument;
        checked = true;
      }
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Instrument",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeights.bold,
            ),
          ),
          leading: InkWell(
            onTap: () {
              context.pop();
            },
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Choose an instrument that you play",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 50),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Number of columns
                    mainAxisSpacing: 15.0, // Vertical spacing between items
                    crossAxisSpacing: 50.0,
                    childAspectRatio: 0.7// Horizontal spacing between items
                  ),
                  itemCount: 30, // Total number of items in the grid
                  itemBuilder: (context, index) {
                    return instrumentWidget(index);
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      value.updateUserPref({
                        "instrument": selectedIndex,
                      });

                      context.pop();
                    },
                    child: const Text(
                      "Save",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: context.bottomPadding + 20,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget instrumentWidget(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            height: 90,
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: CColors.textColor,
                border: selectedIndex == index
                    ? Border.all(color: CColors.primary)
                    : null),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomAssetImage(
                    path: "assets/instruments/Instrument_${index + 1}.png",
                    height: 90,
                    fit: BoxFit.fill,
                  ),
                ),
                if(selectedIndex == index)
                const Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.check_circle,
                        color: CColors.primary,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
          const SizedBox(height: 10,),
          Text(instruments[index],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeights.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  List<String> instruments = [
    "Guitar",
    "Saxophone",
    "Drums",
    "Maracas",
    "Trumpet",
    "Keyboard",
    "Harp",
    "Violin",
    "Mike",
    "Acoustic Guitar",
    "Flute",
    "Xylophone",
    "Piano",
    "Clarinet",
    "Electric Car",
    "Cymbal",
    "Tambourine",
    "Harmonica",
    "Congo",
    "French Horn",
    "Banjo",
    "Drum",
    "Tuba",
    "Accordion",
    "Bongo",
    "Triangle",
    "OUD",
    "Clavicle",
    "Tubular Chimes",
    "Metro Nomi",
  ];
}
