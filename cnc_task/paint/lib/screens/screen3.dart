
import 'package:flutter/material.dart';
import '../palatte.dart';
import 'package:http/http.dart' as http;
import '../widgets/widgets.dart';
import 'package:paint/palatte.dart';

class RectanglePaintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          
        body: Center(
          child: Container(
            child:Column(
              children: [
                Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 30),
            width: 400,
            height: 400,
            child: CustomPaint(
              painter: RectanglePainter(),
            ),
          ),
          SizedBox(
                              height: 80,
                            ),
          Container(
                    width:300,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () async {
                  await http.post(Uri.parse('http://192.168.1.210:4000/rectangle'));
                },
                      child: Text('Paint',style: kBodyText),
                    ),
                  ),
                  SizedBox(
                              height: 50,
                            ),
          Container(
                    width:300,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () {Navigator.pushNamed(context, '/second');},
                      child: Text('Back',style: kBodyText),
                    ),
                  ),

              ],
            )
            
          
        ),
      ));
}

class RectanglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final a = Offset(size.width * 1 / 8, size.height * 1 / 4);
    final b = Offset(size.width * 7 / 8, size.height * 3 / 4);
    final rect = Rect.fromPoints(a, b);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

   






