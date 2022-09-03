import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/all_users/users.dart';
import 'package:padshare/Source/widgets/checkout_core/rounded_borders.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_detail_profile.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_friends_profile.dart';
import 'package:padshare/Source/widgets/transitions/hero_dialog_route.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
const TextStyle boldText = TextStyle(
  fontWeight: FontWeight.bold,
);
class UserGroups extends StatefulWidget {
  const UserGroups({Key key}) : super(key: key);

  @override
  State<UserGroups> createState() => _UserGroupsState();
}

class _UserGroupsState extends State<UserGroups> {
  Map<String, dynamic> userrequests;

  Map<String, dynamic> userData;

  var res;

  List friends = [];
  List d = [];

  var teamrequests;

  Map<String, dynamic> usergroups;





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
            });
            // print(result.data())
      });

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      print("User_Team_1 ${userrequests}");
      print("User_Team ${userrequests['teams']}");
      var response = userrequests['teams'];

         for(var teamid in response)
           // print("team ${teamid}");
           // arrayContains: {"uid":_auth.currentUser.uid}
    // .where("Usersteam.uid",arrayContains:_auth.currentUser.uid )
      await _firestore
          .collection("teams")
          .where("teamId", isEqualTo: teamid).get()//.where('cellnumber', isEqualTo: cellNumber)

          .then((result){


        if(kDebugMode){
          debugPrint("TEAMREQUEST:: TRUE" );
          print(result.docs[0]);
        }

        setState(() {
          print(" TEAMREQUEST _${result.docs[0].data()['Usersteam']}");
           teamrequests = result.docs[0].data()['Usersteam'];
          // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
        });

      });
      print("USER_TEA ${teamrequests}");


        teamrequests.map((data) {
          // print("Data_ ${data['requests'][0]}");
          var result = data;
          print("Data_ ${data}");

          if(result['uid'] == _auth.currentUser.uid){
           if(result['isMembers'] == false){
             d.add(result);
           }


          }
        }).toList();

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

  getTeamGroups() async{
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
        });
        // print(result.data())
      });

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      print("User_Team_1 ${userrequests}");
      print("User_Team ${userrequests['teams']}");
      var response = userrequests['teams'];

      for(var teamid in response)
        // print("team ${teamid}");
        // arrayContains: {"uid":_auth.currentUser.uid}
        // .where("Usersteam.uid",arrayContains:_auth.currentUser.uid )
        await _firestore
            .collection("teams")
            .where("teamId", isEqualTo: teamid).get()//.where('cellnumber', isEqualTo: cellNumber)

            .then((result){


          if(kDebugMode){
            debugPrint("TEAMREQUEST:: TRUE" );
            print(result.docs);
          }

          setState(() {
            print(" TEAMREQUEST _${result.docs.length}");
            teamrequests = result.docs;
            // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
          });

        });
      print("USER_TEA ${teamrequests}");
      var result;
      if(teamrequests != null)
        for(var n in teamrequests){
          print(n.data());
          setState(() {
            usergroups = n.data();
          });
        }

      d.add(usergroups);
      // teamrequests.map((data)async {
      //   // print("Data_ ${data['requests'][0]}");
      //   var result = data;
      //    print("Data_ ${data}");
      //
      //   for(var groupID in result)
      //     // print(groupID);
      //     await _firestore
      //       .collection("teams")
      //       .doc(groupID) //.where('cellnumber', isEqualTo: cellNumber)
      //       .get()
      //       .then((result){
      //     setState(() {
      //       usergroups = result.data();
      //     });
      //      print(result.data());
      //   });
      //
      //
      //   print("m _${usergroups}");
      //
      //
      //        d.add(usergroups);
      //
      //
      //
      //
      // }).toList();

    }}



  bool showRequests = false;

  @override
  void initState() {
    // TODO: implement initState
    // getuser();
    super.initState();

    getTeamGroups();
  }



  @override
  Widget build(BuildContext context) {

    print("PRUD ${d}");
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
             Container(
              height: 160,
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
            ) ,

            SizedBox(height: 20,),

          ListView.builder(
            itemCount: d.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index){
              var user = d[index];
              print("MY_U_TEAM ${user}");
              return teamrequests == null || d.length == 1 ? Container(
                 height: 200,
                child: Center(child : Text("No Groups to Display"))
              ) : GestureDetector(
                onTap: (){
                  // Navigator.of(context).push(
                  //     HeroDialogRoute(builder: (context) {
                  //       return FriendsProfile(userdata:_auth.currentUser, user:user);
                  //     }));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Card(
                    color: Colors.green.withOpacity(0.2),
                    elevation: 0,
                    child: ListTile(
                      title: new Text(user == null ? "" : user['teamName'],style: GoogleFonts.roboto(fontWeight: FontWeight.w700, color: Colors.black, fontSize: 20),),
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          new Text("${_auth.currentUser.displayName} ",style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color:
                          Colors.green.shade400, fontSize: 18), ),
                          Text("Team Member",style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color:
                          Colors.blueGrey, fontSize: 15), )
                        ],
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
    );
  }
}
