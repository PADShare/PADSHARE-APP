import 'package:flutter/material.dart';
import 'package:padshare/Source/ui/IntroScreens/ScreenOne.dart';
import 'package:padshare/Source/ui/IntroScreens/ScreenTwo.dart';
import 'package:padshare/Source/widgets/DotIndicator.dart';

class IntroScreen extends StatefulWidget{
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
final PageController _controller = PageController();

void _pageChanged(int index) {
  setState(() {});
}

final List<Widget> _pages = [
  ScreenOne(),
  ScreenTwo(),
  new ConstrainedBox(
    constraints: const BoxConstraints.expand(),
    child:  new Container( color: Colors.purple,)
  ),
  // new ConstrainedBox(
  //   constraints: const BoxConstraints.expand(),
  //   child: new Container( color: Colors.red,)
  // ),
  // new ConstrainedBox(
  //   constraints: const BoxConstraints.expand(),
  //   child:  new Container( color: Colors.green,)
  // ),
];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: new Container(
        child: new Stack(
          children: [
            new PageView.builder(
              controller: _controller,
              physics: new AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index){
                return  _pages[index % _pages.length];
              },
              onPageChanged: _pageChanged
            ),

            Positioned(
              bottom: 130,
              left: 0,
              right: 0,
              child:  new Container(
                padding: const EdgeInsets.all(20),
                child: new Center(
                  child: Indicator(
                    controller: _controller,
                    itemCount: _pages.length,
                  )
                ),
              ),

            )
          ],
        ),
      )
    );
  }
}