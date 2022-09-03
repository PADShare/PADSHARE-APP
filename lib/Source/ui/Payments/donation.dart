import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/Pages/login.dart';
import 'package:padshare/Source/ui/Payments/success.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/utils/APINetwork/userDetailApi.dart';
import 'package:padshare/main.dart';
import 'package:place_picker/uuid.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:rave_flutter/rave_flutter.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Donations extends StatefulWidget {

  @override
  _DonationsState createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  APINetworkHandler _apiHandler = new APINetworkHandler();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _currencyController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  final String txref = DateTime.now().toString();
  var _formKey = GlobalKey<FormState>();
  //FLWPUBK-0f1b1a0717972264eb9c4322d7c1af59-X
  String selectedCurrency = "";
  //String publicKey = "FLWPUBK-fa5280bc0fe47044e013b3d0599af44f-X";
  // String encryptionKey = "b3a9cd2eaad4588ebea7aba0";
   String publicKey = "FLWPUBK-9f215ca8a13e3c536f8bba781ed3b881-X";
  // String publicKey = "FLWPUBK_TEST-bee92b08cccc7db9de9dd41a8b85c7c6-X";
                      // FLWPUBK-9f215ca8a13e3c536f8bba781ed3b881-X
   String encryptionKey = "1dd8cda7d96e48bcec99832b";
  // String encryptionKey = "FLWSECK_TEST5064e1c0d7aa";

  List<SubAccount> subAccounts = [];
  final bool live = true;
  bool _validatePhone = false;
  bool _validateCurrency = false;
  bool _validateAmount = false;
  var name = _auth.currentUser.displayName[0];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var ds ="Phone Number is required";

  String postId;

  var email;
  var username;

  @override
  void initState() {
    // TODO: implement initStateg\
    getCurrentUser();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation == Orientation.landscape;
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xffF4F6FE),
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(Icons.menu, size: 26,),
          onTap: (){
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Center(child: new Text("Donate", style: GoogleFonts.roboto(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w300), textAlign: TextAlign.center,)),

        actions: [
          Padding(padding: EdgeInsets.only(right: 10), child: InkWell(
              onTap: (){
              },
              child: Icon(Icons.more_vert_outlined, size: 20,)),)
        ],
      ),
      body: new Stack(
        children: [
          new Column(
            children: [
              new Container(
                width:MediaQuery.of(context).size.width,
                height: orientation ? MediaQuery.of(context).size.height * .40 : MediaQuery.of(context).size.height * .34,

                decoration: BoxDecoration(
                    color: Colors.purple,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/girls.png")
                  )
                ),
              ),

              // new Container(
              //   height: MediaQuery.of(context).size.height * .20,
              //   color: Colors.red,
              // )


            ],
          ),
          CardpaymentWidget()
        ],
      ),
      drawer: Theme(
        data: new ThemeData(canvasColor: Color(0xff3F2060)),
        child: Drawer(
          child: new ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff16CF8C)
                ),
                // accountName: Row(
                //   children: [
                //     Container(
                //       width: 50,
                //       height: 50,
                //       decoration: BoxDecoration(
                //           shape: BoxShape.circle
                //       ),
                //       child: CircleAvatar(
                //         backgroundColor: Colors.grey,
                //         child: Icon(Icons.check),
                //       ),
                //     ),
                //
                //     Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text('User'),
                //         Text("@user")
                //       ],
                //     )
                //
                //   ],
                // ),
                accountEmail: Text(_auth.currentUser.phoneNumber),
                accountName: new Text(_auth.currentUser.displayName),

                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: _auth.currentUser.photoURL==null ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Center(child: Text(name.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.w500),),),
                    ),
                  ) : Image.network(_auth.currentUser.photoURL, fit: BoxFit.cover,),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: 50,left: 40,bottom: 70),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    new Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => NewsFeed(selectedId: 0,)
                                  )
                              );
                              // RestartWidget.restartApp(context);
                            },
                            leading: Icon(Icons.home, color: Colors.white,),
                            title: new Text("Home", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => NewsFeed(selectedId: 4)),
                              );
                            },
                            leading: Icon(Icons.person_outline_outlined, color: Colors.white,),
                            title: new Text("Profile", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => NewsFeed(selectedId: 1)),
                              );
                            },
                            leading: Icon(Icons.food_bank, color: Colors.white,),
                            title: new Text("PadBank", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => NewsFeed(selectedId: 3)),
                              );
                            },
                            leading: Icon(Icons.shop, color: Colors.white,),
                            title: new Text("Shop", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: ()async{

                              // final savedtokken = new FlutterSecureStorage();
                              ///await savedtokken.deleteAll();

                              Navigator.of(context).pop();
                              showDiaLogs();


                            },
                            leading: Icon(Icons.cancel_outlined, color: Colors.white.withOpacity(0.5),),
                            title: new Text("Logout", style: TextStyle(color:Colors.white.withOpacity(0.5), fontWeight: FontWeight.w500),),
                          ),
                        ),
                      ],
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

  Widget _getCurrency() {
    final currencies = [
      "UGX",
      "USD",
      "NGN",
      "RWF",
      "KES",

    ];
    //
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: currencies
            .map((currency) => ListTile(
          onTap: () => {this._handleCurrencyTap(currency)},
          title: Column(
            children: [
              Text(
                currency,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 4),
              Divider(height: 1)
            ],
          ),
        ))
            .toList(),
      ),
    );
  }
  Future<void> getCurrentUser() async{

    debugPrint("GETUSER:: entered" );

    if(_auth.currentUser != null){
      var cellNumber = _auth.currentUser.phoneNumber;
      print(cellNumber);
      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      debugPrint(cellNumber);
      await _firestore
          .collection("users")
          .doc(_auth.currentUser.uid)//.where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result){
        debugPrint("GETUSER:: TRUE" );

        print(result.data()['email']);
        // if (result.docs.length > 0) {
        //   debugPrint("GETUSER:: TRUE" );
        //   debugPrint("GETUSER:: TRUE :::" + result.docs.single.data()['location']);
        setState(() {
          print(result.data()['name']);
          debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
          username = result.data()['name'];
          email = result.data()['email'];
        });

      });
    }


  }

  _handleCurrencyTap(String currency) {
    this.setState(() {
      this.selectedCurrency = currency;
      this._currencyController.text = currency;
    });
    Navigator.pop(this.context);
  }
  void _openBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getCurrency();
        });
  }


  _handlePaymentInitialization() async {
    // final savedtokken = new FlutterSecureStorage();
    // final Map<String,String> dataEmail = await savedtokken.readAll();


    var initializer = RavePayInitializer(
      amount: double.parse(_amountController.text),
      publicKey: publicKey,
      encryptionKey: encryptionKey,
      acceptCardPayments: true,
      acceptUgMobileMoneyPayments: true,
      acceptMpesaPayments: false,
      acceptAccountPayments: true,
      displayFee: true,
      isPreAuth: false,
      staging: live,
      companyName: new Text("PADShare"),
      companyLogo: new Container(
          decoration: BoxDecoration(
             image: DecorationImage(
                image: AssetImage("assets/images/padshared_logo.png")
            )
        ),
      ),
      narration: '',
      txRef: DateTime.now().toString(),
      orderRef: DateTime.now().toString(),)
      ..country = "NG"
      ..currency = _currencyController.text
      ..email = email //dataEmail['email'].toString()
      ..fName = "" //dataEmail['username'].toString()
      ..staging = false
     // ..staging = !live
      ..subAccounts = subAccounts;

    // ..staging = !live;

    var resop = RavePayManager().prompt(
        context: context, initializer: initializer);

      resop.then((value) async {
      print("RESSS ERROR::::::::::");

      var err = await value.status.index;

      print("error RORWR: ${err}");

      var err2 = await value.message;

      print("error MSG: ${err2}");

      print("RESSSSSS::::::::::");
      var response = await value.rawResponse;

      if( err == 1){
        print("RESPONSE ERROR  : ${err}");

        AlertDialog alertDialog = new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),

          ),
          title: Text('Payment Failed',style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 20)),
          content: Text("No  transaction made..\n\n${err2}",style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 16)),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                }, child: Text("OK",style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18)))
          ],
        );

        showDialog(context: context,
            builder: (_) => alertDialog
        );

      }else if(err == 2){
        AlertDialog alertDialog = new AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),

          ),
          title: Text('Payment Failed',style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 20)),
          content: Text("No  transaction made..\n\n${err2}",style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 16)),
          actions: <Widget>[
            FlatButton(
                onPressed: (){
                  Navigator.pop(context);
                }, child: Text("OK",style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18)))
          ],
        );

        showDialog(context: context,
            builder: (_) => alertDialog
        );
      }else{

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => Successful()), (
            Route<dynamic> route) => false
        );

        // if(resop['status'] = 'error'){
        //
        // }

        _apiHandler.handlepayments(
            user: _auth.currentUser.phoneNumber,
            amount: response['data']['amount'],
            status: response['data']['status'].toString(),
            paymentType: response['data']['paymentType'].toString(),
            paymentId: response['data']['paymentId'].toString(),
            currency: response['data']['currency'].toString(),
            createdAt: Timestamp.now().toString()

        );
      }

      print("RESPONSE HERE : ${response['data']['orderRef']}");

      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (_) => Successful()), (
      //     Route<dynamic> route) => false
      // );
      //
      // // if(resop['status'] = 'error'){
      // //
      // // }
      //
      // _apiHandler.handlepayments(
      //     user: _auth.currentUser.phoneNumber,
      //     amount: response['data']['amount'],
      //     status: response['data']['status'].toString(),
      //     paymentType: response['data']['paymentType'].toString(),
      //     paymentId: response['data']['paymentId'].toString(),
      //     currency: response['data']['currency'].toString(),
      //     createdAt: Timestamp.now().toString()
      //
      // );

      setState(() {
        postId = Uuid().generateV4();
      });

    }, onError: (error) {
      print("Error::");
      print(error);

      AlertDialog alertDialog = new AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),

        ),
        title: Text('payment failed',style: GoogleFonts.roboto(fontWeight: FontWeight.w700, fontSize: 20)),
        content: Text("No  transaction made..",style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 16)),
        actions: <Widget>[
          FlatButton(
              onPressed: (){
                Navigator.pop(context);
              }, child: Text("OK",style: GoogleFonts.openSans(fontWeight: FontWeight.w700, fontSize: 18)))
        ],
      );

      showDialog(context: context,
          builder: (_) => alertDialog
      );

    });

      // print(response.status);
      //
      // return response.status;
      }


      Future<void> showLoading(String message) {
        return showDialog(
          context: this.context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
                width: double.infinity,
                height: 50,
                child: Text(message),
              ),
            );
          },
        );
      }


      ShowPaymentComplete() async {
        AlertDialog showDDialog = await AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: const EdgeInsets.symmetric(vertical: 50),
          content: Container(
            height: 400,
            padding: EdgeInsets.only(top: 80),
            decoration: BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.circular(41),
            ),
            child: new Column(
              children: [
                Icon(Icons.check_circle, size: 80, color: Colors.green,),
                new Text("Payment Complete.", style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20,
                    fontWeight: FontWeight.w400
                ),),
                SizedBox(height: 50,),
                new FlatButton(onPressed: () {
                  Navigator.of(context).pop();
                },
                    child: new Text("Continue", style: TextStyle(
                        color: Colors.deepPurple, fontSize: 18),))
              ],
            ),
          ),
          // actions: [
          //   FlatButton(onPressed: (){
          //     Navigator.of(context).pop();
          //   }, child: new Text("Ok"))
          // ],
        );

        showDialog(context: context, builder: (_) => showDDialog);
      }

  CardpaymentWidget() {

    return  new Container(
      alignment: Alignment.topCenter,
      padding: new EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.28,
      ),
      child: new Container(
        height: MediaQuery.of(context).size.height * .54,
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: new Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(29),
                    topLeft: Radius.circular(29)
                )
            ),
            margin: EdgeInsets.zero,
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.only(right: 50, left: 50, top: 40),
              child: Wrap(
                children: [
                  new Column(
                    children: [
                      new TextFormField(
                        controller: _amountController,
                        validator: (value){
                          if(value.isEmpty ){
                            return "please Amount Required.";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.roboto(fontSize: 14,color: Color(0xff8A8A8C),fontWeight: FontWeight.w500),

                        decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682)
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682)
                                )
                            ),
                            labelText: "Amount",
                            errorStyle: GoogleFonts.roboto(fontSize: 8,),
                            // errorStyle: GoogleFonts.roboto(fontSize: 8,color: Color(0xff8A8A8C), fontWeight: FontWeight.w300),
                            labelStyle: GoogleFonts.roboto(fontSize: 11,color: Color(0xff8A8A8C), fontWeight: FontWeight.w300),
                            contentPadding: const EdgeInsets.only(top: 10,left: 30,right: 15, bottom: 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682)
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682),
                                    width: 1
                                )
                            )
                        ),
                      ),
                      SizedBox(height: 15,),
                      new TextFormField(
                        controller: _currencyController,
                        // validator: (value) =>
                        // value.isNotEmpty ? null : "Currency is required",
                        onTap: _openBottomSheet,
                        style: GoogleFonts.roboto(fontSize: 14,color: Color(0xff8A8A8C),fontWeight: FontWeight.w500),

                        decoration: InputDecoration(
                            labelText: "Currency",

                            labelStyle: GoogleFonts.roboto(fontSize: 11,color: Color(0xff8A8A8C),fontWeight: FontWeight.w300),
                            contentPadding: const EdgeInsets.only(top: 10,left: 30,right: 15, bottom: 10),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682)
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682),
                                    width: 1
                                )
                            )
                        ),
                      ),
                      SizedBox(height: 15,),

                      new TextFormField(
                        controller: _phoneController,
                        // validator:  (value) => value.isNotEmpty ? null : ds,
                        //
                        // onChanged: (value){
                        //      ds ="";
                        //     value = ds;
                        // },
                        validator: (value){
                          if(value.length < 7){
                            return "number must be 9 Characters";
                          }
                          return null;
                        },
                        style: GoogleFonts.roboto(fontSize: 14,color: Color(0xff8A8A8C),fontWeight: FontWeight.w500),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: "Phone Number",
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682)
                                )
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682)
                                )
                            ),
                            errorStyle: GoogleFonts.roboto(fontSize: 8,),
                            labelStyle: GoogleFonts.roboto(fontSize: 11,color: Color(0xff8A8A8C),fontWeight: FontWeight.w300),
                            contentPadding: const EdgeInsets.only(top: 20,left: 30,right: 15, bottom: 20),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide( color: Color(0xff6C1682) ) ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xff6C1682),
                                    width: 1
                                )
                            )
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top:35),
                        child: Container(
                          height: 46,
                          width: MediaQuery.of(context).size.width * .48,
                          decoration: BoxDecoration(
                            color: Color(0xff16CF8C),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FlatButton(onPressed: () async{

                            // beginPayment();

                            print("am Pressed");

                            if (_formKey.currentState.validate()) {
                              await this._handlePaymentInitialization();
                              // ShowPaymentComplete();
                              Successful();
                            }

                          },
                              child: new Text("Donate",style: GoogleFonts.roboto(color: Colors.white),)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget showDiaLogs(){

    AlertDialog alertDialog = AlertDialog(
      contentTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54),
      title: Center(child: Text("Log Out")),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      content: Container(
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text("Are you sure you would like to log out?.Your history will be cleared and you'll need to log in again", textAlign: TextAlign.center,)),
            SizedBox(height: 30,),
            TextButton(
              child: Container(
                  height: 40,
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:Colors.cyan,
                  ),
                  child: Center(child: Text("YES",style: TextStyle(color: Colors.white)))),
              onPressed: () {
                // Navigator.of(context).pop();
                //  Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop('dialog');
                _onLoading(context);

                // Navigator.push(context, MaterialPageRoute(builder: (_)=>ManageAddress()));
              },
            ),
            TextButton(
              child: Container(
                  height: 40,
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:Colors.black54,
                  ),
                  child: Center(child: Text("NO", style: TextStyle(color: Colors.white54),))),
              onPressed: () {

                Navigator.of(context, rootNavigator: true).pop('dialog');

                // Navigator.of(context).pop();

                // RestartWidget.restartApp(context);

                // Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsFeed()));
              },
            )
          ],
        ),
      ),
      actions: [

      ],
    );

    showDialog(context: context, builder: (_)=> alertDialog);
  }


  void _onLoading(context) {
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
              new Text("logging out of Padshare..", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      _auth.signOut().then((value){

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder:(_) => Login()
            )
        );


      });

    });
  }
  Widget progressIndictor() {

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // new Text('Loading please wait...', style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),),
        SpinKitDoubleBounce(
          size: 44.0,
          color: Colors.blue,
        ),
      ],
      // )
    );
  }

  }




