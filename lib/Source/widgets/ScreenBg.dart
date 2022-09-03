import 'package:flutter/material.dart';
class ScreenPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    Paint paint  = new Paint();
    final width = size.width;
    final height = size.height;
    Path backgroundPath = new Path();
    backgroundPath.addRect(Rect.fromLTRB(0, 0, width, height));
    paint.color = Color(0xffF4F6FE);

    canvas.drawPath(backgroundPath, paint);

    Path downOvalpath = new Path();
    // downOvalpath.moveTo(width, height * 0.70);
    // downOvalpath.quadraticBezierTo(width * 0.40, height * 0.72, width * 0.38, height);
    //
    // downOvalpath.lineTo(width, height);
    downOvalpath.moveTo(0, height * 0.72);
    downOvalpath.quadraticBezierTo(width * 0.53, height * 0.75 , width * 0.52, height );
    downOvalpath.lineTo(0, height);


    downOvalpath.close();

    paint.color = Color(0xff692CAB).withOpacity(0.3);

    canvas.drawPath(downOvalpath, paint);

      Path upperOvalPath = new Path();
      upperOvalPath.moveTo(width - (width  * -0.80) , 0);

      // upperOvalPath.lineTo(width , height * 0.24);
      //  upperOvalPath.lineTo(width,height * 0.70);
    upperOvalPath.quadraticBezierTo(width * 0.22, height * 0.38, width * 0.84, height * -0.3);
      // upperOvalPath.lineTo(width/2, 0);
     upperOvalPath.close();

    // paint.color = Color(0xff388674);

    paint.color = Color(0xff692CAB).withOpacity(0.3);

    canvas.drawPath(upperOvalPath, paint);

    Path circlePath = new Path();
    
    //circlePath.moveTo(width * 0.5, height);
    
    //circlePath.addRect(Rect.fromLTRB(50, 300, width * 0.5, height * 0.5));
    circlePath.addOval(Rect.fromCircle(center: Offset(width * 0.66, height * 0.68),radius: 40));
    circlePath.close();
    paint.color = Color(0xff692CAB).withOpacity(0.3);
    canvas.drawPath(circlePath, paint);


    Path circleSmallPath = new Path();

    //circleSmallPath.moveTo(width * 0.8, height);
    //circlePath.addRect(Rect.fromLTRB(50, 300, width * 0.5, height * 0.5));
    circleSmallPath.addOval(Rect.fromCircle(center: Offset(width * 0.75, height * 0.75),radius: 18));
    paint.color = Color(0xff16CF8C).withOpacity(0.2);
    canvas.drawPath(circleSmallPath, paint);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate != false;
  }
}

