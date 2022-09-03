import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padshare/Source/ui/Pages/all_users/users.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/utils/Notifications/notificationservice.dart';
import 'package:padshare/main.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseStorage _storage = FirebaseStorage.instance;

class CreatePost extends StatefulWidget{
  @override
  _CreatePostState createState() => _CreatePostState();
}



class _CreatePostState extends State<CreatePost> {
  final TextEditingController _message = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var name = _auth.currentUser.displayName[0];
  String postId = Uuid().v4();

  var imageFile;
  var imagefileName;
 bool isUploading = false;

  File _image;
  File _sampleFile;
  File _lastCroped;

  bool isLoading = false;

  var picture;

  var _progress;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    print(Offset(0.0, -1.0).distanceSquared - Offset(0.0, 0.0).distanceSquared);
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Color(0xffF4F6FE),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        key: _scaffoldKey,
        child: SingleChildScrollView(
          child: Column(
            children: [

              new Container(
                width: MediaQuery.of(context).size.width,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xffffffff)
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    new Row(
                      children: [
                        InkWell(
                            onTap: (){
                              // RestartWidget.restartApp(context);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 0,))
                              );
                            },
                          child: Container(width: 35, decoration: BoxDecoration( color: Colors.greenAccent), child: new Icon(Icons.arrow_back, size: 30, color: Colors.white,),)
                        ),
                        SizedBox(width: 10,),
                        new Text("Create post", style: GoogleFonts.roboto(fontSize: 12, color: Color(0xff692CAB),fontWeight: FontWeight.w300),)
                      ],
                    ),
                      new Text(
                        "", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 12, fontWeight: FontWeight.bold),
                      )
                    // new Text(
                    //   "Share", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 12, fontWeight: FontWeight.bold),
                    // )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:14.0, right: 14, left: 14 , bottom: 5),
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: _image == null ? 300: 400,
                  decoration: BoxDecoration(
                      color: Color(0xffffffff),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 8,
                        )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:20.0, bottom: 10, right: 20,left: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // new Text("Title of story", style: GoogleFonts.roboto(
                          //   color: Color(0xff3E4347),
                          //   fontWeight: FontWeight.bold,
                          //   fontSize: 15,
                          //
                          // ),),
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Container(
                                height:33,
                                width: 33,
                                child:_auth.currentUser.photoURL==null ? Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Center(child: Text(name.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.w500),),),
                                  ),
                                ) : Image.network(_auth.currentUser.photoURL)),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new Text(_auth.currentUser.displayName, textAlign: TextAlign.center,),
                              )
                            ],
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          // Padding(
                          //
                          //   padding: const EdgeInsets.only(left: 20),
                          // child: new TextFormField(
                          //   controller: _title,
                          //   validator: (value){
                          //      if(value.isEmpty){
                          //        return "please provide Title";
                          //      }
                          //      return null;
                          //   },
                          //   decoration: InputDecoration(
                          //       hintText: "provide title",
                          //       focusedBorder: InputBorder.none,
                          //       enabledBorder: InputBorder.none,
                          //       errorBorder: InputBorder.none,
                          //       disabledBorder: InputBorder.none,
                          //       fillColor: Colors.deepPurpleAccent.withOpacity(0.02),
                          //       filled: true,
                          //       hintStyle: GoogleFonts.roboto(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)
                          //
                          //   ),
                          // ),
                          // ),

                          Container(
                            height:_image == null ? 120 : 91,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20, ),
                              child: TextFormField(
                                controller: _message,
                                maxLines: _image == null ? 15 : 10,
                                validator: (value){
                                 // if(value.isEmpty){
                                 //   return "please provide a Post..";
                                 // }
                                 return null;
                                },
                                decoration: InputDecoration(
                                    hintText: "What do you want to share?",
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),

                                  hintStyle: GoogleFonts.roboto(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height:_image == null ? 70 : 200,
                            child: Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.cover,
                                        image: _image == null ? AssetImage("assets/images/h.png") : FileImage(_image)
                                    )
                                ),
                              ),
                            ),

                          ),
                          Padding(
                            padding: const EdgeInsets.only(left:10.0, top: 8),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               new Row(
                                 children: [
                                   InkWell(
                                       onTap: (){
                                         onImageUPload(ImageSource.camera);
                                       },
                                        child: SvgPicture.asset("assets/images/camera.svg",width: 20,height: 20,)),
                                   SizedBox(width: 8,),
                                   InkWell(
                                       onTap: (){
                                         onImageUPload(ImageSource.gallery);
                                       },
                                       child: SvgPicture.asset("assets/images/picture.svg",width: 20, height: 20,)),
                                   SizedBox(width: 8,),
                                   Container(
                                     width: MediaQuery.of(context).size.width * 0.35,
                                     child: Row(
                                       children: [
                                         Flexible(child: new Text(_image == null ? "upload Image" : imagefileName.toString(), style: GoogleFonts.roboto(color: Colors.black87, fontSize: 10, fontWeight: FontWeight.w200),overflow: TextOverflow.ellipsis,)),
                                       ],
                                     ),
                                   )
                                 ],
                               ),
             //                    InkWell(
             //                        onTap: () async {
             //
             //                        },
             // child: SvgPicture.asset("assets/images/send.svg")),
                                FlatButton(
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onPressed: isUploading ? null : () => handleSubmit(context), child:
                                new SvgPicture.asset("assets/images/send.svg")
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),


            isUploading ? LinearProgressIndicator() :  Padding(
            padding: const EdgeInsets.only(right: 20, left: 20),
            child: LinearProgressIndicator(
              backgroundColor:_progress== null? Color(0xffF4F6FE) : Colors.deepPurple,
              value: _progress == null ? 0 : _progress,
            ),
          ),

              // Text(_progress == null ? "" : 'Uploaded ${(_progress * 100).toStringAsFixed(2)} %'),

            ],
          ),
        ),

      ),

      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.a,
        activeIcon: Icons.close,
        icon: Icons.add,
        buttonSize: Size(40,40),
        children: [
          SpeedDialChild(
              child:Icon(Icons.person_add_alt),
              label: "Users",
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=> Users()),
                );
              }
          ),
          SpeedDialChild(
              child:Image.asset("assets/images/addStory.png", height: 20,width:20,),
              label: "Add Story",
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=> CreatePost()),
                );
              }
          )
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: "btn1",
      //   backgroundColor: Colors.cyan,
      //   onPressed: (){
      //     Navigator.of(context).push(
      //       MaterialPageRoute(builder: (_)=> CreatePost()),
      //     );
      //   },
      //   child: Icon(Icons.add, size: 30, color:Colors.white38),
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
   uploagImageToFirebase(context)async {
    setState(() {
      isLoading = true;
    });
     if (_image != null) {
      // isLoading ?showProgressDialog(context) :  Navigator.of(context, rootNavigator: true).pop();
       var snapshort = await _storage
           .ref().child("postMediaFiles/user_post$postId.jpg")    // .ref().child("userpictures/$imagefileName")
           .putFile(_image)
           .whenComplete(() {
         print("compeleted Upload");
         // createPost(message: _message.text.trim(), mediaUrl: "").then((value) {
         //   setState(() {
         //     _message.text = "";
         //     isLoading = false;
         //   });
         //   Navigator.of(context).pushReplacement(
         //       MaterialPageRoute(
         //           builder: (_) => NewsFeed()
         //       )
         //   );
         // });
         setState(() {
           isLoading = false;
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

  void FCMSENDMESSEG()async{
    try{
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers:<String, String>{
          'Content-Type': 'application/json',
          'Authorization' : 'key=AAAAaY4xDEY:APA91bFsqGzpFfm7fq-fq6jhd90EjsKUDrwKRhGluFbv8901FBlYYVll0lvJpJZNR_olOMlLcOOQ-A_e2lLKDQkaZdR5FkhHYHE2FVY7swi7q-2GxLerwMLzv2VNu418jjvgv95QoVZT',
        },
        // body:jsonEncode(
        //   <String, dynamic>{
        //     'notification': <String, dynamic>{
        //       'body': 'Text',
        //       'title': 'Test Title',
        //     },
        //     'priority': 'high',
        //     'data': <String, dynamic>{
        //       'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        //       'id': '1',
        //       'status': 'done'
        //     },
        //     'to': '/topics/Users/',
        //   }
        // )
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'you have new post from ${_auth.currentUser.displayName}',
              'title': 'message'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "/topics/MessagesToSend",
          },
        ),
      );

    }catch(e){
      print(e);
      print("error push notification ::$e");
    }
  }

  handleSubmit(context) async {
    setState(() {
      isUploading = true;
    });

    await uploagImageToFirebase(context);
    await createPostInFirestore(
      message: _message.text.trim(),
      mediaUrl: imageFile,
    );
    _message.clear();
    setState(() {
      imageFile = null;
      _image  = null;
      isUploading = false;
      isLoading = false;
      postId = Uuid().v4();
    });
    var id = Random();
    var notificationid = id.nextInt(30000);
    // NotificationService().showNotification(notificationid, "New Message", "you have new posts from ${_auth.currentUser.displayName}", 3);
      FCMSENDMESSEG();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> NewsFeed(selectedId: 0,)),
              (Route<dynamic> route) => false

      );

      // RestartWidget.restartApp(context);
  }
  createPostInFirestore({String message, String mediaUrl}) async {

    await _firestore
        .collection('post')
        .doc(_auth.currentUser.uid)
        .collection('userPosts')
        .doc(postId)
        .set(
         {
            "postId": postId,
            "ownerId": _auth.currentUser.uid,
            "username" : _auth.currentUser.displayName,
            "phone":_auth.currentUser.phoneNumber,
            "userProfile": _auth.currentUser.photoURL,
            "mediaUrl": mediaUrl,
            "message": message,
            "timestamp": Timestamp.now(),
            "isPostSelected" : false,
            "activePost": 1,
            "shares" : {},
            "likes":0

         },SetOptions(merge: true)
    );

    await _firestore
        .collection('allposts')
        .doc(postId)
        .set(
        {
          "postId": postId,
          "ownerId": _auth.currentUser.uid,
          "username" : _auth.currentUser.displayName,
          "userProfile": _auth.currentUser.photoURL,
          "phone":_auth.currentUser.phoneNumber,
          "mediaUrl": mediaUrl,
          "message": message,
          "timestamp": Timestamp.now(),
          "isPostSelected" : false,
          "activePost": 1,
          "shares" : {},
          "likes":0

        },SetOptions(merge: true)
    );
    await _firestore
        .collection('comments')
        .doc(postId)
        .set(
        {
          "postId": postId,
          "ownerId": _auth.currentUser.uid,
          "comment":[],
          "likes" : {}

        },SetOptions(merge: true)
    );
  }


  Future<void> createPost({String message, String mediaUrl}) async{
       print(_auth.currentUser.uid);
     if(_auth.currentUser != null){

       await _firestore
           .collection('posts')
           .doc(_auth.currentUser.uid)
           .set({

         "user":_auth.currentUser.displayName,
         "phone":_auth.currentUser.phoneNumber,
         "posts": [],
       },SetOptions(merge: true))
           .then((result)async{
         // await  _auth.currentUser.updateProfile(
         //     photoURL: imageFile.toString() ?? ""
         // );
         setState(() {
           isLoading = false;

         });
         //  displaySnackBar("Posted Successfully..");
       } ).catchError((onError) =>{
         debugPrint('Error saving userPost' + onError.toString()),
          // displaySnackBar("Error Posting..")
       });
        // print("IMAGETEXT" + " " + imageFile ?? "");
      await  _firestore
          .doc(_auth.currentUser.uid)
          .collection('posts')
          .doc(_auth.currentUser.uid)
           .update(
           {
              "message":FieldValue.arrayUnion(
                  [{
                     'message': message,
                     'picture': imageFile,
                     'timestamp':new DateTime.now(),
                     'user':_auth.currentUser.phoneNumber,
                  }]
              )
             // "posts": FieldValue.arrayUnion([{
             //   "message":message,
             //   "picture":imageFile,
             //   "timestamp" : new DateTime.now()}])
           }
       ).then((value){
        message = "";
      });
     }else{
       //displaySnackBar("No User Available..");
     }

  }


  displaySnackBar(text) {
    final snackBar = SnackBar(content: Text(text));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
  Future<void> UploadImage() async{
    PickedFile simage = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
       File image = File(simage.path);
    setState(() {
      _image = image;
    });


    if(_image != null ){
      // uploadImageFile(_sampleFile.path);
    }

    print(_image);

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


  Widget progressIndictor() {

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        new Text('posting...', style: GoogleFonts.roboto(color: Colors.grey, fontSize: 8),),
        JumpingDotsProgressIndicator(
          fontSize: 20.0,
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
  isLoading ?  showDialog(
       barrierColor: Colors.white.withOpacity(0),
       barrierDismissible: false,
       context: context, builder: (BuildContext context){
     return WillPopScope(child: alert, onWillPop: (){},);
   }) :  Navigator.of(context, rootNavigator: true).pop();
  }




}




