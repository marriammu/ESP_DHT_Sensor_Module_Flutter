import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:tuple/tuple.dart';
import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(const MyApp());
}
late int data;   //for data to be saved in 

// int getLocation(timer) async{
//  int loc=await getData(); 
//  return loc; 
// }

List<Map<String, dynamic>> convertToList(List<dynamic> data) { //convert json to list
  List<Map<String, dynamic>> newData = [];
  var length = data.length;
  for (int i = 0; i < length; ++i) {
    newData.add({
      'strength': data[i]["strength"],
    });
  }
  return newData;
}

Future<int> getData() async { // return json obj
    var res = await http.get(Uri.parse('http://localhost:80/Readings'),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });
    
    var jasonObj = json.decode(res.body);
    return jasonObj['strength'];
  }

  // bool Comparing(List<dynamic> NewData, List<Map<String, dynamic>> OldData) {
  //   if (NewData.length != OldData.length) {
  //     return false;
  //   }
  //   for (int i = 0; i < OldData.length; ++i) {
  //     if (NewData[i]["strength"] != NewData[i]["strength"]) {
  //       return false;
  //     }
  //   }
  //   return true;
  // }
  
  // void getReadings(Timer timer) async {
  //   var temp = await getData();
  //   var length = data.length;
  //   if (temp.length > data.length) {
  //     var newLength = temp.length - data.length;
  //     for (int j = 0; j < newLength; j++) {
  //       data.add({'strength': temp[j + length]['strength']});
  //     }
  //   }
  //   data = convertToList(temp);
  // }
  

  @override
  void initState() {
      Timer.periodic(const Duration(seconds: 2),(timer) async{ data = await getData();});
  }


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
       my_loc.addAll([580,217]); 
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  OpenPainter painter = new OpenPainter();
  double x = 0, y = 0;

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
          child: Text('x: ' + this.x.toString() + ', y: ' + this.y.toString()), 
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

class OpenPainter extends CustomPainter {
  double y = 580, x =217;
  List<double> my_loc= coord(data); 
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff63aa65)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 10;

    //list of points
    var points = [
      Offset(my_loc[0],my_loc[1]),
      ];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  void move(double x, double y) {
    this.my_loc[1] = 580 - y * 50;
    this..my_loc[0] = 217 - x * 50;
  }
}

