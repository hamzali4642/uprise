import 'package:flutter/material.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image(
          image: AssetImage(Assets.imagesEvent),
          width: double.infinity,
          height: 120,
          fit: BoxFit.cover,
        ),
        Container(
          child: Column(
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
                    style: TextButton.styleFrom(

                    ),
                    onPressed: () {},
                    child: Text(
                      "Add to Calendar",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
