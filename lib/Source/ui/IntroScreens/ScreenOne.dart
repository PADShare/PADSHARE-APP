import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/Register.dart';
import 'package:padshare/Source/ui/Pages/login.dart';
import 'package:progress_indicators/progress_indicators.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class ScreenOne extends StatefulWidget{

  @override
  _ScreenOneState createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {

 var isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/screen1.png"),
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
                  child:  new Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Color(0xff16CF8C)
                    ),
                    width: 300,
                    height: 42,
                    child: new FlatButton(onPressed: (){

                       _onLoading();
                       //print()

                      // Navigator.of(context).pushAndRemoveUntil(
                      //             MaterialPageRoute(builder: (_)=> CreateTeams()), (Route<dynamic> route) => false
                      //           );

                      // if(_auth.currentUser != null){
                      //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> NewsFeed()),
                      //           (Route<dynamic> route) => false
                      //
                      //   );
                      //
                      // } else{
                      // Navigator.of(context).pushAndRemoveUntil(
                      //         MaterialPageRoute(builder: (_)=> Register("")), (Route<dynamic> route) => false
                      //       );}
                          //
                      // showProgressDialog(context);
                      // showProgressDialog(context);
                      //     Navigator.of(context).push(
                      //           MaterialPageRoute(builder: (_)=> Login())
                      //       );
                      // if(_auth.currentUser != null){
                      //
                      //    // Navigator.of(context, rootNavigator: true).pop();
                      //   Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (_)=> Login()), (Route<dynamic> route) => false
                      //   );
                      // //
                      // } else{
                      //    // Navigator.of(context, rootNavigator: true).pop();
                      //   // Navigator.of(context).pushReplacement(
                      //   //     MaterialPageRoute(builder: (_) => Login()));
                      //
                      //   Navigator.of(context).pushAndRemoveUntil(
                      //       MaterialPageRoute(builder: (_)=> Login()), (Route<dynamic> route) => false
                      //   );
                      //
                      // }


                    }, child: new Text("Start donating now",
                      style: GoogleFonts.roboto(fontSize: 12, color: Colors.white, fontWeight: FontWeight.normal),),),
                  ))
            ],
          ),
        )
      ),
    );
  }

 void _onLoading() {
   showDialog(
     context: context,
     barrierDismissible: false,
     builder: (BuildContext context) {
       // return showProgressDialog(context);
       return Dialog(
        backgroundColor: Colors.transparent,
         elevation: 0,
         child: new Column(
           mainAxisSize: MainAxisSize.min,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
             progressIndictor(),
             SizedBox(height: 5,),
             new Text("Loading", style: GoogleFonts.roboto(color: Colors.white, fontSize: 12)),
           ],
         ),
       );
     },
   );
   new Future.delayed(new Duration(seconds: 3), () {
     // Navigator.pop(context); //pop dialog
     // _login();
     // SignUpUser();
     // if(_auth.currentUser != null){
     //   Navigator.pop(context);
     //   Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> NewsFeed()),
     //           (Route<dynamic> route) => false
     //
     //   );

     // } else{
     Navigator.pop(context);
     Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(builder: (_)=> Login()), (Route<dynamic> route) => false
           );
   // }
     //

   });
 }

  Widget progressIndictor() {

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // new Text('Loading please wait...', style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),),
        JumpingDotsProgressIndicator(
          fontSize: 44.0,
          color: Colors.white,

        ),
      ],
      // )
    );
  }

  showProgressDialog(BuildContext context){

    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        color: Colors.transparent,
        child: Center(

            child: progressIndictor()
        ),
      ),


    );
     showDialog(
        barrierColor: Colors.white.withOpacity(0),
        barrierDismissible: false,
        context: context, builder: (BuildContext context){
      return WillPopScope(child: alert, onWillPop: (){},);
    }) ;
  }

  Future getUser()async{
    _firestore.collection("users").get().then((QuerySnapshot querySnapshot){

      print("USER");
      print(querySnapshot.size);

    } );
  }
}