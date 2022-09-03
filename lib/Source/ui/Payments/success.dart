import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/main.dart';

class Successful extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation == Orientation.landscape;
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NewsFeed()
              )
            );
            RestartWidget.restartApp(context);
          },
          child: Icon(Icons.arrow_back_outlined, color:Color(0xff692CAB), size: 25,),
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 10), child: InkWell(
              onTap: (){

              },
              child: Icon(Icons.more_vert_outlined,color:Color(0xff692CAB), size: 20,)),)
        ],
      ),
      backgroundColor: Color(0xffF4F6FE),
      body: new Padding(
        padding: EdgeInsets.all(20),
      child: SafeArea(
        child: SingleChildScrollView(
          child: new Column(
            children: [
              Center(
                child: new Container(
                  width: MediaQuery.of(context).size.width * .85,
                  height: orientation ? MediaQuery.of(context).size.height * .95 : MediaQuery.of(context).size.height * .50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                     Padding(
                       padding: const EdgeInsets.only(top: 20,bottom: 20),
                       child: new Container(
                         width: 73,
                         height: 73,
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(100),
                           color: Color(0xff16CF8C),
                         ),
                         child: Image.asset("assets/images/tick.png"),
                         // child: SvgPicture.asset("assets/images/tick.svg",  fit: BoxFit.fitWidth,),
                       ),
                     ),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 40,
                          child: Center(child: new Text("Thank you for your  generous DONATION!",textAlign: TextAlign.center, style: GoogleFonts.roboto(color: Color(0xff290E77), fontWeight: FontWeight.w300, fontSize: 16),))),

                      SizedBox(height: 30,),

                      new SvgPicture.asset("assets/images/thumbs.svg")

                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top:30),
                child: Container(
                  height: 46,
                  width: MediaQuery.of(context).size.width * .48,
                  decoration: BoxDecoration(
                    color: Color(0xff692CAB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FlatButton(onPressed: (){

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_)=> NewsFeed()), (Route<dynamic> route) => false
                    );
                  },
                      child: new Text("DONE",style: GoogleFonts.roboto(color: Colors.white,fontSize: 16))),
                ),
              )
            ],
          ),
        ),
      ),
      )
    );
  }
}