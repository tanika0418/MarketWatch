import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market_watch/utils/Responsive.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../providers/DataProvider.dart';
import '../utils/Constants.dart';

class BuildChart extends StatefulWidget {
  const BuildChart({
    Key? key,
    required this.values,
    required this.isUp,
  }) : super(key: key);

  final Map<String, int> values;
  final bool isUp;

  @override
  State<BuildChart> createState() => _BuildChartState();
}

class _BuildChartState extends State<BuildChart> {
  int? _currentYear;
  final List<StockData> chartData = [];

  List<StockData> getChartData(int yearController, BuildContext context) {
    int currentYear = yearController % 10000;
    if (_currentYear == currentYear && !chartData.isEmpty) {
      return chartData;
    }
    chartData.clear();
    int startYear = (yearController / 10000).round();
    int countYear = startYear;
    int limit = (Responsive.isMobile(context) ? 5 : 8);
    if (currentYear - startYear + 1 > limit) {
      countYear = currentYear - limit + 1;
    }
    while (countYear <= currentYear) {
      chartData.add(
        StockData(
          countYear as double,
          widget.values[countYear.toString()] as double,
        ),
      );
      countYear++;
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    int? yearController = Provider.of<DataProvider>(context).yearController;
    return SfCartesianChart(
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries>[
        AreaSeries<StockData, double>(
          animationDuration: 2000,
          gradient: widget.isUp == true ? gradientGreen : gradientRed,
          name: "Stocks",
          dataSource: getChartData(yearController!, context),
          xValueMapper: (StockData sales, _) => sales.year,
          yValueMapper: (StockData sales, _) => sales.value,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          markerSettings: MarkerSettings(
            isVisible: true,
            borderColor: widget.isUp == true ? Colors.green : Colors.red,
          ),
          enableTooltip: true,
        ),
      ],
      primaryXAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
          labelFormat: '{value}',
          numberFormat: NumberFormat.simpleCurrency(decimalDigits: 0)),
    );
  }
}

class StockData {
  StockData(this.year, this.value);
  final double year;
  final double value;
}
