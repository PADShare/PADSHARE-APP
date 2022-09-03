
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:padshare/Source/ui/Pages/IntroScreen.dart';
import 'package:padshare/Source/ui/authentication/authenticatedUser.dart';
import 'package:padshare/helper/binding.dart';

class Padshare extends StatelessWidget{
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final PageStorageBucket _bucket = new PageStorageBucket();
  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return FutureBuilder(

      future: _initialization,
      builder: (context,snapshot){
        if(snapshot.hasError){
          return _somethingWentWrong(); }

        if(snapshot.connectionState == ConnectionState.done){
          return new GetMaterialApp(
              initialBinding: Binding(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                    primarySwatch: Colors.deepPurple,
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                  ),
                  home: AuthenticatedUser(),
          );
        }

        return Center(child: CircularProgressIndicator());
      },


    );
  }
}

Widget _somethingWentWrong() {
  return new MaterialApp(
    home: new Scaffold(
        body: Center(child: new Text("Could not Load the App..."))),
  );
}