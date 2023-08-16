import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';

class HomeChipWidget extends StatelessWidget {
  const HomeChipWidget({super.key, required this.text,});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, value) {
        bool isSelected = provider.homeSelected == text;
        return InkWell(
          onTap: (){
            provider.homeSelected = text;
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5,),
            padding: const EdgeInsets.symmetric(vertical: 5,),
            decoration: BoxDecoration(
              color: isSelected ? CColors.URbtnBgColor : CColors.feedContainerViewColor,
              borderRadius: BorderRadius.circular(20,),
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.popins(
                style: TextStyle(
                  color: isSelected ? CColors.primary : Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeights.medium,
                )
              ),
            ),
          ),
        );
      }
    );
  }
}
