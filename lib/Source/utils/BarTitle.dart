
 import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:padshare/Source/utils/dummyData.dart';

class  BarTitle {
  static SideTitles getTopBottomTitles() => SideTitles(
    showTitles: true,
    getTextStyles: (value) => const TextStyle(color: Colors.white, fontSize: 10),
    getTitles: (double id) => DummyData.barData.firstWhere((element) => element.id == id.toInt())
      .name,
  );

  static SideTitles getSideTitles() => SideTitles(
    showTitles: true,
    getTextStyles: (value) => const TextStyle(color: Colors.white, fontSize: 10),
    interval: DummyData.interval.toDouble(),
    getTitles: (double value) => '${value.toInt()}k'
  );
 }