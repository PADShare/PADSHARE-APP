import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/login.dart';


class ScreenTwo extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/screen2.png"),
          fit: BoxFit.cover
        )
      ),
   child: Padding(
     padding: const EdgeInsets.all(20.0),
     child: new Stack(
       children: [
         Positioned(
           bottom:200,
           child: Container(

             width: MediaQuery.of(context).size.width,child: new Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               new Text("We’re in this together", style: GoogleFonts.roboto(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
               SizedBox(height: 10,),
               new Text("We can be the generation that ends menstraual shame",style: GoogleFonts.roboto(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),),
             ],
           ),
           ),
         ),

         Positioned(
             bottom:50,
             left: 0,
             right: 0,
             child: new Container(

               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(12),
                   color: Color(0xff16CF8C)
               ),
               width: 300,
               height: 42,
               child: new FlatButton(onPressed: (){

                 Navigator.of(context).pushReplacement(
                     MaterialPageRoute(builder: (_) => Login()));

               }, child: new Text("Start donating now",
                 style: GoogleFonts.roboto(fontSize: 12, color: Colors.white, fontWeight: FontWeight.normal),),),
             ))
       ],
     ),
   ),
    );
  }
}