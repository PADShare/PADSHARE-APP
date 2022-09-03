import 'package:flutter/material.dart';

class RestartAPPWidget extends StatefulWidget {
  RestartAPPWidget({this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartAPPWidgetState>().restartApp();
  }

  @override
  _RestartAPPWidgetState createState() => _RestartAPPWidgetState();
}

class _RestartAPPWidgetState extends State<RestartAPPWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
