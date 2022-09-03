import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/all_users/users.dart';
import 'package:padshare/Source/ui/Pages/invitations/user_groups.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
import 'package:padshare/Source/widgets/checkout_core/rounded_borders.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_detail_profile.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_friends_profile.dart';
import 'package:padshare/Source/widgets/transitions/hero_dialog_route.dart';
import 'package:http/http.dart' as http;

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
const TextStyle boldText = TextStyle(
  fontWeight: FontWeight.bold,
);
class UserInvitations extends StatefulWidget {
  const UserInvitations({Key key}) : super(key: key);

  @override
  State<UserInvitations> createState() => _UserInvitationsState();
}

class _UserInvitationsState extends State<UserInvitations> {
  Map<String, dynamic> userrequests;

  Map<String, dynamic> userData;

  var res;

  List friends = [];
  List d = [];

  var teamrequests;

  var myTeamRes;

  var token;

  var user_send_token;





  getuser() async{
    if(_auth.currentUser != null){


      if(kDebugMode){
        debugPrint("GETUSER:: entered IF" );
      }

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      await _firestore
          .collection("users")
          .doc(_auth.currentUser.uid) //.where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result){


        if(kDebugMode){
          debugPrint("GETUSER:: TRUE" );
          print(result.data());
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

      if(userrequests['requests'] != null) {
        print("USER_IDS ${userrequests['requests']}");
        var ids = userrequests['requests'];
        for(var id in ids )
          // print(id);
         // print(id);
          await _firestore
              .collection("users")
              .doc(id)//.where('cellnumber', isEqualTo: cellNumber)
              .get()
              .then((result){
               setState(() {
                 userData = result.data();
               });

               var UID = {
                 "uid" : id
               };

               userData.addAll(UID);
               d.add(userData);
                   });
      }
    // }
  }}

  getTeamInvites() async{
    if(_auth.currentUser != null){


      if(kDebugMode){
        debugPrint("GETUSER:: entered IF" );
      }

      await _firestore
          .collection("users")
          .doc(_auth.currentUser.uid) //.where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result){
            setState(() {
              userrequests = result.data();
              user_send_token = userrequests['user_token'];
            });
            // print(result.data())
      });

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      print("User_Team_1 ${userrequests}");
      print("User_Team ${userrequests['teams']}");
      print("senders_token ${userrequests['user_token']}");
      var response = userrequests['teams'];

         for(var teamid in response)
            // print("team ${teamid}");
           // arrayContains: {"uid":_auth.currentUser.uid}
    // .where("Usersteam.uid",arrayContains:_auth.currentUser.uid )
      await _firestore
          .collection("userTeams")
          // .where("teamId", isEqualTo:  teamid  )
          .doc(teamid)
          .collection("allUsers")
          .doc(_auth.currentUser.uid)
          .get()//.where('cellnumber', isEqualTo: cellNumber)

          .then((result){


        if(kDebugMode){
          debugPrint("TEAMREQUEST:: TRUE" );
          print(result.data());
        }

        setState(() {
          print(" TEAMREQUEST _${result.data()}");
           teamrequests = result.data();
          // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
        });

      });

      print("USER_TEA_ ${teamrequests}");


        // for (var teams in teamrequests){
        //    print("_S ${teams.data()}");
        //    setState(() {
        //      myTeamRes = teams.data()['Usersteam'];
        //    });
        // }
       // print("ST _${myTeamRes}");
      var result = teamrequests;
      if(result['isMembers'] == false){
               d.add(result);
             }

      // myTeamRes.map((data) {
      //     // print("Data_ ${data['requests'][0]}");
      //     var result = data;
      //     print("Data_ ${data}");
      //
      //     if(result['uid'] == _auth.currentUser.uid){
      //      if(result['isMembers'] == false){
      //        d.add(result);
      //      }
      //
      //
      //     }
      //   }).toList();

    }}

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
          print(result.data());
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
              .collection("users")
              .doc(id)//.where('cellnumber', isEqualTo: cellNumber)
              .get()
              .then((result){
            setState(() {
              userData = result.data();
            });

            var UID = {
              "uid" : id
            };

            userData.addAll(UID);
            friends.add(userData);
          });
      }
      // }
    }}



  bool showRequests = false;

  @override
  void initState() {
    // TODO: implement initState
    getuser();
    super.initState();


    getTeamInvites();
    getuserFriends();

   // FIREBASE_FCM.FCMGetTOKEN();
    // FIREBASE_FCM.;
    FirebaseMessaging.instance.subscribeToTopic("MessagesToSend");
  }

  void FCMGetTOKEN()async{
    await FirebaseMessaging.instance.getToken().then((token)=> print("DEVICE_TOEKEN_ ${token}"));
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
              'body': 'Test Body',
              'title': 'Test Title 2'
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
  var storage = FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {

    print("PRUD ${token}");
    return new Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: InkWell(
                onTap: (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        maintainState: true,
                        builder: (_)=> Users()),
                  );
                },
                child: Icon(Icons.person_add, size: 30,)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FlutterSwitch(
              activeColor: Color(0xff00b18a),
              inactiveColor: Color(0xff692cab),
              activeText: "Friends",
              inactiveText: "Pending",
              width: 100,
              height: 35,
              toggleSize: 20,
              value: showRequests,
              borderRadius: 35,
              padding: 5,
              showOnOff: true,
              onToggle: (val){
                setState(() {
                  showRequests = val;
                });
              },

            ),
          ),

          // GestureDetector(
          //   onTap: ()async{
          //      // FCMSENDMESSEG();
          //     var token = await storage.read(key: "token");
          //
          //     print("USER_TOKEN ::${token}");
          //     // FIREBASE_FCM.FCMSAVETOKEN(token);
          //     FIREBASE_FCM.FCMSENDMESSEG(token, "am testing this NOTIFICATION", "NEW MESSAGE"," new test again here with me");
          //   },
          //     child: Icon(Icons.account_box_sharp, size: 60,))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            showRequests ? Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // color: Color(0xff00b18a)
                // color:Colors.black26
                  color: Color(0xff692cab)
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/PADSHARE-LOGO.png")
                        )
                    ),
                  ),

                  new Text("Friends",style: GoogleFonts.openSans(color:Colors.white, fontSize: 23, fontWeight: FontWeight.w400),),
                  new Text("Changing lives Together",style: GoogleFonts.openSans(color:Colors.blueGrey, fontSize: 13, fontWeight: FontWeight.w400),),

                ],
              ),
            ) : Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  // color: Color(0xff692cab)
                  color: Color(0xff00b18a)
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/message-icon.png")
                      )
                    ),
                  ),

                  new Text("Invitations",style: GoogleFonts.openSans(color:Colors.white, fontSize: 23, fontWeight: FontWeight.w400),),

                ],
              ),
            ),

            SizedBox(height: 20,),



          showRequests ?
          ListView.builder(
            itemCount: friends.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              var user = friends[index];
              return GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                      HeroDialogRoute(builder: (context) {
                        return FriendsProfile(userdata:_auth.currentUser, user:user);
                      }));
                },
                child: ListTile(
                  leading: new Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: user['mediaUrl'] == null ? AssetImage("assets/images/profileuser.png") : NetworkImage(user['mediaUrl']),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  title: new Text(user['name'],style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Color(0xff666363), fontSize: 15),),
                  subtitle: new Text("You are now Friends",style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Color(
                      0xffa0a0a0), fontSize: 12), ),
                  trailing: InkWell(
                    onTap: ()async{

                    },
                    child: RoundedContainer(
                      color: Colors.lightGreen,
                      margin: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 6.0,
                      ),
                      child: Text(
                        "Friends",
                        style: boldText.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
          // ListView(
          //   shrinkWrap: true,
          //   padding: EdgeInsets.zero,
          //   physics: NeverScrollableScrollPhysics(),
          //   children: [
          //     // ListTile(
          //     //   leading: new Container(
          //     //     height: 80,
          //     //     width: 80,
          //     //     decoration: BoxDecoration(
          //     //         color: Colors.grey[200],
          //     //         shape: BoxShape.circle,
          //     //         image: DecorationImage(
          //     //             image: AssetImage("assets/images/profileuser.png"),
          //     //             fit: BoxFit.cover
          //     //         )
          //     //     ),
          //     //   ),
          //     //   title: new Text("Nsamba Isaac",style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Color(0xff666363), fontSize: 15),),
          //     //   subtitle: new Text("INVITE SENT 1 day ago",style: GoogleFonts.roboto(fontWeight: FontWeight.w500, color: Color(
          //     //       0xffa0a0a0), fontSize: 11), ),
          //     //   trailing: RoundedContainer(
          //     //     color: Colors.indigo,
          //     //     margin: const EdgeInsets.symmetric(
          //     //       vertical: 6.0,
          //     //       horizontal: 6.0,
          //     //     ),
          //     //     child: Text(
          //     //       "ACCEPT",
          //     //       style: boldText.copyWith(
          //     //         color: Colors.white,
          //     //       ),
          //     //     ),
          //     //   ),
          //     // )
          //   ],
          //
          // )
              :  ListView.builder(
              itemCount: d.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
               var user = d[index];
               List mylist = [];
               mylist.add(user);
               mylist.where((element) => element["isMember"] == true).toList();
               print("USER _ ${user}");
               print("USER_m _ ${mylist}");




               // return  Text("data");
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: new Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: user['mediaUrl'] == null ? AssetImage("assets/images/profileuser.png") : NetworkImage(user['userprofile']),
                              fit: BoxFit.cover
                          )
                      ),
                    ),
                    title: new Text(user['name'] ?? user['user'],style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Color(0xff666363), fontSize: 15),),
                    subtitle: user['isMember'] == true ?new Text("You've been Invited to Join ${user['team'] } TEAM by ${user['OwerTeam'] }",style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Color(
                        0xffa0a0a0), fontSize: 11), ) : new Text("requests. approve this Friend request",style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Color(
                        0xffa0a0a0), fontSize: 12), ),
                    trailing: user['isMember'] == true ?

                    InkWell(
                      onTap: ()async{
                        var senderID = "";
                        var requestData;
                        print("AM ACCEPTING ");
                        // await _firestore.collection("teams").doc(user['teamID'])..update(
                        //     {
                        //   "Usersteam" : [{
                        //     // 'requests' : [],
                        //     // 'members':   [user['uid']],
                        //     // "isMembers" : true,
                        //     "OwerTeam":user['OwerTeam'],
                        //     "user": user['user'],
                        //     "imageurl":user['mediaUrl'],
                        //     "userId" : user['userId'],
                        //     "OwerTeam" : user['OwerTeam'],
                        //     "uid" : user['uid'],
                        //     "teamID" : user['teamID'],
                        //     "phone"   : user['phone'],
                        //     'isMember' : true,
                        //     'team': user['team'],
                        //     'members':   [user['teamID']],
                        //     "isRequest" :  true,
                        //     "isMembers" : true,
                        //     'requests' : [],
                        //
                        //   }],
                        //   // "requests" : FieldValue.arrayUnion([_auth.currentUser.uid])
                        //   // "requests" : FieldValue.arrayRemove([user['uid']])
                        // }).then((value) => setState(() {}));

                        var filter = d.where((element) => element["isMember"] == true && element['name'] == user['name']).toList();
                        var userIndex =    filter.indexWhere((element) => element["isMember"] == true && element['name'] == user['name']);
                        print("resu _${filter}");
                        print("resu _${userIndex} \nn ${ filter[userIndex]}");

                        await _firestore.collection("userTeams")
                            .doc(filter[userIndex]['teamID'])
                            .collection("allUsers")
                            .doc(filter[userIndex]['uid'])

                            .update({
                            'requests': FieldValue.arrayRemove([_auth.currentUser.uid]),
                            'members' : FieldValue.arrayUnion([filter[userIndex]['uid']]) ,
                            'isMembers' : true,
                        });

                        await _firestore
                            .collection("users")
                            .doc(filter[userIndex]['userId']) //.where('cellnumber', isEqualTo: cellNumber)
                            .get()
                            .then((results) {
                          var ds = results.data();
                          setState(() {
                            requestData = ds;
                            senderID = requestData['user_token'];
                          });
                        });


                        FIREBASE_FCM.FCMSENDMESSEG(
                                                 senderID,
                                                     "${userrequests['name']} has accepted to join ${teamrequests['team'] } Team",
                                                     "new member",
                                                     "");


   // FIREBASE_FCM.FCMSENDMESSEG(
   //                          senderID,
   //                          Row(
   //                            children: [
   //                              Text("${userrequests['name']} ", style:TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color:Colors.blueGrey)),
   //                              Text("Has accepted the Invite ",style:TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color:Colors.grey) ),
   //                              Text(teamrequests['team'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color:Colors.lightGreen),),
   //                            ],
   //                          ),
   //                          "A User Accepted Invite",
   //                          "");

                                    // var result = response;

                        // setState(() {});
                        Navigator.pop(context);
                      },
                      child: RoundedContainer(
                        color:user['isMembers'] == true ? Colors.amber : Colors.greenAccent,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 6.0,
                        ),
                        child:user['isMembers'] == true ?
                        Text(
                          "JOINED",
                          style: boldText.copyWith(
                            color: Colors.black,
                          ),
                        )
                            :  Text(
                          "ACCEPT",
                          style: boldText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                        : InkWell(
                      onTap: ()async{
                        await _firestore.collection('users')
                            .doc(_auth.currentUser.uid)
                            .update({
                          "friends" : FieldValue.arrayUnion([user['uid']]),
                          // "requests" : FieldValue.arrayUnion([_auth.currentUser.uid])
                          "requests" : FieldValue.arrayRemove([user['uid']])
                        });
                        await _firestore.collection('users')
                            .doc(user['uid'])
                            .update({
                          "friends" : FieldValue.arrayUnion([_auth.currentUser.uid]),
                        });

                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: RoundedContainer(
                        color: Colors.indigo,
                        margin: const EdgeInsets.symmetric(
                          vertical: 6.0,
                          horizontal: 6.0,
                        ),
                        child: Text(
                          "CONFIRM",
                          style: boldText.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
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
              label: "Groups",
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=> UserGroups()),
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
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }
}
