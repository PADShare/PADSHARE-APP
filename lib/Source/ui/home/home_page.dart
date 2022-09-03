import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/all_users/users.dart';
import 'package:padshare/Source/ui/Pages/invitations/user_invitations.dart';
import 'package:padshare/Source/ui/Pages/login.dart';
import 'package:padshare/Source/ui/Payments/donation.dart';
import 'package:padshare/Source/ui/newsFeed/CreatePost.dart';
import 'package:padshare/Source/ui/newsFeed/newDetails.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:padshare/Source/ui/tabs/tabs_page.dart';
import 'package:padshare/Source/utils/restart/restart_app.dart';
import 'package:padshare/main.dart';
import 'package:uuid/uuid.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final docData = FirebaseFirestore.instance.collection("posts");

class HomePage extends StatefulWidget{

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey<FormState>_formKey = new GlobalKey<FormState>();
  TextEditingController _controllerTeam =  TextEditingController();
  var teamId = Uuid().v1();
  Timer timer;
  static BuildContext appContext;
  bool isSelected = false;

  List list = [];

  List<dynamic> posts=[];
  var name = _auth.currentUser.displayName[0];

  List<QueryDocumentSnapshot> notificationposts =[];

  List<void> currenttotalPosts;

  var currenttotalPost;
  getdata()async{
    var result = await getallList();

    // print(result);
  }

  Future notificationPosts()async{
    var snapshot = await _firestore.collection("allposts").orderBy('timestamp',descending: true ).get();
    // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection("allposts").orderBy('timestamp',descending: true ).snapshots();
    //   .then((QuerySnapshot snapshot){
    // snapshot.docs.forEach((DocumentSnapshot doc) {
    //   print(doc.data());
    //   print(doc.data()['message']);
    // });
    //
    // });

    setState(() {
      notificationposts = snapshot.docs;
    });
    // return snapshot.docs;

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

  Future fetchUserPosts()async{
    var snapshot = await _firestore.collection("allposts").orderBy('timestamp',descending: true ).get();
    // final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection("allposts").orderBy('timestamp',descending: true ).snapshots();
    //   .then((QuerySnapshot snapshot){
    // snapshot.docs.forEach((DocumentSnapshot doc) {
    //   print(doc.data());
    //   print(doc.data()['message']);
    // });
    //
    // });

   // setState(() {
   //   notificationposts = snapshot.docs;
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

  fetchPoststotal(){
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection("allposts").orderBy('timestamp',descending: true ).snapshots();
    print("DA_POST");
    _usersStream.forEach((doc) {
      print("DA_POST ${doc.docs}");
      // currenttotalPosts =
       doc.docs.map((e){
         currenttotalPost = e.data()['postId'];
         print("s ${currenttotalPost}");

         if(!list.contains(currenttotalPost)){
           list.add(currenttotalPost);
         }
         // print("s ${e.data()['postId']}");
       var mlist =   list.elementAt(0);
        print("m $mlist");
        var d = currenttotalPost;
        for(var i =0; i<mlist.length; i++){
          print("DIS_ ${mlist[i]}");

        }


       }).toList();


       print("DOC ${list}");
      // print("DOC_id ${list.}");
      // print("DOC ${currenttotalPost}");


      // if(!list.contains())
      // list.add(currenttotalPosts.length);


    });


  }



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    fetchUserPosts();
    // getDatalist();
    // getallList();
    allPostDocuments();
    //getallDocuments();
    notificationPosts();
    super.initState();
    appContext = context;
    // timer = Timer.periodic(Duration(seconds: 10), (timer)=> fetchPoststotal());
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  var datalength;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection("allposts").orderBy('timestamp',descending: true ).snapshots();


  getFetchPosts(){

    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){

          return Text("Something Went Wrong");
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return Text("Loading");
        }

        return ListView(
          children: snapshot.data.docs.map((DocumentSnapshot documentSnapshot){

            // return InkWell(
            //   onTap: (){
            //    // NavigateToDetailPage(documentSnapshot.data());
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(top:10.0, bottom: 10, right: 10,left: 10),
            //     child: ListItemsPosts(documentSnapshot.data()['mediaUrl'], documentSnapshot.data()['message'], snapshot.data()[index], date),
            //   ),
            // );

          }).toList(),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    // print("df ${_auth.currentUser}");
    List<String> listOfStrings = ["apple", "banana", "strawberry", "cherry"];
    var orientation = MediaQuery.of(context).orientation == Orientation.landscape;
    // TODO: implement build
    return new Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      backgroundColor: Color(0xffF4F6FE),
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Transform.translate(
          offset: Offset(-26,0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:13.0),
                child: GestureDetector(
                  onTap: (){
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Icon(Icons.menu, color: Color(0xff692CAB), size: 33,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:6.0),
                child: new Text(_auth.currentUser.displayName, style: GoogleFonts.roboto(color: Color(0xff666363), fontWeight: FontWeight.bold,fontSize: 14),),
              )
            ],
          ),
        ),

        // title: new Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     GestureDetector(
        //       onTap: (){},
        //       child: Icon(Icons.menu, color: Color(0xff692CAB), size: 33,),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(left:14.0, top: 8),
        //       child: new Text("Hey Sandra!", style: GoogleFonts.roboto(color: Color(0xff666363), fontWeight: FontWeight.bold,fontSize: 14),),
        //     )
        //   ],
        // ),
        actions: [
          // PopupMenuTheme(data: data, child: child)
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              color: Colors.transparent,
              elevation: 0,
              onSelected: (isSelected){
                print("Is Selected_");
              },
              itemBuilder: (context){

                return <PopupMenuItem<String>>[
                  PopupMenuItem<String>(
                      // child: FutureBuilder(
                      //   future: fetchUserPosts(),
                      //   builder: (context, snapshot){
                      //
                      //     if(snapshot.hasData){
                      //       return  ;
                      //     }
                      //     return Center(child: CircularProgressIndicator(),);
                      //   },
                      //
                      // )
                    child: Container(
                      color: Colors.black54,
                      width: MediaQuery.of(context).size.width,
                      child: LimitedBox(
                        maxHeight: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            shrinkWrap: true,
                           itemCount: notificationposts.length,
                           itemBuilder: (context, index){

                             datalength = notificationposts.length;
                             Timestamp time2 = notificationposts[index]['timestamp'];
                             final DateTime docDateTime = DateTime.parse(time2.toDate().toString());
                             //var date =  DateFormat('EEE, MMM d, ''yy').format(docDateTime);
                             // var date = DateFormat.yMMMMd('en_US').format(docDateTime);

                             DateTime time = DateTime.tryParse(time2.toDate().toString());
                             var date = timeago.format(time);

                             print("TEST $date");

                             print("POST ${notificationposts[index].data()}");

                             // return Text("data");
                             return   GestureDetector(
                               onTap: ()async{
                                 Navigator.pop(context);
                                 NavigateToDetailPage(notificationposts[index]);
                                 await _firestore
                                     .collection('post')
                                     .doc(notificationposts[index]['ownerId'])
                                     .collection('userPosts')
                                     .doc(notificationposts[index]['postId'])
                                     .update({
                                   "isPostSelected" : true,
                                   "activePost" : 0
                                 });

                                 await _firestore
                                     .collection('allposts')
                                     .doc(notificationposts[index]['postId'])
                                     .update({
                                   "isPostSelected" : true,
                                   "activePost" : 0
                                 });


                                 print("list ${currenttotalPosts.length}");


                                 setState(() {
                                   isSelected = true;
                                   currenttotalPosts.removeAt(0);
                                   notificationposts[index].data()['isPostSelected'] = true;
                                 });



                               },
                               child: Card(
                                 color: notificationposts[index]['isPostSelected'] == true ? Colors.black.withOpacity(0.08) : Colors.black12,
                                 elevation: notificationposts[index]['isPostSelected'] == true ? 0 : 1,
                                 child: ListTile(

                                   leading: CircleAvatar(
                                     backgroundImage: NetworkImage(notificationposts[index].data()['mediaUrl']),
                                     radius: 25,
                                     backgroundColor: Colors.blueGrey.shade200,
                                     child: Stack(
                                       overflow: Overflow.visible,
                                       children: [
                                         Positioned(
                                           top: 30,
                                           right: -8,
                                           child: Align(
                                             alignment: Alignment.bottomRight,
                                             child: CircleAvatar(
                                               radius: 15,
                                               backgroundColor: Colors.white70,
                                               child: Image.asset("assets/images/bell.png", height:20,width:20),
                                             ),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                   title:   new Text("you have new post from ${notificationposts[index]['username']}", maxLines: 2,style:TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color:Colors.white), overflow: TextOverflow.ellipsis,),
                                   subtitle: Text(date, style:TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color:Colors.greenAccent)),
                                   trailing: notificationposts[index]['isPostSelected'] == true ? Container( height: 1, width: 1):Container( height: 15, width: 15, decoration: BoxDecoration(
                                       color: Colors.blue,
                                       borderRadius: BorderRadius.circular(100)
                                   ),) ,
                                 ),
                               ),
                             );

                           },
                        ),
                      ),
                    ),

                  )

                ];
              },
              // icon:  Badge(
              //     badgeContent: datalength == null ? new Text("0",  style: GoogleFonts.roboto(color: Colors.white, fontSize: 8),) : new Text( isSelected ? (datalength - 1).toString() : datalength.toString(), style: GoogleFonts.roboto(color: Colors.white, fontSize: 8),),
              //     child: SvgPicture.asset("assets/images/notification.svg")),
              icon:  Badge(
                  // Text(currenttotalPosts.length.toString()),
                  badgeContent: new Text(currenttotalPosts == null ? "0" : currenttotalPosts.length.toString(),  style: GoogleFonts.roboto(color: Colors.white, fontSize: 8),),
                  child: SvgPicture.asset("assets/images/notification.svg")),
              )),
        ],

      ),
      drawer: Theme(
        data: new ThemeData(canvasColor: Color(0xff3F2060)),
        child: Drawer(

          child: new ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                    color: Color(0xff16CF8C)
                ),
                accountEmail: Text(_auth.currentUser.phoneNumber),
                accountName: new Text(_auth.currentUser.displayName.toString() ?? ''),

                currentAccountPicture: ClipRRect(
                  borderRadius: BorderRadius.circular(110),
                  child: _auth.currentUser.photoURL==null ? Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.deepOrangeAccent.shade200,
                      child: Center(child: Text(name.toUpperCase(),style: GoogleFonts.roboto(color: Colors.white54, fontSize: 35, fontWeight: FontWeight.w500),),),
                    ),
                  ) : Image.network(_auth.currentUser.photoURL, fit: BoxFit.cover,),
                ),
              ),


              Padding(
                padding: EdgeInsets.only(top: 50,left: 40,bottom: 70),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    new Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => NewsFeed(selectedId: 0,)
                                  )
                              );
                              // RestartWidget.restartApp(context);
                            },
                            leading: Icon(Icons.home, color: Colors.white,),
                            title: new Text("Home", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              // setState(() {
                              //      setState(() {
                              //
                              //      });
                              //      Navigator.of(context).pop();

                                //   Navigator.push(context, MaterialPageRoute(
                                //
                                //     builder: (_){
                                //   return  NewsFeed(index: 4,);
                                // }));

                                //NewsFeed(index: 3,);
                              // });

                                   // Navigator.pushReplacement(
                                   //   context,
                                   //   MaterialPageRoute(builder: (context) => TabsPage(selectedIndex: 2)),
                                   // );

                                   Navigator.pushReplacement(
                                     context,
                                     MaterialPageRoute(builder: (context) => NewsFeed(selectedId: 4)),
                                   );


                              // Navigator.push(context, MaterialPageRoute(maintainState: true,builder: (_) => NewsFeed(index: 3,)));

                                   // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                   //     NewsFeed(selectedId: 3,)), (Route<dynamic> route) => false);

                                   // RestartAPPWidget.restartApp(context);



                            },
                            leading: Icon(Icons.person_outline_outlined, color: Colors.white,),
                            title: new Text("Profile", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => NewsFeed(selectedId: 1)),
                              );
                            },
                            leading: Icon(Icons.food_bank, color: Colors.white,),
                            title: new Text("PadBank", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: (){
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => NewsFeed(selectedId: 3)),
                              );
                            },
                            leading: Icon(Icons.shop, color: Colors.white,),
                            title: new Text("Shop", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),

                          child: ListTile(
                            onTap: ()async{

                              // _auth.signOut().then((value){
                              //
                              //   Navigator.of(context).pushReplacement(
                              //       MaterialPageRoute(
                              //           builder:(_) => Login()
                              //       )
                              //   );
                              //
                              //
                              // });
                              Navigator.of(context).pop();
                              showDiaLogs();




                            },
                            leading: Icon(Icons.cancel_outlined, color: Colors.white.withOpacity(0.5),),
                            title: new Text("Logout", style: TextStyle(color:Colors.white.withOpacity(0.5), fontWeight: FontWeight.w500),),
                          ),
                        ),
                      ],
                    ),





                  ],
                ),
              ),

            ],

          ),
        ),
      ),
      body: new Builder(
        builder: (BuildContext context){
          return Column(
            children: <Widget>[
              Expanded(
                flex: orientation ? 35 : 7,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 410,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(49),
                        bottomLeft: Radius.circular(49),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 8,
                            offset: Offset(0,1),
                            spreadRadius: 4
                        )
                      ]
                  ),
                  child: SafeArea(
                    child: Wrap(
                      children: [
                        new Column(
                          children: [
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 13),
                              child: new Text("What would you want to", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 12, fontWeight: FontWeight.bold),),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 30,right: 30),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    child: new Column(
                                      children: [

                                        new Container(
                                          width: 85,
                                          height: 85,
                                          decoration:  BoxDecoration(
                                              color: Color(0xff16CF8C).withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(100),
                                              border: Border.all(color: Color(0xffE7FAF3), width:8),
                                              image:  DecorationImage(
                                                  fit: BoxFit.scaleDown,
                                                  scale: 1.3,
                                                  image: AssetImage("assets/images/padsicon.png")
                                              )
                                          ),
                                          child: InkWell(
                                            onTap: (){
                                             var list1 = [];
                                             // 5dd10023-0b2d-4346-8e63-92ca3729170a
                                             // 7a696e6e-6094-4af8-bdf3-da208a957cb7
                                             // var id = {"5dd10023-0b2d-4346-8e63-92ca3729170a":false};
                                             //   list1.insert(0, id);
                                             //
                                             //   list.insert(0,list1);

                                              // print(mylist.elementAt(2));

                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_)=> Donations()),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        new  Text("Give", style: GoogleFonts.roboto(color: Color(0xff94989B), fontSize: 12, fontWeight: FontWeight.w600),)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: new Column(
                                      children: [
                                        new Container(
                                          width: 85,
                                          height: 85,
                                          decoration:  BoxDecoration(
                                              color: Color(0xffF6A96C).withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(100),
                                              border: Border.all(color: Color(0xffFEF6F0), width:8),
                                              image:  DecorationImage(
                                                  fit: BoxFit.scaleDown,
                                                  scale: 1.3,
                                                  image: AssetImage("assets/images/addStory.png")
                                              )
                                          ),
                                          child: new InkWell(
                                            onTap: (){
                                              Navigator.of(context).push(
                                                MaterialPageRoute(builder: (_)=> CreatePost()),
                                              );
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        new  Text("Add story", style: GoogleFonts.roboto(color: Color(0xff94989B), fontSize: 12, fontWeight: FontWeight.w600),)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: new Column(
                                      children: [
                                        new Container(
                                          width: 85,
                                          height: 85,
                                          decoration:  BoxDecoration(
                                              color: Color(0xff692CAB).withOpacity(0.3),
                                              borderRadius: BorderRadius.circular(100),
                                              border: Border.all(color: Color(0xffF0E9F7), width:8),
                                              image:  DecorationImage(
                                                  fit: BoxFit.scaleDown,
                                                  scale: 1.3,
                                                  image: AssetImage("assets/images/card.png")
                                              )
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        new  Text("Pad Credit", style: GoogleFonts.roboto(color: Color(0xff94989B), fontSize: 12, fontWeight: FontWeight.w600),)
                                      ],
                                    ),
                                  )
                                ],),
                            )

                          ],

                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only( top: 30, left: 50),
                      child: new Text("Stories", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w300),),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 8,
                child: new Container(
                  child: Container(
                    // color: Colors.blue,
                    // child: new Text("data"),

                    child: FutureBuilder(
                      future: fetchUserPosts(),
                      builder: (_, snapshot){

                        if(snapshot.hasError) {

                          return  Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.brown.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Image.asset("assets/images/signal.png", height: 40, color: Colors.white70,),
                                          Text("Check your connection", style: TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w400),)
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );

                        }


                        if(snapshot.hasData){

                          var result = snapshot.data;

                          return result.length == 0 ?
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset("assets/images/cloud-computing.png", height: 40, color: Colors.grey,),
                                          SizedBox(width: 20,),
                                          Text("No Posts", style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.w400),)
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                              :ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index){
                              var dataposts = snapshot.data[index];
                              Timestamp time = dataposts['timestamp'];
                              final DateTime docDateTime = DateTime.parse(time.toDate().toString());
                              var date =  DateFormat('EEE, MMM d, ''yy').format(docDateTime);
                              print("date");
                              print(date);
                              // var date = DateTime.parse(time);
                              // print (date);


                              // return new Text(data['message']);
                              return snapshot.data.length == 0 ? Container(
                                child: Center(child: Text("No posts", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),),),
                              ) :InkWell(
                                onTap: (){
                                  NavigateToDetailPage(snapshot.data[index]);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top:10.0, bottom: 10, right: 10,left: 10),
                                  child: ListItemsPosts(dataposts['mediaUrl'], dataposts['message'], snapshot.data[index], date),
                                ),
                              );
                            } ,
                          );

                          // return Center(child: Text("no stories yet", style: GoogleFonts.roboto(color: Colors.white54),));
                        }

                        return Center(child:CircularProgressIndicator());
                        // return Text("no Posts yet..");



                      },
                    ),

                    // child: getFetchPosts(),


                    // child: FutureBuilder(
                    //   future: allPostDocuments(),
                    //   builder: (_, snapshot){
                    //     if(snapshot.hasData){
                    //       // print(snapshot.data);
                    //      // return Text("data");
                    //      // print(snapshot.data[0]['messages'].picture);
                    //       return MediaQuery.removePadding(
                    //         removeTop: true,
                    //         context: context,
                    //         child: new ListView.builder(
                    //
                    //             itemCount: snapshot.data.length,
                    //             itemBuilder: (_, index){
                    //               // DocumentSnapshot data = snapshot.data[index];
                    //               // var data =snapshot.data[index];
                    //               //   print(snapshot.data);
                    //
                    //               return Text("data");
                    //
                    //               // return Padding(
                    //               //   padding: const EdgeInsets.only(top:10.0, bottom: 10, right: 10,left: 10),
                    //               //   child: ListItemsPosts(data['picture'],data['title'], data['message'], data),
                    //               // );
                    //             }
                    //
                    //         ),
                    //       );
                    //     }
                    //     return Center(child: CircularProgressIndicator());
                    //   },
                    // ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButton: SpeedDial(
        // animatedIcon: AnimatedIcons.a,
        activeIcon: Icons.close,
        icon: Icons.add,
        buttonSize: Size(40,40),
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
                showTeamDialogo();
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

  Future getallDocuments() async{
    var data = await _firestore.collection("posts").get();

    //debugPrint("RESPONSE::::" + data.docs.single.data()['message']);

    //return data.docs.single.data()['message'];


  }

  // getDatalist()async{
  //  docData.get().then((QuerySnapshot snapshot){
  //    snapshot.docs.forEach((DocumentSnapshot doc) {
  //       print("DataSAMPLE::");
  //       print(doc.data()['message']);
  //       print(doc.id);
  //       print(doc.reference);
  //
  //    });
  //  });
  // }

  Future getDatalist() async{
    QuerySnapshot  snapshot = await docData.get();
    // snapshot.docs.forEach((DocumentSnapshot doc)
    //  {
    //   print("DADDD:");
    //   print(doc.id) ;
    //
    //     });

    //   => doc.data()['message']);

    var data = snapshot.docs;

    setState(() {
      posts = data;
    });

    // return result;
  }

  Future allPostDocuments() async{
    // var data = _firestore.collection("posts").get().then((querySnapshot)=>{
    //   querySnapshot.forEach(())
    // });

    var response ;

    var snapshot = await _firestore.collection("posts").get();
    var data = snapshot.docs.map((doc)=> doc.data());
    // debugPrint("RESPONSE::::" + data.docs.single.data()['message']);
    final List<DocumentSnapshot> documents = snapshot.docs;

    // documents.forEach((element) {
    //   debugPrint("DATA::" + element.data()['message'][0]['title'].toString());
    //   setState(() {
    //     response = element;
    //   });
    // });
    // debugPrint("RESPONSE::::" + response);

    var datas = snapshot.docs.map((doc)=> doc.data());

    return datas;



    // return data.docs.single.data()['message'];


  }


  Future<void> getallList() async{
    var result;
    CollectionReference _collectionRef = _firestore.collection("posts");
    QuerySnapshot querySnapshot = await _collectionRef.get();
    final allData = querySnapshot.docs.map((e) => e.data()).toList();
    print("TESTING DATA");
    // allData[2]['message'][0]['title'].toString()
    allData.forEach((element) {
      print (element['message'][0]['title']);
      setState(() {
        result = element['message'];
      });
    });

    return result;
  }




  Widget ListItemsPosts(image,subTitle, DocumentSnapshot index, date){

    return new Container(
        width: MediaQuery.of(context).size.width * 0.86,
        height: 118,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Color(0xffFFFFFF),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300],
                blurRadius: 5,
                offset: Offset(0,3),
              )
            ]
        ),

        child: Padding(
          padding: const EdgeInsets.only(top:14.0, left: 14, bottom: 14),
          child: new Row(children: [

            new Column(
              children: [
                new Container(
                  height: 90,
                  width: 91,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: image == null ?  AssetImage("assets/images/dark-placeholder.png") : NetworkImage(image)
                      )
                  ),
                ),
              ],
            ),

            Container(
              width: MediaQuery.of(context).size.width * .59,
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom:4.0),
                  child: Transform.translate(
                      offset: new Offset(-2, 0),
                      child: Row(

                        children: [
                          new Text("Posted :", style: GoogleFonts.roboto(fontSize: 10,color: Color(0xff666363).withOpacity(0.4),fontWeight: FontWeight.bold),),
                          new Text(date.toString(), style: GoogleFonts.roboto(fontSize: 10,color: Color(0xff666363).withOpacity(0.3),fontWeight: FontWeight.bold),),
                        ],
                      )),
                ),

                subtitle: Transform.translate(
                  offset: new Offset(-2, 0),
                  child: new Text(subTitle ?? "",
                    maxLines: 3, style: TextStyle(fontSize: 12),

                  ),
                ),

                trailing: Icon(Icons.arrow_forward_ios),
                contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                dense:true,
                // onTap: () {
                //  NavigateToDetailPage(index);
                // },
              ),
            )

          ],),
        )

    );
  }

  void NavigateToDetailPage(DocumentSnapshot posts) {




    WidgetsBinding.instance.addPostFrameCallback((_){

      // Add Your Code here.

      Navigator.push(context,
          MaterialPageRoute(builder: (_)=> NewDetails(userpost: posts))
      );

    });
  }

  Widget showDiaLogs(){

    AlertDialog alertDialog = AlertDialog(
       contentTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54),
      title: Center(child: Text("Log Out")),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      content: Container(
        height: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text("Are you sure you would like to log out?.Your history will be cleared and you'll need to log in again", textAlign: TextAlign.center,)),
            SizedBox(height: 30,),
            TextButton(
              child: Container(
                height: 40,
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:Colors.cyan,
                  ),
                  child: Center(child: Text("YES",style: TextStyle(color: Colors.white)))),
              onPressed: () {
                // Navigator.of(context).pop();
                //  Navigator.pop(context);
                Navigator.of(context, rootNavigator: true).pop('dialog');
                _onLoading(context);

                // Navigator.push(context, MaterialPageRoute(builder: (_)=>ManageAddress()));
              },
            ),
            TextButton(
              child: Container(
                  height: 40,
                  width:MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color:Colors.black54,
                  ),
                  child: Center(child: Text("NO", style: TextStyle(color: Colors.white54),))),
              onPressed: () {

                Navigator.of(context, rootNavigator: true).pop('dialog');

                // Navigator.of(context).pop();

                // RestartWidget.restartApp(context);

                 // Navigator.push(context, MaterialPageRoute(builder: (_)=>NewsFeed()));
              },
            )
          ],
        ),
      ),
      actions: [

      ],
    );

    showDialog(context: context, builder: (_)=> alertDialog);
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
              new Text("logging out of Padshare..", style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      _auth.signOut().then((value){

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder:(_) => Login()
            )
        );


      });

    });
  }
  Widget progressIndictor() {

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // new Text('Loading please wait...', style: GoogleFonts.roboto(color: Colors.white, fontSize: 12),),
        SpinKitDoubleBounce(
          size: 44.0,
          color: Colors.blue,
        ),
      ],
      // )
    );
  }

  showTeamDialogo() {
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

              // setState(() {
              //   _controllerTeam.text = "";
              // });


              var snakBar = SnackBar(content: Text('The team created is ${_controllerTeam.text}', style: TextStyle(color: Colors.cyan),),);

              ScaffoldMessenger.of(context).showSnackBar(snakBar);

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
  createteams( context,{String team}){
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