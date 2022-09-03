import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:padshare/Source/ui/NavigationScreens/Shop.dart';
import 'package:padshare/Source/ui/NavigationScreens/impact.dart';
import 'package:padshare/Source/ui/Pages/Profile.dart';
import 'package:padshare/Source/ui/home/home_page.dart';

class TabNavigationItem {
  final Widget page;
  final Widget title;
  final Icon icon;

  TabNavigationItem({this.page, this.title, this.icon});

  // new CustomBottomTabs(child: HomePage(),),
  // new CustomBottomTabs(child: Impact(),),
  // new CustomBottomTabs(child: Impact(),),
  // new CustomBottomTabs(child: Shop(),),
  // new CustomBottomTabs(child: UserProfile(),),

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: HomePage(),//Container(child: Center(child: Text("Home"),),),
      icon: Icon(Icons.home),
      title: Text("Home"),
    ),
    TabNavigationItem(
      page: Impact(),
      icon: Icon(Icons.search),
      title: Text("Impact"),
    ),
    TabNavigationItem(
      page: Impact(),
      icon: Icon(Icons.search),
      title: Text(""),
    ),
    TabNavigationItem(
      page: Shop(),
      icon: Icon(Icons.home),
      title: Text("Shop"),
    ),
    TabNavigationItem(
      page: UserProfile(),
      icon: Icon(Icons.home),
      title: Text("profile"),
    ),
  ];
}