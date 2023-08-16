import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../helpers/colors.dart';
import '../provider/dashboard_provider.dart';

class GenreTileWidget extends StatelessWidget {
  const GenreTileWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
        builder: (context, provider, value) {
          bool isSelected = provider.selectedGenres.contains(text);
          return InkWell(
            onTap: (){
              if(provider.selectedGenres.contains(text)){
                provider.selectedGenres.remove(text);
              }else{
                provider.selectedGenres.add(text);
              }
              provider.refresh();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10,),
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? CColors.primary : null,
                borderRadius: BorderRadius.circular(20,),
                border: isSelected ? null : Border.all(color: Colors.white, width: 1)
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? CColors.Black : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeights.medium,
                ),
              ),
            ),
          );
        }
    );
  }
}
