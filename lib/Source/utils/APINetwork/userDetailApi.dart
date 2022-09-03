
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:place_picker/uuid.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class APINetworkHandler {
  String postId = Uuid().generateV4();


  // Future fetchUserProfile () async{
  //
  //   final savedtokken = new FlutterSecureStorage();
  //   final Map<String,String> token = await savedtokken.readAll();
  //
  //   final response = await http.get(
  //       Uri.http("padshare.herokuapp.com", "/api/account/user_detail/${token['userId']}/"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json",
  //         'Accept': 'application/json',
  //         "Authorization": "Token ${token['userToken']}"
  //       }
  //   );
  //    print(token['userId']);
  //
  //   if(response.statusCode == 200 || response.statusCode == 201){
  //
  //    final jsonResponse = json.decode(response.body);
  //
  //
  //     return UserModel.fromJson(jsonResponse);
  //
  //   }
  //
  // }
  //
  //
  // Future fetchPadBankData () async {
  //
  //   final savedtokken = new FlutterSecureStorage();
  //   final Map<String,String> token = await savedtokken.readAll();
  //
  //   final response = await http.get(
  //       Uri.http("padshare.herokuapp.com","/api/payments/padbank/"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json",
  //         'Accept': 'application/json',
  //         "Authorization": "Token ${token['userToken']}"
  //       }
  //   );
  //
  //   print(token['userId']);
  //   print(token['userToken']);
  //
  //
  //
  //   if(response.statusCode == 200 || response.statusCode == 201){
  //
  //     final jsonResponse = json.decode(response.body);
  //
  //     print(jsonResponse);
  //
  //
  //     return PadBankModel.fromMap(jsonResponse);
  //
  //   }
  //
  //
  // }





  Future createPostPayments(
      id,
      txRef,
      orderRef,
      flwRef,
      amount,
      charged_amount,
      appfee,
      charge_type,
      status,
      merchantfee,
      chargeResponseCode,
      raveRef,
      chargeResponseMessage,
      currency,
      narration,
      paymentType,
      paymentId,
      customerId,
      customerphone,
      customerfullName,
      customeremail,
      context
      ) async{
    var url = "https://padshare.herokuapp.com";
    final savedtokken = new FlutterSecureStorage();
    final Map<String,String> token = await savedtokken.readAll();

    try{
      final response = await http.post(
        Uri.https("padshare.herokuapp.com",'/api/payments/get_payments/'), headers: <String, String>{
        'Content-Type' : 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Authorization": "Token ${token['userToken']}"
      },
        body: jsonEncode(<String, String>{
          "id":id,
          "txRef":txRef,
          "orderRef":orderRef,
          "flwRef":flwRef,
          "amount":amount,
          "charged_amount":charged_amount,
          "appfee":appfee,
          "charge_type": charge_type,
          "status":status,
          "merchantfee":merchantfee,
          "chargeResponseCode":chargeResponseCode,
          "raveRef":raveRef,
          "chargeResponseMessage":chargeResponseMessage,
          "currency":currency,
          "narration":narration,
          "paymentType":paymentType,
          "paymentId":paymentId,
          "customerId":customerId,
          "customer.phone":customerphone,
          "customer.fullName":customerfullName,
          "customer.email":customeremail,

        }),
      );
      var data = jsonDecode(response.body);
      print(response.statusCode );
      print(data);
      if(response.statusCode == 400){
        // Navigator.pop(context);
        if(data['email'][0] = true) {

          AlertDialog alert = new  AlertDialog(
            title: Text("User Already Exist",style:GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 16)),
            content: Text("account with this username Or Email already exists.(Click in empty Space to Exit)", style: GoogleFonts.openSans(fontWeight: FontWeight.w500, fontSize: 16),),
            actions: <Widget>[
              GestureDetector(
                onTap: (){
                  // Navigator.push(context, MaterialPageRoute(
                  //     builder: (_) => MainLogin()
                  // ));
                },
                child: new Text("ok",style:TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
              )
            ],
          );

          showDialog(context: context,
              builder: (_) =>  alert
          );


        }
      }
      if(response.statusCode == 200  || response.statusCode == 201 ){

        // Navigator.of(context).push(
        //     MaterialPageRoute(
        //         builder: (_) => new UserBottomRoutePage()
        //     )
        // );
      print(json.decode(response.body));
      print("Payment already made Here ");

      } else{
        print(response.statusCode);
        throw Exception('Failed to Load Data....');

      }

    }catch(e){
      print(e);

    }

    //   url,{
    //   "full_name":fullNames,
    //   "email":email,
    //   "username":username,
    //   "password":password,
    //   "password2":password,
    //   "is_verified":"true",
    //   "reg_access":email
    // });

    //     Uri.http(url, 'User'),
    //     headers: <String, String> {
    //   'Content-Type': 'application/json; charset=UTF-8',
    //
    //     },
    //   body: jsonEncode(<String, String>{
    //
    //
    //   })
    //     );
    // var data = jsonDecode(response.body);
    // print("Status Code ${response.statusCode}");
    // if(response.statusCode == 200 && data['email'][0] != "account with this email already exists") {
    //
    //  // return User.fromJson(jsonDecode(response.body));
    //
    //   // if( email == data['email']){
    //     print(data['email'][0]);
    //   // }
    //   print(jsonDecode(response.body));
    //
    //   //print("Data Inserted into DB : ${User.fromJson(jsonDecode(response.body))}");
    //   return jsonDecode(response.body);
    //
    //   }else{
    //      // return Future.error("error", StackTrace.fromString("this is is TRace"));
    //
    //   throw Exception("Error Inserting Data");
    //   }

    // try {
    //   return User.fromJson(jsonDecode(response.body));
    // } catch (e) {
    //   print("errorMESAGE: $e");
    // }

  }


  Future handlepayments({String user, num amount, String currency, String paymentType, String paymentId, String status, String createdAt})async{


    await _firestore.collection("donations")
          .doc(_auth.currentUser.uid)
        .collection('UserDonations')
        .doc(postId)
        .set({
          "amount": amount,
          "status": status,
          "currency": currency,
          "paymentType": paymentType,
          "paymentId": paymentId,
          "charge_type": "normal",
          "createdAt": createdAt,
           },SetOptions(merge: true)).then((result) {

     print("Transaction Completed");
    }, onError: (error){
             print("ERROR ADDING PAYMENT");
             print(error);
    });

    await _firestore
        .collection('allDonations')
        .doc(postId)
        .set(
        {
          "amount": amount,
          "status": status,
          "currency": currency,
          "paymentType": paymentType,
          "paymentId": paymentId,
          "charge_type": "normal",
          "createdAt": createdAt,
          "shares" : {}

        },SetOptions(merge: true)
    );



  }



}


