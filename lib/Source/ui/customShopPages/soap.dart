import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoapPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      // body: new Center(
      //   // child: new Text("Soap Page"),
      // ),
      body:Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 160,),
            new Text("Information!", style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Colors.black, fontSize: 25),),
            SizedBox(height: 13,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: new Text("This service is not yet available.Kindly check back later.", textAlign: TextAlign.center, style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 19),),
            ),
          ],
        ),
      ),
    );
  }
}