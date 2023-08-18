import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';

import '../helpers/colors.dart';

class PromosWidget extends StatelessWidget {
  const PromosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            5,
          ),
          child: Column(
            children: [
              const Image(
                image: AssetImage(Assets.imagesEvent),
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(
                  10,
                ),
                decoration: const BoxDecoration(color: CColors.eventViewBgColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Texas for a cause",
                      style: AppTextStyles.title(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Description: Texase  for a adsad",
                      style: AppTextStyles.clickable(
                        color: CColors.Grey,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Click Here",
                              style: AppTextStyles.popins(
                                  style: const TextStyle(
                                    color: CColors.primary,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline
                                  )
                              )
                          ),
                          const SizedBox(width: 5,),
                          const Icon(Icons.open_in_new,
                            color: CColors.primary,
                            size: 18,
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
      ),
    );
  }
}
