import 'package:flutter/material.dart';
import 'dart:ui';
class HeroDialogRoute<T> extends PageRoute<T>{
 final WidgetBuilder _builder;
  HeroDialogRoute({
    @required WidgetBuilder builder,
    RouteSettings  settings,
    bool fullscreenDialog = false
}) : _builder = builder,
     super(settings: settings, fullscreenDialog: fullscreenDialog);

  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.black12;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => "pop Dialog Modal";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return _builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return child;
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => true;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => const Duration(milliseconds: 300);


}