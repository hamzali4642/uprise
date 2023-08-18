import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uprise/generated/assets.dart';
import 'package:uprise/helpers/textstyles.dart';
import 'package:uprise/models/calendar_model.dart';
import 'package:uprise/models/event_model.dart';
import 'package:uprise/provider/data_provider.dart';

import '../helpers/colors.dart';

class EventWidget extends StatefulWidget {
  const EventWidget({super.key, required this.eventModel});

  final EventModel eventModel;

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  late DataProvider dataProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(
      builder: (context, value, child) {
        dataProvider = value;
        return Container(
          margin: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              10,
            ),
            child: Column(
              children: [
                Image(
                  image: NetworkImage(widget.eventModel.posterUrl),
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
                Container(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  decoration: const BoxDecoration(color: CColors.eventViewBgColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.eventModel.name,
                              style: AppTextStyles.title(color: Colors.white),
                            ),
                          ),
                          Builder(
                            builder: (context) {
                              var cal = dataProvider.userModel!.calendar;
                              bool added = cal.where((element) => element.event == widget.eventModel.id).isNotEmpty;
                              return TextButton(
                                onPressed: () {
                                  var date = DateTime(
                                    widget.eventModel.startDate.year,
                                    widget.eventModel.startDate.month,
                                    widget.eventModel.startDate.day,
                                  );
                                  var model = CalendarModel(date: date, event: widget.eventModel.id!);
                                  if(added){
                                    cal.removeWhere((element) => element.event == widget.eventModel.id!);
                                  }else{
                                    cal.add(model);
                                  }

                                  var list = List.generate(cal.length, (index) => cal[index].toMap());
                                  dataProvider.updateUserPref({
                                    "calendar" : list,
                                  });
                                },
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
                                  child: Text(
                                    "${added ? "Remove" : "Add"} to Calendar",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            }
                          ),
                        ],
                      ),
                      Text(
                        widget.eventModel.description,
                        style: AppTextStyles.clickable(
                          color: CColors.textColor,
                        ),
                      ),
                      itemWidget(
                        widget.eventModel.venue,
                        Icons.location_pin,
                      ),
                      itemWidget(
                        DateFormat('hh:mm a').format(widget.eventModel.startDate),
                        Icons.access_time_outlined,
                      ),
                      itemWidget(
                        DateFormat('EEEE, MMMM d, y').format(widget.eventModel.startDate),
                        Icons.calendar_month,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget itemWidget(String text, IconData iconData) {
    return Row(
      children: [
        Icon(
          iconData,
          color: CColors.textColor,
          size: 16,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.clickable(
              color: CColors.textColor,
            ),
          ),
        ),
      ],
    );
  }
}
