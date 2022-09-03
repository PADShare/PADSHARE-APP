import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/widgets/checkout_core/rounded_borders.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_detail_profile.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_friends_profile.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_profile_details.dart';
import 'package:padshare/Source/widgets/transitions/hero_dialog_route.dart';
import 'package:padshare/main.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
const TextStyle boldText = TextStyle(
  fontWeight: FontWeight.bold,
);
class Users extends StatefulWidget {
  const Users({Key key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  Map<String, dynamic> userrequests;

  Map<String, dynamic> userData;

  var res;

  List friends = [];
  List d = [];

  var result;

  var UserRequestID;

  Map<String, dynamic> userrequested_ids;

  var user_dataId;

  var pressedAttentionIndex =  -1; // -1;





  getuser() async{
    if(_auth.currentUser != null){


      if(kDebugMode){
        // debugPrint("GETUSER:: entered IF" );
      }

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      await _firestore
          .collection("users")
          .doc(_auth.currentUser.uid)//.where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result){


        if(kDebugMode){
          // debugPrint("GETUSER:: TRUE" );
          // print(result.data());
        }


        // if (result.docs.length > 0) {
        //   debugPrint("GETUSER:: TRUE" );
        //   debugPrint("GETUSER:: TRUE :::" + result.docs.single.data()['location']);
        setState(() {
          // print(result.data()['name']);
          userrequests = result.data();
          // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
        });

      });

      if(userrequests['requests'] != null) {
        // print("USER_IDS ${userrequests['requests']}");
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

  getuserFriends() async{
    if(_auth.currentUser != null){


      if(kDebugMode){
        // debugPrint("GETUSER:: entered IF" );
      }

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      await _firestore
          .collection("users")
          .doc(_auth.currentUser.uid)//.where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result){


        if(kDebugMode){
          // debugPrint("GETUSER:: TRUE" );
          // print(result.data());
        }


        // if (result.docs.length > 0) {
        //   debugPrint("GETUSER:: TRUE" );
        //   debugPrint("GETUSER:: TRUE :::" + result.docs.single.data()['location']);
        setState(() {
          // print(result.data()['name']);
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

  Future fetchUserPosts()async{
    var snapshot = await _firestore.collection("users").get();
    // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection("allposts").orderBy('timestamp',descending: true ).snapshots();
    //   .then((QuerySnapshot snapshot){
    // snapshot.docs.forEach((DocumentSnapshot doc) {
    //   print(doc.data());
    //   print(doc.data()['message']);
    // });
    //
    // });


    return snapshot.docs;

    // CollectionReference _reference = _firestore.collection("allposts").orderBy('timestamp',descending: true );
    //
    // _reference.snapshots().listen((QuerySnapshot  querySnapshot) {
    //   querySnapshot.docChanges.forEach((result) {
    //     print("DRESULT");
    //     print(result);
    //   });
    // });

    // return snapshot.docs;
    // return _usersStream;

  }

  CheckuserID(uid) async{
    if(_auth.currentUser != null){


      if(kDebugMode){
        debugPrint("GETUSER:: entered IF" );
      }

      //cellNumber = "0" + _auth.currentUser.phoneNumber.substring(3,cellNumber.length);
      // debugPrint(cellNumber);
      await _firestore
          .collection("users")
          .doc(uid)//.where('cellnumber', isEqualTo: cellNumber)
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
          userrequested_ids = result.data();
          // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
        });

      });

      if(userrequested_ids['requests'] != null) {
        print("USER_IDS ${userrequested_ids['requests']}");
        var ids = userrequested_ids['requests'];
        for(var id in ids ){
          setState(() {
            user_dataId = id;
          });
        }
          // print(id);
          // print(id);

      }
      // }
    }}



  bool showRequests = false;

  bool alreadrequested = false;

  var notconnected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
    getuserFriends();
    fetchUserPosts();
    notconnected = 0;
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
            child: FlutterSwitch(
              activeColor: Color(0xff692cab),
              inactiveColor: Colors.amberAccent.shade200,
              activeText: "Friends",
              inactiveText: "Connect",
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
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Container(
              height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  // color: Colors.cyan.shade500
                  color: Color(0xff00b18a)
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  new Text("ALL Users",style: GoogleFonts.openSans(color:Colors.white54, fontSize: 20, fontWeight: FontWeight.w400),),

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
                :  FutureBuilder(
              future: fetchUserPosts(),
              builder: (BuildContext context, snapshot){

                // print("Data user : ${snapshot.data}");

                if(snapshot.hasError){

                  return Text("error");
                }

                if(snapshot.hasData){

                  result = snapshot.data;

                  // print("users_all ${result[0].data()}");
                  // print("users_friends ${friends}");



                  return ListView.builder(
                    itemCount: result.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index){
                      final pressAttention = pressedAttentionIndex == index;
                      // print("daa ${result[index].data()['uid']}");
                       var user = result[index].data();
                       // setState(() {
                       //   UserRequestID = user['uid'];
                       //
                       // });
                       List iss = [];
                      // user.insert(result[index], {"h":false});
                      // print("users_all ${user}");

                      print("is Selected0 ${user['isSelected']}");


                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(
                                HeroDialogRoute(builder: (context) {
                                  return UserDetailProfile(userdata:_auth.currentUser, user:user);
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
                                      image: user['userprofile'] == null ? AssetImage("assets/images/profileuser.png") : NetworkImage(user['userprofile']),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            title: new Text(user['name'],style: GoogleFonts.roboto(fontWeight: FontWeight.w600, color: Color(0xff666363), fontSize: 15),),
                            subtitle: new Text("Connect with Friends",style: GoogleFonts.roboto(fontWeight: FontWeight.w400, color: Color(
                                0xffa0a0a0), fontSize: 12), ),
                            trailing: user['isSelected']==true ?
                            InkWell(
                                onTap: ()async{
                                  // Navigator.pop(context);
                                },
                                child: RoundedContainer(
                                  color: user['isSelected']==true ? Colors.lightGreen :  Colors.indigo,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 6.0,
                                  ),
                                  child:user['isSelected']==true ?  Text(
                                      "REQUEST SENT",
                                      style: boldText.copyWith(
                                        color: Colors.white,
                                      ) ) :Text(
                                    "CONNECT",
                                    style: boldText.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                            )
                                : InkWell(
                              onTap: ()async{

                                await _firestore.collection('users')
                                    .doc(user['uid'])
                                    .update({
                                  "friends" : FieldValue.arrayUnion([]),
                                  // "uid": FieldValue.arrayUnion(user['uid']),
                                  "request_from":FieldValue.arrayUnion([_auth.currentUser.displayName]),
                                  "requests" : FieldValue.arrayUnion([_auth.currentUser.uid])
                                });

                                showtoast();
                                //  setState(() {
                                //    CheckuserID(user['uid']);
                                //  });

                                await _firestore
                                    .collection("users")
                                    .doc(user['uid'])//.where('cellnumber', isEqualTo: cellNumber)
                                    .get()
                                    .then((result){


                                  if(kDebugMode){
                                    debugPrint("GETUSER:: TRUE" );
                                    print(result.data());
                                  }


                               setState(() {
                                    print(result.data()['name']);
                                    userrequested_ids = result.data();
                                    user['isSelected'] = true;
                                    // debugPrint("GETTER:: TRUE :::" + result.data()['location']);
                                  });

                                });

                                await _firestore.collection('users').doc(user['uid']).update({'isSelected': true});


                                print('requsted_DD ${userrequested_ids['uid']}');

                               print("is Selected ${user['isSelected']}");
                                setState(() {
                                  // notconnected = index;
                                  // pressedAttentionIndex = index;
                                  // alreadrequested = true;
                                  user['isSelected'] = !user['isSelected'];
                                });
                                print("is Selected2 ${user['isSelected']}");
                                if(userrequested_ids['uid'] == user['uid']){
                                  // setState(() {
                                  //   notconnected = index;
                                  //   pressedAttentionIndex = index;
                                  // });
                                  print("Same ID ${index}");
                                  print("UID ${user_dataId} OR ${user['uid']}");
                                  setState(() {
                                    user['isSelected'] = true;
                                  });
                                }else{
                                  // print("UID ${user_dataId} OR ${user['uid']}");
                                }

                                // Navigator.pop(context);
                              },
                              child: RoundedContainer(
                                color: user['isSelected']==true ? Colors.lightGreen :  Colors.indigo,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 6.0,
                                  horizontal: 6.0,
                                ),
                                child:user['isSelected']==true ?  Text(
                                  "REQUEST SENT",
                                  style: boldText.copyWith(
                                    color: Colors.white,
                                  ) ) :Text(
                                  "CONNECT",
                                  style: boldText.copyWith(
                                    color: Colors.white,
                                ),
                                ),
                              )
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }

                // RoundedContainer(
                //   color: Colors.indigo,
                //   margin: const EdgeInsets.symmetric(
                //     vertical: 6.0,
                //     horizontal: 6.0,
                //   ),
                //   child: Text(
                //     "REQUEST SENT",
                //     style: boldText.copyWith(
                //       color: Colors.white,
                //     ),
                //   ),
                // )


                return Center(child: CircularProgressIndicator());

              },
            )
          ],
        ),
      ),
    );
  }


  Widget showtoast(){
    var toast = Fluttertoast.showToast(
        msg: 'Request Sent successfully!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.blueGrey,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // throw toast;
  }
}
