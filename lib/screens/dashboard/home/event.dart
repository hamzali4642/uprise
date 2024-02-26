import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/models/event_model.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/event_widget.dart';
import 'package:uprise/widgets/state_check.dart';
import 'package:utility_extensions/utility_extensions.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      Widget? check = stateCheck(value.eventState, value.events);

      return check ??
          CustomScrollView(
            slivers: [
              events(value),
            ],
          );
    });
  }

  Widget events(DataProvider value) {
    DateTime now = DateTime.now();

    List<EventModel> temp = [];

    for (var element in value.events) {
      if (element.genre == value.userModel!.selectedGenres.first) {
        if (value.type == "City Wide" &&
            value.userModel!.city == element.city) {
          temp.add(element);
        } else if (value.type == "State Wide" &&
            value.userModel!.state == element.state) {
          temp.add(element);
        } else if (value.type == "Country Wide" &&
            value.userModel!.country == element.country) {
          temp.add(element);
        }
      }
    }

    List<EventModel> events = temp
        .where((element) => element.startDate.difference(now).inHours >= -24)
        .toList();

    // value.temp.where((element) => element.genre == value.userModel!.selectedGenres.first).toList();

    return SliverList(
      delegate: SliverChildBuilderDelegate((ctx, i) {
        return EventWidget(eventModel: events[i]);
      }, childCount: events.length),
    );
  }
}
