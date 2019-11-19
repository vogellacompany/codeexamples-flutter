import 'package:flutter/material.dart';

void main() => runApp(App());
    
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TouchWithRectanglesExample(),
    );
  }
}

 class TouchWithRectanglesExample extends StatefulWidget {
  @override
  _RectsExampleState createState() => _RectsExampleState();
}

class _RectsExampleState extends State<TouchWithRectanglesExample> {
  int _index = -1;

  @override
  Widget build(BuildContext context) {
        double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
    
    return Scaffold(
      
      body: Center(
        child:
        Rects(
          rects: [
            Rect.fromLTRB(0, 20, width/2, 40),
            Rect.fromLTRB(40, 60, 80, 100),
          ],
          selectedIndex: _index,
          onSelected: (index) {
            setState(() {
              _index = index;
            });
          },
        ),
      ),
    );
  }
}

class Rects extends StatelessWidget {
  final List<Rect> rects;
  final void Function(int) onSelected;
  final int selectedIndex;

  const Rects({
    Key key,
    @required this.rects,
    @required this.onSelected,
    this.selectedIndex = -1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        RenderBox box = context.findRenderObject();
        final offset = box.globalToLocal(details.globalPosition);
        final index = rects.lastIndexWhere((rect) => rect.contains(offset));
        if (index != -1) {
          onSelected(index);
          return;
        }
        onSelected(-1);
      },
      child: CustomPaint(
        size: Size(320, 240),
        painter: _RectPainter(rects, selectedIndex),
      ),
    );
  }
}

class _RectPainter extends CustomPainter {
  static Paint _red = Paint()..color = Colors.red;
  static Paint _blue = Paint()..color = Colors.blue;

  final List<Rect> rects;
  final int selectedIndex;

  _RectPainter(this.rects, this.selectedIndex);

  @override
  void paint(Canvas canvas, Size size) {
    var i = 0;
    for (Rect rect in rects) {
      canvas.drawRect(rect, i++ == selectedIndex ? _red : _blue);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}