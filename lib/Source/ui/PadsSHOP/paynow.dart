import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/models/shopping/cart_product.dart';
import 'package:padshare/Source/ui/Payments/success.dart';
import 'package:padshare/Source/utils/cart_productHelper.dart';
import 'package:rave_flutter/rave_flutter.dart';

class PaymentChekout extends StatefulWidget{
  List<CartProduct> cartProduct;

  PaymentChekout({this.cartProduct});

  @override
  _PaymentChekoutState createState() => _PaymentChekoutState();
}

class _PaymentChekoutState extends State<PaymentChekout> {
  double mytotal =0.0;
  String publicKey = "FLWPUBK-fa5280bc0fe47044e013b3d0599af44f-X";
  String encryptionKey = "b3a9cd2eaad4588ebea7aba0";
  List<SubAccount> subAccounts = [];
  final bool live = true;

  _totalPrice()async{
    var dbHelper = CartProductHelper.db;
    var total = (await  dbHelper.gettotalPrice())[0]['Total'];
    print("my TTOTAL $total");
    setState(() {
      mytotal = double.parse(total.toString());
    });

    print(mytotal);
    // cartprod.map((e) => print("TOTAL;: ${e.price}"));
    // return cartprod;
  }

 @override
  void initState() {
    // TODO: implement initState
    _totalPrice();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    print(widget.cartProduct[0].name);
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Color(0xffF4F6FE),
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: new Icon(Icons.arrow_back, color: Color(0xff692CAB),),
        ),
      ),
      body: SafeArea(
        child: Flexible(
          child: new ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Container(
                  padding: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Colors.grey[300],
                              style: BorderStyle.solid
                          )
                      )
                  ),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text("Payment Methods", style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),),

                    ],),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: new Container(
                  padding: const EdgeInsets.only(bottom: 25),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Colors.grey[300],
                              style: BorderStyle.solid
                          )
                      )
                  ),
                  child: Image.asset("assets/images/credit-card.png"),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:15.0, left: 15),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: Colors.grey[300],
                              style: BorderStyle.solid
                          )
                      )
                  ),

                  child: new ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 1000),
                    child: ListView.builder(
                     shrinkWrap: true,
                    itemCount: widget.cartProduct.length,
                    itemBuilder: (_, index){
                      return  new ListTile(
                            title: new Text(widget.cartProduct[index].name, style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),),
                              subtitle: new Text("Size: ${widget.cartProduct[index].sizes}",style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                            trailing: Padding(
                              padding: const EdgeInsets.only(bottom:8.0),
                              child: new Text('\$${widget.cartProduct[index].price}',style: TextStyle(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,),),

                          ),);
                    },
                  ),)
                  // child: new ListTile(
                  //   title: new Text("Panadol Extra", style: GoogleFonts.roboto(color: Color(0xff3E4347), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal),),
                  //     subtitle: new Text("Size: M",style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                  //   trailing: Padding(
                  //     padding: const EdgeInsets.only(bottom:8.0),
                  //     child: new Text('\$240',style: TextStyle(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal,),),
                  //   ),
                 // ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: new Column(
                  children: [
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text("Subtotal", style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),),
                        new Text("\$ ${mytotal}", style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    SizedBox(height: 5,),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text("Tax", style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),),
                        new Text("\$ 3.55", style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w500),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Text("TOTAL", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                        new Text("\$ ${mytotal + 3.55}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),),
                      ],
                    ),

                    SizedBox(height: 40,),
                    GestureDetector(
                      onTap: (){
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (_) => PaymentChekout()
                        //     )
                        // );
                        _handlePaymentInitialization(total: mytotal.toString());
                      },
                      child: Container(
                        width: 500,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xff16CF8C),
                        ),

                        child: Center(child: new Text("Pay Now", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700), textAlign: TextAlign.center,)),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ) ,
    );
  }

  _handlePaymentInitialization({String total}) async {
    // final savedtokken = new FlutterSecureStorage();
    // final Map<String,String> dataEmail = await savedtokken.readAll();


    var initializer = RavePayInitializer(
      amount: double.parse(total),
      publicKey: publicKey,
      encryptionKey: encryptionKey,
      acceptCardPayments: true,
      acceptAccountPayments: true,
      displayFee: true,
      isPreAuth: false,
      staging: live,
      companyName: new Text("Padshare"),
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
      ..country = "UG"
      ..currency = "UGX"
      ..email = "" //dataEmail['email'].toString()
      ..fName = "" //dataEmail['username'].toString()
      ..subAccounts = subAccounts;
    // ..staging = !live;

    // Initialize and get the transaction result
    // RaveResult response = await RavePayManager()
    //     .prompt(context: context, initializer: initializer);


    // final flutterwave = Flutterwave.forUIPayment(
    //     amount: this.amountController.text.trim(),
    //     currency: this.currencyController.text.trim(),
    //     context: context,
    //     publicKey: "FLWPUBK_TEST-ab0414d4824d8919a6c46589f92208bb-X",
    //     encryptionKey: "FLWSECK_TEST414705779751",
    //     email: "nsa@gmail.com01",
    //     fullName: "Test User",
    //     isDebugMode: true,
    //     txRef: DateTime.now().toIso8601String(),
    //     narration: "Example Project",
    //     phoneNumber: this.phoneNumberController.text.trim(),
    //     acceptAccountPayment: true,
    //     acceptCardPayment: true,
    //     acceptUSSDPayment: true
    // );
    // final response = await flutterwave.initializeForUiPayments();
    // if (response != null) {
    //   this.showLoading(response.data.status);
    //   print(response.data);
    // } else {
    //   this.showLoading("No Response!");
    // }
    var resop = RavePayManager().prompt(
        context: context, initializer: initializer);

    resop.then((value) async {
      print("RESSSSSS::::::::::");

      var response = await value.rawResponse;

      print("RESPONSE HERE : ${response['data']['orderRef']}");

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Successful()), (
          Route<dynamic> route) => false
      );

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

      // setState(() {
      //   postId = Uuid().generateV4();
      // });

      //   _apiHandler.createPostPayments(
      //       response['data']['id'].toString(),
      //       response['data']['txRef'].toString(),
      //       response['data']['orderRef'].toString(),
      //       response['data']['flwRef'].toString(),
      //       response['data']['amount'].toString(),
      //       response['data']['charged_amount'].toString(),
      //       response['data']['appfee'].toString(),
      //       response['data']['charge_type'].toString(),
      //       response['data']['status'].toString(),
      //       response['data']['merchantfee'].toString(),
      //       response['data']['chargeResponseCode'].toString(),
      //       response['data']['ravRef'].toString(),
      //       response['data']['chargeResponseMessage'].toString(),
      //       response['data']['currency'].toString(),
      //       response['data']['narration'].toString(),
      //       response['data']['paymentType'].toString(),
      //       response['data']['paymentId'].toString(),
      //       response['data']['customer.id'].toString(),
      //       response['data']['customer.phone'].toString(),
      //       response['data']['customer.fullName'].toString(),
      //       response['data']['customer.email'].toString(),
      //       context);
      //   // ShowPaymentComplete();

    }, onError: (error) {
      print("Error::");
      print(error);
    });

    // print(response.status);
    //
    // return response.status;
  }
}