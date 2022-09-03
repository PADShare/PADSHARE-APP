import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/TopTabsViewPages/Month/MonthPage.dart';
import 'package:padshare/Source/ui/TopTabsViewPages/Week/Week.dart';
import 'package:padshare/Source/ui/TopTabsViewPages/Year/Year.dart';

class CustomTopTabsBar extends StatefulWidget{

  @override
  _CustomTopTabsBarState createState() => _CustomTopTabsBarState();
}

class _CustomTopTabsBarState extends State<CustomTopTabsBar>  { //with SingleTickerProviderStateMixin
  bool is_selected = true;

  TabController _controller;


  @override
  void initState() {
    // TODO: implement initState
    // _controller = TabController(length: 3, vsync: this);
    // _controller.addListener(() {
    //   setState(() {
    //
    //   });
    //   print("am CHANGED..");

    // });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    double orjWidth = MediaQuery.of(context).size.width;
    double cameraWidth = orjWidth/16;
    double tabsWidth = (orjWidth - cameraWidth)/3;
    // TODO: implement build
    return DefaultTabController(
      length: 3,

      child: new Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: 20),
          child: new Container(
            child:  new Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right:15, left: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color: Color(0xffE9E9EB),
                        border: Border.all(color: Colors.white, width: 1, style: BorderStyle.solid)
                    ),
                    child: new TabBar(
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      isScrollable: true,
                      onTap: (value){

                        setState(() {
                          is_selected = false;
                          print("AM CHANGED...");
                        });

                      },
                      indicatorPadding: EdgeInsets.only(top: 5, bottom: 5,right: 40, left:10),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Colors.white),
                      labelColor: Color(0xff6C1682) ,
                      unselectedLabelColor: Color(0xff94989B),
                      unselectedLabelStyle: GoogleFonts.roboto(color: Color(0xff94989B), fontSize: 12, fontWeight: FontWeight.w400),

                      labelStyle: GoogleFonts.roboto(color: Color(0xff6C1682), fontSize: 12, fontWeight: FontWeight.w600),


                      tabs: [
                        Container(
                          margin: EdgeInsets.all(4),
                          width: tabsWidth,
                          child: Transform.translate(
                              offset: Offset(-16, 0),
                              child: new Tab(text:"Week")),
                          decoration: BoxDecoration(
                              border:  Border(
                                  right: BorderSide(
                                      color: Color(0xff94989B),
                                      width: 1
                                  )
                              )
                          ),

                        ),

                        Container(
                            margin: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                      color: Color(0xff94989B),
                                      width: 1,
                                    )
                                )
                            ),
                            width: tabsWidth,
                            child: Transform.translate(
                                offset: Offset(-18, 0),
                                child: new Tab(text:"Month"))),
                        Container(
                            margin: EdgeInsets.all(4),
                            width: tabsWidth,
                            child: Transform.translate(
                                offset: Offset(-18, 0),
                                child: new Tab(text:"Year"))),

                      ],
                    ),
                  ),
                ),

                Expanded(flex: 2,
                  child: TabBarView(
                    children: [
                      // new Container(),
                      // new Container(),
                      // new Container()
                      new WeekPage(),
                      new MonthPage(),
                      new YearPage()
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}