
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:padshare/Source/ui/Pages/invitations/user_invitations.dart';
import 'package:padshare/Source/utils/DataController.dart';
import 'package:intl/intl.dart';
import 'package:padshare/Source/utils/Firebase_fcm.dart';
import 'package:padshare/Source/widgets/popups_cards/user_account_profile/user_profile_details.dart';
import 'package:padshare/Source/widgets/transitions/hero_dialog_route.dart';
import 'package:sqflite/sqflite.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class SingleUserPost extends StatefulWidget {
  DocumentSnapshot userpost;
  SingleUserPost({Key key, this.userpost}) : super(key: key);

  @override
  _SingleUserPostState createState() => _SingleUserPostState();
}

class _SingleUserPostState extends State<SingleUserPost> {

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

  TextEditingController _commentUpdate = TextEditingController();

  Map<String, dynamic> data;

  CollectionReference postRef;

  int  postData = 0;

  var likedata;

  int likes = 0;

  bool liked = false;

  var deviceToken;


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
      print("LENGTH::");
      // print(result.data());
    });

  }
  getlikes(){
    var  likesprint = 0;
    _firestore.collection("allposts").doc(widget.userpost['postId']).get().then((value){
      print("likeFunc::3");
      print(value['likes']);




      setState(() {
        likesprint = value['likes'];
        likes = likesprint;
      });

      print("likeFunc-33");
      print(likesprint);
    });



    print("likeFunc");
    print(likesprint);




  }
  @override
  void initState() {
    // TODO: implement initState
    likeRef = _firestore.collection('likes').doc(currentUser);
    super.initState();
    likeRef.get().then((value) => data = value.data());
    postRef = _firestore.collection('allposts');
    getallComments();
    getlikes();
  }

  @override
  Widget build(BuildContext context) {
    var image = widget.userpost.data()['mediaUrl'];
    var userimage = widget.userpost.data()['userProfile'];
    //   print(widget.userpost.data()['mediaUrl']);

    var dataposts = widget.userpost.data();
    var uid = widget.userpost.data()['postId'];
    // print(widget.userpost.data()['likes']);
    // isLikedByUser = false;
    Timestamp time = dataposts['timestamp'];
    final DateTime docDateTime = DateTime.parse(time.toDate().toString());
    var date =  DateFormat('EEE, MMM d, ''yy').format(docDateTime);

    return Padding(
      padding: const EdgeInsets.only(top:8.0, left: 4, right: 4, bottom: 8),
      child: Column(
        children: [
          // new ListTile(
          //   leading: new CircleAvatar(
          //     backgroundColor: Colors.deepPurpleAccent,
          //     backgroundImage: userimage == null?  AssetImage("assets/images/profile.png", ) : NetworkImage(userimage),
          //     radius: 30,
          //   ),
          //   title: new Text(widget.userpost.data()['username'], style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),),
          //   subtitle: new Row(children: [
          //     new Text(date.toString(), style: GoogleFonts.roboto(fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 12),),
          //     new SizedBox(width: 3,),
          //     new Text("-") ,
          //     new SizedBox(width: 3,),
          //     new Image.asset("assets/images/earth-globe-with-continents-maps.png", fit: BoxFit.contain, width: 15,height: 15, color: Colors.grey,),
          //   ],),
          //   trailing: new Icon(Icons.more_vert_outlined, size: 20,),
          // ),


          InkWell(
            onTap: () {
              Navigator.of(context).push(
                  HeroDialogRoute(builder: (context) {
                    return InviteUserToJoinTeam(userdata: widget.userpost
                        .data(),);
                  }));
            },
            child: new ListTile(
              leading: new CircleAvatar(
                backgroundColor: Colors.deepPurpleAccent,
                backgroundImage: userimage == null ? AssetImage(
                  "assets/images/profile.png",) : NetworkImage(userimage),
                radius: 30,
              ),
              title: new Text(widget.userpost.data()['username'],
                style: TextStyle(color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),),
              subtitle: new Row(children: [
                new Text(date.toString(), style: GoogleFonts.roboto(
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),),
                new SizedBox(width: 3,),
                new Text("-"),
                new SizedBox(width: 3,),
                new Image.asset(
                  "assets/images/earth-globe-with-continents-maps.png",
                  fit: BoxFit.contain,
                  width: 15,
                  height: 15,
                  color: Colors.grey,),
              ],),
              trailing: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert_outlined, color: Colors.black38, size: 20,),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: 'connect',
                      child: new Text("Connect"),

                    ),
                    PopupMenuItem(
                      value: 'friends',
                      child: new Text("Friends"),

                    )
                  ];
                },
                onSelected: (String value) async {


                  if (value == 'connect') {
                    Navigator.of(context).push(
                        HeroDialogRoute(builder: (context) {
                          return InviteUserToJoinTeam(userdata: widget.userpost
                              .data(),);
                        }));
                  }else{
                    Navigator.of(context).push(
                        HeroDialogRoute(builder: (context) {
                          return Material(
                              color: Colors.white,
                              elevation: 2,
                              shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: UserInvitations());
                        }));
                  }
                },
              ),
              // trailing: GestureDetector(
              //     onTap: (){
              //
              //     },
              //     child: new Icon(Icons.more_vert_outlined, size: 20,)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              constraints: BoxConstraints(
                  maxHeight: double.infinity
              ),
              // color: Colors.red,
              width: MediaQuery.of(context).size.width,
              child: new Text(widget.userpost.data()['message'] ?? "", style: GoogleFonts.roboto(
                  fontSize: 18, height: 1.5, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Container(
              // height: MediaQuery.of(context).size.height * .50,
                width: MediaQuery.of(context).size.width,

                child:image == null  ? new Container(height: 5,) : Image.network(widget.userpost.data()['mediaUrl'],fit: BoxFit.fill,)
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:10.0, left: 30, right: 30, bottom: 10),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: new Row(
                    children: [
                      // new Text( likes == null ? widget.userpost.data()['likes'].toString() : likes.toString() , style: GoogleFonts.roboto(color: Colors.grey.shade500,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 12)),
                      StreamBuilder(
                        // _firestore.collection("allposts").doc(widget.userpost['postId'])
                        stream: _firestore.collection('allposts').doc(widget.userpost['postId']).snapshots(),
                        builder: (BuildContext context , snapshot){
                          if(snapshot.hasData){
                            print("Linkes<<<< ${snapshot.data['likes']}");

                            return Text(snapshot.data['likes'].toString(),
                                style: GoogleFonts.roboto(
                                    color: Colors.grey.shade500,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12)
                            );
                          }
                          return Text("0");
                        },
                      ),
                      SizedBox(width: 8,),
                      new Text("likes", style: GoogleFonts.roboto(color: Colors.grey.shade500,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 12))
                    ],
                  ),
                ),
                Container(
                  child: new Row(
                    children: [
                      new Text("${postComments == null ? "0" : postComments.length}", style: GoogleFonts.roboto(color: Colors.grey.shade500,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 12)),
                      SizedBox(width: 8,),
                      new Text("Comment", style: GoogleFonts.roboto(color: Colors.grey.shade500,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 12))
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(top:10.0, left: 30, right: 30, bottom: 10),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  child: new Row(
                    children: [
                      GestureDetector(
                          onTap: (){
                            //  showComment();
                            //checklikes();
                            // isLikedFunction();

                            // print('likesRef not null $likeRef');

                            setState(() {
                              liked = true;
                            });

                            likeRef.get().then((value){

                              if(value.data() != null){
                                //first If Statement
                                if(value.data().keys.contains(uid)){

                                  _firestore.runTransaction((transaction)async{
                                    DocumentSnapshot postSnapshot = await transaction.get(postRef.doc(uid));
                                    if(postSnapshot.exists){
                                      await transaction.update(postRef.doc(uid),
                                          <String,dynamic>{
                                            'likes':postSnapshot.data()['likes'] - 1
                                          });


                                    }
                                    print(transaction);
                                  });

                                  likeRef.update({uid:FieldValue.delete()});
                                  // getlikes();
                                  setState(() {
                                    likeRef.get().then((value) => data = value.data());
                                    // getlikes();
                                      liked = false;
                                  });

                                }else{

                                  _firestore.runTransaction((transaction) async{

                                    DocumentSnapshot postSnapshot = await transaction.get(postRef.doc(uid));

                                    if(postSnapshot.exists){

                                      print('Exists !!!');

                                      await transaction.update(postRef.doc(uid),
                                          <String,dynamic> {
                                            'likes':postSnapshot.data()['likes'] + 1
                                          });


                                    }


                                  });
                                  likeRef.update({uid:true});

                                  setState(() {

                                    likeRef.get().then((value) => data = value.data());
                                    getlikes();
                                  });

                                }


                              }else{
                                print('likes null');

                                _firestore.runTransaction((transaction) async{
                                  DocumentSnapshot postSnapshot = await transaction.get(postRef.doc(uid));
                                  if(postSnapshot.exists){

                                    print('Exists !!!');

                                    await transaction.update(postRef.doc(uid),
                                        <String,dynamic> {
                                          'likes':postSnapshot.data()['likes'] + 1
                                        });


                                  }


                                });


                                print("CURR $currentUser");

                                _controller.AddLikes(id:widget.userpost.data()['postId'],userId: currentUser );
                                setState(() {
                                  likeRef.get().then((value) => data = value.data());
                                  getlikes();
                                });


                              }

                            });

                          },
    // data.containsKey(widget.userpost.data()['postId'])
    //                       child: new Icon( liked == true ||  data !=null ?  Icons.thumb_up : Icons.thumb_up_alt_outlined  , size: 30,color: liked == true || data !=null  ?   Colors.blue : Colors.grey.shade500 ,)

                        child: StreamBuilder(
                          // _firestore.collection("allposts").doc(widget.userpost['postId'])
                          stream: _firestore.collection('likes').doc(widget.userpost['ownerId']).snapshots(),
                          builder: (BuildContext context , snapshot){
                            if(snapshot.hasData){
                              // print("Linkes<<<< ${snapshot.data.data()[widget.userpost['postId']]}");

                              if(snapshot.data.data() == null && snapshot.data.data()[widget.userpost['postId']] == true){
                                return new Icon( liked == true ?  Icons.thumb_up : Icons.thumb_up_alt_outlined  , size: 30,color: liked == true  ?   Colors.blue : Colors.grey.shade500 ,);
                              }

                              if(snapshot.data.data() == null || snapshot.data.data()[widget.userpost['postId']] != true){
                                print("CHE FALSE");
                                return new Icon( liked == true ?  Icons.thumb_up : Icons.thumb_up_alt_outlined  , size: 30,color: liked == true  ?   Colors.blue : Colors.grey.shade500 ,);
                              }



                              return new Icon( liked == true ||  snapshot.data.data()[widget.userpost['postId']] == true ?  Icons.thumb_up : Icons.thumb_up_alt_outlined  , size: 30,color: liked == true || snapshot.data.data()[widget.userpost['postId']] == true ?   Colors.blue : Colors.grey.shade500 ,);
                            }
                            return Text("0");
                          },
                        )

                      ),

                      SizedBox(width: 8,),
                      new Text("Like", style: GoogleFonts.roboto(color: Colors.grey.shade500,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16))
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    showComment();
                  },
                  child: Container(
                    child: new Row(
                      children: [
                        new Icon(Icons.message_outlined, size: 30,color: Colors.grey.shade500,),
                        SizedBox(width: 8,),
                        new Text("Comment", style: GoogleFonts.roboto(color: Colors.grey.shade500,fontStyle: FontStyle.normal, fontWeight: FontWeight.w400, fontSize: 16))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),

          Padding(
            padding: const EdgeInsets.only( right: 15, left: 15),
            child: new Container(
              width: MediaQuery.of(context).size.width,
              // color: Colors.red,
              child: Column(
                children: [
                  Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: isVisible,
                      child: Container(
                          height: isVisible ?  220 : 0,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.redAccent,
                          margin: EdgeInsets.only(top: 5, bottom: 20),
                          child: Center(child: new Container(
                              color: Colors.white,
                              child: new Column(
                                children: [
                                  new Container(
                                    height: isVisible ? 50 : 2,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[300],
                                            offset: Offset(0,2),
                                            blurRadius: 2,

                                          )
                                        ]
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:10.0, left: 10, right: 10, bottom: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          new Text("Comments ", style:  GoogleFonts.roboto(color: Colors.black54, fontSize: 16,fontWeight: FontWeight.w400 ),),
                                          GestureDetector(
                                              onTap: (){
                                                // removeComments();
                                                showComment();
                                              },
                                              child: new Icon(Icons.close, size: 30, color: Colors.black54,))
                                        ],
                                      ),
                                    ),
                                  ),
                                  new Container(
                                      height:  isVisible ? 165 : 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 20.0, bottom: 10, right: 20, left: 10),
                                        child: Column(
                                          children: [
                                            new Row(
                                              children: [
                                                Center(
                                                  child: Container(
                                                    child: new CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage: _auth.currentUser.photoURL == null ? new AssetImage("assets/images/profile1.png") : NetworkImage(_auth.currentUser.photoURL),
                                                      backgroundColor: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top:8.0, bottom: 4, left: 8),
                                                  child: new Container(
                                                      height:  isVisible ? 80 : 2,
                                                      width: MediaQuery.of(context).size.width * 0.60,
                                                      color: Colors.grey[300],
                                                      child:  new TextFormField(
                                                        controller: _commentController,
                                                        decoration: InputDecoration(
                                                          hintText: "ADD COMMENT",
                                                          contentPadding: EdgeInsets.only(left: 8, right: 8),
                                                          border: InputBorder.none,
                                                          focusedBorder: InputBorder.none,

                                                        ),
                                                      )
                                                  ),
                                                )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(right:10.0, top: 5),
                                              child: Container(
                                                child: new Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    GestureDetector( child: new Text("CANCEL", style: GoogleFonts.roboto( fontWeight: FontWeight.w400, fontSize: 15))),
                                                    SizedBox(width: 15,),
                                                    FlatButton(
                                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

                                                        onPressed: ()async{
                                                          print("AM CLICKED");
                                                          await _firestore
                                                              .collection("UsersTokens")
                                                              .doc(widget.userpost.data()['ownerId']) //.where('cellnumber', isEqualTo: cellNumber)
                                                              .get().then((value){
                                                            setState(() {
                                                              deviceToken = value.data()['user_token'];
                                                            });

                                                            print("sender _IDTOKEN ${deviceToken}");

                                                          });

                                                          await _controller.AddComment(message:_commentController.text,id: widget.userpost.data()['postId'], url: _auth.currentUser.photoURL, userID: widget.userpost.data()['ownerId'], username: _auth.currentUser.displayName ).then((value){
                                                            print("AM CLICKED:: 2");
                                                            print("clicked $value");

                                                            setState(() {
                                                              getallComments();
                                                            });
                                                          });
                                                          setState(() {
                                                            _commentController.text = "";
                                                          });
                                                          showComment();
                                                          FIREBASE_FCM.FCMSENDMESSEG(
                                                          deviceToken,
                                                            "${_auth.currentUser.displayName} commented on your post:${_commentController.text}",
                                                              "new comment"
                                                              , "");
                                                          // FIREBASE_FCM.FCMSENDMESSEG(
                                                          // deviceToken,
                                                          //     Row(
                                                          //       children: [
                                                          //         Text("${_auth.currentUser.displayName}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey),),
                                                          //         Text("commented on Your post:${_commentController.text}"),
                                                          //       ],
                                                          //     ),
                                                          //     "new comment"
                                                          //     , "");
                                                        },
                                                        child: new Text("COMMENT", style: GoogleFonts.roboto(color: Colors.lightBlueAccent, fontWeight: FontWeight.w400, fontSize: 15),))
                                                  ],
                                                ),
                                              ),
                                            ),

                                          ],
                                        ),
                                      )
                                  ),


                                ],
                              )
                          ))
                      )
                  ),
                  postComments == null  ? new Container(height: 1,) : Container(
                    // height: MediaQuery.of(context).size.height * 0.40,
                      decoration: BoxDecoration(
                        color: Colors.lightBlueAccent.withOpacity(0.02),
                      ),
                      child: ListComments(postComments)
                  )
                ],
              ),
            ), )
        ],
      ),
    );
  }

  ListComments(List<dynamic> postComment) {

    return postComment == null ? new Container() : ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
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
      Timer(Duration(milliseconds: 10), (){
        setState(() {
          isLikedByUser = false;
        });
      });
    }
  }
}
