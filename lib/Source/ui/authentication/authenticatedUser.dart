
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:padshare/Source/ui/IntroScreens/ScreenOne.dart';
import 'package:padshare/Source/ui/IntroScreens/ScreenTwo.dart';
import 'package:padshare/Source/ui/newsFeed/newDetails.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/ui/tabs/tabs_page.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
import 'package:padshare/Source/widgets/DotIndicator.dart';
import 'package:padshare/main.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthenticatedUser extends StatefulWidget{

  @override
  _AuthenticatedUserState createState() => _AuthenticatedUserState();
}

class _AuthenticatedUserState extends State<AuthenticatedUser> {
  final PageController _controller = PageController();
  final List<Widget> _pages = [
    ScreenOne(),
    ScreenTwo(),
    // new ConstrainedBox(
    //     constraints: const BoxConstraints.expand(),
    //     child:  new Container( color: Colors.purple,)
    // )
  ];

  String token;

  void _pageChanged(int index) {
    setState(() {});
  }

  // IntroScreen()
  bool isAuth = false;
  var storage = FlutterSecureStorage();
  Scaffold buildUnAuthScreen(){
    return new Scaffold(
        body: new Container(
          child: new Stack(
            children: [
              new PageView.builder(
                  controller: _controller,
                  physics: new AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index){
                    return  _pages[index % _pages.length];
                  },
                  onPageChanged: _pageChanged
              ),

              Positioned(
                bottom: 130,
                left: 0,
                right: 0,
                child:  new Container(
                  padding: const EdgeInsets.all(20),
                  child: new Center(
                      child: Indicator(
                        controller: _controller,
                        itemCount: _pages.length,
                      )
                  ),
                ),

              )
            ],
          ),
        )
    );
  }

  // buildAuthScreen(){
  //   return new Text("Authenticated");
  // }

  buildAuthScreen(){
    return new NewsFeed(selectedId: 0); //TabsPage(selectedIndex: 0); //NewsFeed();
   //  return NewDetails();
  }

  gettoken()async{
    // await storage.write(key: "token", value: token);
   var tokens =  await storage.read(key: "token");
   setState(() {
     token = tokens;
   });
  }

   @override
  void initState() {
    // TODO: implement initState
      FIREBASE_FCM.FCMGetTOKEN();
      gettoken();
     if(_auth.currentUser != null){
       setState(() {
         isAuth = true;
       });
       // storage.read(key: "token");
     }else{
       setState(() {
         isAuth = false;
       });
     }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // print("TOKEN : ${token}");
    _firestore.collection('UsersTokens').doc(_auth.currentUser.uid).update({
      'user_token': token
    });
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}