import 'package:flutter/material.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';
import '../helpers/textstyles.dart';

class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation(
      {required this.items, required this.onSelect, super.key});

  final List<BottomNavItem> items;
  final Function(int) onSelect;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(), // This creates the center curve
      notchMargin: 6.0, // Adjust the margin according to your preference
      child: Row(
        children: [
          for (var item in items)
            itemWidget(
              item,
            ),
        ],
      ),
    );
  }

  itemWidget(BottomNavItem item) {
    if (item.index == 2) {
      return Expanded(child: SizedBox());
    } else {
      return Expanded(
        child: IconButton(
          onPressed: () {
            onSelect(item.index);
          },
          icon: Column(
            children: [
              Expanded(
                child: ImageIcon(
                  AssetImage(item.iconData),
                  size: 20,
                  color: item.isSelected ? CColors.primary : CColors.White,
                ),
              ),
              Text(
                item.title ?? "",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.popins(
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeights.bold,
                    color: item.isSelected ? CColors.primary : CColors.White,
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
