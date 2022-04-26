
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
// import 'package:web_socket_channel/io.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import "dart:developer";
import 'package:flutter_loginpage/palatte.dart';
import '../widgets/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Alaa(),
    );
  }
}

class Alaa extends StatefulWidget {
  const Alaa({Key key}) : super(key: key);
  @override
  _Alaa createState() => _Alaa();
}

class _Alaa extends State<Alaa> {
   List<LiveData> chartData;
   List<LiveRead> chartRead;
   List<LiveNum> chartNum;
   ChartSeriesController _chartSeriesController;
   ChartSeriesController _chartReadController;
   ChartSeriesController _chartNumController;
  // late Future<dynamic> _futureData;
  List<Map<String, dynamic>> data = [];
  List<Map<String, dynamic>> data2 = [];
  
  List<Map<String, dynamic>> convertToList(List<dynamic> data) {
    List<Map<String, dynamic>> newData = [];
    var length = data.length;
    for (int i = 0; i < length; ++i) {
      newData.add({
        'Temperature': data[i]["Temperature"],
        'Humidity': data[i]["Humidity"]
      });
    }
    // print(newData);
    return newData;
  }

  getTemperatureData() async {
    var res = await http.get(Uri.parse('http://192.168.1.9:3000/Temperature'),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });
    if (res.statusCode == 200) {
      var jasonObj = json.decode(res.body) as List<dynamic>;
      print('7aga');
      // print(jasonObj);
      return jasonObj;
    }
  }
   getHumidityData() async {
    var res = await http.get(Uri.parse('http://192.168.1.9:3000/Humidity'),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*"
        });
    if (res.statusCode == 200) {
      var jasonObj = json.decode(res.body) as List<dynamic>;
      return jasonObj;
    }
  }

  bool Comparing(List<dynamic> NewData, List<Map<String, dynamic>> OldData) {
    if (NewData.length != OldData.length) {
      return false;
    }

    for (int i = 0; i < OldData.length; ++i) {
      if (NewData[i]["Temperature"] != NewData[i]["Temperature"]) {
        return false;
      }
      if (NewData[i]["Humidity"] != NewData[i]["Humidity"]) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    chartData = getChartData();
    chartRead = getChartRead();
    chartNum = getChartNum();

    Timer.periodic(const Duration(seconds: 1), getReadings);
    Timer.periodic(const Duration(seconds: 1), getReadings2);
    Timer.periodic(const Duration(seconds: 1), getReadings3);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BackgroundImage(),
        
        SafeArea(
      
      child: Scaffold(
        backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //     title: Text("Patient Rooms"), backgroundColor: Colors.redAccent),
          
          body: Container(
           
              alignment: Alignment.topCenter, //inner widget alignment to center
              padding: EdgeInsets.all(20),
              child: Column(
                
                children: <Widget>[
                  Container(
                    height: 80,
                    child: Center(
                      child: Text(
                        'Patient Rooms',
                        style: kHeading,
                      ),
                    ),
                  ),
                  Expanded(

                      child: Scaffold(
                          body: SfCartesianChart(
                              series: <LineSeries<LiveNum, int>>[
                        LineSeries<LiveNum, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartNumController = controller;
                          },
                          dataSource: chartNum,
                          color: const Color.fromRGBO(50, 20, 100, 1),
                          xValueMapper: (LiveNum sales, _) => sales.time,
                          yValueMapper: (LiveNum sales, _) => sales.number,
                        )
                      ],
                              primaryXAxis: NumericAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 3,
                                  title: AxisTitle(text: 'Time (seconds)')),
                              primaryYAxis: NumericAxis(
                                  axisLine: const AxisLine(width: 0),
                                  majorTickLines: const MajorTickLines(size: 0),
                                  title: AxisTitle(text: 'Sensor'))))
                         ),
                                  
                    Container(child:Row(children: [
                         Column(children: [

                           Container(
                             width:80,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () {Navigator.pushNamed(context, '/fifth');},
                      child: Text('P1',style: kBodyText),
                    ),
                    

                           )

                         ],)
                         

                         ],

                         )
                    
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Expanded(
                      child: Scaffold(
                          body: SfCartesianChart(
                              series: <LineSeries<LiveData, double>>[
                        LineSeries<LiveData, double>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController = controller;
                          },
                          dataSource: chartData,
                          color: const Color.fromRGBO(192, 108, 132, 1),
                          xValueMapper: (LiveData sales, _) => sales.time,
                          yValueMapper: (LiveData sales, _) => sales.speed,
                        )
                      ],
                              primaryXAxis: NumericAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 3,
                                  title: AxisTitle(text: 'Time (seconds)')),
                              primaryYAxis: NumericAxis(
                                  axisLine: const AxisLine(width: 0),
                                  majorTickLines: const MajorTickLines(size: 0),
                                  title: AxisTitle(text: 'Temp'))))
                         ),
                                 

                              Container(child:Row(children: [Column(children: [
                           Container(
                             width:80,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () async {
                  await http.post(Uri.parse('http://192.168.1.9:3000/ToggleTemperature'));
                },
                      child: Text('O/F',style: kBodyText),
                    ),
                    

                           )
                         ],
                         ),
                         SizedBox(
                    width: 10,
                  ),
                         Column(children: [

                           Container(
                             width:80,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () {Navigator.pushNamed(context, '/fifth');},
                      child: Text('P2',style: kBodyText),
                    ),
                    

                           )

                         ],)
                         

                         ],

                         )
                    
                  ),
                   SizedBox(
                    height: 30,
                  ),
                  Expanded(
                      child: Scaffold(
                          body: SfCartesianChart(
                              series: <LineSeries<LiveRead, double>>[
                        LineSeries<LiveRead, double>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartReadController = controller;
                          },
                          dataSource: chartRead,
                          color: Color.fromARGB(255, 116, 192, 108),
                          xValueMapper: (LiveRead sales, _) => sales.time,
                          yValueMapper: (LiveRead sales, _) => sales.temp,
                        )
                      ],
                              primaryXAxis: NumericAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 3,
                                  title: AxisTitle(text: 'Time (seconds)')),
                              primaryYAxis: NumericAxis(
                                  axisLine: const AxisLine(width: 0),
                                  majorTickLines: const MajorTickLines(size: 0),
                                  title: AxisTitle(text: 'Hum'))))),

                  Container(child:Row(children: [Column(children: [
                           Container(
                             width:80,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () async {
                  await http.post(Uri.parse('http://192.168.1.9:3000/ToggleHumidity'));
                },
                      child: Text('O/F',style: kBodyText),
                    ),
                    

                           )
                         ],
                         ),
                         SizedBox(
                    width: 10,
                  ),
                         Column(children: [

                           Container(
                             width:80,
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                    child: FlatButton(
                      onPressed: () {Navigator.pushNamed(context, '/sixth');},
                      child: Text('P3',style: kBodyText),
                    ),
                    

                           )

                         ],)
                         

                         ],

                         )
                    
                  ),

                  Container(
                    width:150,
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
              )))),
      ],
      );
  }

  double time = 3;
  double time2 = 3;
  int t=3;
  void updateData() {
    chartNum.add(LiveNum(t++, (math.Random().nextInt(60) + 30)));
    chartNum.removeAt(0);
    _chartNumController.updateDataSource(
        addedDataIndex: chartNum.length - 1, removedDataIndex: 0);
  }
  void updateDataSource(double data1) {
    chartData.add(LiveData(time++, data1));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

    void updateDataSource2(double data2) {
    chartRead.add(LiveRead(time2++, data2));
    chartRead.removeAt(0);
    _chartReadController.updateDataSource(
      addedDataIndex: chartRead.length - 1, removedDataIndex: 0);
    }


  void getReadings(Timer timer) async {
    var temp = await getTemperatureData();
    var length = data.length;
    if (temp.length > data.length) {
      var newLength = temp.length - data.length;
      for (int j = 0; j < newLength; j++) {
        data.add({'Temperature': temp[j + length]['Temperature']});
        updateDataSource(temp[j + length]['Temperature']);
      }   
    }
    data = convertToList(temp);

  }
 void getReadings2(Timer timer) async {
    var temp2 = await getHumidityData();
    var length2 = data2.length;
    if (temp2.length > data2.length) {  
      var newLength2 = temp2.length - data2.length;
      for (int j = 0; j < newLength2; j++) {
        data.add({'Humidity': temp2[j + length2]['Humidity']});
        updateDataSource2(temp2[j + length2]['Humidity']);
      }
    }
    data2 = convertToList(temp2);
 }
 void getReadings3(Timer timer) async {
  
    updateData();
  }
 List<LiveData> getChartData() {
    return <LiveData>[
      LiveData(0, 42),
      LiveData(1, 47),
      LiveData(2, 43),
    ];
  }

  List<LiveRead> getChartRead() {
    return <LiveRead>[
      LiveRead(0, 10),
      LiveRead(1, 15),
      LiveRead(2, 22),
    ];
  }
  List<LiveNum> getChartNum() {
    return <LiveNum>[
      LiveNum(0, 10),
      LiveNum(1, 15),
      LiveNum(2, 22),
    ];
  }



}

class LiveData {
  LiveData(this.time, this.speed);
  final double time;
  final double speed;
}

class LiveRead {
  LiveRead(this.time, this.temp);
  final double time;
  final double temp;
}

class LiveNum {
  LiveNum(this.time, this.number);
  final int time;
  final num number;
}
