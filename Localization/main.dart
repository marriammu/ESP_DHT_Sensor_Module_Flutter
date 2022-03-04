import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:tuple/tuple.dart';
// import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(const MyApp());
  
}
// int data = 1;   //for data to be saved in 
 
    
getData() async { // return json obj
    var res = await http.get(Uri.parse('http://IP Address:80/Readings'),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });
    
    var jasonObj = json.decode(res.body);
    // log(jasonObj['label']);
    print(jasonObj['label'].runtimeType);
    print(jasonObj['label']);
    return jasonObj['label'];

  }
// Replay
int data = 0;
List<int>previousPoits=[];
///////////////////

  @override
  void initState() {
   
  
      
  }


 List<double> coord(int label){

  //  print("alo");
  //  print(label);
   List<double> my_loc=[]; 
    if (label==0){ // modrg
      my_loc.addAll([580,217]);
    }
    else if(label==1){ // hallway
      my_loc.addAll([580,217]);
      // print(my_loc);
    }
    else if(label==2){ //tamer
       my_loc.addAll([580,217]);
      //  print(my_loc);
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
        // Center(
          // child: Image.asset('lib/img/floor.jpeg'),
        // ),
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
        ),
        //+++++++++++++++++++++++++++++++++++++
        Center(child: Column(children: <Widget>[  
            Container(  
              margin: EdgeInsets.all(25),  
              child: FlatButton(  
                child: Text('Replay Previous', style: TextStyle(fontSize: 20.0),),  
                onPressed: () {},  
              ),  
            ),  
            Container(  
              margin: EdgeInsets.all(25),  
              child: FlatButton(  
                child: Text('LogIn', style: TextStyle(fontSize: 20.0),),  
                color: Colors.blueAccent,  
                textColor: Colors.white,  
                onPressed: () {
                   Timer.periodic(const Duration(seconds: 2),(timer)async { 
                     data = await getData();
                   
                      
                     setState(() {
                     
                      print("data");
                      print(data);
                      // Replay
                      print(previousPoits.length);
                      if (previousPoits.length==0)
                      {
                        // print("mew");
                          previousPoits.add(data);
                      }
                      else{
                        // print('do');
                      if(data!=previousPoits[previousPoits.length-1])
                      {
                      previousPoits.add(data);
                      
                      // print(data);
                      }

                      }
                      ///////////////////////////
                      print(previousPoits);
                      replay(previousPoits);
                      });
                    
                     
                     });                     // Replay func call 
                },  
              ),  
            ),  
          ]  
         )) 
        //++++++++++++++++++++++++++++++++++++
      ]),
      
    );
  }
}
// Replay
replay(List<int> data){
  for(int i=(data.length-1);i>=0;i--)
  { 
  
    print("replay");
    print(data[i]);
    //Draw Here with data[i]
  }
}
//////////////////////
class OpenPainter extends CustomPainter {
  double y = 580, x =217;
   
  @override
  void paint(Canvas canvas, Size size) {
    // int variable = int.parse(data);
    List<double> my_loc= coord(2);

    // print("i am here");
    // print("data :");
    // print(data);
    
    // print(data);
    var paint1 = Paint()
      ..color = Color(0xff63aa65)
      ..strokeCap = StrokeCap.round //rounded points
      ..strokeWidth = 10;

    Paint circle = Paint()..color = Color(0xFF123);
    canvas.drawCircle(Offset(100,100), 5, circle);
    //list of points
    var points = [
      Offset(my_loc[0],my_loc[1]),
      ];
    //draw points on canvas
    // canvas.drawPoints(PointMode.points, points, paint1);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  // void move(double x, double y) {
  //   this.my_loc[1] = 580 - y * 50;
  //   this..my_loc[0] = 217 - x * 50;
  // }
}

