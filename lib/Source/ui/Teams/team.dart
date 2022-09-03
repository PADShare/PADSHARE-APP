import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/models/teams/teamusers_model.dart';
import 'package:padshare/Source/ui/Pages/invitations/user_groups.dart';
import 'package:padshare/Source/ui/Teams/createTeam.dart';
import 'package:padshare/Source/ui/Teams/member_friend_profile.dart';
import 'package:padshare/Source/ui/Teams/teamWallet.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/ui/updateUserProfile/update_user_team_profile.dart';
import 'package:padshare/Source/utils/Api.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
import 'package:padshare/Source/widgets/transitions/hero_dialog_route.dart';
import 'package:padshare/main.dart';
import 'package:uuid/uuid.dart';



final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class Teams extends StatefulWidget{


  @override
  _TeamsState createState() => _TeamsState();
}

class _TeamsState extends State<Teams> {
  var storage = FlutterSecureStorage();
  GlobalKey<FormState>_formKey = new GlobalKey<FormState>();
  TextEditingController _controllerTeam =  TextEditingController();
  var teamId = Uuid().v1();
  var teamusers;
  var isLoading = true;
  var team;
  var orientation;

  var teamname;
  var  teamuser;

  List<TeamUsersModel>  _listuser;

  List allteams = [];
  List newTeamItems = [];

  String number;

  var selectedTeam;

  String team_ID;

  var allTeamUsers;

  getteams() async{

   // var teams = await API.getTeamUsers();
     await _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).get().then((QuerySnapshot snapshot) {

      print("PRINT");
      print(snapshot.docs.single.data()['Usersteam']);

      // teamuser   = snapshot.docs['Usersteam'];
      setState(() {
        teamuser   = snapshot.docs.single.data()['Usersteam'];
      });

      if(snapshot.docs == null){
      setState(() {
        isLoading = false;
      });
      }

    });


    await Future.delayed(Duration(seconds: 2)).then((value){

      setState(() {
        isLoading = false;
       // teamusers = teams;
       //  teamuser   = [
       //    {"1"," 2"}
       //  ];

      });

      // myteam.docs.map((data) {
      //   print("PRINT");
      //   print(data);
      // });

    });



  }

  getUsers(){
    CollectionReference reference = _firestore.collection("teams");

     DocumentReference documentReference = reference.doc(_auth.currentUser.uid);

     // documentReference.get().asStream()

  }

  teams()async{
    var res = await getteam();
     setState(() {
      // team = res;
     });

     print(team);
  }

  @override
  void initState() {
    // TODO: implement initState
     getteam();
    // getteams();
    getteam();
     teams();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // final orientation = MediaQuery.of(context).orientation;
    // TODO: implement build
    print("SELECTD ${teamname}");
    var orientation = MediaQuery.of(context).orientation == Orientation.landscape;
    return  new Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffF4F6FE),
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: new FlatButton(onPressed: (){
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 4,))
          );
          // RestartWidget.restartApp(context);
        }, child: new Icon(Icons.arrow_back,color: Color(0xff6C1682),)),
        // title: new Text("Profile", style: GoogleFonts.roboto(color: Color(0xff6C1682), fontSize: 18, fontWeight: FontWeight.w600),),
        actions: [

          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 16.0),
            child: GestureDetector(
              onTap: (){
                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (_)=> CreateTeams(num: number,))
                // );
                showDiaLogs();
              },
              child: Icon(Icons.add, size: 30, color: Colors.deepOrangeAccent,),
            ),
          )
          ,
          // GestureDetector(
          //   onTap: (){
          //     Navigator.of(context).push(
          //         MaterialPageRoute(builder: (_)=> CreateTeams(num: number,team: team,))
          //     );
          //   },
          //   child: Padding(
          //     padding: const EdgeInsets.only(right:13.0),
          //     child: SvgPicture.asset("assets/images/proIcon.svg"),
          //   ),
          // )
        ],
      ),
      body:  new Container(
        // child:  isLoading ? Center(child: CircularProgressIndicator(),) :  teamUser(),

        child: new Column(
          children: [
            Expanded(flex: orientation ? 8: 4, child: new Container(

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
                  SizedBox(height: orientation? 5:15,),
                  new Padding(padding: const EdgeInsets.only(top: 40),
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
                      // Navigator.of(context).pop();
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
                              value: selectedTeam,
                              onChanged: (selectedTeamType)async{


                                print("selected TEAM ${selectedTeamType}");

                                var snakbar = SnackBar(
                                  content: Text('Seleted Team is $selectedTeamType', style:TextStyle(color:Color(0xff11b719))),
                                );
                                // Scaffold.of(context).showSnackBar(snakbar);
                                ScaffoldMessenger.of(context).showSnackBar(snakbar);
                                setState(() {
                                  selectedTeam = selectedTeamType;
                                  team = selectedTeam;
                                });

                                FIREBASE_FCM.GETTEAMID(team);
                                var teamid = await storage.read(key: "teamID");

                                setState(() {
                                  team_ID = teamid;
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
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom:1.0),
                  //   child: new Text(teamname == "" || teamname == null ? "Add Team" : teamname,style: GoogleFonts.roboto(color:Color(0xff666363), fontSize: 15,fontStyle: FontStyle.normal, fontWeight: FontWeight.w700),),
                  // ),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Expanded(
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(bottom:1.0),
                  //           child: new Text(teamname == "" || teamname == null ? "Add Team" : teamname,style: GoogleFonts.roboto(color:Color(0xff666363), fontSize: 15,fontStyle: FontStyle.normal, fontWeight: FontWeight.w700),),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Padding(
                  //           padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //           child:
                  //           StreamBuilder<QuerySnapshot>(
                  //             stream: _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).snapshots(),
                  //             builder: (BuildContext context, snapshot){
                  //
                  //               if(snapshot.hasData){
                  //                 // return Text("data");
                  //                 List<DropdownMenuItem> currentTeams = [];
                  //                 for(int i = 0 ; i<snapshot.data.docs.length; i++){
                  //                   DocumentSnapshot teamSnapshot = snapshot.data.docs[i];
                  //                   currentTeams.add(
                  //                       DropdownMenuItem(
                  //                         child: Text(teamSnapshot.data()['teamName'], style: TextStyle(fontSize: 16, color: Colors.cyan),),
                  //                         value: '${teamSnapshot.data()['teamName']}',
                  //                       )
                  //                   );
                  //
                  //                   print("TM ${teamSnapshot.data()['teamName']}");
                  //                 }
                  //
                  //                 return  DropdownButtonHideUnderline(
                  //                   child: DropdownButton(
                  //                     isExpanded: true,
                  //                     items: currentTeams,
                  //                     hint: Text('Choose Team', style: TextStyle(fontSize: 12),),
                  //                     value: selectedTeam,
                  //                     onChanged: (selectedTeamType){
                  //                       print("selected TEAM ${selectedTeamType}");
                  //
                  //                       var snakbar = SnackBar(
                  //                         content: Text('Seleted Team is $selectedTeamType', style:TextStyle(color:Color(0xff11b719))),
                  //                       );
                  //                       Scaffold.of(context).showSnackBar(snakbar);
                  //                       setState(() {
                  //                         selectedTeam = selectedTeamType;
                  //                       });
                  //                     },
                  //                   ),
                  //                 );
                  //               }
                  //
                  //               if(snapshot.hasError){
                  //
                  //                 return Text('No teams', style: TextStyle(fontSize: 10),);
                  //               }
                  //
                  //               return Text('Loading..', style: TextStyle(fontSize: 10),);
                  //
                  //             },
                  //           ),
                  //           // DropdownButtonHideUnderline(
                  //           //   child: DropdownButton(
                  //           //     isExpanded: true,
                  //           //     value: selectedTeam,
                  //           //     onChanged: (selectedTeamType){
                  //           //       print("selected TEAM ${selectedTeamType}");
                  //           //       setState(() {
                  //           //         selectedTeam = selectedTeamType;
                  //           //       });
                  //           //     },
                  //           //     hint: Text('Choose Team', style: TextStyle(fontSize: 12),),
                  //           //
                  //           //
                  //           //   ),
                  //           // ),
                  //           // Text("member",style:TextStyle(fontSize: 16,color: Color(0xff8A8A8C), fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                  //
                  //
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:2.0),
                    child: new Text('$number Members',style: GoogleFonts.roboto(color:Color(0xff94989B), fontSize: 10,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400),),
                  ),


                ],
              ),
            ),),

            Expanded(flex: 7, child: new Container(
               // color: Colors.blue,
               child: isLoading ?  Center(child: Text("No Teams", style:TextStyle(fontSize: 12, color:Colors.grey)),) :  teamUser(),
              //  child: teamUser(),
            ),)
          ],
        ),

        // child:  Column(
        //   children: [

        //
        //     // teamUsers()
        //     isLoading ? Center(child: CircularProgressIndicator(),) :  teamUser()
        //   ],
        // ),
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

  Widget teamUser(){
    // return  Text(teamusers[0].name);
    // return GridView.builder(
    //     itemCount: teamusers.length,
    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
    //     itemBuilder:(_, index){
    //       if(teamusers.length != 0){
    //         return new Text("data");
    //         // return Padding(padding: const EdgeInsets.all(8),
    //         // child: index == 0 ? new Container(width: 40,height: 40, color: Colors.red, decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
    //         // ): CircleAvatar(backgroundColor: Colors.transparent, backgroundImage: NetworkImage(teamusers[index].avatar),));
    //       } else
    //         return  Container();
    //     });
     print("MYTEAM ${team}");

      return team == null ?
      // Container()
      StreamBuilder(stream: _firestore.collection('teams').where("teamName", isEqualTo: selectedTeam==null ? team:selectedTeam ).snapshots(),
        builder: (BuildContext context, snapshot){

          print('team ${team}');
          // print('check ${snapshot.data.docs[0].data()}');
          if(snapshot.hasData){
            var resultteam =  snapshot.data.docs[0].data()['Usersteam'];
            print("my team ${selectedTeam}");

            number = resultteam.length.toString();

            // return Text("data");
            return
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).snapshots(),
              builder: (BuildContext context, snapshot){

                if(snapshot.hasData){
                  // return Text("data");
                  // setState(() {
                  //   teamname = snapshot.data.docs;
                  // });
                  List<dynamic> currentTeams = [];
                  for(int i = 0 ; i<snapshot.data.docs.length; i++){
                    DocumentSnapshot teamSnapshot = snapshot.data.docs[i];
                    currentTeams.add(teamSnapshot.data());


                    // setState(() {
                    //   team = teamSnapshot.data()['teamName'];
                    // });
                  }

                  return  Padding(
                    padding: const EdgeInsets.only(top:20.0, right: 10, left : 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: currentTeams.length,
                      itemBuilder: (BuildContext context , index){

                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_)=> CreateTeams(num: number,team: team == null ? currentTeams[index]['teamName']: team,))
                            );
                          },
                          child: Card(
                            color:Colors.white70,
                            child: ListTile(

                              title: Text(currentTeams[index]['teamName']),
                              subtitle: Row(
                                children: [
                                  Text("created by"),
                                  SizedBox(width: 10,),
                                  Text("${_auth.currentUser.displayName}", style:TextStyle(color:Color(0xff00b18a), fontSize: 18,fontWeight: FontWeight.w500)),
                                   ],
                              ),
                              trailing: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert_outlined, color: Colors.black38, size: 20,),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'friends',
                                      child: new Text("Add to Team"),

                                    ),

                                    PopupMenuItem(
                                      value: 'groups',
                                      child: new Text("Teams/Groups"),

                                    ),

                                  ];
                                },
                                onSelected: (String value) async {
                                 if(value == "friends"){
                                   setState(() {
                                     team = currentTeams[index]['teamName'];
                                   });
                                   print("TEM< $team");
                                   Navigator.of(context).push(
                                       MaterialPageRoute(builder: (_)=> CreateTeams(num: number,team: team,))
                                   );
                                 }else{
                                   Navigator.of(context).push(
                                       MaterialPageRoute(builder: (_)=> UserGroups())
                                   );
                                 }

                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if(snapshot.hasError){

                  return Text('No teams', style: TextStyle(fontSize: 10),);
                }

                return Text('Loading..', style: TextStyle(fontSize: 10),);

              },
            )
                ;
          }

          if(snapshot.hasError){
            return Text("No Data");
          }
          return Center(child: Text("loading.."));
        },
      )
          :
      // Text(team);
    FutureBuilder(future: _firestore.collection('userTeams').doc(team_ID).collection("allUsers").get(),
        builder: (BuildContext context, snapshot){

        print('team ${team_ID}');
         // print('check ${snapshot.data.docs[0].data()}');
         List myteamUsers = [];
          if(snapshot.hasData){
            var querySnapshot =  snapshot.data;
            // print("my team_ ${selectedTeam} ${}");

             myteamUsers = querySnapshot.docs.map((doc) => doc.data()).toList();

            // setState(() {
            //   myteamUsers = allData;
            // });

            // resultteam.docs.forEach((field) {
            //   print("Al ${field.data()}");
            //
            //   print("dS ${allTeamUsers['uid']}");
            //   setState(() {
            //     myteamUsers = field.data();
            //   });

              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //
              //
              //
              //   print("dS ${allTeamUsers['uid']}");
              //   setState(() {
              //     myteamUsers = field.data();
              //   });
              //
              //
              // });

            // });




            // resultteam.docs.map((team){
            //   print("c ${team.data()['s']}");
            // }).toList();
                // final document = resultteam.where((doc)=> doc['teamID'] == team_ID);

                //print("AL ${document}");

              // allteamUsers.insert(0, {team.data()});
            // allteamUsers.add(allTeamUsers);

            // number = resultteam.length.toString()
            print("ALLDATA ${myteamUsers}");
             var index =    myteamUsers.indexWhere(((element) => element['user'] == "autoIndex"));

            var mydata =  myteamUsers.where(((element) => element['user'] == "autoIndex")).toList();
            for(var user in mydata){
              print("OBH _${user}");
              myteamUsers.removeAt(index);
              myteamUsers.insert(0, user);
            }
             // myteamUsers.insert(0, );

            print("new USERT ${myteamUsers.length}");

          // var exist =  allteams.any((element) => element['uid'] == allTeamUsers['uid']);
          //   print("CHRCK ${exist}");
          //   if(exist != true){
          //     allteams.add(allTeamUsers);
          //
          //     // var getuser =    allteamUsers.where((element) => element['user'] == "autoIndex");
          //     // allteamUsers.remove(getuser);
          //     // allteamUsers.insert(0, getuser);
          //
          //   }
          //
          //   print("ALL _ ${allteams}");

         // var getuser =    allteamUsers.where((element) => element['user'] == "autoIndex");
         //        allteamUsers.remove(getuser);

            // for(var i = 0 ; i<allteamUsers.length; i++){
            // }

            // return Text("data");
            return myteamUsers.length == 1 ?
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).snapshots(),
              builder: (BuildContext context, snapshot){

                if(snapshot.hasData){
                  // return Text("data");
                  // setState(() {
                  //   teamname = snapshot.data.docs;
                  // });
                  List<dynamic> currentTeams = [];
                  for(int i = 0 ; i<snapshot.data.docs.length; i++){
                    DocumentSnapshot teamSnapshot = snapshot.data.docs[i];
                    currentTeams.add(teamSnapshot.data());


                    // setState(() {
                    //   team = teamSnapshot.data()['teamName'];
                    // });
                  }

                  return  Padding(
                    padding: const EdgeInsets.only(top:20.0, right: 10, left : 10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: currentTeams.length,
                      itemBuilder: (BuildContext context , index){

                        return InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (_)=> CreateTeams(num: number,team: team == null ? currentTeams[index]['teamName']: team,))
                            );
                          },
                          child: Card(
                            color:Colors.white70,
                            child: ListTile(

                              title: Text(currentTeams[index]['teamName']),
                              subtitle: Row(
                                children: [
                                  Text("created by"),
                                  SizedBox(width: 10,),
                                  Text("${_auth.currentUser.displayName}", style:TextStyle(color:Color(0xff00b18a), fontSize: 18,fontWeight: FontWeight.w500)),
                                ],
                              ),
                              trailing: PopupMenuButton(
                                icon: Icon(
                                  Icons.more_vert_outlined, color: Colors.black38, size: 20,),
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'friends',
                                      child: new Text("Add to Team"),

                                    ),

                                    PopupMenuItem(
                                      value: 'groups',
                                      child: new Text("Teams/Groups"),

                                    ),

                                  ];
                                },
                                onSelected: (String value) async {
                                  if(value == "friends"){
                                    setState(() {
                                      team = currentTeams[index]['teamName'];
                                    });
                                    print("TEM< $team");
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_)=> CreateTeams(num: number,team: team,))
                                    );
                                  }else{
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_)=> UserGroups())
                                    );
                                  }

                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }

                if(snapshot.hasError){

                  return Text('No teams', style: TextStyle(fontSize: 10),);
                }

                return Text('Loading..', style: TextStyle(fontSize: 10),);

              },
            )

          : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 3 : 4),
                itemCount: myteamUsers.length ,
                padding: EdgeInsets.zero,
                itemBuilder: (_,index){
                  // print("T ${resultteam[index]}");
                  if(myteamUsers.length != 0){
                    // print("TRIM ${allteamUsers[index]}");

                    // setState(() {
                    //   number = team.length.toString();
                    // });

                    number = "${myteamUsers.length - 1}";

                     var teams = myteamUsers[index] ;
                    print("teamADD ${teams['user']}");
                    // print(resultteam[index]['phone']);
                    // print(" TDF  Index $index");

                              // var numbers = teams['Usersteam'];
                            //   if(numbers.length == 1){
                            //     setState(() {
                            //       numbers = 0;
                            //       number = numbers.toString();
                            //     });
                            //   }else{
                            //
                            // number = numbers.length.toString();
                            //   }

                    // return Text("data");

                    return Padding(
                        padding: const EdgeInsets.only(top:8.0, right: 8, left: 8, bottom: 0),
                        child:
                        index == 0 ?

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
                                    print(team);
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (_)=> CreateTeams(num: number, team:team))
                                    );
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

                            :
                        // Text("data")
                         teams['isMembers']== false ? Container() : SizedBox(
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              new Container(
                                width: 70,
                                height: 70,
                                decoration:teams['imageurl'] == null || teams['imageurl'] == "" ? BoxDecoration(
                                  color: Color(0xff692CAB).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(100),
                                ) :  BoxDecoration(
                                    color: Color(0xff692CAB).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(100),
                                    image: DecorationImage(
                                      image: NetworkImage(teams['imageurl']),
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
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        HeroDialogRoute(builder: (context) {
                                          return UpdateUserTeamProfile(userdata: teams,);
                                        }));
                                    // Navigator.of(context).push(
                                    //     HeroDialogRoute(builder: (context) {
                                    //       return MemberProfile(userdata:_auth.currentUser, user:teams);
                                    //     }));
                                  },
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top:8.0, left: 8, right: 8),
                                child: new Text(teams['user'] == ""  ? "" : teams['user'], style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal), textAlign: TextAlign.center,),
                              )
                            ],
                          ),
                        )
                    );
                  } else
                    return new Container();
                });
          }

          if(snapshot.hasError){
            return Text("No Data");
          }
      return Center(child: Text("loading.."));
        },
    );
  }

  Widget teamUsers(){
    return Column(
      children: [
        Padding(
       padding: const EdgeInsets.only(right: 40,left: 40, bottom: 20,top: 20),
       child: new Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           SizedBox(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                    color: Color(0xff692CAB).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(100),
                    image: DecorationImage(
                      image: AssetImage("assets/images/plusSign.png"),
                      fit: BoxFit.scaleDown,
                    )
                ),
                child: RaisedButton(
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
          ),
           SizedBox(
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 new Container(
                   width: 90,
                   height: 90,
                   decoration: BoxDecoration(
                       color: Color(0xff692CAB).withOpacity(0.2),
                       borderRadius: BorderRadius.circular(100),
                       image: DecorationImage(
                         image: AssetImage("assets/images/user1.png"),
                         fit: BoxFit.scaleDown,
                       )
                   ),
                   child: RaisedButton(
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
                   child: new Text("Martha", style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                 )
               ],
             ),
           ),
           SizedBox(
             child: new Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 new Container(
                   width: 90,
                   height: 90,
                   decoration: BoxDecoration(
                       color: Color(0xff692CAB).withOpacity(0.2),
                       borderRadius: BorderRadius.circular(100),
                       image: DecorationImage(
                         image: AssetImage("assets/images/user2.png"),
                         fit: BoxFit.scaleDown,
                       )
                   ),
                   child: RaisedButton(
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
                   child: new Text("Buhiire", style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                 )
               ],
             ),
           ),
         ],
       ),
     ),
        Padding(
          padding: const EdgeInsets.only(right: 40,left: 40, bottom: 20,top: 20),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Color(0xff692CAB).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage("assets/images/user3.png"),
                            fit: BoxFit.scaleDown,
                          )
                      ),
                      child: RaisedButton(
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
                      child: new Text("Yamzit", style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                    )
                  ],
                ),
              ),
              SizedBox(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Color(0xff692CAB).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage("assets/images/user1.png"),
                            fit: BoxFit.scaleDown,
                          )
                      ),
                      child: RaisedButton(
                        color: Colors.transparent,
                        disabledElevation: 0,
                        focusElevation: 0,
                        focusColor: Colors.transparent,
                        autofocus: false,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0,
                        hoverColor: Colors.transparent,
                        hoverElevation: 0,
                        // splashColor: Colors.transparent,
                        elevation: 0,
                        onPressed: (){
                          print("AM CLIDED");
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Text("Martha", style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                    )
                  ],
                ),
              ),
              SizedBox(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                          color: Color(0xff692CAB).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: AssetImage("assets/images/user2.png"),
                            fit: BoxFit.scaleDown,
                          )
                      ),
                      child: RaisedButton(
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
                      child: new Text("Buhiire", style: GoogleFonts.roboto(color: Color(0xff290E77), fontSize: 10, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal),),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  getteam()async{
     await _firestore.collection('teams').where("userId", isEqualTo: _auth.currentUser.uid).get().then((QuerySnapshot snapshot){

      if(snapshot.docs.length > 0){

        print('TEAM');
       ////  print(snapshot.docs.single.data()['Usersteam']);
       //// log("USERTEAMS" + snapshot.docs.single.data()['Usersteam'][1]['phone'].toString());
       ////  print(teamIds);

        //           var numbers = snapshot.docs.single.data()['Usersteam'];
        //           if(numbers.length == 1){
        //             setState(() {
        //               numbers = 0;
        //               number = numbers.toString();
        //             });
        //           }else{
        //
        //       setState(() {
        //         number = numbers.length.toString();
        //       });
        //           }
   //  List<TeamUsersModel> teamusers = (json.decode(team) as List).map((e) => TeamUsersModel.fromJson(e)).toList();
      print("users");
    //  print(teamusers.toString());
    //   print(numbers.length.toString());
    //     teamname = snapshot.docs.single.data()['teamName'];
         setState(() {
              teamname = snapshot.docs;
             // team = snapshot.docs.single.data()['Usersteam'];

         });


         if(teamname == null){
           setState(() {
             isLoading = false;
           });
         }

         Future.delayed(Duration(seconds: 1)).then((value){

          setState(() {
            isLoading = false;

          });

        });
      }

    });

     return teamname;
  }


  Widget showDiaLogs(){
    // BuildContext dialogContext;
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

            // BuildContext context;
            // Navigator.of(context).pop();


            // Navigator.of(context, rootNavigator: true).pop();

            if(_formKey.currentState.validate()){

              createteams(team: _controllerTeam.text);

              setState(() {

                selectedTeam = _controllerTeam.text;
                team = selectedTeam;
                getteam();

              });


              var snakBar = SnackBar(content: Text('The team created is ${_controllerTeam.text}', style: TextStyle(color: Colors.cyan),),);

              // Scaffold.of(context).showSnackBar(snakBar);
              ScaffoldMessenger.of(context).showSnackBar(snakBar);
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

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_)=> NewsFeed(selectedId: 0,))
            );



            // RestartWidget.restartApp(context);

            // Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsFeed()));
          },
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context){
      // dialogContext = context;
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
      var uuid  = _firestore.collection('d').doc().id;
      print("AUTO UUID ${uuid}");
      _firestore.collection("userTeams").doc(teamId).collection("allUsers").doc(uuid).set({
        "s" : 0,
        "user": "autoIndex",
        "imageurl" : null,
        "uid": uuid
      });



    });
  }

}



