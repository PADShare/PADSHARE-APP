import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:padshare/Source/ui/Charts/weekBarChartWidget/weekBarChartWidget.dart';
import 'package:padshare/Source/utils/Api.dart';

class MonthPage extends StatefulWidget{

  @override
  _MonthPageState createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {

  var loading = true;

  List weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  var weekdayss;

//  getdata()async{
//    List  weekday = await API.getDates();
//    int index = 0;
//    // if (index < weekdays.length - 1) {
//    //   setState(() {
//    //     index++;
//    //
//    //   });
//
//    setState(() {
//
//      weekdayss = weekday;
//    });
//
// }

  void initState() {
      // getdata();
    // TODO: implement initState
    super.initState();
  }




  int index = 0;

  BarChartData data = BarChartData(
    // barGroups: group
  );

  List<BarChartGroupData> group = [];
 List<PieChartSectionData> datas = [
   PieChartSectionData(title: "A", color: Colors.blue),
   PieChartSectionData(title: "B", color: Colors.orange),
   PieChartSectionData(title: "C", color: Colors.red),
   PieChartSectionData(title: "C", color: Colors.green)
 ];


  @override
  Widget build(BuildContext context) {
    // var weekdayss;
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     // Text("Month Page "),
    //
    //     WeekBarChartWidget()

        // PieChart(
        //   PieChartData(
        //     sections: datas,
        //     centerSpaceColor: Colors.blue,
        //     centerSpaceRadius: 5
        //   )
        // )

        // BarChart(
        // data
        // ,
        //   swapAnimationDuration: Duration(milliseconds: 150),
        //     )

        // ElevatedButton(
        //   onPressed: () {
        //     // if (index < weekdayss.length - 1) {
        //     //   setState(() {
        //     //     index++;
        //     //   });
        //     // }
        //   },
        //   child: Text("Next item"),
        // ),
        //
        // ElevatedButton(
        //   onPressed: () {
        //     if (index > 0) {
        //       setState(() {
        //         index--;
        //       });
        //     }
        //   },
        //   child: Text("Back"),
        // ),
    //   ],
    // );
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),

      ),
      color: Color(0xff060647),
      child: new Container(
        height: 100,
        padding: EdgeInsets.only(top: 16),
        child: WeekBarChartWidget(),
      ),
    );
  }

}