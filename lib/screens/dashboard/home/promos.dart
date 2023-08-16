import 'package:flutter/material.dart';
import 'package:uprise/widgets/promos_widget.dart';

class Promos extends StatelessWidget {
  const Promos({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemBuilder: (ctx, i) {
        return const PromosWidget();
      },
      itemCount: 5,
    );
  }
}
