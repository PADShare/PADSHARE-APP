
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:place_picker/uuid.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;


class DataController extends GetxController{

  final uid = Uuid().generateV4();

  Future getData(String collection)async{
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firebaseFirestore.collection(collection).orderBy('timestamp',descending: true ).get();

    return snapshot.docChanges;
  }

  Future queryData(String queryString)async{
    return FirebaseFirestore.instance.collection('users').where('name', isGreaterThanOrEqualTo: queryString).get();

  }

  Future AddComment({String message, String id, String userID, String url, String username}){

    return FirebaseFirestore.instance.collection("comments").doc(id).update({
      'comment': FieldValue.arrayUnion([{
         "userId": userID,
         "comment":message,
         "photoUrl": url,
         "username": username,
         "commentId":uid,
         "timestamp": Timestamp.now(),

      }])
    });


  }

  // Future getAllComments(String collection)async{
  //
  //   final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   QuerySnapshot snapshot = await firebaseFirestore.collection(collection).get();
  //
  //   return snapshot.docs;
  //
  // }
  Future AddLikes({String id, userId}){

    return FirebaseFirestore.instance.collection("likes").doc(userId).
    set({id: true});
  }

  Future RemoveLikes({String id, userId}){

    return FirebaseFirestore.instance.collection("allposts").doc(id).set({
      "likes": FieldValue.arrayRemove([userId])
    });
  }

  Future getPost()async{
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("post").doc(_auth.currentUser.uid).collection("userPosts").get();
   // print(snapshot.docs);
    return snapshot.docs;
  }
}