import 'package:flutter/material.dart';
class myCustomBackground extends CustomPainter {
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
    downOvalpath.moveTo(width, height * 0.70);
    downOvalpath.quadraticBezierTo(width * 0.40, height * 0.72, width * 0.38, height);

    downOvalpath.lineTo(width, height);

    downOvalpath.close();

    paint.color = Color(0xff692CAB).withOpacity(0.3);

    canvas.drawPath(downOvalpath, paint);

    Path upperOvalPath = new Path();

    upperOvalPath.lineTo(0, height * 0.30);
    upperOvalPath.quadraticBezierTo(width * .78, height * 0.30, width * 0.45, height * -0.25);
    upperOvalPath.lineTo(width, 0);
    upperOvalPath.lineTo(0, 0);

    upperOvalPath.close();


     upperOvalPath.close();

    // paint.color = Color(0xff388674);

    paint.color = Color(0xff692CAB).withOpacity(0.3);

    canvas.drawPath(upperOvalPath, paint);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return oldDelegate != false;
  }
}

