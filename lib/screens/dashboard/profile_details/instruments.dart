import 'package:flutter/material.dart';
import 'package:uprise/helpers/colors.dart';
import 'package:uprise/widgets/custom_asset_image.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

class Instruments extends StatefulWidget {
  const Instruments({Key? key}) : super(key: key);

  @override
  _InstrumentsState createState() => _InstrumentsState();
}

class _InstrumentsState extends State<Instruments> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
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
              "Choose an instrument that you are interested in",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of columns
                  mainAxisSpacing: 50.0, // Vertical spacing between items
                  crossAxisSpacing: 50.0, // Horizontal spacing between items
                ),
                itemCount: 20, // Total number of items in the grid
                itemBuilder: (context, index) {
                  return instrumentWidget(index);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget instrumentWidget(int index) {
    return InkWell(
      onTap: (){
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        height: 90,
        width: 90,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: CColors.textColor,
          border: selectedIndex == index  ?  Border.all(color: CColors.primary) : null

        ),
        child:  CustomAssetImage(
          path: "assets/instruments/Instrument_${index+1}.png",
          height: 90,
        ),
      ),
    );
  }
}
