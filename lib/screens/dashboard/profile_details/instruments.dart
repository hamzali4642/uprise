import 'package:flutter/material.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

class Instruments extends StatefulWidget {
  const Instruments({Key? key}) : super(key: key);

  @override
  _InstrumentsState createState() => _InstrumentsState();
}

class _InstrumentsState extends State<Instruments> {
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
    );
  }
}
