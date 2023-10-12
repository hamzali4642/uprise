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

      return check?.toSliver ??
          CustomScrollView(
            slivers: [
              events(value),
            ],
          );
    });
  }

  Widget events(DataProvider value) {
    List<EventModel> events = value.events.where((element) => element.genre == value.userModel!.selectedGenres.first).toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate((ctx, i) {
        return EventWidget(eventModel: events[i]);
      }, childCount: events.length),
    );
  }
}
