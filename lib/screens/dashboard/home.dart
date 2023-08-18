import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uprise/provider/dashboard_provider.dart';
import 'package:uprise/widgets/home_chip_widget.dart';
import '../../helpers/constants.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric( vertical: 10),
          child: Column(
            children: [
              selectionWidget(),
              const SizedBox(height: 10,),
              Expanded(child: provider.homePage()),
            ],
          ),
        );
      }
    );
  }

  Widget selectionWidget() {
    return const Row(
      children: [
        Expanded(
          child: HomeChipWidget(
            text: "Feed",
          ),

        ),
        Expanded(
          child: HomeChipWidget(
            text: "Events",
          ),

        ),
        Expanded(
          child: HomeChipWidget(
            text: "Promos",
          ),
        ),
        Expanded(
          child: HomeChipWidget(
            text: "Statistics",
          ),
        ),
      ],
    );
  }
}
