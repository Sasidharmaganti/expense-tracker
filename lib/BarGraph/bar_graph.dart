import 'package:expense_tracker/BarGraph/individual_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyBarGraph extends StatefulWidget {
  final List<double> monthlySummary;
  final int startMonth;

  const MyBarGraph({
    super.key,
    required this.monthlySummary,
    required this.startMonth,
  });

  @override
  State<MyBarGraph> createState() => _MyBarGraphState();
}

class _MyBarGraphState extends State<MyBarGraph> {

  List<IndividualBar> barData =[];

  @override

  void initState() {

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp)=> scrollToEnd());

  }
  void initializedBarData(){
    barData = List.generate(
        widget.monthlySummary.length,
            (index)=> IndividualBar(
          x: index,
          y: widget.monthlySummary[index],
        )
    );
  }

  double calculateMax(){
    double max = 500;
    widget.monthlySummary.sort();
    max= widget.monthlySummary.last*1.05;
    if(max<500){
      return 500;
    }
    return max;
  }

  final ScrollController _scrollController = ScrollController();
  void scrollToEnd(){
    _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 1),
        curve: Curves.fastOutSlowIn
    );
  }
  @override
  Widget build(BuildContext context) {

    initializedBarData();

    double barWidth = 20;
    double spaceBetweenBars = 15;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: barWidth* barData.length + spaceBetweenBars*(barData.length-1),
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: calculateMax(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: const FlTitlesData(
                show: true,
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getBottomTitles,
                      reservedSize: 24
                  ),
                ),
              ),
              barGroups:  barData.map(
                    (data)=> BarChartGroupData(
                  x: data.x,
                  barRods:[
                    BarChartRodData(
                      toY: data.y,
                      width: barWidth,
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey.shade800,
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: calculateMax(),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ).toList(),
              alignment: BarChartAlignment.center,
              groupsSpace: spaceBetweenBars,
            ),
          ),
        ),
      ),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const textStyle = TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    fontSize: 12,
  );

  // Get the current month index (0-11) based on the current date
  int currentMonthIndex = DateTime.now().month - 1;

  // Define an array of month initials
  List<String> monthInitials = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  // Calculate the index of the month to display
  int displayMonthIndex = (currentMonthIndex + value.toInt()) % 12;

  // Get the corresponding month initial
  String text = monthInitials[displayMonthIndex];

  return SideTitleWidget(
    child: Text(
      text,
      style: textStyle,
    ),
    axisSide: meta.axisSide,
  );
}
