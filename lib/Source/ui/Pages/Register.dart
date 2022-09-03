import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/OTPScreen.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:intl/intl.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
import 'package:padshare/Source/utils/Notifications/notificationservice.dart';
import 'package:padshare/main.dart';
import 'package:progress_indicators/progress_indicators.dart';
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
 final FirebaseAuth _auth = FirebaseAuth.instance;

class Register extends StatefulWidget{
String _phone;
 Register(this._phone);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _fullname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _Dob = new TextEditingController();
  final TextEditingController _location = new TextEditingController();
  final double circleRadius = 100.0;
  final _formKey = GlobalKey<FormState>();

  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';
  DateTime _selectedDate;
  var storage = FlutterSecureStorage();
  int month;

  int months;

  String newmonth;

  var dateOfBirth;

  String emailValidator(String value){

    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(pattern);

    if(!regExp.hasMatch(value)){

      return "Email format not Valid...";
    }else{

      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FIREBASE_FCM.FCMGetTOKEN();
    FirebaseMessaging.instance.subscribeToTopic("MessagesToSend");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fullname.dispose();
    _email.dispose();
    _Dob.dispose();
    _location.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
     print(widget._phone);
    // TODO: implement build
    return  new Scaffold(
      backgroundColor: Color(0xffF4F6FE),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                   Padding(padding: EdgeInsets.only(top: circleRadius /2),
                   child: new Container(
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.only(
                           topRight: Radius.circular(45),
                           bottomLeft: Radius.circular(45),
                         ),
                         boxShadow:[
                           BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 5,
                               blurRadius: 8,
                               offset: Offset(0,7)
                           )
                         ]
                     ),
                     width: MediaQuery.of(context).size.width * 0.80,
                     height: 471,

                     child: Padding(
                         padding: const EdgeInsets.only(top:20, right:30.0, left: 40),
                         child: new Column(
                           children: [

                             new Padding(padding: const EdgeInsets.only(bottom: 10, top: 50),
                               child: new Text("TELL US ABOUT YOU", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.normal),),
                             ),

                             new Row(
                               children: <Widget>[
                                 Container(
                                     padding:  EdgeInsets.only(left: 3),
                                     width: 20,
                                     child: SvgPicture.asset("assets/images/person.svg")
                                 ) ,

                                 Container(
                                     width: MediaQuery.of(context).size.width * 0.50,
                                     child: new TextFormField(
                                       controller: _fullname,
                                       enabled: !isLoading,
                                       validator: (value){
                                           if(value.isEmpty){
                                             return "please provide your Names..";
                                           }
                                           return null;
                                           },
                                       style: GoogleFonts.openSans(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w600),
                                       decoration: InputDecoration(
                                         hintText: "Full Name",

                                         hintStyle: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 17, fontWeight: FontWeight.w200),
                                         contentPadding: const EdgeInsets.only(top: 5,left: 15,right: 10, bottom: 5),),

                                     )
                                 ),


                               ],
                             ),
                             SizedBox(height: 15,),
                             new Row(
                               children: <Widget>[
                                 Container(
                                     padding:  EdgeInsets.only(left: 3),
                                     width: 20,
                                     child: SvgPicture.asset("assets/images/email.svg")
                                 ) ,

                                 Container(
                                     width: MediaQuery.of(context).size.width * 0.50,
                                     child: new TextFormField(
                                       controller: _email,
                                       enabled: !isLoading,
                                       validator: emailValidator,
                                       style: GoogleFonts.openSans(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w600),
                                       decoration: InputDecoration(
                                         hintText: "Email address",
                                         errorStyle: TextStyle(color: Colors.red, fontSize: 10),
                                         hintStyle: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 17, fontWeight: FontWeight.w200),
                                         contentPadding: const EdgeInsets.only(top: 5,left: 15,right: 10, bottom: 5),),

                                     )
                                 ),


                               ],
                             ),
                             SizedBox(height: 15,),
                             new Row(
                               children: <Widget>[
                                 Container(
                                     padding:  EdgeInsets.only(left: 3),
                                     width: 20,
                                     child: SvgPicture.asset("assets/images/DateOf_birth.svg")
                                 ) ,

                                 Container(
                                     width: MediaQuery.of(context).size.width * 0.50,
                                     child: new TextFormField(
                                       controller: _Dob,
                                       enabled: !isLoading,
                                       validator: (value){
                                         if(value.isEmpty){
                                           return "please select Date..";
                                         }
                                         return null;
                                       },
                                       onTap: (){
                                         _selectDate(context);
                                       },
                                       style: GoogleFonts.openSans(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w600),
                                       decoration: InputDecoration(
                                         hintText: "Date of birth",
                                         hintStyle: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 17, fontWeight: FontWeight.w200),
                                         contentPadding: const EdgeInsets.only(top: 5,left: 15,right: 10, bottom: 5),),

                                     )
                                 ),


                               ],
                             ),
                             SizedBox(height: 15,),
                             new Row(
                               children: <Widget>[
                                 Container(
                                     padding:  EdgeInsets.only(left: 3),
                                     width: 20,
                                     child: SvgPicture.asset("assets/images/home.svg")
                                 ) ,

                                 Container(
                                     width: MediaQuery.of(context).size.width * 0.50,
                                       child: new TextFormField(
                                       controller: _location,
                                       enabled: !isLoading,
                                       style: GoogleFonts.openSans(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w600),
                                       decoration: InputDecoration(
                                         hintText: "Location",
                                         hintStyle: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 17, fontWeight: FontWeight.w200),
                                         contentPadding: const EdgeInsets.only(top: 5,left: 15,right: 10, bottom: 5),),

                                     )
                                 ),


                               ],
                             ),
                             SizedBox(height: 50,),
                             Container(
                               width: 60,
                               height: 60,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(100),
                                 color: Color(0xff16CF8C),
                               ),
                               child: new FlatButton(
                                   onPressed: (){
                                     if(!isLoading){
                                     //  CircularProgressIndicator();
                                       // SignUpUser();
                                       //
                                       if(_formKey.currentState.validate()){
                                         _onLoading();
                                       }
                                       setState(() {
                                         isRegister = false;
                                         isOTPScreen = true;
                                       });
                                     }

                                   },
                                   child: new Icon(Icons.arrow_forward, color: Colors.white70,)),
                             )
                           ],
                         )
                     ),

                   ),

                   ),

                    Container(
                      width: circleRadius,
                      height: circleRadius,

                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: ShapeDecoration(
                            shape: CircleBorder(),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/logo.png")
                            )
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  _selectDate(BuildContext context ) async{

    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1970),
        lastDate: DateTime(2030),

        builder: (BuildContext context, Widget child){
          return  Theme(
              data: ThemeData.dark().copyWith(
                colorScheme: ColorScheme.dark(
                    primary: Colors.deepPurple,
                    onPrimary: Colors.white,
                    surface: Colors.blueGrey,
                    onSurface: Colors.white
                ),
                dialogBackgroundColor: Colors.blue[500],
              ),
              child: child);
        });

    if(newSelectedDate != null){
      _selectedDate = newSelectedDate;
      _Dob
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _Dob.text.length,
            affinity: TextAffinity.upstream
        ));
    }

  }


Future<void> SignUpUser() async{
   var token = await storage.read(key: "token");
   var id = Random();
   var notificationid = id.nextInt(30000);

  debugPrint("debug 1");
  setState((){
    isLoading = true;
  });

  debugPrint("ISAAC TExt 2");

  if(_formKey.currentState.validate()){
    var phoneNumber = widget._phone;
    dateOfBirth =   DateFunction(_Dob.text);
    debugPrint("phone" + phoneNumber);

    debugPrint('debug 3 ${_email}');

    await  _auth.currentUser.updateDisplayName(
      _fullname.text,
    );
    await  _auth.currentUser.updateEmail(
      _email.text,
    );
    await _firestore
        .collection("users")
        .doc(_auth.currentUser.uid)
        .set({
      'name': _fullname.text.trim(),
      'cellnumber': _auth.currentUser.phoneNumber,
      'email' : _email.text.trim(),
      'DOB': dateOfBirth,
      'location':_location.text.trim(),
      'uid':_auth.currentUser.uid,
      'isSelected': false,
      'isRequest': false,
      'user_token': token,
    }, SetOptions(merge: true))
        .then((value) async{

          FIREBASE_FCM.FCMSAVETOKEN(token);

          // await  _auth.currentUser.updateEmail(_email.text.trim());
       Navigator.pop(context);
      setState((){
        isLoading = false;
        isRegister = false;
        isOTPScreen = false;

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 0,))
            , (route) => false
        );

        // RestartWidget.restartApp(context);

        // Navigator.of(context,rootNavigator: true).pop();
        // RestartWidget.restartApp(context);

      });

    })
        .catchError((onError) =>{
      debugPrint('Error saving user' + onError.toString())
    });


    NotificationService().showNotification(notificationid, "New User", "a member has joined us", 3);


  }

}

  DateFunction(String dateString) {

    DateFormat format = new DateFormat("MMM dd, yyyy");

    var formattedDate = format.parse(dateString);
    DateFormat date = DateFormat("M-dd-yyyy");
    int day = formattedDate.day;
    month = formattedDate.month;
    int year = formattedDate.year;
    if (month < 10) {
      newmonth = "0" + "$month";
    } else {
      newmonth = "$month";
    }
    var dateTime = "${newmonth} ${day},${year}";


    return dateTime;
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
              new Text("Registering", style: GoogleFonts.roboto(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
       // Navigator.pop(context); //pop dialog
      // _login();
      // SignUpUser();
       SignUpUser();
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

}