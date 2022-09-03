import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:padshare/Source/utils/BarTitle.dart';
import 'package:padshare/Source/utils/dummyData.dart';

class WeekBarChartWidget extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
        color: Colors.black12,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.center,
            maxY: 30,
            minY: 0,
            groupsSpace: 20,
            barTouchData: BarTouchData(enabled: true),
            titlesData: FlTitlesData(
              bottomTitles: BarTitle.getTopBottomTitles(),
              leftTitles: BarTitle.getSideTitles()
            ),
            barGroups: DummyData.barData.map((e) => BarChartGroupData(
              x: e.id,

              barRods:[
                BarChartRodData(
                  y: e.y,
                  width: 15,
                  colors: [e.color],
                  borderRadius: e.y > 0 ? BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6)
                  ) :BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6)
                  )
                ),
                // BarChartRodData(
                //     y: e.y,
                //     width: 15,
                //     colors: [e.color],
                //     borderRadius: BorderRadius.only(
                //         topLeft: Radius.circular(6),
                //         topRight: Radius.circular(6)
                //     )
                // ),
              ]
            )).toList()
          )
        ),
      );

  }
}