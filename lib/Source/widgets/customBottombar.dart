import 'package:flutter/material.dart';

class CustomBottomTabs extends StatelessWidget{

  Widget child;

  CustomBottomTabs({this.child});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Navigator(
      onGenerateRoute: (RouteSettings settings){
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context){
          return child;
        });
      },
    );

    // return new Container(
    //   child: child,
    // );
  }
}