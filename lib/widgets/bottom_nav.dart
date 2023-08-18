import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';
import 'package:utility_extensions/utility_extensions.dart';

import '../helpers/colors.dart';
import '../helpers/textstyles.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation(
      {required this.items, required this.onSelect, super.key});

  final List<BottomNavItem> items;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 6.25,
      child: Container(

        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Color(0xff3b3b2c),
                height: 20,
              ),
            ),
            Container(
              color: Colors.black,
              child: Image(
                image: AssetImage(
                  Assets.imagesURTabBase,
                ),

                fit: BoxFit.fitHeight,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(


                padding: EdgeInsets.only(
                  bottom: context.bottomPadding,
                ),
                child: Row(
                  children: [
                    for (var item in items)
                      itemWidget(
                        item,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  itemWidget(BottomNavItem item) {
    if (item.index == 1) {
      return const Expanded(flex: 1, child: SizedBox());
    } else {
      return Expanded(
        flex: 2,
        child: InkWell(
          onTap: () {
            onSelect(item.index);
          },
          child: Column(
            children: [
              SizedBox(height: 10,),
              Icon(
                item.iconData,
                size: 24,
                color: item.isSelected ? Colors.white : Colors.white60,
              ),
              Text(
                item.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.popins(
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeights.bold,
                    color: item.isSelected ? Colors.white : Colors.white60,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class BottomNavItem {
  dynamic iconData;
  String? title;
  int index;
  bool isSelected;

  BottomNavItem({
    this.iconData,
    this.title,
    required this.index,
    required this.isSelected,
  });
}
