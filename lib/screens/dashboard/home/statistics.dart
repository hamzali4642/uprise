import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:uprise/helpers/constants.dart';
import 'package:uprise/provider/data_provider.dart';
import 'package:uprise/widgets/heading_widget.dart';
import 'package:utility_extensions/extensions/font_utilities.dart';

import '../../../helpers/colors.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late DataProvider provider;

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (context, provider, child) {
      this.provider = provider;
      return SingleChildScrollView(
        child: Column(
          children: [
            usersWidget(),
            const SizedBox(
              height: 20,
            ),
            eventsPerYearWidget(),
            const SizedBox(
              height: 20,
            ),
            genrePreferencesWidget(),
            const SizedBox(
              height: 20,
            ),
            bandsWidget(),
            const SizedBox(
              height: 20,
            ),
            popularArtistWidget(),
            const SizedBox(
              height: 20,
            ),
            popularArtistPerGenreWidget(),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      );
    });
  }

  Widget usersWidget() {
    var artists = provider.users.where((element) => element.isBand).length;
    var listeners = provider.users.where((element) => !element.isBand).length;

    List<PieData> pieData = [
      PieData(
        "",
        artists,
      ),
      PieData(
        "",
        listeners,
      ),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: CColors.statisticsBgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingWidget(
            text: "Users",
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: SfCircularChart(palette: [
                  Colors.blue.shade800,
                  Colors.blue,
                ], series: <PieSeries<PieData, String>>[
                  PieSeries<PieData, String>(
                      radius: "90.0",
                      explode: false,
                      dataSource: pieData,
                      xValueMapper: (PieData data, _) => data.xData,
                      yValueMapper: (PieData data, _) => data.yData,
                      dataLabelMapper: (PieData data, _) => data.text,
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: false)),
                ]),
              ),
              Expanded(
                child: Column(
                  children: [
                    pieDetailsWidget("$artists Artists", Colors.blue.shade800),
                    pieDetailsWidget("$listeners Listeners", Colors.blue),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget pieDetailsWidget(String text, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 30,
          ),
          Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget eventsPerYearWidget() {
    // provider.getEventChartData();
    //
    // List<ChartData> chartData = [
    //   ChartData(DateTime(2022, 8), 1),
    //   ChartData(DateTime(2022, 9), 0),
    //   ChartData(DateTime(2022, 10), 0),
    //   ChartData(DateTime(2022, 11), 4),
    //   ChartData(DateTime(2022, 12), 5),
    //   ChartData(DateTime(2023, 1), 2),
    //   ChartData(DateTime(2023, 2), 3),
    //   ChartData(DateTime(2023, 4), 0),
    //   ChartData(DateTime(2023, 5), 1),
    //   ChartData(DateTime(2023, 6), 8),
    //   ChartData(DateTime(2023, 7), 1),
    // ];
    var majorGridLines = const MajorGridLines(
      width: 1,
      color: Colors.grey,
      dashArray: <double>[4, 5], // [5 units of line, 2 units of gap]
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: CColors.statisticsBgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingWidget(
            text: "Events Per Year",
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                axisLine: const AxisLine(width: 0),
                interval: 2,
                majorGridLines: majorGridLines,
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                minimum: 0,
                interval: 2,
                majorGridLines: majorGridLines,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: false,
                tooltipPosition: TooltipPosition.pointer,
                activationMode: ActivationMode.singleTap,
              ),
              series: _getEventsData(provider.getEventChartData()),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          chartDescriptionWidget(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  List<AreaSeries<ChartData, DateTime>> _getEventsData(
      List<ChartData> chartData) {
    var lineWidth = 1.0;
    var markerSettings =
        const MarkerSettings(isVisible: true, color: CColors.primary);
    var emptyPointSettings = EmptyPointSettings(
      mode: EmptyPointMode.drop,
    );
    return <AreaSeries<ChartData, DateTime>>[
      AreaSeries<ChartData, DateTime>(
          dataSource: chartData,
          color: CColors.primary.withOpacity(0.1),
          enableTooltip: false,
          markerSettings: markerSettings,
          emptyPointSettings: emptyPointSettings,
          borderColor: CColors.primary,
          borderWidth: lineWidth,
          xValueMapper: (ChartData sales, _) => sales.xData,
          yValueMapper: (ChartData sales, _) => sales.yData)
    ];
  }

  Widget genrePreferencesWidget() {
    List<PieData> pieData = [];

    HashMap<String, int> values = provider.getGenrePref();
    for (var entry in values.entries) {
      String key = entry.key;
      int value = entry.value;
      if (value != 0) {
        pieData.add(
          PieData(
            "",
            value,
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: CColors.statisticsBgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingWidget(
            text: "Genre Preferences",
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: SfCircularChart(
                    palette: Constants.colors,
                    series: <PieSeries<PieData, String>>[
                      PieSeries<PieData, String>(
                          radius: "90.0",
                          explode: false,
                          dataSource: pieData,
                          xValueMapper: (PieData data, _) => data.xData,
                          yValueMapper: (PieData data, _) => data.yData,
                          dataLabelMapper: (PieData data, _) => data.text,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: false)),
                    ]),
              ),
              Expanded(
                child: Builder(builder: (context) {
                  List<Widget> widgets = [];
                  int index = 0;
                  for (var entry in values.entries) {
                    if (entry.value != 0) {
                      widgets.add(pieDetailsWidget(
                        "${entry.value * 10}% ${entry.key}",
                        Constants.colors[index % Constants.colors.length],
                      ));
                      index++;
                    }
                  }
                  return Column(children: [
                    for (var widget in widgets) ...[
                      widget
                    ]
                  ]);
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bandsWidget() {
    // List<ChartData> chartData = [
    //   ChartData(DateTime(2023, 2), 1),
    //   ChartData(DateTime(2023, 4), 0),
    //   ChartData(DateTime(2023, 4), 0),
    //   ChartData(DateTime(2023, 5), 1),
    //   ChartData(DateTime(2023, 6), 0),
    //   ChartData(DateTime(2023, 7), 0),
    // ];
    var majorGridLines = const MajorGridLines(
      width: 1,
      color: Colors.grey,
      dashArray: <double>[4, 5],
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: CColors.statisticsBgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingWidget(
            text: "Bands",
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: SfCartesianChart(
              margin: EdgeInsets.zero,
              plotAreaBorderWidth: 0,
              primaryXAxis: DateTimeAxis(
                axisLine: const AxisLine(width: 0),
                interval: 1,
                majorGridLines: majorGridLines,
                isVisible: true,
              ),
              primaryYAxis: NumericAxis(
                axisLine: const AxisLine(width: 0),
                majorGridLines: majorGridLines,
                isVisible: true,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: false,
                tooltipPosition: TooltipPosition.pointer,
                activationMode: ActivationMode.singleTap,
              ),
              series: _getBandData(provider.getBandsChartData()),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          chartDescriptionWidget(),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  List<AreaSeries<ChartData, DateTime>> _getBandData(
      List<ChartData> chartData) {
    var lineWidth = 1.0;
    var markerSettings =
        const MarkerSettings(isVisible: true, color: Colors.yellow);
    var emptyPointSettings = EmptyPointSettings(
      mode: EmptyPointMode.drop,
    );
    return <AreaSeries<ChartData, DateTime>>[
      AreaSeries<ChartData, DateTime>(
          dataSource: chartData,
          color: Colors.yellow.withOpacity(0.1),
          enableTooltip: false,
          markerSettings: markerSettings,
          emptyPointSettings: emptyPointSettings,
          borderColor: Colors.yellow,
          borderWidth: lineWidth,
          xValueMapper: (ChartData sales, _) => sales.xData,
          yValueMapper: (ChartData sales, _) => sales.yData)
    ];
  }

  Widget popularArtistWidget() {
    var band = provider.getPopularBand();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: CColors.statisticsBgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingWidget(
            text: "Popular Artist",
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  band?.bandName ?? "",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeights.medium,
                    fontSize: 16,
                  ),
                ),
              ),
              const Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image(
                    image: NetworkImage(
                      Constants.demoCoverImage,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget popularArtistPerGenreWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding + 30,
        vertical: 10,
      ),
      decoration: const BoxDecoration(
        color: CColors.statisticsBgColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingWidget(
            text: "Popular Artist Per Genre",
          ),
          const SizedBox(
            height: 20,
          ),
          GridView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 60,
              mainAxisSpacing: 10,
            ),
            children: [
              for (var entry in provider.getPopularArtistByGenre().entries) ...[
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: Image(
                              image: NetworkImage(
                                Constants.demoCoverImage,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 10,
                            child: Text(
                              entry.key,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      entry.value.bandName!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeights.semiBold,
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget chartDescriptionWidget() {
    var style = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeights.medium,
      fontSize: 16,
    );
    return Row(
      children: [
        Expanded(
          child: Text(
            "X-Time period",
            textAlign: TextAlign.center,
            style: style,
          ),
        ),
        Expanded(
          child: Text("Y-Count", textAlign: TextAlign.center, style: style),
        ),
      ],
    );
  }
}

class PieData {
  PieData(this.xData, this.yData, [this.text = ""]);

  final String xData;
  final num yData;
  final String text;
}

class ChartData {
  ChartData(this.xData, this.yData);

  final DateTime xData;
  final num yData;
}
