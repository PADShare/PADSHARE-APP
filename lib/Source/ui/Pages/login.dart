import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/Pages/OTPScreen.dart';
import 'package:padshare/Source/ui/Pages/Register.dart';
import 'package:padshare/Source/widgets/ScreenBackground.dart';
import 'package:sms_autofill/sms_autofill.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Login extends StatefulWidget{

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final TextEditingController _phone = new TextEditingController();
  final TextEditingController _smsController = new TextEditingController();
  String _vericationId;
  final _formKey = GlobalKey<FormState>();

  final SmsAutoFill _autoFill =  SmsAutoFill();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int seleted ;

  CountryCode country;
  static bool isLargeScreen = true;
  var isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _phone.dispose();
    _smsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // final Orientation orientation = MediaQuery.of(context).orientation;
    //   isLandscape = orientation == Orientation.landscape;
    // TODO: implement build
    return new Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,

      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: new CustomPaint(
          painter: myCustomBackground(),
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
                 bottom: 130, //android 140,
                // bottom: 250 ios,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    Container(
                        padding: EdgeInsets.only(top:8, bottom: 30),
                        width: MediaQuery.of(context).size.width,
                        child: Align(
                          alignment: Alignment.center,
                            child: Center(child: new Text("", style: GoogleFonts.roboto(fontSize: 26, color: Color(0xff666363),fontWeight: FontWeight.w400), textAlign: TextAlign.center,)))),
                    Container(
                      width: MediaQuery.of(context).size.width * 60,
                      height: 156,

                      child:  Form(
                        key: _formKey,
                        child: Stack(
                              children: [
                                new Container(
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
                                  height: 131,

                                  child: new Row(
                                    children: <Widget>[
                                      Container(
                                        padding:  EdgeInsets.only(left: 2),
                                        width: 100,
                                        child: Theme(
                                          data: ThemeData(
                                              canvasColor: Color(0xff16CF8C)
                                          ),

                                          child: CountryCodePicker(
                                            onChanged: (value){
                                              setState(() {
                                                country = value;
                                                print(country.toString());
                                              });
                                            },
                                            textStyle: TextStyle(fontSize: 12, color: Colors.black54),
                                            hideMainText: false,
                                            showFlagMain: true,
                                            showFlag: false,
                                            initialSelection: 'US',
                                            hideSearch: true,
                                            showCountryOnly: false,
                                            favorite: ['+256', 'UG'],
                                            showOnlyCountryWhenClosed: false,
                                            alignLeft: true,
                                            boxDecoration: BoxDecoration(
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ) ,

                                      Container(
                                          width: MediaQuery.of(context).size.width * 0.50,

                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 30),
                                            child: new TextFormField(
                                              controller: _phone,
                                              enabled: !isLoading,
                                              validator: (value){
                                                if(value.isEmpty ){
                                                  return "Please enter Phone";
                                                         } else if(value.length < 9){
                                                  return "incorrect Phone";

                                                                      }
                                                return null;
                                              },

                                              keyboardType: TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter.digitsOnly
                                              ],
                                              style: GoogleFonts.openSans(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w600),
                                              decoration: InputDecoration(
                                                hintText: "Phone number",
                                                hintStyle: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 17, fontWeight: FontWeight.w200),
                                                contentPadding: const EdgeInsets.only(top: 5,left: 2,right: 10, bottom: 5),


                                              ),

                                            ),
                                          )
                                      ),


                                    ],
                                  ),

                                ),

                                new Positioned(
                                  child: Container(
                                      height: 156,
                                      width: MediaQuery.of(context).size.width * 0.84,
                                      alignment: Alignment.centerRight,
                                      margin: const EdgeInsets.only(top: 50, ),
                                      child: Column(
                                        children: [
                                          new FloatingActionButton(
                                            backgroundColor:  Color(0xff16CF8C),
                                              onPressed: () async{

                                              _phone.text = await _autoFill.hint;

                                              // signInWithPhoneNumber();
                                                 if(_formKey.currentState.validate()){
                                                   print("Phone 1:::${_phone.text}");
                                                 var phone = country.toString().trim() + _phone.text.toString().trim().replaceFirst(new RegExp(r'^0+'), '');
                                                 var phones = _phone.text.replaceFirst(new RegExp(r'^0+'), '');
                                                   print(" 2:::$phones");
                                                Navigator.pushAndRemoveUntil(context,
                                                    MaterialPageRoute(builder: (_)=> OTPScreen(phone))
                                                    , (route) => false
                                                );

                                               // await signInWithPhoneNumber();

                                              }

                                                 },
                                            child: Icon(Icons.arrow_forward_rounded, size: 35,),
                                          ),
                                        ],
                                      )


                                  ),
                                ),

                              ],
                            ),
                      ),


                    ),

                    Container(
                      margin: EdgeInsets.only(top:40,bottom: 5),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: !isLoading ? new Text("", textAlign: TextAlign.center,) : Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )

                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithPhoneNumber() async{
    setState(() {
      isLoading = true;
    });
String _phoneNumber = country.toString().trim() + _phone.text.toString().trim();

var isValidUser = false;
var number = _phoneNumber.toString().trim();
await _firestore
      .collection('users')
      .where('cellnumber', isEqualTo: number)
      .get()
      .then((result){
     if(result.docs.length >0){

       setState(() {
         isValidUser = true;
       });
     }
});

 if(isValidUser){

   var verifyPhoneNumber = _auth.verifyPhoneNumber(
       phoneNumber: number,
       verificationCompleted: (phoneAuthCredential){
         _auth.signInWithCredential(phoneAuthCredential).then((user)async =>{
         debugPrint("1st Instance Phone verify"),
           if(user != null){
           debugPrint("1st Instance Phone verify"),
             setState((){
               isLoading = false;
             }),

         Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (_)=> UserProfile()))

           }

         });
       },

       verificationFailed: (FirebaseAuthException error){
         // displaySnackBar("")
         setState(() {
           isLoading =  false;
         });
         print("validation Failed please Try again");
       },

       codeSent: (verificationCode, [forceResendingToken]){
         setState(() {
           isLoading = false;
           _vericationId = verificationCode;
         });

         Navigator.of(context).pushReplacement(
             MaterialPageRoute(builder: (_)=> OTPScreen(_phoneNumber)));


       },

       codeAutoRetrievalTimeout: (String verificationCode) {
         setState(() {
           isLoading = false;
           _vericationId = verificationCode;
         });
       },
     timeout: Duration(seconds: 60)
   );
   await verifyPhoneNumber;
 } else {
   setState(() {
     isLoading = false;
   });
   displaySnackBar('Number not found, please sign up first');
   Navigator.of(context).pushReplacement(
       MaterialPageRoute(builder: (_)=> Register(_phoneNumber)));

 }

  //   void verificationComplete(AuthCredential phoneAuthCredential){
  // print("verification Complete");
//}

  }

  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}