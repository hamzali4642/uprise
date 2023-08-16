import 'package:flutter/material.dart';
import 'package:uprise/widgets/heading_widget.dart';

import '../../helpers/constants.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
      child: Column(
        children: [
          const HeadingWidget(text: "New Releases",),
          const HeadingWidget(text: "Recommended Radio Stations",),
        ],
      ),
    );
  }
}
