import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';

import '../helpers/colors.dart';

class PromosWidget extends StatelessWidget {
  const PromosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          10,
        ),
        child: Column(
          children: [
            Image(
              image: AssetImage(Assets.imagesEvent),
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(
                10,
              ),
              decoration: BoxDecoration(color: CColors.eventViewBgColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Texas for a cause",
                    style: AppTextStyles.title(color: Colors.white),
                  ),
                  Text(
                    "Description: Texase  for a adsad",
                    style: AppTextStyles.clickable(
                      color: CColors.textColor,
                    ),
                  ),
                  TextButton(

                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Click Here",
                            style: AppTextStyles.popins(
                                style: TextStyle(
                                  color: CColors.primary,
                                )
                            )
                        ),
                        SizedBox(width: 10,),
                        Icon(Icons.open_in_new,
                          color: CColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
