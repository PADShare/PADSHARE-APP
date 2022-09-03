import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/main.dart';
import 'package:path/path.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

class UpdateUser extends StatefulWidget{

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {

  TextEditingController _fullName = TextEditingController();
  TextEditingController _email    = TextEditingController();
  TextEditingController _phone    = TextEditingController();
  var name = _auth.currentUser.displayName[0];
  final _formKey = GlobalKey<FormState>();
  var username ;
  var cellnumber;
  var dob;
  var email;
  var location;

  var imageFile;
  var imagefileName;
  File _image;
  Future<void> getCurrentUser() async{

    debugPrint("GETUSER:: entered" );
    if(_auth.currentUser != null){
      var cellNumber = _auth.currentUser.phoneNumber;
      debugPrint("GETUSER:: entered IF" );
      print("Entered HET");
      print(cellNumber);
      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      debugPrint(cellNumber);
      await _firestore
          .collection("users")
          .where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result){
        debugPrint("GETUSER:: TRUE" );
        if (result.docs.length > 0) {
          debugPrint("GETUSER:: TRUE" );
          setState(() {
            // print(result.docs.single.data()['name']);
            username = result.docs.single.data()['name'].toString();
            email = result.docs.single.data()['email'].toString();
            location = result.docs.single.data()['location'].toString();
            dob = result.docs.single.data()['DOB'];
          });
        }


        // setState((){
        //       debugPrint(result.docs[0]);
        //      // username = result.docs[0].data()['name'];
        //      // email = result.docs[0].data()['email'];
        //      // cellnumber = cellnumber;
        //      // location = result.docs[0].data()['location'];
        //      // dob = result.docs[0].data()['DOB'];
        //     });
      });
    }

  }
  var string = _auth.currentUser.email.toString();

  bool _isButtonDisabled;

  var isUploading = false;
  String postId = Uuid().v4();

  double _progress;

  @override
  void initState() {
    // TODO: implement initState
    _isButtonDisabled = false;
    getCurrentUser();
    super.initState();
    _fullName = TextEditingController(text: _auth.currentUser.displayName);
    _email = TextEditingController(text: string);
    print("usr ${username}");
  }








  @override
  Widget build(BuildContext context) {



    _updateProfile()async{

      setState(() {
        _isButtonDisabled = true;
      });

      print("CLICKED");

      if(_formKey.currentState.validate()){

        if(_auth.currentUser != null){
          var code = _auth.currentUser.phoneNumber.characters.take(4);
          var phones = _phone.text.replaceFirst(new RegExp(r'^0+'), code.toString());
          await _firestore
              .collection('users')
              .doc(_auth.currentUser.uid)
              .update({
            // "cellnumber": phones,
            "email" :_email.text,
            "name" : _fullName.text

          }).then((result) {

            _onLoading(context);



          });

          print(_fullName.text);

        }

      }



    }
    // TODO: implement build
    print(Offset(0.0, -1.0).distanceSquared - Offset(0.0, 0.0).distanceSquared);
    return Form(
      key: _formKey,
      child: new Scaffold(
          backgroundColor: Color(0xffF4F6FE),
          extendBodyBehindAppBar: true,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: new FlatButton(onPressed: (){
              // RestartWidget.restartApp(context);
              // Navigator.pop(context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    maintainState: true,
                    builder: (_) => NewsFeed(selectedId: 4,))
              );
            }, child: new Icon(Icons.arrow_back,color: Color(0xff6C1682),)),
            title: new Text("Edit user details ", style: GoogleFonts.roboto(color: Color(0xff6C1682), fontSize: 18, fontWeight: FontWeight.w600),),
            actions: [
              GestureDetector(
                onTap:  (){
                 _updateProfile();
                },
                child: Padding(
                  padding: const EdgeInsets.only(right:15.0 , top: 15),
                  child: Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Color(0xff16CF8C),
                      ),
                      child: Center(child: new Text("Save", style: GoogleFonts.roboto(color: Colors.white, fontSize: 16),))),
                ),
              ),

            ],
          ),
          body: SingleChildScrollView(
            child: new Column(
              children: [
                isUploading ?  SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: LinearProgressIndicator(),
                  ),
                ) : Container() ,

                new Container(

                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(49),
                        bottomRight: Radius.circular(49),
                      ),
                      boxShadow:[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,7)
                        )
                      ]
                  ),

                  child: new Column(
                    children: [
                      SizedBox(height: 40,),
                      new Padding(padding: const EdgeInsets.only(top: 80),
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _auth.currentUser.photoURL==null ? Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Center(child: Text(name.toString().toUpperCase(),style: GoogleFonts.roboto(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.w500),),),
                                ),
                              ) :    new Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(
                                    image:_image == null ? NetworkImage(_auth.currentUser.photoURL) : FileImage(_image)
                                  )
                                ),

                              ),
                              Container(
                                  width: 40,
                                  child: Align(
                                  alignment: Alignment.topCenter,
                                  child: InkWell(onTap: () async{

                                   await onImageUPload(ImageSource.gallery);
                                   await uploagImageToFirebase(context);
                                   // await _auth.currentUser.updateProfile(
                                   //   photoURL: imageFile
                                   // );
                                   await _auth.currentUser.updatePhotoURL(imageFile);
                                   await _auth.currentUser.updateDisplayName(_fullName.text);
                                   await _firestore
                                       .collection('users')
                                       .doc(_auth.currentUser.uid).update({
                                     "mediaUrl":imageFile,
                                     'userprofile' : _auth.currentUser.photoURL
                                   });
                                   // await _firestore.collection("userTeams")
                                   //     .doc(teamId)
                                   //     .collection("allUsers")
                                   //     .doc(uuid).update({});
                                   setState(() {
                                     isUploading = false;
                                   });

                                  },
                              child: SvgPicture.asset("assets/images/edit.svg", width: 25,height: 25,))))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:2.0),
                        child: Transform.translate(
                            offset: Offset(-25,0),
                            child: new Text(username ?? '',style: GoogleFonts.roboto(color:Color(0xff666363), fontSize: 20, fontWeight: FontWeight.bold),)),
                      ),


                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.only(top: 60 , right: 20,left: 20),
                  child: new Column(
                    children: [
                      new Container(
                         width: MediaQuery.of(context).size.width * .84,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide( width: 1, color: Color(0xff6C1682), style: BorderStyle.solid)
                          )),

                          child: Padding(
                            padding: const EdgeInsets.only(right: 20,left: 20),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Flexible(
                                  child: new TextFormField(
                                         controller: _fullName,
                                       validator: (value){
                                           if(value.isEmpty){
                                             return "please enter your Name";
                                           }

                                           return null;
                                       },
                                       decoration: const InputDecoration(
                                         // labelText: 'Full Names', hintText: "john.doe@gmail.com",
                                         labelText: 'Full Names',
                                           focusedBorder: InputBorder.none,
                                           enabledBorder: InputBorder.none,
                                           errorBorder: InputBorder.none,
                                           disabledBorder: InputBorder.none,
                                         focusedErrorBorder: InputBorder.none,
                                         border: InputBorder.none,
                                         // contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                  )),
                                ),

                                new Icon(Icons.arrow_forward_ios,size: 20, color: Colors.grey,)

                              ],
                            ),
                          )
                      ),
                      SizedBox(height: 10,),
                      new Container(
                          width: MediaQuery.of(context).size.width * .84,
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide( width: 1, color: Color(0xff6C1682), style: BorderStyle.solid)
                              )),

                          child: Padding(
                            padding: const EdgeInsets.only(right: 20,left: 20),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                new Flexible(
                                  child: new TextFormField(
                                      controller: _email,
                                      validator: (value){
                                        if(value.isEmpty){
                                          return "please enter Email Adress";
                                        }

                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: "Email Adress",
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        focusedErrorBorder: InputBorder.none,
                                      )),
                                ),

                                new Icon(Icons.arrow_forward_ios,size: 20, color: Colors.grey,)

                              ],
                            ),
                          )
                      ),
                      SizedBox(height: 10,),
                      // new Container(
                      //     width: MediaQuery.of(context).size.width * .84,
                      //     height: 50,
                      //     decoration: BoxDecoration(
                      //         border: Border(
                      //             bottom: BorderSide( width: 1, color: Color(0xff6C1682), style: BorderStyle.solid)
                      //         )),
                      //
                      //     child: Padding(
                      //       padding: const EdgeInsets.only(right: 20,left: 20),
                      //       child: new Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           new Flexible(
                      //             child: new TextFormField(
                      //                 controller: _phone,
                      //                 validator: (value){
                      //                   if(value.isEmpty){
                      //                     return "please enter Phone Number";
                      //                   }
                      //
                      //                   return null;
                      //                 },
                      //                 decoration: const InputDecoration(
                      //                   hintText: "Phone Number",
                      //                   focusedBorder: InputBorder.none,
                      //                   enabledBorder: InputBorder.none,
                      //                   errorBorder: InputBorder.none,
                      //                   disabledBorder: InputBorder.none,
                      //                   focusedErrorBorder: InputBorder.none,
                      //                 )),
                      //           ),
                      //
                      //           new Icon(Icons.arrow_forward_ios,size: 20, color: Colors.grey,)
                      //
                      //         ],
                      //       ),
                      //     )
                      // ),
                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }



  onImageUPload(ImageSource source,{BuildContext context, captureImage}) async{

    final _picker = ImagePicker();
    File cropedImage;

    final pickedImage  = await _picker.getImage(
        source: source,
       imageQuality: 50
    );

    cropedImage = await ImageCropper.cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 50,
        maxHeight: 700,
        maxWidth: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.white,
          toolbarTitle: "PadShare",
        )

    );
    print("cropper ${cropedImage.runtimeType}");
    debugPrint("cropper-Image  ${cropedImage.path}");
    var filename = basename(cropedImage.path);
    debugPrint("-Image  $filename");
    setState(() {
      _image = cropedImage ?? pickedImage;
      imagefileName = filename;
    });



    return cropedImage.path;
  }
  uploagImageToFirebase(context)async {
    setState(() {
      isUploading = true;
    });
    if (_image != null) {
      // isLoading ?showProgressDialog(context) :  Navigator.of(context, rootNavigator: true).pop();
      var snapshort = await _storage
          .ref().child("userpictures/user_post$postId.jpg")    // .ref().child("userpictures/$imagefileName")
          .putFile(_image)
          .whenComplete(() {
        print("compeleted Upload");

        setState(() {
          isUploading = false;
        });
      });

      var downloadUrl = (await snapshort.ref.getDownloadURL()).toString();
      // if(_auth.currentUser != null){
      //
      // }
      print("Downloadableurl");

      setState(() {
        imageFile = downloadUrl;
        _progress = snapshort.bytesTransferred.toDouble() /
            snapshort.totalBytes.toDouble();
      });


      print(downloadUrl);
    } else {
      print("Error UPloading File TO FIRE STORE");
      // createPost(_message.text.trim(),_title.text.trim()).then((value) {
      //
      // setState(() {
      // _message.text = "";
      // _image.delete();
      // });
      // });
      // }

    }

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
    });
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
              new Text("updating..", style: GoogleFonts.roboto(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 2), () {



      Navigator.of(context,rootNavigator: true).pop();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 4,)), (Route<dynamic> route) => false
      );
      // RestartWidget.restartApp(context);

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