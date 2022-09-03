import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/Pages/Register.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
import 'package:padshare/Source/widgets/ScreenBg.dart';
import 'package:padshare/main.dart';
import 'package:sms_autofill/sms_autofill.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class OTPScreen extends StatefulWidget{
  String _phone;
  OTPScreen(this._phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _smsConroller = new TextEditingController();
  String _vericationId;
  final _formKey = GlobalKey<FormState>();
  final SmsAutoFill _autoFill =  SmsAutoFill();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';
  var storage = FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    OTPVerification();
    super.initState();
    FIREBASE_FCM.FCMGetTOKEN();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _smsConroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print(widget._phone);
    return new Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: new CustomPaint(
          painter: ScreenPaint(),
          child: Stack(
            children: [
              Positioned(
                width:MediaQuery.of(context).size.width,
                height: 230,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: new Container(
                    width:100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                        ),
                        borderRadius: BorderRadius.circular(100)
                    ),
                  ),
                ),
              ),

              new Positioned(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top:8.0, bottom: 30,),
                      // child: Center(child: new Text("Verify", style: GoogleFonts.roboto(fontSize: 26, color: Color(0xff666363),fontWeight: FontWeight.w400),)),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 60,
                      height: 156,
                      child: Center(
                        child: Form(
                          key: _formKey,

                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [

                              Padding(

                                padding: const EdgeInsets.only(right: 100/4),
                                child:  new Container(
                                  width: MediaQuery.of(context).size.width * 0.80,
                                  height: 131,
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

                                  child: !isLoading
                                      ? Container(
                                    margin: const EdgeInsets.only(right: 50, left: 15),
                                    width: MediaQuery.of(context).size.width * 0.30,
                                    child: Center(
                                      child: new TextFormField(
                                        controller: _smsConroller,
                                        initialValue: null,
                                        autofocus: true,
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        validator: (value){
                                          if(value.isEmpty){
                                            return "Please enter OTP Code";
                                          }
                                          return null;
                                        },
                                        style: GoogleFonts.openSans(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w600),
                                        decoration: InputDecoration(
                                          hintText: "Enter verification code",
                                          hintStyle: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 17, fontWeight: FontWeight.w200),
                                          contentPadding: const EdgeInsets.only(left: 15,right: 30),
                                        ),

                                      ),
                                    ),
                                  )
                                      : Container()
                                  ,

                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: Colors.white,
                                ),
                                child:  Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: new FloatingActionButton(
                                      backgroundColor: Color(0xff16CF8C),
                                      onPressed: ()async{
                                        var token = await storage.read(key: "token");
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });

                                          try {
                                            await _auth
                                                .signInWithCredential(
                                                PhoneAuthProvider.credential(
                                                    verificationId:
                                                    verificationCode,
                                                    smsCode:
                                                    _smsConroller.text))
                                                .then((value) async {
                                              if (value.user != null) {
                                                print('User now has Access');
                                                // await signInWithPhoneNumber();
                                                var isValidUser = false;
                                                // await _registerUser();
                                                var number = widget._phone;

                                                try{

                                                  await _firestore
                                                      .collection('users')
                                                      .where('cellnumber', isEqualTo: number)
                                                      .get()
                                                      .then((result){
                                                    if(result.docs.length >0){
                                                      isValidUser = true;
                                                    }
                                                  });

                                                  if(isValidUser){
                                                     var token = await storage.read(key: 'token');
                                                    await _firestore.collection('UsersTokens').doc(_auth.currentUser.uid).update({
                                                      'user_token': token
                                                    });
                                                    await FIREBASE_FCM.FCMUPDATETOKEN(token);

                                                    Navigator.pushAndRemoveUntil(context,
                                                        MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 0,))
                                                        , (route) => false);
                                                    // RestartWidget.restartApp(context);

                                                  }else{

                                                    Navigator.pushAndRemoveUntil(context,
                                                        MaterialPageRoute(builder: (_)=> Register(widget._phone))
                                                        , (route) => false
                                                    );
                                                  }

                                                }catch(e){
                                                  print(e);
                                                }


                                                // _registerUser();
                                              }
                                            });
                                          } catch (e) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            FocusScope.of(context).unfocus();
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                                content: new Text(
                                                    'Invalid Verification code')));
                                          }
                                        }

                                        },
                                      child: Icon(Icons.arrow_forward_rounded, size:30,),
                                    )
                                ),
                              ),



                            ],
                          ),
                        ),
                      ),



                    ),
                    Center(
                      child: Container(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              child: Text(
                                  !isLoading
                                      ? "Enter OTP SMS Please wait..."
                                      : "Sending OTP code SMS...",
                                  style: GoogleFonts.roboto(fontSize: 9, ),
                                  textAlign: TextAlign.center))),
                    ),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }



  Future<void> OTPVerification() async {
    var isValidUser = false;

    debugPrint("debug 1");
    setState(() {
      isLoading = true;
    });

    debugPrint("ISAAC TExt 2");

    var phoneNumber = widget._phone;
    debugPrint("phone" + phoneNumber);
    var verifyPhonenumber = _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        debugPrint("OTP 2");
        _auth.signInWithCredential(credential).then((user) async {
          debugPrint('debug RESP');
          if (user.user != null)
            {
              debugPrint('debug OTP 3');
              debugPrint('user loggedIn OTP XXXXXX');

              await _firestore
                  .collection('users')
            .where('cellnumber', isEqualTo: phoneNumber)
            .get()
            .then((result){
        if(result.docs.length >0){

        setState(() {
        isValidUser = true;
        });
        }
        });
              if(isValidUser){
                Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => NewsFeed(selectedId: 0,)),
                            (route) => false);
                // RestartWidget.restartApp(context);
              }else{

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Register("")),
                        (route) => false);
              }


              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => Register("")),
              //         (route) => false)
            }
        });
      },
      verificationFailed: (FirebaseAuthException error) {
        debugPrint('debug 4');
        debugPrint('ISAA FirebaseError OTP ' + error.toString());
        setState(() {
          isLoading = false;
        });
      },
      codeSent: (String verificationId, int resendToken) {
        debugPrint('debug 5');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
          // Navigator.pushAndRemoveUntil(context,
          //   MaterialPageRoute(builder: (_)=> OTPScreen(phoneNumber))
          //   ,(route) => false
          // );
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        debugPrint('debug 6');
        setState(() {
          isLoading = false;
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
    debugPrint('debug 7');
    await verifyPhonenumber;
    debugPrint('debug 8');
  }
}