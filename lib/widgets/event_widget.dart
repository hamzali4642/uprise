import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';

import '../helpers/colors.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10,),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10,),
        child: Column(
          children: [
            const Image(
              image: AssetImage(Assets.imagesEvent),
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            Container(
              padding: const EdgeInsets.all(10,),
              decoration: const BoxDecoration(
                color: CColors.eventViewBgColor
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Texas for a cause",
                          style: AppTextStyles.title(color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Container(
                          decoration: BoxDecoration(
                            color: CColors.URbtnBgColor,
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: const Text(
                            "Add to Calendar",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Description: Texase  for a adsad",
                    style: AppTextStyles.clickable(color: CColors.textColor,),
                  ),

                  itemWidget("Location chek krne ", Icons.location_pin,),
                  itemWidget("9:09", Icons.access_time_outlined,),
                  itemWidget("Wednesday", Icons.calendar_month,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget itemWidget(String text, IconData iconData){
    return Row(
      children: [
        Icon(iconData, color: CColors.textColor, size: 16,),
        const SizedBox(width: 10,),
        Expanded(
          child: Text(text,
            style: AppTextStyles.clickable(color: CColors.textColor,),
          ),
        ),
      ],
    );
  }
}
