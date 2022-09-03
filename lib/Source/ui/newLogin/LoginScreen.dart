import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/ui/tabs/tabs_page.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget{


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
final TextEditingController _phoneController = TextEditingController();

final TextEditingController _smsController = TextEditingController();

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

var currentState = MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  String verificationCode;

  var showloading = false;
  var storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      key: _scaffoldKey,
      body: showloading ? Center(child: CircularProgressIndicator(),) :  currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE ?
          getPhoneNumberScreen() : getOTPSmsNumberScreen()
    );
  }

  getPhoneNumberScreen(){
   return new Column(
     children: [
       Spacer(),
       new TextField(
         controller: _phoneController,
         decoration: InputDecoration(
           hintText: "Phone Number"
         ),
       ),
       SizedBox(height:10),
       FlatButton(onPressed: ()async{

             setState(() {
               showloading = true;
             });


         await  _auth.verifyPhoneNumber(
             phoneNumber: _phoneController.text.toString().trim(),
             verificationCompleted: (phoneAuthCredential)async{
                 setState(() {
                   showloading = false;
                 });

                 signInWithPhoneAuthCredentials(phoneAuthCredential);
             },
             verificationFailed: (verificationFailed)async{
               setState(() {
                 showloading = false;
               });
               // ${verificationFailed.message}
              _scaffoldKey.currentState.showSnackBar(SnackBar(content: new Text("VerificationFailed::${verificationFailed.message}" )));

              debugPrint("ERROR PHONE VERIFY::::: ${verificationFailed.message}");
             },
             codeSent: (verificationId, resendingToken)async{

             setState(() {
               showloading = false;
               currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
               verificationCode = verificationId;

             });
             },
             codeAutoRetrievalTimeout:(verificationId)async{

             });

        // await  _auth.verifyPhoneNumber(
        //      phoneNumber: _phoneController.text.toString().trim(),
        //      verificationCompleted: (phoneAuthCredential)async{
        //
        //      },
        //      verificationFailed: (verificationFailed)async{
        //
        //      },
        //      codeSent: (verificationId, resendingToken)async{
        //
        //      },
        //      codeAutoRetrievalTimeout:(verificationId)async{
        //
        //      });

       }, child: new Text("SEND")),
       Spacer(),
     ],
   );
  }

  getOTPSmsNumberScreen(){
    return new Column(
      children: [
        Spacer(),
        new TextFormField(
          controller: _smsController,
          initialValue: null,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(
              hintText: "Enter OTP SMS",
          ),
        ),
        SizedBox(height:10),
        FlatButton(onPressed: ()async{
          PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
              verificationId: verificationCode,
              smsCode: _smsController.toString().trim());
          print("CODE SENT::: $verificationCode");
          signInWithPhoneAuthCredentials(phoneAuthCredential);

        }, child: new Text("Verify")),
        Spacer(),
      ],
    );
  }

signInWithPhoneAuthCredentials(PhoneAuthCredential phoneAuthCredential) async{

    setState(() {
      showloading = true;
    });

  try{
    final authCredential =  await _auth.signInWithCredential(phoneAuthCredential);
    print("Inside SIgnIN");
    setState(() {
      showloading = false;
    });


    if(authCredential?.user !=null){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 0,)) //NewsFeed())
      );
      // RestartWidget.restartApp(context);
    }
  }on FirebaseAuthException catch(e){
    setState(() {
      showloading = false;
    });
    FocusScope.of(context).unfocus();
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(
        content: new Text(
            'Invalid Verification code :: ${e.message}')));

    // debugPrint("Invalid Verification code");
    debugPrint("Invalid Verification code:::${e}");
  }
}

}