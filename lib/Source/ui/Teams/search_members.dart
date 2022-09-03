
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:padshare/Source/utils/DataController.dart';
import 'package:padshare/Source/widgets/user_posts_single/single_user_post.dart';
import 'package:uuid/uuid.dart';
const String _herouserProfile = "my-hero-profile";

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class SearchMembers extends StatefulWidget {
  final user;
  final userdata;

  SearchMembers({@required this.user, @required this.userdata});

  @override
  _SearchMembersState createState() => _SearchMembersState();
}

class _SearchMembersState extends State<SearchMembers> {
  var location;

  Map<String, dynamic> userrequests;

  var userFriends;
  bool isloading = true;
  var userUId;
  List<QueryDocumentSnapshot> posts;

  TextEditingController  _controllerSearch =  TextEditingController();
  GlobalKey<FormState>_formKey = new GlobalKey<FormState>();
  TextEditingController _controllerTeam =  TextEditingController();
  DataController usersteams = DataController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;
  int tappedIndex;
  bool addedItem = false;
  var teamname;

  var teamId = Uuid().v1();

  var teamIds;

  var selectedTeam;



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

      await _firestore
          .collection("users")
          .doc(widget.userdata['ownerId']) //.where('cellnumber', isEqualTo: cellNumber)
          .get()
          .then((result) {
        if (kDebugMode) {
          debugPrint("GETUSER:: TRUE");
          print(result.data());
        }

        if(result.data()['requests'] == null){

          print("no Ides");
        }else{
          userrequests = result.data();
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


  gettotalUsers()async{
    _firestore.collection('post')
        .doc(widget.user['uid'])
        .collection('userPosts').get().then((result){
      print("USER_POSTS");
      print(result.docs.length);
      setState(() {
        // totaluser = result.docs.length;
        posts = result.docs;
      });
      Future.delayed(Duration(seconds: 2)).then((value){
        setState(() {
          isloading = false;
        });
      });
    });

  }

  getteam()async{
    // var response = await _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).get().then((QuerySnapshot snapshot){
    // // var response = await _firestore.collection('teams').get().then((QuerySnapshot snapshot){
    //
    //   if(snapshot.docs.length > 0){
    //
    //     print('TEAM');
    //     print(snapshot.docs);
    //     print(teamIds);
    //     setState(() {
    //       teamname = snapshot.docs;
    //       teamIds = snapshot.docs.single.data()['teamId'];
    //     });
    //   }
    //
    // });

    var response = await _firestore.collection('teams').where("teamName", isEqualTo: selectedTeam).get().then((QuerySnapshot snapshot){
      print("TEMM_3 ${snapshot.docs.length}");
      if(snapshot.docs.length > 0){

        print('TEAM');
        print(selectedTeam);
        print(snapshot.docs.single.data()['teamId']);
        setState(() {
          teamname = snapshot.docs;
          teamIds = snapshot.docs.single.data()['teamId'];
        });
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    gettotalUsers();
    super.initState();
    getuser();
    getteam();
    getuserFriends();
  }

  @override
  Widget build(BuildContext context) {
    print("TEam ${teamname == null}");
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                          child: Row(
                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Text("Invite to join my Team", style: TextStyle(
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
                  ),

                  const Divider(
                    color: Colors.white,
                    thickness: 0.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                            Text(
                              'Send invites to:',
                            style: TextStyle(fontSize: 15.0),
                          ),
                          Text(
                            'search for Friends to send invites',
                            style:
                            TextStyle(fontSize: 14.0, color: Colors.black45),
                          ),]),
                        ),


                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                                flex: 2,
                                child: searchteams() ),
                            Expanded(child: teamname == null  ?
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xffcecaca)
                                ),
                                borderRadius: BorderRadius.circular(15),
                                // fillColor: Color(0xffE5E5E5),
                                // prefixIcon: Icon(Icons.search_rounded, size: 20,)
                              ),
                              child: TextButton(onPressed: (){
                                // Navigator.of(context, rootNavigator: true).pop('dialog');
                                Navigator.of(context).pop();
                                showDiaLogs();
                              }, child: Text("Add Team", style:  TextStyle(fontSize: 12, color: Colors.cyan),)),
                            )
                                : Container(

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                  child:
                                    StreamBuilder<QuerySnapshot>(
                                      stream: _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).snapshots(),
                                      builder: (BuildContext context, snapshot){

                                        if(snapshot.hasData){
                                          // return Text("data");
                                          List<DropdownMenuItem> currentTeams = [];
                                          for(int i = 0 ; i<snapshot.data.docs.length; i++){
                                           DocumentSnapshot teamSnapshot = snapshot.data.docs[i];
                                           currentTeams.add(
                                             DropdownMenuItem(
                                               child: Text(teamSnapshot.data()['teamName'], style: TextStyle(fontSize: 16, color: Colors.cyan),),
                                                 value: '${teamSnapshot.data()['teamName']}',
                                             )
                                           );

                                           print("TM ${teamSnapshot.data()['teamName']}");
                                          }

                                          return  DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              isExpanded: true,
                                              items: currentTeams,
                                              hint: Text('Choose Team', style: TextStyle(fontSize: 12),),
                                              value: selectedTeam,
                                          onChanged: (selectedTeamType){
                                                print("selected TEAM ${selectedTeamType}");


                                                setState(() {
                                                  selectedTeam = selectedTeamType;
                                                });

                                                var snakbar = SnackBar(
                                                  content: Text('Seleted Team is $selectedTeamType', style:TextStyle(color:Color(0xff11b719))),
                                                );
                                                // Scaffold.of(context).showSnackBar(snakbar);
                                                ScaffoldMessenger.of(context).showSnackBar(snakbar);

                                              },
                                            ),
                                          );
                                        }

                                        if(snapshot.hasError){

                                          return Text('No teams', style: TextStyle(fontSize: 10),);
                                        }

                                        return Text('Loading..', style: TextStyle(fontSize: 10),);

                                      },
                                    ),
                                  // DropdownButtonHideUnderline(
                                  //   child: DropdownButton(
                                  //     isExpanded: true,
                                  //     value: selectedTeam,
                                  //     onChanged: (selectedTeamType){
                                  //       print("selected TEAM ${selectedTeamType}");
                                  //       setState(() {
                                  //         selectedTeam = selectedTeamType;
                                  //       });
                                  //     },
                                  //     hint: Text('Choose Team', style: TextStyle(fontSize: 12),),
                                  //
                                  //
                                  //   ),
                                  // ),
                                  // Text("member",style:TextStyle(fontSize: 16,color: Color(0xff8A8A8C), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),


                                ),
                              decoration: BoxDecoration(
                                 border: Border.all(
                                   color: Color(0xffcecaca)
                                 ),
                                  borderRadius: BorderRadius.circular(15),
                                  // fillColor: Color(0xffE5E5E5),
                                  // prefixIcon: Icon(Icons.search_rounded, size: 20,)
                              ),
                            ),)
                          ],
                        ),
                        SizedBox(height: 20,),
                        // isExecuted ? searchData() : displayUsers()
                        LimitedBox(
                          maxHeight: 200,
                          child:  isExecuted ? searchData() : Container( height: 10,),
                        ),

                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: Container(
                              height: 45,
                              decoration: BoxDecoration(
                                color:Colors.blueAccent
                              ),
                              child: TextButton(
                                child: Text("Send Invite", style:TextStyle(color:Colors.white54)),
                              )
                            ),
                          ),
                        )

                      ],
                    ),

                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  var searchmember = new Row(

    children: [


    ],
  );

  Widget searchteams(){
    return Padding(
      padding: const EdgeInsets.only(top:15.0, left: 10, right: 20, bottom: 8),
      child: new TextFormField(
        controller: _controllerSearch,
        onTap: (){
          print("am TAPPED");

        },
        onChanged: (search)async{
          // setState(() {
          //   isExecuted = true;
          // });
          print("am tapped searching $search");

          search = search.toLowerCase();

          print("search ${search}");

          // if(search.isEmpty){
          //   isExecuted = false;
          // }

          setState(() {
            usersteams.queryData(search).then((value) {
              setState(() {
                snapshotData = value;
                isExecuted = true;
              });
              print("result::");
              print(value);
            });
          });

        },
        decoration: InputDecoration(
            labelText: "Search",
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
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(
                    color: Color(0xffE5E5E5),
                    width: 1
                )
            ),
            prefixIcon: Icon(Icons.search_rounded, size: 20,)
        ),
      ),
    );
  }
  displayUsers(){
    return FutureBuilder(
      future: getusersall(),
      builder: (_, snapshot){

        if(snapshot.hasData){
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.length,
            itemBuilder: (_, index){
              var result = snapshot.data[index].data();
              // return Text(snapshot.data[index]['name']);
              return  InkWell(
                  onTap: (){
                    setState(() {
                      tappedIndex = index;
                      addedItem = true;
                    });
                  },
                  // child: Text("${result.data()['email']} "));
                  child : ListUsers(result,title: result['name'], phone: result['cellnumber'], imageUrl: result['mediaUrl'], uid:result['uid']));

            },
          );
        }

        return Center(child: new CircularProgressIndicator(),);
      },
    );
  }
  getusersall()async{

    var snapshot = await  _firestore.collection("users").get();
    print("users");
    // print(snapshot.docs);

    return snapshot.docs;
  }
  Widget searchData(){
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemCount: snapshotData.docs.length,
      itemBuilder: (BuildContext context, int index){
        // return ListTile(
        //   title: Text(snapshotData.docs[index].data()['name']),
        // );
        var result = snapshotData.docs[index].data();
        return ListUsers(result, title: result['name'], phone: result['cellnumber'], imageUrl: result['mediaUrl']);
      },
    );
  }
  Widget ListUsers(index,{String title, String phone, String imageUrl, uid}){

    return Container(

        child: new Column(

          children: [
            ListTile(
              onTap: ()async{

                await _firestore.collection('teams').where("Usersteam", arrayContains: _auth.currentUser.uid).get().then((result){

                  print("not able HERE");
                  print(result.size);

                  if(result.size == 0){
                     _onLoading(context);
                    print("not able");
                    _firestore.collection("teams").doc(teamIds).update({
                      "Usersteam": FieldValue.arrayUnion([
                        { "user": title,
                          "imageurl":index['mediaUrl'],
                          "userId" : _auth.currentUser.uid,
                          "teamID" : teamIds,
                          "phone"   : index['cellnumber'],
                          "uid" : uid,
                          'isMember' : true,
                        }
                      ])
                    }).then((value){

                      setState(() {
                        addedItem = true;
                      });

                      // Future.delayed(Duration(seconds: 3)).then((value){
                      //   Navigator.of(context).pop();
                      //   setState(() {
                      //     isLoading = false;
                      //
                      //   });
                      //
                      // });
                      // Navigator.of(context).pop();
                      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> NewsFeed()),
                      //               (Route<dynamic> route) => false
                      //
                      //       );
                    });
                  }
                } );


                print("teamsID");
                print(teamIds);

              },
              leading: Container(
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xffECECFF),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: imageUrl == null || imageUrl == "" ?  AssetImage("assets/images/profile.png") : NetworkImage(imageUrl),
                  ),
                ),
              ),
              title: new Text(title == null ? "" : title, style: GoogleFonts.roboto(color: Color(0xff3E4347), fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 15),),
              subtitle: new Text(phone == null ? "" : phone, style: GoogleFonts.roboto(color: Color(0xff8A8A8C).withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
              // trailing: addedItem ?  Padding(
              //   padding: const EdgeInsets.only(right:10.0),
              //   child:  new Container(
              //     width: 20,height: 20,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(100),
              //       color: Colors.greenAccent,
              //     ),
              //     child: Icon(Icons.check, color: Colors.white,size: 20,),
              //   ),
              // ) : Padding(
              //   padding: const EdgeInsets.only(right:10.0),
              //   child: Container(width: 20,height: 20,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(100),
              //         color: Colors.grey.withOpacity(0.1)
              //     ),
              //   ),
              //
              // ),
              trailing: Padding(
                padding: const EdgeInsets.only(right:10.0),
                child:  new Container(
                  width: 20,height: 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.greenAccent,
                  ),
                  child: Icon(Icons.add, color: Colors.white,size: 20,),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, left: 80),
              child: Divider(
                height: 1,
                color: Color(0xffCCCCCC),thickness: 0.8,
              ),
            )

          ],
        )
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

              createteams(team: _controllerTeam.text);

              setState(() {
                _controllerTeam.text = "";
              });
              Navigator.pop(dialogContext, false);
              // Navigator.of(context, rootNavigator: true).pop('dialog');
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

  createteams({String team}){
    _firestore.collection("teams").doc(teamId).set({
      "teamName": team,
      "teamId" : teamId,
      "postCount" : 0,
      "userId":_auth.currentUser.uid,
      "Usersteam" : {}
    }).then((value){
      // setState(() {
      //   teamId = Uuid().v1();
      // });

      var snakBar = SnackBar(content: Text('The team created is ${team}', style: TextStyle(color: Colors.deepOrangeAccent),),);

      Scaffold.of(context).showSnackBar(snakBar);


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
              new Text("Adding user..", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.of(context, rootNavigator: true).pop('dialog');


    });
  }
  Widget progressIndictor() {

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // new Text('Loading please wait...', style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),),
        SpinKitFadingCircle(
          size: 44.0,
          color: Colors.amber,
        ),
      ],
      // )
    );
  }
}
