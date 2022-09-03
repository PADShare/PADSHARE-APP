
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
const String _herouserProfile = "my-hero-profile";
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class InviteUserToJoinTeam extends StatefulWidget {
  final token;
  final userdata;

  InviteUserToJoinTeam({@required this.token, @required this.userdata});

  @override
  _InviteUserToJoinTeamState createState() => _InviteUserToJoinTeamState();
}

class _InviteUserToJoinTeamState extends State<InviteUserToJoinTeam> {
  var location;

  Map<String, dynamic> userrequests;

  var userFriends;

  var userUId;

  int totaluser;



  getuserFriends() async{
    if(_auth.currentUser != null){


      if(kDebugMode){
        debugPrint("GETUSER:: entered IF" );
      }

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

         setState(() {
           userFriends = id;
         });
        // print(id);

      }
      // }
    }}

  getuser() async {
    if (_auth.currentUser != null) {
      if (kDebugMode) {
        debugPrint("GETUSER:: entered IF");
      }

      // await _firestore
      //     .collection("users")
      //     .doc(widget.userdata['ownerId']) //.where('cellnumber', isEqualTo: cellNumber)
      //     .get()
      //     .then((result) {
      //   if (kDebugMode) {
      //     debugPrint("GETUSER:: TRUE");
      //     print(result.data());
      //   }
      //
      //   if(result.data()['requests'] == null){
      //
      //     print("no Ides");
      //   }else{
      //     userrequests = result.data();
      //   }
      //
      //
      //   // if (result.docs.length > 0) {
      //   //   debugPrint("GETUSER:: TRUE" );
      //   //   debugPrint("GETUSER:: TRUE :::" + result.docs.single.data()['location']);
      //   setState(() {
      //     // print(result.data()['name']);
      //    userrequests = result.data();
      //     // debugPrint("GETUSER:: TRUE :::" + result.data()['location']);
      //   });
      //
      // });

      if (userrequests['requests'] != null) {
        print("USER_IDS ${userrequests['requests']}");
        var ids = userrequests['requests'];
        for (var id in ids)
          userUId = id;
        // print(id);

      }
      // }
    }
  }



    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getuser();
    getuserFriends();
  }

  @override
  Widget build(BuildContext context) {
    print(userUId);
    print("USER ${widget.userdata}");
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Hero(
          tag: _herouserProfile,
          // createRectTween: (begin, end) {
          //   return CustomRectTween(begin: begin, end: end);
          // },
          child: Material(
            color: Colors.white,
            elevation: 2,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 55,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.4),
                                blurRadius: 1,
                                offset: Offset(0,2)
                            )
                          ]
                      ),
                      child: Wrap(
                        children: [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      flex:2,
                                      child: Text("Send Friends Request", style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "PROXIMANOVA",
                                          fontWeight: FontWeight.w700,
                                          fontStyle: FontStyle.normal
                                      ),),
                                    ),

                                    Flexible(
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel", style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.orange,
                                            fontFamily: "PROXIMANOVA",
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal
                                        ),),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                      color: Colors.white,
                      thickness: 0.2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height * 0.043),
                          SizedBox(height: 15,),
                          new Padding(padding: const EdgeInsets.only(top: 20),
                            child: new Container(
                              width: 150,
                              height: 150,
                              child: widget.userdata ==null ? Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle
                                ),
                                child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  child: Center(child: Text(widget.userdata['username'][0].toUpperCase(),style: GoogleFonts.roboto(color: Colors.white54, fontSize: 40, fontWeight: FontWeight.w500),),),
                                ),
                              ) : Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                        image: NetworkImage(widget.userdata['mediaUrl']),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top:10.0,),
                            child: new Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(11),

                              ),
                              child:new Text(widget.userdata['username'] ?? '',style: GoogleFonts.roboto(color:Color(0xff666363), fontSize: 20, fontWeight: FontWeight.bold),),
                            ),
                          ),

                        ],
                      ),

                    ),
                    // width: MediaQuery.of(context).size.width * 0.92,
                    //     height: MediaQuery.of(context).size.height * 0.94,
                    SizedBox(height: MediaQuery.of(context).size.height * 0.10,),
                    InkWell(

                      onTap: () async{
                        await _firestore.collection('users')
                            .doc(widget.userdata['ownerId'])
                            .update({
                          "friends" : FieldValue.arrayUnion([]),
                          "requests" : FieldValue.arrayUnion([_auth.currentUser.uid])
                        });

                        var snakBar = SnackBar(content: Text('The request sent to ${widget.userdata['username']}', style: TextStyle(color: Colors.cyan),),);
                        Scaffold.of(context).showSnackBar(snakBar);
                        Navigator.pop(context);
                        // print("RECIEVER PROFILE_ID ${widget.userdata['ownerId']}");
                        // print("SENDERS_ID: ${_auth.currentUser.uid}");
                      },

                      child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                          color: Color(0xff1480C3),
                        ),
                        child: Center(
                          child: new Text("Connect",style: TextStyle(color:Color(0xfff5f5f3),fontSize: 20, fontFamily: "PROXIMANOVA", fontWeight: FontWeight.w200),),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
