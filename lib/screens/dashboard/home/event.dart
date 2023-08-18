import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/event_widget.dart';
import 'package:uprise/widgets/state_check.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (ctx, value, child) {
      Widget? check = stateCheck(value.eventState, value.events);

      return check ??
          ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (ctx, i) {
              return  EventWidget(eventModel: value.events[i]);
            },
            itemCount: value.events.length,
          );
    });
  }
}
