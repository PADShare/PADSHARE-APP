import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/Pages/Register.dart';
import 'package:padshare/Source/widgets/ScreenBg.dart';
import 'package:sms_autofill/sms_autofill.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class OTPScreen extends StatefulWidget {
  String _phone;
  OTPScreen(this._phone);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {

  final TextEditingController _fullname = new TextEditingController();
  final TextEditingController _email = new TextEditingController();
  final TextEditingController _Dob = new TextEditingController();
  final TextEditingController _location = new TextEditingController();
  final double circleRadius = 100.0;

  final TextEditingController _smsConroller = new TextEditingController();
  String _vericationId;
  final _formKey = GlobalKey<FormState>();
  final SmsAutoFill _autoFill = SmsAutoFill();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var isLoading = false;
  var isResend = false;
  var isRegister = true;
  var isOTPScreen = false;
  var verificationCode = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    OTPVerification();
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
    // print(widget._phone);
    return new Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: new CustomPaint(
          painter: ScreenPaint(),
          child: Stack(
            children: [
              Positioned(
                width: MediaQuery.of(context).size.width,
                height: 230,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: new Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/logo.png"),
                        ),
                        borderRadius: BorderRadius.circular(100)),
                  ),
                ),
              ),
              new Positioned(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8.0,
                        bottom: 30,
                      ),
                      child: Center(
                          child: new Text(
                            "Verify",
                            style: GoogleFonts.roboto(
                                fontSize: 26,
                                color: Color(0xff666363),
                                fontWeight: FontWeight.w400),
                          )),
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
                                padding: const EdgeInsets.only(right: 100 / 4),
                                child: new Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.80,
                                  height: 131,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(45),
                                        bottomLeft: Radius.circular(45),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 5,
                                            blurRadius: 8,
                                            offset: Offset(0, 7))
                                      ]),
                                  child: !isLoading
                                      ? Container(
                                    margin: const EdgeInsets.only(
                                        right: 50, left: 15),
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.30,
                                    child: Center(
                                      child: new TextFormField(
                                        controller: _smsConroller,
                                        initialValue: null,
                                        autofocus: true,
                                        keyboardType:
                                        TextInputType.number,
                                        inputFormatters: <
                                            TextInputFormatter>[
                                          FilteringTextInputFormatter
                                              .digitsOnly
                                        ],
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please enter OTP Code";
                                          }
                                          return null;
                                        },
                                        style: GoogleFonts.openSans(
                                            color: Color(0xff666363),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                        decoration: InputDecoration(
                                          hintText:
                                          "Enter verification code",
                                          hintStyle: GoogleFonts.roboto(
                                              color: Color(0xff666363),
                                              fontSize: 17,
                                              fontWeight:
                                              FontWeight.w200),
                                          contentPadding:
                                          const EdgeInsets.only(
                                              left: 15, right: 30),
                                        ),
                                      ),
                                    ),
                                  )
                                      : Container(),
                                ),
                              ),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: new FloatingActionButton(
                                      backgroundColor: Color(0xff16CF8C),
                                      onPressed: () async {
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
                                                    Navigator.pushAndRemoveUntil(context,
                                                        MaterialPageRoute(builder: (_)=> UserProfile())
                                                        , (route) => false
                                                    );
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
                                      child: Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 30,
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Center(
                    //   child: Container(
                    //       child: Padding(
                    //           padding: const EdgeInsets.symmetric(
                    //               vertical: 10.0, horizontal: 10.0),
                    //           child: Text(
                    //               !isLoading
                    //                   ? "Enter OTP from SMS"
                    //                   : "Sending OTP code SMS",
                    //               style: GoogleFonts.roboto(
                    //                 fontSize: 9,
                    //               ),
                    //               textAlign: TextAlign.center))),
                    // ),
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
        _auth.signInWithCredential(credential).then((user) async => {
          debugPrint('debug RESP'),
          if (user.user != null)
            {
              debugPrint('debug OTP 3'),
              debugPrint('user loggedIn OTP XXXXXX'),
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Register("")),
                      (route) => false)
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

  Future<void> signInWithPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    String _phoneNumber = widget._phone;

    var isValidUser = false;
    var number = _phoneNumber.toString().trim();
    await _firestore
        .collection('user')
        .where('cellnumber', isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.length > 0) {
        isValidUser = true;
      }
    });

    if (isValidUser) {
      var verifyPhoneNumber = _auth.verifyPhoneNumber(
          phoneNumber: number,
          verificationCompleted: (phoneAuthCredential) {
            _auth
                .signInWithCredential(phoneAuthCredential)
                .then((user) async => {
              debugPrint("1st Instance Phone verify"),
              if (user != null)
                {
                  debugPrint("1st Instance Phone verify"),
                  setState(() {
                    isLoading = false;
                  }),
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => UserProfile()))
                }
            });
          },
          verificationFailed: (FirebaseAuthException error) {
            // displaySnackBar("")
            setState(() {
              isLoading = false;
            });
            print("validation Failed please Try again");
          },
          codeSent: (verificationCode, [forceResendingToken]) {
            setState(() {
              isLoading = false;
              _vericationId = verificationCode;
            });

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => OTPScreen(_phoneNumber)));
          },
          codeAutoRetrievalTimeout: (String verificationCode) {
            setState(() {
              isLoading = false;
              _vericationId = verificationCode;
            });
          },
          timeout: Duration(seconds: 60));
      await verifyPhoneNumber;
    } else {
      setState(() {
        isLoading = false;
      });
      // displaySnackBar('Number not found, please sign up first');
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Register(_phoneNumber)));
    }

    //   void verificationComplete(AuthCredential phoneAuthCredential){
    // print("verification Complete");
//}
  }


  Widget _registerUser (){
    return new Scaffold(
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
                                          style: GoogleFonts.openSans(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w600),
                                          decoration: InputDecoration(
                                            hintText: "Email address",
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
                                      onPressed: () async {

                                        if(_formKey.currentState.validate()){

                                          // Navigator.of(context).pushReplacement(
                                          //     MaterialPageRoute(builder: (_) => UserProfile()));

                                          var phoneNumber = widget._phone;
                                          debugPrint("phone" + phoneNumber);

                                          debugPrint('debug 3');

                                          await _firestore
                                              .collection("users")
                                              .doc(_auth.currentUser.uid)
                                              .set({
                                            'name': _fullname.text.trim(),
                                            'cellnumber': phoneNumber,
                                            'email' : _email.text.trim(),
                                            'DOB': _Dob.text.trim(),
                                            'location':_location.text.trim()
                                          }, SetOptions(merge: true))
                                              .then((value) {
                                            setState((){
                                              isLoading = false;
                                              isRegister = false;
                                              isOTPScreen = false;

                                              Navigator.pushAndRemoveUntil(context,
                                                  MaterialPageRoute(builder: (_)=> UserProfile())
                                                  , (route) => false
                                              );
                                            });
                                          })
                                              .catchError((onError) =>{
                                            debugPrint('Error saving user' + onError.toString())
                                          });

                                        }
                                        // if(!isLoading){
                                        //   // SignUpUser();
                                        //
                                        //   // setState(() {
                                        //   //
                                        //   //   isRegister = false;
                                        //   //   isOTPScreen = true;
                                        //   // });
                                        // }

                                      },
                                      child: new Icon(Icons.arrow_forward)),
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
}




