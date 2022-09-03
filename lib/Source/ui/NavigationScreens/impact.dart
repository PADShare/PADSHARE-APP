import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/widgets/customTopTabsbar.dart';
import 'package:padshare/main.dart';

class Impact extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          title: Center(child: new Text("Impact",style: GoogleFonts.roboto(color: Color(0xff6C1682),))),

          leading: new FlatButton(onPressed: (){
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => new NewsFeed(selectedId: 0,))
            );
            RestartWidget.restartApp(context);
          }, child: new Icon(Icons.arrow_back_ios,color: Color(0xff6C1682),)),
          // title: new Text("Profile", style: GoogleFonts.roboto(color: Color(0xff6C1682), fontSize: 18, fontWeight: FontWeight.w600),),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_)=> null)
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right:13.0),
                child: Icon(Icons.more_vert_outlined, color:Color(0xff6C1682),),
              ),
            )
          ],
        ),
      backgroundColor: Color(0xffF4F6FE),
      body: new Column(
        children: [
          new Container(
              height: 450,
              child:  new CustomTopTabsBar()
          ),
        ],
      )
    );
  }
}