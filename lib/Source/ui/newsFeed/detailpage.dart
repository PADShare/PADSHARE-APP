import 'dart:async';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:padshare/Source/models/userPosts.dart';
import 'package:padshare/Source/utils/DataController.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:intl/intl.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class DetailsPage extends StatefulWidget{

  DocumentSnapshot userpost;
   DetailsPage({this.userpost});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  DocumentReference likeRef;

  final String currentUser = _auth.currentUser?.uid;
  TextEditingController _commentController = TextEditingController();
  bool isVisible = false;
  bool isLikedByUser = false;
  bool _isliked;

  // bool iscomment = true;

  DataController _controller = DataController();

  List<dynamic> postComments = [];

  int likeCount;

  DocumentSnapshot postComment;
  TextEditingController _commentUpdate = TextEditingController();

  Map<String, dynamic> data;

  // Map<String, dynamic> postComment;

  showComment(){
    setState(() {
      isVisible = !isVisible;
    });

  }
 getallComments()async{


    await  _firestore.collection('comments').doc(widget.userpost.data()['postId']).get().then((result){
       print("USER_POSTS");
      // print(result.data()["comment"]);
       setState(() {

         // totaluser = result.docs.length;
        postComments = result.data()['comment'];

       });
       // Future.delayed(Duration(seconds: 2)).then((value){
       //   setState(() {
       //     isloading = false;
       //   });
       // });
       print("LENGTH::");
        print(result.data());
     });

 }
  // removeComments(){
  //   setState(() {
  //     iscomment = !iscomment;
  //   });
  // }

   checklikes()async{


    // print(likes['likedby']);
    // _isliked = likes[currentUser] == true;
    // print(likes['likes'][currentUser]);
    // _controller.AddLikes(userId: widget.userpost.data()['ownerId'], id: widget.userpost.data()['postId']);
    // if(_isliked) {
    //   _controller.AddLikes(userId: widget.userpost.data()['ownerId'], id: widget.userpost.data()['postId']);
    //   setState(() {
    //     likeCount -=1;
    //     isLikedByUser = true;
    //     likes[currentUser] = false;
    //   });
    // }


     // if( likes['likedby'] == currentUser){
     //   setState(() {
     //     isLikedByUser = true;
     //   });
     //   print(isLikedByUser);
     // }else{
     //
     //   setState(() {
     //     isLikedByUser =false;
     //   });
     // }


     bool isPostLiked;
     Future<DocumentSnapshot> docSnapshot = FirebaseFirestore.instance.collection('allposts').doc(widget.userpost.data()['postId']).get();
     DocumentSnapshot doc = await docSnapshot;

     if(doc.data() == null){
       setState(() {
         isLikedByUser = false;
       });
     }else{

       // print(doc['likes']['likedBy']);
       // if (doc['likes']['likedBy'].contains(currentUser)) {
       //
       //   isLikedByUser = true;
       //
       // } else {
       //
       //   isLikedByUser = false;
       //
       // }
     }


     Future<DocumentSnapshot> commentSnapshot = FirebaseFirestore.instance.collection('allposts').doc(widget.userpost.data()['postId']).get();
     DocumentSnapshot comment = await commentSnapshot;

     print(comment.data().length);

     // setState(() {
     //   postComment = comment.data();
     // });

   }

 @override
  void initState() {
    // TODO: implement initState
     checklikes();
    likeRef = _firestore.collection('likes').doc(_auth.currentUser.phoneNumber);
    super.initState();
    likeRef.get().then((value) => data = value.data());
     getallComments();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //isLikedByUser = (likes[currentUser])
    var likes = widget.userpost.data()['likes'];

    // setState(() {
    //   postComments = widget?.userpost.data()['comment'] ;
    // });

       // print(widget.userpost.data()['comment']);

   // print("DARDARA::");
    // var dd = widget.userpost.data()['likes'];
    // print(dd);
     var image = widget.userpost.data()['mediaUrl'];
    //   print(widget.userpost.data()['mediaUrl']);

    var dataposts = widget.userpost.data();
    // isLikedByUser = false;
    Timestamp time = dataposts['timestamp'];
    final DateTime docDateTime = DateTime.parse(time.toDate().toString());
    var date =  DateFormat('EEE, MMM d, ''yy').format(docDateTime);

    print("date");
    return new Scaffold(
      extendBodyBehindAppBar: true,
      appBar: new AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: new Text("Details"),
        actions: [
          // Padding(
          //   padding: const EdgeInsets.only(right:12.0),
          //   child: GestureDetector(
          //     onTap: (){},
          //     child: new Image.asset("assets/images/Editicon.png"),
          //   ),
          // )
        ],
      ),
      backgroundColor: Color(0xffF4F6FE),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 260,
            decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(
                //   bottomRight: Radius.circular(49),
                //   bottomLeft: Radius.circular(49),
                // ),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  // image: AssetImage("assets/images/imagepic.png")
                  image: image == null  ? AssetImage("assets/images/dark-placeholder.png") : NetworkImage(widget.userpost.data()['mediaUrl'])
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

          ),

          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //   Padding(
              //   padding: const EdgeInsets.only( top: 10, left: 50),
              //   child: new Text("Stories", style: GoogleFonts.roboto(color: Color(0xff666363), fontSize: 18, fontWeight: FontWeight.w300),),
              // ),
              Padding(
                padding: const EdgeInsets.only(top:5.0, right: 15, left: 15),
                child: new Container(
                  width: MediaQuery.of(context).size.width,
                  height: 163,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 8,
                      )
                    ]
                  ),

                  child: Padding(
                    padding: const EdgeInsets.only(top:20.0, bottom: 5, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(

                    children: [
                    new Text("Posted :", style: GoogleFonts.roboto(fontSize: 10,color: Color(0xff666363).withOpacity(0.4),fontWeight: FontWeight.bold),),
                    new Text(date.toString(), style: GoogleFonts.roboto(fontSize: 10,color: Color(0xff666363).withOpacity(0.3),fontWeight: FontWeight.bold),),
                    ],
                  ),
                        // new Text("post", style: GoogleFonts.roboto(
                        //   color: Color(0xff3E4347),
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 15,
                        //
                        // ),),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          // color: Colors.orangeAccent,
                          height: 90,
                          width: MediaQuery.of(context).size.width,
                          child: new Text(widget.userpost.data()['message'] ?? "", style:  TextStyle(fontSize: 13, fontWeight: FontWeight.w300, color: Color(0xff3E4347)),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left:10.0),
                          child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                             GestureDetector(

                                 onTap: (){
                                 //  showComment();
                                 //checklikes();
                                   var uid = widget.userpost.data()['postd'];
                                   isLikedFunction();
                                   likeRef.get().then((value){
                                     if(value.data() != null){
                                       if(value.data().keys.contains(uid)){
                                         _firestore.runTransaction((transaction)async{
                                          // DocumentSnapshot postSnapshot = await transaction.get(postRef)
                                         });
                                       }
                                     }else{
                                       print('likes null');
                                       _firestore.runTransaction((transaction) async{
                                        DocumentSnapshot postSnapshot = await transaction.get(uid);
                                        if(postSnapshot.exists){
                                          //await transaction.update(uid, postSnapshot.data(){'likes': postSnapshot.data()['likes'] + 1})
                                        }else{
                                          likeRef.set({uid: true});
                                        }

                                       });

                                     }
                                   });
                                 print("CURR $currentUser");

                                   isLikedByUser ? _controller.RemoveLikes(id: widget.userpost.data()['postId'],userId:widget.userpost.data()['ownerId'] )
                                                 : _controller.AddLikes(id: widget.userpost.data()['postId'],userId: currentUser);

                                 setState(() {
                                   isLikedByUser = true;
                                 });
                                 },
                                // child: SvgPicture.asset("assets/images/heart.svg")
                                child: Icon(data != null && data.containsKey(widget.userpost.data()['postId']) ? Icons.favorite : Icons.favorite_border,
                                color: data != null && data.containsKey(widget.userpost.data()['postId']) ? Colors.redAccent : Colors.grey,
                                ),

                             ),
                              SizedBox(width: 10,),
                              InkWell(
                                  onTap: (){
                                      showComment();
                                  },
                                  child: Badge(

                                    // widget.userpost.data()['comment'][0] == null ? [] : widget.userpost.data()['comment'].length

                                       badgeContent: Text("${postComments == null ? "0" : postComments.length}", style: TextStyle(color: Colors.white, fontSize: 8)),
                                       child: SvgPicture.asset("assets/images/message.svg", width: 20,))),
                              SizedBox(width: 10,),
                            //   InkWell(
                            //       onTap: (){},
                            //       child: SvgPicture.asset("assets/images/share.svg"))
                             ],
                          ),
                        )
                      ],
                    ),
                  ),

                ),
              ),



            ],
          ),
         SizedBox(height: 10,),

          // Visibility(
          //     maintainSize: true,
          //     maintainAnimation: true,
          //     maintainState: true,
          //     visible: isVisible,
          //     child: Container(
          //         height: 220,
          //         width: 200,
          //         color: Colors.redAccent,
          //         margin: EdgeInsets.only(top: 10, bottom: 20),
          //         child: Center(child: new Container(
          //             color: Colors.white,
          //             child: new Column(
          //               children: [
          //                 new Container(
          //                   height: 50,
          //                   width: MediaQuery.of(context).size.width,
          //
          //                   decoration: BoxDecoration(
          //                       color: Colors.white,
          //                       boxShadow: [
          //                         BoxShadow(
          //                           color: Colors.grey[300],
          //                           offset: Offset(0,2),
          //                           blurRadius: 2,
          //
          //                         )
          //                       ]
          //                   ),
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(10.0),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                       children: [
          //                         new Text("Comments ", style:  GoogleFonts.roboto(color: Colors.black54, fontSize: 16,fontWeight: FontWeight.w400 ),),
          //                         GestureDetector(
          //                             onTap: (){
          //                              // removeComments();
          //                               showComment();
          //                             },
          //                             child: new Icon(Icons.close, size: 30, color: Colors.black54,))
          //                       ],
          //                     ),
          //                   ),
          //                 ),
          //                 new Container(
          //                     height: 165,
          //                     child: Padding(
          //                       padding: const EdgeInsets.only(top:20.0, bottom: 10, right: 20, left: 10),
          //                       child: Column(
          //                         children: [
          //                           new Row(
          //                             children: [
          //                               Center(
          //                                 child: Container(
          //                                   child: new CircleAvatar(
          //                                     radius: 30,
          //                                     backgroundImage: _auth.currentUser.photoURL == null ? new AssetImage("assets/images/profile1.png") : NetworkImage(_auth.currentUser.photoURL),
          //                                     backgroundColor: Colors.grey,
          //                                   ),
          //                                 ),
          //                               ),
          //                               Padding(
          //                                 padding: const EdgeInsets.only(top:8.0, bottom: 4, right: 8, left: 8),
          //                                 child: new Container(
          //                                   height:  80,
          //                                   width: MediaQuery.of(context).size.width * 0.67,
          //                                   color: Colors.grey[300],
          //                                   child:  new TextFormField(
          //                                     controller: _commentController,
          //                                     decoration: InputDecoration(
          //                                       hintText: "ADD COMMENT",
          //                                       contentPadding: EdgeInsets.only(left: 8, right: 8),
          //                                       border: InputBorder.none,
          //                                       focusedBorder: InputBorder.none,
          //
          //                                     ),
          //                                   )
          //                                 ),
          //                               )
          //                             ],
          //                           ),
          //                           Padding(
          //                             padding: const EdgeInsets.only(right:10.0, top: 5),
          //                             child: Container(
          //                               child: new Row(
          //                                 mainAxisAlignment: MainAxisAlignment.end,
          //                                 children: [
          //                                   GestureDetector( child: new Text("CANCEL", style: GoogleFonts.roboto( fontWeight: FontWeight.w400, fontSize: 15))),
          //                                   SizedBox(width: 15,),
          //                                   FlatButton(
          //                                     materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          //
          //                                       onPressed: ()async{
          //                                         print("AM CLICKED");
          //                                        await _controller.AddComment(message:_commentController.text,id: widget.userpost.data()['postId'], url: widget.userpost.data()['mediaUrl'], userID: widget.userpost.data()['ownerId'], username: widget.userpost.data()['username'] ).then((value){
          //                                          print("AM CLICKED:: 2");
          //                                          print("clicked $value");
          //
          //                                        });
          //                                        setState(() {
          //                                          _commentController.text = "";
          //                                        });
          //                                       },
          //                                       child: new Text("COMMENT", style: GoogleFonts.roboto(color: Colors.lightBlueAccent, fontWeight: FontWeight.w400, fontSize: 15),))
          //                                 ],
          //                               ),
          //                             ),
          //                           ),
          //
          //                         ],
          //                       ),
          //                     )
          //                 ),
          //
          //
          //               ],
          //             )
          //         ))
          //     )
          // ),



        ],
      ),
    );
  }

  ListComments(List<dynamic> postComment) {

    return postComment == null ? new Container() : ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: postComments.length,


      itemBuilder: (_, int index){
       // var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

        Timestamp time = postComments[index]['timestamp'];
        final DateTime docDateTime = DateTime.parse(time.toDate().toString());
        //var date =  DateFormat('EEE, MMM d, ''yy').format(docDateTime);
          var date = DateFormat.yMMMMd('en_US').format(docDateTime);
        print("TEST $date");
        // var newdate =    Jiffy('EEE, MMM d, ''yy').fromNow();

         //print(newdate);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: new CircleAvatar(
              // AssetImage("assets/images/profile1.png")
                  backgroundImage: NetworkImage(postComments[index]['photoUrl']),
                  radius: 30,
                ),
                title: new Text( postComments[index]['username'], style: GoogleFonts.roboto(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    new Text(postComments[index]['comment'],maxLines: 3, style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                    // "5 month ago"
                    new Text(date, style: GoogleFonts.roboto(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
                  ],
                ),
                trailing: PopupMenuButton(
                  icon: Icon(Icons.more_vert_outlined, color: Colors.black38,size: 20,),
                  itemBuilder: (context){

                    return [
                      PopupMenuItem(
                        value: 'edit',
                        child: new Text("Edit"),

                      ),
                      PopupMenuItem(
                        value: 'remove',
                        child: new Text("Remove"),

                      )
                    ];
                  },
                  onSelected: (String value)async{
                    DocumentReference _reference = _firestore.collection('comments').doc(widget.userpost.data()['postId']);
                    // // DocumentReference _reference = _firestore.collection('comments').where('commentId', isEqualTo: commentID).get();
                    DocumentSnapshot  doc = await _reference.get();
                    var commentID =  postComments[index]['commentId'];
                    var mynewlist = [];
                    print('YOu clicked on the popup menu item');

                    if(value == 'remove'){


                       print(index);
                       var mylist = doc.data()['comment'][index];
                       mynewlist.add(mylist);
                      print(mylist);


                     if(_auth.currentUser.uid == postComments[index]['userId']){
                       await _reference.update({
                         "comment": FieldValue.arrayRemove(mynewlist)
                       });
                       setState(() {});

                     }
                    }else if(value == "edit"){

                      setState(() {
                        _commentUpdate.text = postComments[index]['comment'];
                      });

                 var alert =      AlertDialog(
                        title: new Text("Edit Comment"),
                        content: Container(
                          height: 80,
                          child: new TextFormField(
                            controller: _commentUpdate,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: postComments[index]['comment'],
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey
                                )
                              )
                            ),
                          ),
                        ),
                        actions: [
                          new FlatButton(onPressed:(){

                            Navigator.of(context).pop();

                          }, child: new Text("CANCEL")),

                          new FlatButton(

                              onPressed:()async{

                                DocumentReference _reference = _firestore.collection('comments').doc(widget.userpost.data()['postId']);
                                // // DocumentReference _reference = _firestore.collection('comments').where('commentId', isEqualTo: commentID).get();
                                DocumentSnapshot  doc = await _reference.get();

                                var mylist = doc.data()['comment'][index];
                                //print( );
                                mylist['comment'] = _commentUpdate.text.toString().trim();
                                mynewlist.add(mylist);
                             //  print(mylist);
                                // List<dynamic>

                                // if(mynewlist is List){
                                //   print("YES");
                                // }else if(mylist is List<dynamic>){
                                //   print("DATA: YEST");
                                // }

                            await _reference.update({
                              "comment": mynewlist
                            });
                            setState(() {
                               getallComments();
                            });
                                Navigator.of(context).pop();

                          }, child: new Text("UPDATE"))
                        ],


                      );



    if(_auth.currentUser.uid == postComments[index]['userId']){

      showDialog(context: context, builder: (BuildContext  context){
        return alert;
      });
    }


                    }
                  },
                ),
              ),
            ),
            Divider(),
          ],
        );
      },


    );
  }

  void isLikedFunction() {
    setState(() {
      isLikedByUser = true;
    });

    if(isLikedByUser){
      Timer(Duration(milliseconds: 500), (){
        setState(() {
          isLikedByUser = false;
        });
      });
    }
  }
}


// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ListTile(
// leading: new CircleAvatar(
// backgroundImage: AssetImage("assets/images/profile1.png"),
// radius: 30,
// ),
// title: new Text("Nsamba Isaac", style: GoogleFonts.roboto(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
// subtitle: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// new Text("I,am ready now here ", style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
// new Text("5 month ago", style: GoogleFonts.roboto(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
// ],
// ),
// trailing: Icon(Icons.more_vert_outlined, color: Colors.black38,size: 20,),
// ),
// ),
// Divider(),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ListTile(
// leading: new CircleAvatar(
// backgroundImage: AssetImage("assets/images/profile1.png"),
// radius: 30,
// ),
// title: new Text("Nsamba Isaac", style: GoogleFonts.roboto(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
// subtitle: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// new Text("I,am ready now here ", style: GoogleFonts.roboto(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
// new Text("5 month ago", style: GoogleFonts.roboto(color: Colors.black38, fontSize: 13, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
// ],
// ),
// trailing: Icon(Icons.more_vert_outlined, color: Colors.black38,size: 20,),
// ),
// )