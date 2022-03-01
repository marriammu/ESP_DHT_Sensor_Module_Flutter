import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:tuple/tuple.dart';
import 'package:http/http.dart' as http;
// import 'dart:ffi';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
void main() {
  runApp(const MyApp());
}
List<Map<int,dynamic>> data =[];

 List<double> coord(int label){
   List<double> my_loc=[]; 
    if (label==0){ // modrg
      
      my_loc.addAll([580,217]);
    }
    else if(label==1){ // hallway
      my_loc.addAll([217,580]);
    }
    else if(label==2){ //tamer
       my_loc.addAll([580,217]);
    }
    else if(label==3){ //TA's Office
       my_loc.addAll([210,300]); 
    }
    return my_loc;
  }

  


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<dynamic> _futureData;
  List<Map<String, dynamic>> data = [
    
  ];

  Future<dynamic> getData() async{
    var res = await http.get(Uri.parse('http://172.28.130.32:80/Readings')); 
    if(res.statusCode==200){ 
      var jasonObj= json.decode(res.body);

    return jasonObj;
    }
  }


  @override
  void initState() {
    
    
     _futureData = getData();
    
    super.initState();

    

    
  }
  
  OpenPainter painter = new OpenPainter();
  // double x = 0, y = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: 
      Stack(children: [

        Expanded(child:FutureBuilder(
                future: _futureData,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var length = snapshot.data.length;
                    data.clear();
                    for (int i = 0; i < length; ++i) {
                      data.add({
                        "data": snapshot.data["data"],
                        
                      });
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            child: ListTile(
                              
                              title: Text(snapshot.data["data"].toString()),
                          
                            ),
                          );
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),),




        Center(
          child: Image.asset('lib/img/floor.jpeg'),
        ),
        Center(
            child: Container(
              width: 400,
              height: 640,
              child: CustomPaint(
                painter: this.painter,
              ),
            )
        ),
        Container(
          alignment: Alignment.topRight,
          // child: Text('x: ' + this.x.toString() + ', y: ' + this.y.toString()), 
        )
      ]),

      
      // Container(
      //   decoration: BoxDecoration(
      //   image: DecorationImage(
      //   image: AssetImage("lib/img/floor.jpeg"),
      //   // fit:  BoxFit.fitWidth  
      //   scale: 0.5
      //   )
      // ),
      // ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
// Point loc = coord(1);
class OpenPainter extends CustomPainter {
  // static var coord= Tuple2<double, double>(580, 217);
  // double y = 0, x = 0;
  List<double> my_loc= coord(1); 
  // this.location = coord(1);
  // Point location = coord(1);
  // double get x_value => null;
  // double y = my_point, x = x_value;
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff63aa65)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 10;

    //list of points
    var points = [
      // location
      Offset(my_loc[0],my_loc[1]),
      // Offset(80, 70),
      // Offset(380, 175),
      // Offset(200, 175),
      // Offset(150, 105),
      // Offset(300, 75),
      // Offset(320, 200),
      // Offset(89, 125)
      ];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  // void move(double x, double y) {
  //   this.y = 580 - y * 50;
  //   this.x = 217 - x * 50;
  // }


}

