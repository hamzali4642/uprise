import 'package:flutter/material.dart';
import 'package:utility_extensions/utility_extensions.dart';

class MarginWidget extends StatelessWidget {
  const MarginWidget({
    this.isSliver = false,
    this.isHorizontal = false,
    this.factor = 1.0,
    Key? key,
  }) : super(key: key);

  final bool isSliver;
  final bool isHorizontal;
  final double factor;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    if (isSliver) {
      return SizedBox(
        height: isHorizontal ? null : height * 0.02 * factor,
        width: isHorizontal ? width * 0.03 * factor : null,
      ).toSliver;
    } else {
      return SizedBox(
        height: isHorizontal ? null : height * 0.02 * factor,
        width: isHorizontal ? width * 0.03 * factor : null,
      );
    }
  }
}
