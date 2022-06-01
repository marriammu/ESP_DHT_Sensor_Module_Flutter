
import 'package:flutter/material.dart';
import '../palatte.dart';
import 'package:http/http.dart' as http;


class TrianglePaintPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Container(
            child:Column(
              children: [Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 30),
            width: 400,
            height: 400,
            child: CustomPaint(
              painter: TrianglePainter(),
            ),
          ),
          SizedBox(
                              height: 80,
                            ),
          Container(
                    width:300,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () async {
                  await http.post(Uri.parse('http://192.168.1.210:4000/triangle'));
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
                    color: Colors.green,
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

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 1 / 2, size.height * 1 / 4);
    path.lineTo(size.width * 1 / 6, size.height * 3 / 4);
    path.lineTo(size.width * 5 / 6, size.height * 3 / 4);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
