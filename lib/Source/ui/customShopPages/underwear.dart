import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UnderWearPage extends StatefulWidget{

  @override
  State<UnderWearPage> createState() => _UnderWearPageState();
}

class _UnderWearPageState extends State<UnderWearPage> {
  // displayLoading(){
  //   return  Future.delayed(Duration.zero, () => showDiaLogs());
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // displayLoading();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Padding(
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

  Widget showDiaLogs(){

    AlertDialog alertDialog = AlertDialog(
      title: Text("Information"),
      content: Text("This service is not yet available.Kindly check back later."),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);

            // Navigator.push(context, MaterialPageRoute(builder: (_)=>ManageAddress()));
          },
        )
      ],
    );

    showDialog(context: context, builder: (_)=> alertDialog);
  }
}