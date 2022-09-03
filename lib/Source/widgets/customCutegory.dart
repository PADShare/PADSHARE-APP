import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/customShopPages/padsPage.dart';
import 'package:padshare/Source/ui/customShopPages/painKiller.dart';
import 'package:padshare/Source/ui/customShopPages/soap.dart';
import 'package:padshare/Source/ui/customShopPages/underwear.dart';

class CustomAppCategories extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Theme(
      data: ThemeData(canvasColor: Color(0xFDFEFF)),
      child: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: Container(
              padding: EdgeInsets.only(top: 20, bottom: 2),
              child: new Column(
                children: <Widget>[
                  new TabBar(
                      isScrollable: true,
                      labelColor: Colors.black,
                      indicatorColor: Color(0xff3E4347),
                      unselectedLabelColor: Color(0xff666363),
                      unselectedLabelStyle:GoogleFonts.openSans(fontWeight: FontWeight.w200, fontSize: 11, fontStyle: FontStyle.normal),

                      labelStyle: GoogleFonts.openSans(fontWeight:FontWeight.w600, fontSize: 13, fontStyle: FontStyle.normal),
                      tabs: <Widget>[
                        Tab(text: "Pads",),
                        Tab(text: "Pain Killers",),
                        Tab(text: "UnderWear",),
                        Tab(text: "Soap",),
                      ]),
                      Expanded(
                    flex: 2,
                    child: TabBarView(
                      children: <Widget>[
                        PadsPage(),
                        PainKilllersPage(),
                        UnderWearPage(),
                        SoapPage()
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}