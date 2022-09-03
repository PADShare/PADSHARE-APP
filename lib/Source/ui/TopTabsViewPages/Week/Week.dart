import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/utils/Api.dart';

enum Loadpages{
  page_1,
  page_2,
  page_3,
  page_4
}
class WeekPage extends StatefulWidget{
  @override
  _WeekPageState createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  var result;
 API api = API();
var weekday ;
var loading = true;

void loadweekdata()async{

  List weekdays = await API.getDates();
  await Future.delayed(Duration(seconds: 1)).then((value)  {

    setState(() {
      loading = false;
      weekday = weekdays;
    });
  });
  setState(() {
    // weekday = weekday;
  });

}

  usingbeneficiary()async{
     var res = api.gettotalStaticts().then((value){
       print("Reslt");
       print(value);
       setState(() {
         result = value;
       });
     });
  }

  void initState() {
    // TODO: implement initState
    loadweekdata();
    usingbeneficiary();
    super.initState();
  }

int position = 0;



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // return loading ? Center(child: CircularProgressIndicator(),) : new Scaffold(
    return loading ? Center(child: CircularProgressIndicator(),) : new Scaffold(
       backgroundColor: Colors.transparent,
      body:Padding(
        padding: const EdgeInsets.only(top:20),
        child: new Column(
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RaisedButton(
                  color: Colors.transparent,
                  disabledElevation: 0,
                  focusElevation: 0,
                  focusColor: Colors.transparent,
                  autofocus: false,
                  highlightColor: Colors.transparent,
                  highlightElevation: 0,
                  hoverColor: Colors.transparent,
                  hoverElevation: 0,
                  // splashColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: (){
                    API.getDates();
                    if(position > 0){
                      setState(() {
                        position--;
                      });
                    }
                  },
                  elevation: 0,
                  child: Container(
                    width:28,
                    height: 28,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Color(0xff8A8A8C), width: 1, style: BorderStyle.solid)
                    ),
                    child: Icon(Icons.arrow_back_ios_sharp, color:Color(0xff8A8A8C),size: 20,)
                    ),
                ),

                // new Container(
                //   child: new Text("2020, April, 20-26",style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xff8A8A8C))),
                // ),

                new Container(
                  child: new Text(weekday[position].date.toString(),style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xff8A8A8C))),
                ),


                RaisedButton(
                  color: Colors.transparent,
                  disabledElevation: 0,
                  focusElevation: 0,
                  focusColor: Colors.transparent,
                  autofocus: false,
                  highlightColor: Colors.transparent,
                  highlightElevation: 0,
                  hoverColor: Colors.transparent,
                  hoverElevation: 0,
                  // splashColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: (){
                   if(position < weekday.length -1 ){
                     setState(() {
                       position++;
                     });
                   }
                  },
                  elevation: 0,
                  child: Container(
                      width:28,
                      height: 28,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color:  Color(0xff8A8A8C), width: 1, style: BorderStyle.solid)
                      ),
                      child: Icon(Icons.arrow_forward_ios_sharp, size: 20, color: Color(0xff8A8A8C),)
                  ),
                ),
              ],
            ),
           new SizedBox(height: 5,),
            new Container(
              height: 123,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white30,
                    blurRadius: 5
                  )
                ]
              ),
              width:MediaQuery.of(context).size.width * .85,
              alignment: Alignment.center,
              child: Image.asset("assets/images/graph.png", fit: BoxFit.contain,),
              
              
            ),

            new Padding(
              padding: EdgeInsets.only(top: 20, left: 30,right:30, bottom:20),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  new Container(
                    width: MediaQuery.of(context).size.width * .26,
                    height: 52,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 4,
                              offset: Offset(0,4),
                              spreadRadius: 1
                          )
                        ]
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text(result['total_num_girls'].toString(), style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 14, fontWeight: FontWeight.w700),),
                        SizedBox(
                          height: 2,
                        ),
                        new Text("Beneficiaries", style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 7, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                      ],
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width * .26,
                    height: 52,
                    decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 4,
                              offset: Offset(0,4),
                              spreadRadius: 1
                          )
                        ]
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text(result['total_relief_packages'].toString(), style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 14, fontWeight: FontWeight.w700),),
                        SizedBox(
                          height: 2,
                        ),
                        new Text("Total Packages", style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 7, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                      ],
                    ),
                  ),
                  new Container(
                    width: MediaQuery.of(context).size.width * .26,
                    height: 52,
                    decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 4,
                              offset: Offset(0,4),
                              spreadRadius: 1
                          )
                        ]
                    ),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Text(result['total_packages_delivered'].toString(), style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 14, fontWeight: FontWeight.w700),),
                        SizedBox(
                          height: 2,
                        ),
                        new Text("Packages delivered", style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 7, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                      ],
                    ),
                  )
                ],
              ),
            ),

            new Padding(padding: EdgeInsets.only(left: 40, right: 40),
            child: new Container(

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12)
              ),
              width: MediaQuery.of(context).size.width * .85,
              height: 68,
              child: Padding(
                padding: const EdgeInsets.only(top:10,bottom: 10, left:20, right:20),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/activelist.png",fit: BoxFit.contain,),
                    new Container(
                      child:  new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Text("Top up by MM", style: GoogleFonts.roboto(color: Color(0xff000444),
                          fontStyle: FontStyle.normal, fontWeight: FontWeight.normal, fontSize: 10
                          ) ),
                          new Text("2nd/06/2020", style: GoogleFonts.roboto(color: Color(0xff324CFE),
                              fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                          ) ),

                          new Text("12:00pm", style: GoogleFonts.roboto(color: Color(0xff8A8A8C),
                              fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 8
                          ) ),

                        ],
                      ),
                    ),

                    new Text("+ 370,000",style: GoogleFonts.roboto(color: Color(0xff000444),
                  fontStyle: FontStyle.normal, fontWeight: FontWeight.w700, fontSize: 10))
                  ],
                ),
              ),
            ),
            )
          ],
        ),
      )
    );
  }
}

