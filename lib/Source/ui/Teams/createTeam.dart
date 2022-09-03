import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:padshare/Source/ui/Teams/team.dart';
import 'package:padshare/Source/ui/Teams/teamWallet.dart';
import 'package:padshare/Source/utils/DataController.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
import 'package:progress_indicators/progress_indicators.dart';
import  'package:uuid/uuid.dart';
// import 'package:cloud_firestore/src/utils/auto_id_generator.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

final FirebaseAuth _auth = FirebaseAuth.instance;

final GoogleSignIn googleSignin = GoogleSignIn();

class CreateTeams extends StatefulWidget{

  String num, team;
  CreateTeams({this.num, this.team});
  @override
  _CreateTeamsState createState() => _CreateTeamsState();
}

class _CreateTeamsState extends State<CreateTeams> {

  TextEditingController _teamname = TextEditingController();
  TextEditingController  _controllerSearch =  TextEditingController();
  GlobalKey<FormState>_formKey = new GlobalKey<FormState>();

  var name = _auth.currentUser.displayName[0];


  var teamId = Uuid().v1();

  var teamname;
  bool addedItem = false;

  var teamusers;
  var isLoading = true;

  var orientation;

  var teamIds;

  int tappedIndex;
  QuerySnapshot snapshotData;
  bool isExecuted = false;
  DataController usersteams = DataController();
  var storage = FlutterSecureStorage();

  var selectedTeam;

  var team;

  String token;

  var deviceSenderTOken;
  login(){
    googleSignin.signIn();
  }

  getuserTOKEN()async{
   // _firestore.collection("users").doc()
  }

  @override
  void initState() {
    // TODO: implement initState
    getusersall();
    getteam();
    tappedIndex = 0;
    FIREBASE_FCM.FCMGetTOKEN();
    getTOken();

    // createteams(team: _teamname.text.trim());

    // googleSignin.onCurrentUserChanged.listen((GoogleSignInAccount account) {
    //   if(account != null){
    //     setState(() {
    //       isAuth = true;
    //     });
    //   }else{
    //     setState(() {
    //       isAuth = false;
    //     });
    //   }
    // });

    //Second time the user SignsIn into the app

    // googleSignin.signInSilently(suppressErrors: false).then((account){
    //   //   if(account != null){
    //   //     setState(() {
    //   //       isAuth = true;
    //   //     });
    //   //   }else{
    //   //     setState(() {
    //   //       isAuth = false;
    //   //     });
    //   //   }
    //
    // });

    // handleSignIn(GoogleSignInAccount account){
    //     if(account != null){
    //   //   //     setState(() {
    //   //   //       isAuth = true;
    //   //   //     });
    //   //   //   }else{
    //   //   //     setState(() {
    //   //   //       isAuth = false;
    //   //   //     });
    //   //   //   }
    // }

    super.initState();
  }

  getTOken()async{
    var tokens = await storage.read(key: "token");
    setState(() {
      token = tokens;
    });
  }


  Widget searchData(){
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: snapshotData.docs.length,
      itemBuilder: (BuildContext context, int index){
       // return ListTile(
       //   title: Text(snapshotData.docs[index].data()['name']),
       // );
        print("data __ ${snapshotData.docs[index].data()}");
        var result = snapshotData.docs[index].data();
        return ListUsers(result, title: result['name'], phone: result['cellnumber'], imageUrl: result['mediaUrl']);
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    final orientation = MediaQuery.of(context).orientation;
    print("TEAM ::: $teamname");
    // TODO: implement build
    return  new Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffF4F6FE),
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: new FlatButton(onPressed: (){
          Navigator.of(context).pop();
             },
            child: new Icon(Icons.arrow_back,color: Color(0xff6C1682),)),
        // title: new Text("Profile", style: GoogleFonts.roboto(color: Color(0xff6C1682), fontSize: 18, fontWeight: FontWeight.w600),),
        actions: [

            // GestureDetector(
            //   onTap:  (){
            //     // _updateProfile();
            //     createteams(team: _teamname.text.trim());
            //     setState(() {
            //       _teamname.text = "";
            //     });
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(right:15.0 , top: 15),
            //     child: Container(
            //         padding: EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(12),
            //           color: Color(0xff16CF8C),
            //         ),
            //         child: Center(child: new Text("Save", style: GoogleFonts.roboto(color: Colors.white, fontSize: 14),))),
            //   ),
            // ),


        ],
      ),
      body:  new Container(
        // child:  isLoading ? Center(child: CircularProgressIndicator(),) :  teamUser(),

        child: new Column(
          children: [
            Expanded(flex: 5,
              child: new Container(

              width: MediaQuery.of(context).size.width,
              height: 260,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(49),
                    bottomRight: Radius.circular(49),
                  ),
                  boxShadow:[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0,4)
                    )
                  ]
              ),

              child: new Column(
                children: [
                  SizedBox(height: 15,),
                  new Padding(padding: const EdgeInsets.only(top: 40),
                    child: new InkWell(
                      onTap: (){
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_)=> null),
                        );
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration:  BoxDecoration(
                          color: Color(0xff00b18a).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(color: Color(0xffebe3f3), width:8),
                          // image:  DecorationImage(
                          //     fit: BoxFit.scaleDown,
                          //     scale: 1.9,
                          //     image: AssetImage("assets/images/management.png")
                          // )
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/management.png", height:40, width: 40, fit: BoxFit.contain,),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  teamname == null  ?
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
                      :Container(
                    width: 90,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).snapshots(),
                      builder: (BuildContext context, snapshot){

                        if(snapshot.hasData){
                          // return Text("data");
                          // setState(() {
                          //   teamname = snapshot.data.docs;
                          // });
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
                            // setState(() {
                            //   team = teamSnapshot.data()['teamName'];
                            // });
                          }

                          return  DropdownButtonHideUnderline(
                            child: DropdownButton(
                              isExpanded: true,
                              items: currentTeams,
                              hint: Text('Choose Team', style: TextStyle(fontSize: 12),),
                              value: widget.team != null ? widget.team :  selectedTeam,
                              onChanged: (selectedTeamType){
                                print("selected TEAM ${selectedTeamType}");

                                var snakbar = SnackBar(
                                  content: Text('Selected Team is $selectedTeamType', style:TextStyle(color:Color(0xff11b719))),
                                );
                                Scaffold.of(context).showSnackBar(snakbar);
                                setState(() {
                                  selectedTeam = selectedTeamType;
                                  team = selectedTeam;
                                });
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:2.0),
                    child: new Text('${widget.num} Members',style: GoogleFonts.roboto(color:Color(0xff94989B), fontSize: 10,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400),),
                  ),


                ],
              ),
            ),),
           Expanded(
             flex: 1,
             child: Container(
                // color: Colors.red,
               child: new Column(
                 children: [

                   Padding(
                     padding: const EdgeInsets.only(top:28.0),
                     child: new Text("Add people to team", style: GoogleFonts.roboto(color: Color(0xff666363),fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
                   ),

                   // searchteams(),
                 ],
               ),
             ),
           ),

            Expanded(flex: 5, child: new Container(

            // color: Colors.blue,
            //  child: isLoading ? Center(child: CircularProgressIndicator(),) :  teamUser(),
              child: new Column(
                children: [
                  searchteams(),
                  // isExecuted ? searchData() :  displayUsers()
                  Flexible(
                     child: isExecuted ? searchData() : displayUsers(),
                  )
                ])

            //       Padding(
            //         padding: const EdgeInsets.only(top:20.0),
            //         child: new Text("Add people to team", style: GoogleFonts.roboto(color: Color(0xff666363),fontSize: 16, fontStyle: FontStyle.normal, fontWeight: FontWeight.w300), textAlign: TextAlign.center,),
            //       ),
            //
            //     searchteams()
            //       // ListUsers()
            //       displayUsers()
            //
            //
            //     ],
            //   )
            //   child: isExecuted ? searchData() :  displayUsers() ,
            ),
            )
          ],
        ),

      ),
      floatingActionButton: new Container(
        width: 80,
        height:80,
        decoration: BoxDecoration(
          color: Color(0xff6C1682),
          border: Border.all(color: Color(0xffFAFAFA),width: 3),
          borderRadius: BorderRadius.circular(100),
        ),
        child: new Container(
          width: 80,
          height:80,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xff6C1682),width: 2),
            borderRadius: BorderRadius.circular(100),
          ),
          child:  FloatingActionButton(
            backgroundColor: Colors.white,
            elevation: 2,
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (_)=> TeamWallet(teamname))
              );
            },
            child: new Text(
              "Wallet", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50,
          color: Colors.white,
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
            padding: EdgeInsets.zero,
            itemCount: snapshot.data.length,
            itemBuilder: (_, index){
              var result = snapshot.data[index].data();
              print("TDS ${result}");
               // return Text(snapshot.data[index]['name']);
              return  InkWell(
                onTap: (){
                setState(() {
                  tappedIndex = index;
                  addedItem = true;
                });
                },
              // child: TextButton(
              //    onPressed: (){
              //
              //    },
              //   child: Text("ADD USER"),
              //    ),
              // );
              //      child: Text("${result.data()['email']} "));
                   child : ListUsers(result,title: result['name'], phone: result['cellnumber'], imageUrl: result['mediaUrl'], uid:result['uid'], userToken:result['user_token']));

            },
          );
        }

        return Center(child: new CircularProgressIndicator(),);
      },
    );
  }

  createteams({String team}){
   _firestore.collection("teams").doc(teamId).set({
     "teamName": team,
     "teamId" : teamId,
     "postCount" : 0,
     "userId":_auth.currentUser.uid,
     "Usersteam" : {}
   }).then((value){
     var uuid  = _firestore.collection('').doc().id;
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
  getteam()async{
    // var response = await _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).get().then((QuerySnapshot snapshot){
    //
    //   if(snapshot.docs.length > 0){
    //
    //     print('TEAM');
    //     print(snapshot.docs.single.data()['teamName']);
    //     print(teamIds);
    //     setState(() {
    //       teamname = snapshot.docs.single.data()['teamName'];
    //        teamIds = snapshot.docs.single.data()['teamId'];
    //     });
    //   }
    //
    // });

    print("TEMM ${widget.team}");
    print("TEMM_2 ${team}");

    var response = await _firestore.collection('teams').where("teamName", isEqualTo: selectedTeam == null ? widget.team : selectedTeam).get().then((QuerySnapshot snapshot){
      print("TEMM_3 ${snapshot.docs.length}");
      if(snapshot.docs.length > 0){

        print('TEAM');
        print(widget.team);
        print("selected ${selectedTeam}");
        // print(snapshot.docs.single.data()['teamId']);
        setState(() {
           teamname = snapshot.docs;
           teamIds = snapshot.docs.single.data()['teamId'];
        });
      }

    });
  }

  Widget teamUser(){

    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 3 : 4),
        itemCount: teamusers.length,
        padding: EdgeInsets.zero,
        itemBuilder: (_,index){
          if(teamusers.length != 0){
            return Padding(
                padding: const EdgeInsets.only(top:8.0, right: 8, left: 8, bottom: 0),
                child:  index == 0 ?

                SizedBox(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Color(0xff692CAB).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: AssetImage("assets/images/plusSign.png"),
                              fit: BoxFit.scaleDown,
                            )
                        ),
                        child: RaisedButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          color: Colors.transparent,
                          disabledElevation: 0,
                          focusElevation: 0,
                          focusColor: Colors.transparent,
                          autofocus: false,
                          highlightColor: Colors.transparent,
                          highlightElevation: 0,
                          hoverColor: Colors.transparent,
                          hoverElevation: 0,
                          splashColor: Colors.transparent,
                          elevation: 0,
                          onPressed: (){
                            print("AM CLIDED");
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Text("Add", style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                      )
                    ],
                  ),
                )

                    : SizedBox(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                            color: Color(0xff692CAB).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              image: NetworkImage(teamusers[index].avatar),
                              fit: BoxFit.cover,
                            )
                        ),
                        child: RaisedButton(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          color: Colors.transparent,
                          disabledElevation: 0,
                          focusElevation: 0,
                          focusColor: Colors.transparent,
                          autofocus: false,
                          highlightColor: Colors.transparent,
                          highlightElevation: 0,
                          hoverColor: Colors.transparent,
                          hoverElevation: 0,
                          splashColor: Colors.transparent,
                          elevation: 0,
                          onPressed: (){
                            print("AM CLIDED");
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top:8.0, left: 8, right: 8),
                        child: new Text(teamusers[index].name, style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal), textAlign: TextAlign.center,),
                      )
                    ],
                  ),
                )
            );
          } else
            return new Container();
        });
  }

  Widget searchteams(){
   return Padding(
     padding: const EdgeInsets.only(top:15.0, left: 30, right: 30, bottom: 8),
     child: new TextFormField(
       controller: _controllerSearch,
        onTap: (){
         print("am TAPPED");
          // GetBuilder<DataController>(
          //   init: DataController(),
          //   builder: (val){
          // return IconButton(icon: Icon(Icons.search), onPressed: (){
          // val.queryData(_controllerSearch.text).then((value){
          // setState(() {
          // snapshotData = value;
          // isExecuted = true;
          //
          //      });
          // print("result::");
          // print(value);
          //          });
          //    });
          // });
        },
        onChanged: (search)async{
         // setState(() {
         //   isExecuted = true;
         // });
          print("am tapped searching $search");

         search = search.toLowerCase();

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

 Widget ListUsers(index,{String title, String phone, String imageUrl , uid, userToken}){


    return Container(

      child: new Column(

        children: [
          ListTile(
            onTap: ()async{
              await _firestore
                  .collection("UsersTokens")
                  .doc(uid) //.where('cellnumber', isEqualTo: cellNumber)
                  .get().then((value){

                var team = value.data()['user_token'];
                setState(() {
                  deviceSenderTOken = value.data()['user_token'];
                });

                print("sender _IDTOKEN ${deviceSenderTOken}");

              });

              await _firestore.collection('teams').where("Usersteam", arrayContains: _auth.currentUser.uid).get().then((result){

                print("not able HERE");
                print(teamIds);


     if(result.size == 0){
       _onLoading();
       print("not able");


       //
          _firestore.collection("userTeams").doc(teamIds).collection("allUsers").doc(uid).set({
             "user": title,
             "imageurl":index['mediaUrl'],
             "userId" : _auth.currentUser.uid,
             "OwerTeam" : _auth.currentUser.displayName,
             "uid" : uid,
             "teamID" : teamIds,
             "phone"   : index['cellnumber'],
             'isMember' : true,
             'team': selectedTeam == null ? widget.team : selectedTeam,
             'members':   FieldValue.arrayUnion([]),
             'senders_token' : token,
             "isRequest" :  true,
             "isMembers" : false,
             "userToken" : deviceSenderTOken,
             // 'requests' : [uid],
             'requests' : FieldValue.arrayUnion([uid]),

       });


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
       // });


       // _firestore.collection("teams").doc(teamIds).update({
       //   "Usersteam": FieldValue.arrayUnion([
       //     { "user": title,
       //       "imageurl":index['mediaUrl'],
       //       "userId" : _auth.currentUser.uid,
       //       "OwerTeam" : _auth.currentUser.displayName,
       //       "uid" : uid,
       //       "teamID" : teamIds,
       //       "phone"   : index['cellnumber'],
       //       'isMember' : true,
       //       'team': selectedTeam == null ? widget.team : selectedTeam,
       //       'members':   [],
       //       "isRequest" :  true,
       //       "isMembers" : false,
       //       'requests' : [uid],
       //       // 'requests' : FieldValue.arrayUnion([_auth.currentUser.uid]),
       //     }
       //   ])
       // }).then((value){
       //
       //   setState(() {
       //     addedItem = true;
       //   });
       //
       //   // Future.delayed(Duration(seconds: 3)).then((value){
       //   //   Navigator.of(context).pop();
       //   //   setState(() {
       //   //     isLoading = false;
       //   //
       //   //   });
       //   //
       //   // });
       //   // Navigator.of(context).pop();
       //   // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=> NewsFeed()),
       //   //               (Route<dynamic> route) => false
       //   //
       //   //       );
       // });

       FIREBASE_FCM.FCMSENDMESSEG(
           deviceSenderTOken,
           "${title} You've been invited to Join ${selectedTeam == null ? widget.team : selectedTeam} Team",
           "Request to Join a Team",
           "request");

       _firestore.collection("users").doc(uid).update({
         "teams" : FieldValue.arrayUnion([teamIds])
       });
       print("DDDID ${deviceSenderTOken}");



     }
   } );

              // _firestore.collection("teams").doc(teamIds).update({
              //   "Usersteam": FieldValue.arrayUnion([
              //     {'isMember' : true,
              //       "isRequest" :  true,
              //       "isMembers" : false,
              //       'requests' : [],
              //     }
              //   ])
              // });


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

  getusersall()async{

   var snapshot = await  _firestore.collection("users").get();
    print("users");
    // print(snapshot.docs);

    return snapshot.docs;
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

  void _onLoading() {
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
              new Text("adding user..", style: GoogleFonts.roboto(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {

      Navigator.pop(context);
      Navigator.of(context).push(
          MaterialPageRoute(builder: (_)=>Teams())
      );
    });
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
                  controller: _teamname,
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

              createteams(team: _teamname.text);

              setState(() {
                _teamname.text = "";
              });


              var snakBar = SnackBar(content: Text('The team created is ${_teamname.text}', style: TextStyle(color: Colors.cyan),),);

              Scaffold.of(context).showSnackBar(snakBar);
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
}