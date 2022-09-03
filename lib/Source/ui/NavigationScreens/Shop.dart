import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/login.dart';
import 'package:padshare/Source/ui/newsFeed/newsfeed.dart';
import 'package:padshare/Source/widgets/customCutegory.dart';
import 'package:padshare/main.dart';
// import 'package:padshare/source/widgets/CustomCategories.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
class Shop extends StatefulWidget{
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  var name = _auth.currentUser.displayName??[0];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
   bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
   // getallProducts();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Theme(
      // data: ThemeData(canvasColor: Color(0xffD3D3D3)),
      data: ThemeData(canvasColor: Color(0xffF4F6FE)),
       // 100%
      child:  new Scaffold(
          extendBodyBehindAppBar: true,
          appBar: new AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: new GestureDetector(
              child: new Icon(Icons.arrow_back_ios, size: 25,color:Color(0xff6C1682) ,),
              onTap: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        maintainState: true,
                        builder: (_) => NewsFeed(selectedId: 0,)));
                // RestartWidget.restartApp(context);
                // Navigator.of(context).push(
                //     MaterialPageRoute(
                //         builder: (_) => NewsFeed()
                //     )
                // );
              },

            ),
            // actions: <Widget>[
            //   GestureDetector(
            //     onTap: (){
            //       _scaffoldKey.currentState.openDrawer();
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.only(right: 15),
            //       child: Icon(Icons.menu, color: Colors.white, size: 30, ),
            //     ),
            //   )
            // ],
          ),
          body:  SafeArea(
            child: Wrap(
              children: [
                new Column(

                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(right:5.0, left: 25,top: 30),
                      child: new Container(
                        height: 12,
                        width: MediaQuery.of(context).size.width,
                        // child: Center(child: new Text("Feature Categories", style: GoogleFonts.openSans(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w200),)),
                   child: Center(
                     child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           new Text("Our Products", style: GoogleFonts.roboto(color: Color(0xff6C1682), fontSize: 12, fontWeight: FontWeight.w400),),
                           FlatButton(onPressed: (){}, child: Icon(Icons.search, size: 20, color: Color(0xff6C1682) ,))

                         ],
                     ),
                   ),
                      ),
                    ),
                    //
                    new Container(
                      height: MediaQuery.of(context).size.height,
                      child: new CustomAppCategories(),
                    ),
                  ],
                ),
              ],
            ),
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
                  accountName: new Text(_auth.currentUser.displayName),

                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(110),
                    child: _auth.currentUser.photoURL==null ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Center(child: Text(name.toString().toUpperCase(),style: GoogleFonts.roboto(color: Colors.white54, fontSize: 20, fontWeight: FontWeight.w500),),),
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
                                        builder: (_) => NewsFeed()
                                    )
                                );
                                RestartWidget.restartApp(context);
                              },
                              leading: Icon(Icons.home, color: Colors.white,),
                              title: new Text("Home", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),

                            child: ListTile(
                              onTap: (){

                              },
                              leading: Icon(Icons.person_outline_outlined, color: Colors.white,),
                              title: new Text("Profile", style: TextStyle(color:Colors.white, fontWeight: FontWeight.w500),),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),

                            child: ListTile(
                              onTap: ()async{

                                // final savedtokken = new FlutterSecureStorage();
                                ///await savedtokken.deleteAll();

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder:(_) => Login()
                                    )
                                );


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
      ),
    );
  }



}