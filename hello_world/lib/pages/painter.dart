import 'package:flutter/material.dart';

class MyCustomPaintWidget extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color =Color.fromARGB(255, 255, 0, 0);
    paint.strokeWidth = 10;
    paint.style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(80, 80),50,paint);
    canvas.drawRect(Rect.fromPoints(Offset(400, 400), Offset(100, 100)), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }

  // use CustomPaint as widget
  //  child: CustomPaint(
  //        painter: MyCustomPaintWidget(),
   //       child: Placeholder(),
   //     ),
}
