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
    return Consumer<DataProvider>(
      builder: (context, provider, child) {
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
      }
    );
  }

  Widget usersWidget() {
    List<_PieData> pieData = [
      _PieData(
        "",
        provider.users.where((element) => element.isBand).length,
      ),
      _PieData(
        "",
        provider.users.where((element) => !element.isBand).length,
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
                ], series: <PieSeries<_PieData, String>>[
                  PieSeries<_PieData, String>(
                      radius: "90.0",
                      explode: false,
                      dataSource: pieData,
                      xValueMapper: (_PieData data, _) => data.xData,
                      yValueMapper: (_PieData data, _) => data.yData,
                      dataLabelMapper: (_PieData data, _) => data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: false)),
                ]),
              ),
              Expanded(
                child: Column(
                  children: [
                    pieDetailsWidget("2 Artists", Colors.blue.shade800),
                    pieDetailsWidget("10 Listeners", Colors.blue),
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
    List<_ChartData> chartData = [
      _ChartData(DateTime(2022, 8), 1),
      _ChartData(DateTime(2022, 9), 0),
      _ChartData(DateTime(2022, 10), 0),
      _ChartData(DateTime(2022, 11), 4),
      _ChartData(DateTime(2022, 12), 5),
      _ChartData(DateTime(2023, 1), 2),
      _ChartData(DateTime(2023, 2), 3),
      _ChartData(DateTime(2023, 4), 0),
      _ChartData(DateTime(2023, 5), 1),
      _ChartData(DateTime(2023, 6), 8),
      _ChartData(DateTime(2023, 7), 1),
    ];
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
              series: _getEventsData(chartData),
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

  List<AreaSeries<_ChartData, DateTime>> _getEventsData(
      List<_ChartData> chartData) {
    var lineWidth = 1.0;
    var markerSettings =
        const MarkerSettings(isVisible: true, color: CColors.primary);
    var emptyPointSettings = EmptyPointSettings(
      mode: EmptyPointMode.drop,
    );
    return <AreaSeries<_ChartData, DateTime>>[
      AreaSeries<_ChartData, DateTime>(
          dataSource: chartData,
          color: CColors.primary.withOpacity(0.1),
          enableTooltip: false,
          markerSettings: markerSettings,
          emptyPointSettings: emptyPointSettings,
          borderColor: CColors.primary,
          borderWidth: lineWidth,
          xValueMapper: (_ChartData sales, _) => sales.xData,
          yValueMapper: (_ChartData sales, _) => sales.yData)
    ];
  }

  Widget genrePreferencesWidget() {
    List<_PieData> pieData = [
      _PieData(
        "",
        10,
      ),
      _PieData(
        "",
        10,
      ),
      _PieData(
        "",
        20,
      ),
      _PieData(
        "",
        10,
      ),
      _PieData(
        "",
        10,
      ),
      _PieData(
        "",
        40,
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
                child: SfCircularChart(palette: [
                  Colors.amber,
                  Colors.deepPurple,
                  Colors.pink,
                  Colors.orange,
                  Colors.yellow,
                  Colors.red,
                ], series: <PieSeries<_PieData, String>>[
                  PieSeries<_PieData, String>(
                      radius: "90.0",
                      explode: false,
                      dataSource: pieData,
                      xValueMapper: (_PieData data, _) => data.xData,
                      yValueMapper: (_PieData data, _) => data.yData,
                      dataLabelMapper: (_PieData data, _) => data.text,
                      dataLabelSettings: DataLabelSettings(isVisible: false)),
                ]),
              ),
              Expanded(
                child: Column(
                  children: [

                    pieDetailsWidget(
                      "10% Punk",
                      Colors.amber,
                    ),
                    pieDetailsWidget(
                      "10% Classical",
                      Colors.amber,
                    ),
                    pieDetailsWidget(
                      "20% Pop",
                      Colors.purple,
                    ),
                    pieDetailsWidget(
                      "10% R&B",
                      Colors.pink,
                    ),
                    pieDetailsWidget(
                      "10% Jazz",
                      Colors.orange,
                    ),
                    pieDetailsWidget(
                      "40% Others",
                      Colors.red,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget bandsWidget() {
    List<_ChartData> chartData = [
      _ChartData(DateTime(2023, 2), 1),
      _ChartData(DateTime(2023, 4), 0),
      _ChartData(DateTime(2023, 4), 0),
      _ChartData(DateTime(2023, 5), 1),
      _ChartData(DateTime(2023, 6), 0),
      _ChartData(DateTime(2023, 7), 0),
    ];
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
                minimum: 0,
                maximum: 1,
                majorGridLines: majorGridLines,
                isVisible: true,
              ),
              tooltipBehavior: TooltipBehavior(
                enable: false,
                tooltipPosition: TooltipPosition.pointer,
                activationMode: ActivationMode.singleTap,
              ),
              series: _getBandData(chartData),
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

  List<AreaSeries<_ChartData, DateTime>> _getBandData(
      List<_ChartData> chartData) {
    var lineWidth = 1.0;
    var markerSettings =
        const MarkerSettings(isVisible: true, color: Colors.yellow);
    var emptyPointSettings = EmptyPointSettings(
      mode: EmptyPointMode.drop,
    );
    return <AreaSeries<_ChartData, DateTime>>[
      AreaSeries<_ChartData, DateTime>(
          dataSource: chartData,
          color: Colors.yellow.withOpacity(0.1),
          enableTooltip: false,
          markerSettings: markerSettings,
          emptyPointSettings: emptyPointSettings,
          borderColor: Colors.yellow,
          borderWidth: lineWidth,
          xValueMapper: (_ChartData sales, _) => sales.xData,
          yValueMapper: (_ChartData sales, _) => sales.yData)
    ];
  }

  Widget popularArtistWidget() {
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
                  "Gytes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeights.medium,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image(
                    image: NetworkImage(
                      Constants.demoImage,
                    ),
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
            text: "Popular Artist Per Genre",
          ),
          const SizedBox(
            height: 20,
          ),
          GridView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              for (int i = 0; i < 3; i++) ...[
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        children: [
                          Positioned.fill(
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
                            child: Text("Gytes",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeights.semiBold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    Text("Gytes",
                      style: TextStyle(
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

  Widget chartDescriptionWidget(){
    var style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeights.medium,
      fontSize: 16,
    );
    return Row(
      children: [
        Expanded(child: Text("X-Time period", textAlign: TextAlign.center, style: style,), ),
        Expanded(child: Text("Y-Count", textAlign: TextAlign.center, style: style),),
      ],
    );
  }
}

class _PieData {
  _PieData(this.xData, this.yData, [this.text = ""]);

  final String xData;
  final num yData;
  final String text;
}

class _ChartData {
  _ChartData(this.xData, this.yData);

  final DateTime xData;
  final num yData;
}
