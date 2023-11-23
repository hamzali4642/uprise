import 'package:flutter/material.dart';
import 'package:uprise/models/event_model.dart';
import 'package:utility_extensions/extensions/context_extensions.dart';
import '../helpers/colors.dart';
import '../helpers/textstyles.dart';
import 'event_details.dart';

class DiscoveryEventCover extends StatelessWidget {
  const DiscoveryEventCover({Key? key, required this.eventModel}) : super(key: key);

  final EventModel eventModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(child: EventDetails(eventModel: eventModel));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            5,
          ),
          child:
          Column(
            children: [
              Image(
                image: NetworkImage(eventModel.posterUrl),
                width: double.infinity,
                height: 160,
                fit: BoxFit.cover,
              ),
              Container(
                padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration:
                const BoxDecoration(color: CColors.eventViewBgColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            eventModel.name,
                            style: AppTextStyles.title(
                                color: Colors.white, fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
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
