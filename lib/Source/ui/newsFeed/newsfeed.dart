
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/NavigationScreens/Shop.dart';
import 'package:padshare/Source/ui/NavigationScreens/impact.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/Payments/donation.dart';
import 'package:padshare/Source/ui/Teams/team.dart';
import 'package:padshare/Source/ui/home/home_page.dart';
import 'package:padshare/Source/ui/newsFeed/CreatePost.dart';
import 'package:padshare/Source/ui/tabs/Nav_tabs/bottom_tabs.dart';
import 'package:padshare/Source/utils/restart/restart_app.dart';
import 'package:padshare/Source/widgets/customBottombar.dart';
import 'package:padshare/main.dart';




final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
final docData = FirebaseFirestore.instance.collection("posts");
class NewsFeed extends StatefulWidget{
  int selectedId = 0;
  NewsFeed({this.selectedId});
  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
   int _selectedId = 0;
  FloatingActionButton floatingActionButton;
  Icon fabIcon = Icon(Icons.perm_media);
  List<Widget> _pagesSelected = [
    new CustomBottomTabs(child: HomePage(),),
    new CustomBottomTabs(child: Impact(),),
    new CustomBottomTabs(child: Impact(),),
    new CustomBottomTabs(child: Shop(),),
    new CustomBottomTabs(child: UserProfile(),),

  ];


  void changeIcon(Icon icon) {
    setState(() {
      fabIcon = icon;
    });
  }
    @override
  void initState() {
    // TODO: implement initState
       _onTapped(widget.selectedId);
      // _onItemTapped(widget.selectedIndex);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    // floatingActionButton = FloatingActionButton(
    //   onPressed: () {},
    //   child: fabIcon,
    // );

    floatingActionButton = FloatingActionButton(backgroundColor: Colors.white,
        onPressed: (){
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => Donations())
      );
        },
        elevation: 3,
        child: new Container(
          width: 60,
          height:60,
          decoration: BoxDecoration(
            color: Color(0xff6C1682),
            border: Border.all(color: Color(0xffFAFAFA),width: 3),
            borderRadius: BorderRadius.circular(100),
          ),
          child: new Container(
            width: 60,
            height:60,
            decoration: BoxDecoration(
              color: Color(0xffFAFAFA),
              border: Border.all(color: Color(0xff6C1682),width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            child:  Center(
              child: new Text(
                "GIVE", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        )

    );

    super.didChangeDependencies();
  }

  Map<int, GlobalKey> navigatorKeys = {
    0: GlobalKey(),
    1: GlobalKey(),
    2: GlobalKey(),
    3: GlobalKey(),
    4: GlobalKey(),
  };
  @override
  Widget build(BuildContext context) {
    print("PAGE_INDEX:: $_selectedId   Page${_pagesSelected.length} SELECYED:${widget.selectedId}");
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Color(0xffF4F6FE),
      // body: _pagesSelected[selectedId],
      body: WillPopScope(
        onWillPop: ()async{
          return !await Navigator.maybePop(navigatorKeys[_selectedId].currentState.context);
          // return await Future<bool>.value(true);
        },
        child: RestartWidget(
          child: IndexedStack(
            children: [
              for (final tabItem in TabNavigationItem.items) tabItem.page,
            ],
            index:widget.selectedId, //_selectedId,
          ),
        ),
      ),

  floatingActionButton: this.floatingActionButton,
  floatingActionButtonLocation:  FloatingActionButtonLocation.centerDocked,

   bottomNavigationBar: BottomNavigationBar(
     unselectedItemColor: Color(0xff8A8A8C),
     selectedItemColor: Color(0xff692CAB),
     currentIndex:  _selectedId,
     type: BottomNavigationBarType.fixed ,
     onTap: _onTapped,
     // onTap: (value){
     //   setState(() {
     //     selectedId = value;
     //   });
     // },
     items: [
       BottomNavigationBarItem(
           icon: ImageIcon(AssetImage("assets/images/home.png")),
           title: new Text('Home')
       ),
       BottomNavigationBarItem(
           icon: ImageIcon(AssetImage("assets/images/impact.png")),
           title: new Text('Impact'),

       ),
       BottomNavigationBarItem(
           icon: Icon(
             null,
           ),
           title: Text('')),
       BottomNavigationBarItem(
           icon: ImageIcon(AssetImage("assets/images/shop.png")),
           title: new Text('shop'),),

    BottomNavigationBarItem(
    icon: ImageIcon(AssetImage("assets/images/profile1.png")),
    title: new Text('profile')
       )
     ],

   ),

    );
  }

  Widget _onTapped(int index){
  setState(() {
     widget.selectedId = index;
      _selectedId = widget.selectedId;
    // _selectedId = index;
    if(index != 2){

      floatingActionButton =  getFloatingActionButton(index);
    }
    print(_selectedId);
  });
  }
  // new Text(
  // "GIVE", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
  // ),
 Widget getFloatingActionButton(int index){

    switch (index) {
     case 0: // Home
       return FloatingActionButton(backgroundColor: Colors.white,
         onPressed: (){
           Navigator.of(context).push(
               MaterialPageRoute(builder: (_) => Donations())
           );
         },
           elevation: 3,
         child: new Container(
           width: 60,
           height:60,
           decoration: BoxDecoration(
             color: Color(0xff6C1682),
             border: Border.all(color: Color(0xffFAFAFA),width: 3),
             borderRadius: BorderRadius.circular(100),
           ),
           child: new Container(
             width: 60,
             height:60,
             decoration: BoxDecoration(
               color: Color(0xffFAFAFA),
               border: Border.all(color: Color(0xff6C1682),width: 2),
               borderRadius: BorderRadius.circular(100),
             ),
             child:  Center(
               child: new Text(
                 "GIVE", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
               ),
             ),
           ),
         )

       );
     case 1: // Map
       return FloatingActionButton(backgroundColor: Colors.white,
         onPressed: (){
           changeIcon(Icon(Icons.save));
           Navigator.of(context).push(
               MaterialPageRoute(builder: (_) => Donations())
           );
         },
           elevation: 3,
         child: new Container(
           width: 60,
           height:60,
           decoration: BoxDecoration(
             color: Color(0xff6C1682),
             border: Border.all(color: Color(0xffFAFAFA),width: 3),
             borderRadius: BorderRadius.circular(100),
           ),
           child: new Container(
             width: 60,
             height:60,
             decoration: BoxDecoration(
               color: Color(0xffFAFAFA),
               border: Border.all(color: Color(0xff6C1682),width: 2),
               borderRadius: BorderRadius.circular(100),
             ),
             child:  Center(
               child: new Text(
                 "GIVE", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
               ),
             ),
           ),
         )
       );
     case 2: // Notification
       return new FloatingActionButton(backgroundColor: Colors.white,
         onPressed: (){},
         elevation: 3,
         child: new Text(
           "GIVE", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
         ),
       );
     case 3: // Notification
       return new FloatingActionButton(backgroundColor: Colors.white,
           onPressed: (){
             Navigator.of(context).push(
                 MaterialPageRoute(builder: (_) => Donations())
             );
           },
           elevation: 3,
           child: new Container(
             width: 70,
             height:70,
             decoration: BoxDecoration(
               color: Color(0xff6C1682),
               border: Border.all(color: Color(0xffFAFAFA),width: 3),
               borderRadius: BorderRadius.circular(100),
             ),
             child: new Container(
               width: 70,
               height:70,
               decoration: BoxDecoration(
                 color: Color(0xffFAFAFA),
                 border: Border.all(color: Color(0xff6C1682),width: 2),
                 borderRadius: BorderRadius.circular(100),
               ),
               child:  Center(
                 child: new Text(
                   "GIVE", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
                 ),
               ),
             ),
           )
       );
     case 4: // Chat
       return FloatingActionButton(backgroundColor: Colors.white,
           onPressed: (){
             Navigator.of(context).push(
                 MaterialPageRoute(builder: (_) => Teams())
             );
           },
           elevation: 3,
           child: new Container(
             width: 70,
             height:70,
             decoration: BoxDecoration(
               color: Color(0xff6C1682),
               border: Border.all(color: Color(0xffFAFAFA),width: 3),
               borderRadius: BorderRadius.circular(100),
             ),
             child: new Container(
               width: 70,
               height:70,
               decoration: BoxDecoration(
                 color: Color(0xffFAFAFA),
                 border: Border.all(color: Color(0xff6C1682),width: 2),
                 borderRadius: BorderRadius.circular(100),
               ),
               child:  Center(
                 child: new Text(
                   "TEAM", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
                 ),
               ),
             ),
           )
       );
     default:
       return FloatingActionButton(backgroundColor: Colors.white,
         onPressed: (){},
         child: new Container(
           width: 70,
           height:70,
           decoration: BoxDecoration(
             color: Color(0xff6C1682),
             border: Border.all(color: Color(0xffFAFAFA),width: 3),
             borderRadius: BorderRadius.circular(100),
           ),
           child: new Container(
             width: 70,
             height:70,
             decoration: BoxDecoration(
               color: Color(0xffFAFAFA),
               border: Border.all(color: Color(0xff6C1682),width: 2),
               borderRadius: BorderRadius.circular(100),
             ),
             child:  Center(
               child: new Text(
                 "GIVE", style: TextStyle(color: Color(0xff6C1682), fontSize: 13, fontWeight: FontWeight.w400),
               ),
             ),
           ),
         )
       );
   }

  }



  Widget showDiaLogs(BuildContext context){

    AlertDialog alertDialog = AlertDialog(
      title: Text("Information"),
      content: Text("This service is not yet available.Kindly check back later."),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.pop(context);

            // Navigator.push(context, MaterialPageRoute(builder: (_)=>ManageAddress()));
          },
        )
      ],
    );

    showDialog(context: context, builder: (_)=> alertDialog);
  }


}



// class HomePage extends StatefulWidget{
//
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getallDocuments();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     final PageStorageBucket _bucket = new PageStorageBucket();
//     return PageStorage(
//       bucket: _bucket,
//       child: Scaffold(
//           extendBodyBehindAppBar: true,
//           appBar: new AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             title: new Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 GestureDetector(
//                   onTap: (){},
//                   child: Icon(Icons.menu, color: Color(0xff692CAB), size: 33,),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left:14.0, top: 8),
//                   child: new Text("Hey Sandra!", style: GoogleFonts.roboto(color: Color(0xff666363), fontWeight: FontWeight.bold,fontSize: 14),),
//                 )
//               ],
//             ),
//             actions: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 15),
//                 child: GestureDetector(
//                   onTap: (){},
//                   child: SvgPicture.asset("assets/images/notification.svg"),
//                 ),
//               ),
//             ],
//           ),
//           body: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: 269,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.only(
//                           bottomRight: Radius.circular(49),
//                           bottomLeft: Radius.circular(49),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                               color: Colors.grey,
//                               blurRadius: 8,
//                               offset: Offset(0,1),
//                               spreadRadius: 4
//                           )
//                         ]
//                     ),
//                     child: SafeArea(
//                       child: new Column(
//                         children: [
//                           SizedBox(height: 8,),
//                           Padding(
//                             padding: const EdgeInsets.only(bottom: 8),
//                             child: new Text("What would you want to", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 12, fontWeight: FontWeight.bold),),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.only(left: 30,right: 30),
//                             child: new Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 SizedBox(
//                                   child: new Column(
//                                     children: [
//                                       new Container(
//                                         width: 85,
//                                         height: 85,
//                                         decoration:  BoxDecoration(
//                                             color: Color(0xff16CF8C).withOpacity(0.3),
//                                             borderRadius: BorderRadius.circular(100),
//                                             border: Border.all(color: Color(0xffE7FAF3), width:8),
//                                             image:  DecorationImage(
//                                                 fit: BoxFit.scaleDown,
//                                                 scale: 1.3,
//                                                 image: AssetImage("assets/images/padsicon.png")
//                                             )
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       new  Text("Give", style: GoogleFonts.roboto(color: Color(0xff94989B), fontSize: 12, fontWeight: FontWeight.w600),)
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   child: new Column(
//                                     children: [
//                                       new Container(
//                                         width: 85,
//                                         height: 85,
//                                         decoration:  BoxDecoration(
//                                             color: Color(0xffF6A96C).withOpacity(0.3),
//                                             borderRadius: BorderRadius.circular(100),
//                                             border: Border.all(color: Color(0xffFEF6F0), width:8),
//                                             image:  DecorationImage(
//                                                 fit: BoxFit.scaleDown,
//                                                 scale: 1.3,
//                                                 image: AssetImage("assets/images/addStory.png")
//                                             )
//                                         ),
//                                         child: new InkWell(
//                                           onTap: (){
//                                             Navigator.of(context).pushReplacement(
//                                               MaterialPageRoute(builder: (_)=> CreatePost()),
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       new  Text("Add story", style: GoogleFonts.roboto(color: Color(0xff94989B), fontSize: 12, fontWeight: FontWeight.w600),)
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   child: new Column(
//                                     children: [
//                                       new Container(
//                                         width: 85,
//                                         height: 85,
//                                         decoration:  BoxDecoration(
//                                             color: Color(0xff692CAB).withOpacity(0.3),
//                                             borderRadius: BorderRadius.circular(100),
//                                             border: Border.all(color: Color(0xffF0E9F7), width:8),
//                                             image:  DecorationImage(
//                                                 fit: BoxFit.scaleDown,
//                                                 scale: 1.3,
//                                                 image: AssetImage("assets/images/card.png")
//                                             )
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       new  Text("Pad Credit", style: GoogleFonts.roboto(color: Color(0xff94989B), fontSize: 12, fontWeight: FontWeight.w600),)
//                                     ],
//                                   ),
//                                 )
//                               ],),
//                           )
//
//                         ],
//
//                       ),
//                     ),
//                   ),
//
//                   Padding(
//                       padding: EdgeInsets.only(top: 50),
//                       child: new Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only( top: 10, left: 50),
//                             child: new Text("Stories", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w300),),
//                           ),
//
//                           Padding(
//                               padding: const EdgeInsets.only( top: 10, left: 30, right: 30),
//
//                               // child: FutureBuilder(
//                               //   future: getallDocuments(),
//                               //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot){
//                               //     if(snapshot.hasData){
//                               //       return new Text("data");
//                               //     }
//                               //     return CircularProgressIndicator();
//                               //   },
//                               // ),
//                               child: Column(
//                                 children: [
//                                   new Container(
//                                       width: MediaQuery.of(context).size.width * 0.86,
//                                       height: 118,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(24),
//                                           color: Color(0xffFFFFFF),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey,
//                                                 blurRadius: 8,
//                                                 offset: Offset(0,5),
//                                                 spreadRadius: 0.2
//                                             )
//                                           ]
//                                       ),
//
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(top:14.0, left: 14, bottom: 14),
//                                         child: new Row(children: [
//
//                                           new Column(
//                                             children: [
//                                               new Container(
//                                                 height: 90,
//                                                 width: 91,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(16),
//                                                     image: DecorationImage(
//                                                         fit: BoxFit.cover,
//                                                         image: AssetImage("assets/images/imagecard.png")
//                                                     )
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//
//                                           Container(
//                                             width: MediaQuery.of(context).size.width * .59,
//                                             child: ListTile(
//                                               title: Transform.translate(
//                                                   offset: new Offset(-10, 0),
//                                                   child: new Text("Title of story", style: GoogleFonts.roboto(fontSize: 12,color: Color(0xff666363),fontWeight: FontWeight.bold),)),
//
//                                               subtitle: Transform.translate(
//                                                 offset: new Offset(-10, 0),
//                                                 child: new Text("Can we donate this to the patient, does the patient get an over dose and at the end of the day, why does one react to Can we donate this to the patient, does the patient get an over dose and at the end of the day, why does one react to over dose and at the end of the .......",
//                                                   maxLines: 3, style: TextStyle(fontSize: 12),
//
//                                                 ),
//                                               ),
//
//                                               trailing: Icon(Icons.arrow_forward_ios),
//                                               contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//                                               dense:true,
//                                               onTap: () {
//                                                 Text('Another data');
//                                               },
//                                             ),
//                                           )
//
//                                         ],),
//                                       )
//
//                                   ),
//                                   SizedBox(height: 30,),
//                                   new Container(
//                                       width: MediaQuery.of(context).size.width * 0.86,
//                                       height: 118,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(24),
//                                           color: Color(0xffFFFFFF),
//                                           boxShadow: [
//                                             BoxShadow(
//                                                 color: Colors.grey,
//                                                 blurRadius: 8,
//                                                 offset: Offset(0,5),
//                                                 spreadRadius: 0.2
//                                             )
//                                           ]
//                                       ),
//
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(top:14.0, left: 14, bottom: 14),
//                                         child: new Row(children: [
//
//                                           new Column(
//                                             children: [
//                                               new Container(
//                                                 height: 90,
//                                                 width: 91,
//                                                 decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.circular(16),
//                                                     image: DecorationImage(
//                                                         fit: BoxFit.cover,
//                                                         image: AssetImage("assets/images/cardicon2.png")
//                                                     )
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//
//                                           Container(
//                                             width: MediaQuery.of(context).size.width * .59,
//                                             child: ListTile(
//                                               title: Transform.translate(
//                                                   offset: new Offset(-10,0),
//                                                   child: new Text("Title of story", style: GoogleFonts.roboto(fontSize: 12,color: Color(0xff666363),fontWeight: FontWeight.bold),)),
//
//                                               subtitle: Transform.translate(
//                                                 offset: new Offset(-10, 0),
//                                                 child: new Text("Can we donate this to the patient, does the patient get an over dose and at the end of the day, why does one react to Can we donate this to the patient, does the patient get an over dose and at the end of the day, why does one react to over dose and at the end of the .......",
//                                                   maxLines: 3, style: TextStyle(fontSize: 12),
//
//                                                 ),
//                                               ),
//
//                                               trailing: Icon(Icons.arrow_forward_ios),
//                                               contentPadding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//                                               dense:true,
//                                               onTap: () {
//                                                 // Text('Another data');
//
//                                                 Navigator.of(context).push(
//                                                     MaterialPageRoute(
//                                                       // builder: (_) => DetailsPage(index)
//                                                     )
//                                                 );
//                                                 print("detail");
//
//                                               },
//                                             ),
//                                           )
//
//
//
//
//                                         ],),
//                                       )
//
//                                   ),
//                                 ],
//                               )
//                           )
//
//                         ],
//                       )
//                   )
//                 ],
//               ))),
//     );
//   }
//
//   Future getallDocuments() async{
//     final snapshort = await _firestore
//         .collection("posts")
//         .get();
//
//     // .then((results) {
//     // print("data URL");
//     // print(results.docs.single.data()['message']);
//     // List<dynamic> documents = results.docs.single.data()['message'];
//     //
//     // documents.forEach((data) {
//     // print("data");
//     // print(data);
//     // });
//
//     // final List<DocumentSnapshot> documents = snapshort.data();
//
//     return snapshort.docs;
//
//
//   }
// }







