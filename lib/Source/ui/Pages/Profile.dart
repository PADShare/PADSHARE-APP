import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/all_users/users.dart';
import 'package:padshare/Source/ui/Pages/invitations/user_invitations.dart';
import 'package:padshare/Source/ui/Pages/updateUser.dart';
import 'package:padshare/Source/ui/Teams/team.dart';
import 'package:padshare/Source/ui/newsFeed/CreatePost.dart';
import 'package:padshare/Source/ui/newsFeed/detailpage.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/utils/DataController.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:padshare/Source/utils/Notifications/notificationservice.dart';
import 'package:padshare/Source/widgets/user_posts_single/single_user_post.dart';
import 'package:uuid/uuid.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;


class UserProfile extends StatefulWidget{

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var username ;
  var cellnumber;
  var dob;
  var email;
  var location;
  var name = _auth.currentUser.displayName[0];
  var totaluser = 0;
  var totalDonations;

  bool isloading = true;

  DataController _controller = DataController();
  GlobalKey<FormState>_formKey = new GlobalKey<FormState>();
  TextEditingController _controllerTeam =  TextEditingController();
  var teamId = Uuid().v1();

  List<QueryDocumentSnapshot> posts;

  Map<String, dynamic> userrequests;

  List<QueryDocumentSnapshot> userPosts;

  List friends = [];

  List<QueryDocumentSnapshot> userFriendsPosts = [];

  var idd;
  @override
  void initState() {
    // TODO: implement initState
    loadings();
    gettotalUserPosts();
    getCurrentUser();
    gettotalUsers();
    getuserFriends();
    super.initState();
    tz.initializeTimeZones();

  }



  gettotalUsers()async{
    _firestore.collection('post')
        .doc(_auth.currentUser.uid)
        .collection('userPosts').get().then((result){
          print("USER_POSTS");
          print(result.docs.length);
          setState(() {
            totaluser = result.docs.length;
            posts = result.docs;
          });
          Future.delayed(Duration(seconds: 2)).then((value){
            setState(() {
              isloading = false;
            });
          });
    });

  _firestore.collection('donations')
      .doc(_auth.currentUser.uid)
      .collection('UserDonations').get()
      .then((value){
        setState(() {
          totalDonations = value.docs.length;
        });
  });

  }


  getuserFriends() async{
    if(_auth.currentUser != null){


      if(kDebugMode){
        debugPrint("GETUSER:: entered IF" );
      }

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      await _firestore
          .collection("users")
          .doc(_auth.currentUser.uid)//.where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result){


        if(kDebugMode){
          debugPrint("GETUSER:: TRUE" );
          print("RES : ${result.data()}");
        }


        // if (result.docs.length > 0) {
        //   debugPrint("GETUSER:: TRUE" );
        //   debugPrint("GETUSER:: TRUE :::" + result.docs.single.data()['location']);
        setState(() {
          print(result.data()['name']);
          userrequests = result.data();
          // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
        });

      });

      if(userrequests['friends'] != null) {
        print("USER_IDS ${userrequests['friends']}");
        var ids = userrequests['friends'];
        for(var id in ids )
          // print(id);
          // print(id);

          await _firestore
              .collection("post")
              .doc(id) //.where('cellnumber', isEqualTo: cellNumber)
              .collection('userPosts')
              .get()
              .then((result){
            setState(() {
              userFriendsPosts = result.docs.toList();
              idd = id;
            });

            var UID = {
              "uid" : id
            };

            friends.add(userFriendsPosts);
          });
      }
      // }
    }}

 bool loading = true;
  loadings(){
    Future.delayed(Duration(seconds: 3)).then( (ers){

       setState(() {
         loading = false;
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // print("users ${userFriendsPosts[0].data()}");
     print("DF ${idd}");
     return loading == true ? Center(
         child: SpinKitDoubleBounce(
             size: 54,
             color: Colors.cyan
         )
     ) :  new Scaffold(
      backgroundColor: Color(0xffF4F6FE),
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        backgroundColor: Colors.white54,
        elevation: 0,
        // leading: new FlatButton(onPressed: null, child: new Icon(Icons.arrow_back,color: Color(0xff6C1682),)),
        title: Center(child: new Text("", style: GoogleFonts.roboto(color: Color(0xff6C1682), fontSize: 18, fontWeight: FontWeight.w600), textAlign: TextAlign.center,)),
        actions: [
          GestureDetector(
            onTap: (){
              // NotificationService().showNotification(1, "New Message", "you have new posts from ${_auth.currentUser.displayName}", 3);

              // NotificationService().showNotification(1, "Text NO", "body", 5);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=> UserInvitations())
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0),
              child: Icon(Icons.person_add_alt,size: 30,color: Color(0xb56c1682),),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(
                    maintainState: true,
                    builder: (_)=> UpdateUser())
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: SvgPicture.asset("assets/images/proIcon.svg", width: 22, height: 22,),
            ),
          )
        ],
      ),
      body: loading ? Center(
        child: SpinKitDancingSquare(
          size: 54,
          color: Colors.cyan
        )
      ) :SingleChildScrollView(
        child: Column(

          children: [
            new Container(
              width: MediaQuery.of(context).size.width,
              height: 280,
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
                  SizedBox(height: 15,),
                  new Padding(padding: const EdgeInsets.only(top: 60),
                  child: new Container(
                    width: 80,
                    height: 80,
                    child: _auth.currentUser.photoURL==null ? Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Center(child: Text(name.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.w500),),),
                      ),
                    ) : Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: NetworkImage(_auth.currentUser.photoURL),
                            fit: BoxFit.cover
                          )
                      ),
                    ),
                  ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:2.0),
                    child: new Text(username ?? '',style: GoogleFonts.roboto(color:Color(0xff666363), fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  new Text(_auth.currentUser.phoneNumber != null ? _auth.currentUser.phoneNumber: ''),

                  SizedBox(
                    height: 21,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 40,left: 40),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        new Column(
                          children: [
                            new Text("Donations", style: TextStyle(fontFamily: 'Gotham', fontSize: 12,color: Color(0xff666363)),),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(totalDonations.toString(), style: TextStyle(fontFamily: 'Gotham', fontSize: 18,color: Color(0xff666363), fontWeight: FontWeight.w700),),
                            )
                          ],
                        ),

                        new Column(
                          children: [
                            new Text("Stories", style: TextStyle(fontFamily: 'Gotham', fontSize: 12,color: Color(0xff666363)),),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text(totaluser.toString(), style: TextStyle(fontFamily: 'Gotham', fontSize: 18,color: Color(0xff666363), fontWeight: FontWeight.w700),),
                            )
                          ],
                        ),

                        new Column(
                          children: [
                            new Text("Pad credit", style: TextStyle(fontFamily: 'Gotham', fontSize: 12,color: Color(0xff666363)),),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: new Text("0", style: TextStyle(fontFamily: 'Gotham', fontSize: 18,color: Color(0xff666363), fontWeight: FontWeight.w700),),
                            )
                          ],
                        )
                      ],
                    ),
                  )

                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right:16.0, left:16, top:16),
              child: new Container(
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(padding: const EdgeInsets.only(top: 10 , right: 40,left: 40),
                      child: new Column(
                        children: [
                          new Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  child: Icon(Icons.mail_outline_rounded, size: 15, color: Colors.deepPurple,),),
                              ),
                              new Text(email ?? '', style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Color(0xff666363), fontSize: 12),)
                            ],
                          ),
                          new Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  child: Icon(Icons.calendar_today_rounded, size: 15, color: Colors.deepPurple,),),
                              ),
                              new Text(dob ?? '', style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Color(0xff666363), fontSize: 12),)
                            ],
                          ),
                          new Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  child: Icon(Icons.home_filled, size: 15, color: Colors.deepPurple,),),
                              ),
                              new Text(location ?? '', style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Color(0xff666363), fontSize: 12),)
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only( top: 8 ),
              child: new Text("User Posts:", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 15, fontWeight: FontWeight.w300, decoration: TextDecoration.underline),),
            ),
            Container(
              color: Colors.lightBlueAccent.withOpacity(0.1),
              // height: MediaQuery.of(context).size.height * 0.25,

              child: isloading ? Center(child: CircularProgressIndicator(),) :
              Column(
                children: [
                  Card(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: posts.length,
                      itemBuilder: (_, index){

                        Timestamp time = posts[index]['timestamp'];
                        final DateTime docDateTime = DateTime.parse(time.toDate().toString());
                        //var date =  DateFormat('EEE, MMM d, ''yy').format(docDateTime);
                        var date = DateFormat.yMMMMd('en_US').format(docDateTime);
                        print("TEST $date");

                        return SingleUserPost(userpost:posts[index] ,);

                        // return new Column(
                        //   children: [
                        //     SingleUserPost(userpost:posts[index] ,),
                        //     // Padding(
                        //     //   padding: const EdgeInsets.only(top:16.0, right: 16, left: 16),
                        //     //   child: ListTile(
                        //     //     leading: new Container(
                        //     //       height: 100,
                        //     //       width: 80,
                        //     //       decoration: BoxDecoration(
                        //     //           color: Colors.grey[200],
                        //     //           image: DecorationImage(
                        //     //               image: NetworkImage(posts[index]['mediaUrl']),
                        //     //               fit: BoxFit.cover
                        //     //           )
                        //     //       ),
                        //     //     ),
                        //     //     title: new Text(posts[index]['message']),
                        //     //     subtitle: new Text("Date posted: $date"),
                        //     //   ),
                        //     // ),
                        //     Divider()
                        //   ],
                        // );
                      },
                    ),
                  ),
                  userFriendsPosts == null ? Container(
                    height: 100,
                    child: Center(child: Text("No posts for this User"))
                  )  : Card(
                    child: ListView.builder(
                      shrinkWrap: true,
                      primary: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: userFriendsPosts == null ? 0 : userFriendsPosts.length,
                      itemBuilder: (_, index){
                        print(userFriendsPosts[index]);

                        var ids = userFriendsPosts[index].data()['ownerId'];

                        //Timestamp time = friends[index]['timestamp'];
                       // final DateTime docDateTime = DateTime.parse(time.toDate().toString());
                        ////var date =  DateFormat('EEE, MMM d, ''yy').format(docDateTime);
                       // var date = DateFormat.yMMMMd('en_US').format(docDateTime);
                       // print("TEST $date");

                        // return Text("data");

                        return ids == _auth.currentUser.uid ?
                        Container(
                            height: 100,
                            child: Center(child: Text("No posts on your connections"))
                        )
                            :SingleUserPost(userpost: userFriendsPosts[index] ,);

                        // return new Column(
                        //   children: [
                        //     SingleUserPost(userpost:posts[index] ,),
                        //     // Padding(
                        //     //   padding: const EdgeInsets.only(top:16.0, right: 16, left: 16),
                        //     //   child: ListTile(
                        //     //     leading: new Container(
                        //     //       height: 100,
                        //     //       width: 80,
                        //     //       decoration: BoxDecoration(
                        //     //           color: Colors.grey[200],
                        //     //           image: DecorationImage(
                        //     //               image: NetworkImage(posts[index]['mediaUrl']),
                        //     //               fit: BoxFit.cover
                        //     //           )
                        //     //       ),
                        //     //     ),
                        //     //     title: new Text(posts[index]['message']),
                        //     //     subtitle: new Text("Date posted: $date"),
                        //     //   ),
                        //     // ),
                        //     Divider()
                        //   ],
                        // );
                      },
                    ),
                  ),
                ],
              ),),
            SizedBox(height: 30,)
          ],
        ),
      ),
      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.a,
        activeIcon: Icons.close,
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child:Icon(Icons.person_pin),
              label: "Friends",
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=> UserInvitations()),
                );
              }
          ),
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
              child:Image.asset("assets/images/management.png", height: 20,width:20,),
              label: "Add Team",
              onTap: (){
                showDiaLogs();
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



  Future<void> getCurrentUser() async{

    debugPrint("GETUSER:: entered" );

    if(_auth.currentUser != null){
      var cellNumber = _auth.currentUser.phoneNumber;
      debugPrint("GETUSER:: entered IF" );
      print("Entered HET");
      // print(cellNumber);
         //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
         //    debugPrint(cellNumber);
         await _firestore
                .collection("users")
                .doc(_auth.currentUser.uid)//.where('cellnumber', isEqualTo: cellNumber)
                .get()
                .then((result){
           debugPrint("GETUSER:: TRUE" );

             // print(result.data()['email']);
           // if (result.docs.length > 0) {
           //   debugPrint("GETUSER:: TRUE" );
           //   debugPrint("GETUSER:: TRUE :::" + result.docs.single.data()['location']);
             setState(() {
                // print(result.data()['name']);
                // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
               username = result.data()['name'];
               email = result.data()['email'];
               location = result.data()['location'];
               dob = result.data()['DOB'];
             });

          });
    }


  }

  Future<void> gettotalUserPosts() async{
     _firestore.collection("post")
         .get().then((QuerySnapshot snapshot){
                       // print("DDDDDAAAAADDD");
                       // print(value);
                      // value.data().forEach((value) => print(value));
                   snapshot.docs.map((DocumentSnapshot doc){
                     print("DDDDDAAAAADDD");
                     print(doc.data());
                   });

                 });
  }

  void NavigateToDetailPage(DocumentSnapshot posts) {

    Navigator.of(context).push(
        MaterialPageRoute(builder: (_)=> DetailsPage(userpost: posts))
    );
  }

  Widget showDiaLogs(){
    BuildContext dialogContext;
    AlertDialog alertDialog = AlertDialog(
      contentTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54),
      title: Center(child: Text("Create a Team")),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      content: Container(
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Center(child: Text("Create a team.to add your Friends ", textAlign: TextAlign.center,)),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Form(
                key: _formKey,
                child: new TextFormField(
                  controller: _controllerTeam,
                  validator: (value){
                    if(value.isEmpty){
                      return "please add a team";
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Add team",
                      labelStyle: TextStyle(fontSize: 16,color: Color(0xff8A8A8C), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),
                      fillColor: Color(0xffE5E5E5),
                      filled: true,
                      contentPadding: const EdgeInsets.only(top: 10,left: 30,right: 15, bottom: 10),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide(
                              color: Color(0xffcecaca)
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color(0xffE5E5E5),
                              width: 1
                          )
                      ),
                      prefixIcon: Icon(Icons.add, size: 20,)
                  ),
                ),
              ),
            ),
            SizedBox(height: 30,),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                color:Colors.cyan,
              ),
              child: Center(child: Text("Add",style: TextStyle(color: Colors.white)))),
          onPressed: () {
            // Navigator.of(context).pop();
            //  Navigator.pop(context);

            if(_formKey.currentState.validate()){

              createteams(dialogContext,team: _controllerTeam.text);




              var snakBar = SnackBar(content: Text('The team created is ${_controllerTeam.text}', style: TextStyle(color: Colors.cyan),),);

              Scaffold.of(context).showSnackBar(snakBar);
              setState(() {
                _controllerTeam.text = "";
              });
              // Navigator.pop(dialogContext, false);
              // Navigator.of(context, rootNavigator: true).pop('dialog');
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 4,))
              );
            }




            // Navigator.push(context, MaterialPageRoute(builder: (_)=>ManageAddress()));
          },
        ),
        TextButton(
          child: Container(
              height: 40,
              width: 60,
              decoration: BoxDecoration(
                color:Colors.black54,
              ),
              child: Center(child: Text("CANCEL", style: TextStyle(color: Colors.white54),))),
          onPressed: () {

            // Navigator.of(context, rootNavigator: true).pop('dialog');

            Navigator.pop(dialogContext, false);



            // RestartWidget.restartApp(context);

            // Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsFeed()));
          },
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      dialogContext = context;
      return alertDialog;
    });

  }
  createteams( context,{String team}){
    _firestore.collection("teams").doc(teamId).set({
      "teamName": team,
      "teamId" : teamId,
      "postCount" : 0,
      "userId":_auth.currentUser.uid,
      "Usersteam" : {}
    }).then((value){

      var uuid  = _firestore.collection('d').doc().id;
      print("AUTO UUID ${uuid}");
      _firestore.collection("userTeams").doc(teamId).collection("allUsers").doc(uuid).set({
        "s" : 0,
        "user": "autoIndex",
        "imageurl" : null,
        "uid": uuid
      });
      // setState(() {
      //   teamId = Uuid().v1();
      // });




    });
  }

}