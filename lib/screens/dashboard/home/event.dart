import 'package:flutter/material.dart';
import 'package:uprise/widgets/event_widget.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return EventWidget();
      },
      itemCount: 5,
    );
  }
}
