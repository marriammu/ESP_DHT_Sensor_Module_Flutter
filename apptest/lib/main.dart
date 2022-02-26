import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebSocketLed(),
    );
  }
}
class WebSocketLed extends StatefulWidget {

  @override
  _WebSocketLed createState() => _WebSocketLed();
  
  
}


class _WebSocketLed extends State<WebSocketLed> {
  late List<LiveData> chartData;
  late List<LiveRead> chartRead;
  late ChartSeriesController _chartSeriesController;
  late ChartSeriesController _chartReadController;
  late Future<dynamic> _futureData;
  List<Map<String, dynamic>> data = [
    
  ];



  

   Future<dynamic> getSensorData() async{
    var res = await http.get(Uri.parse('http://localhost:80/Sensors')); 
    
    if(res.statusCode==200){ 
      var jasonObj= json.decode(res.body);
      
    return jasonObj['data'];
    }
  }

  @override
  void initState() {
    
    
     _futureData = getSensorData();
    chartData = getChartData();
    chartRead = getChartRead();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);
    
    super.initState();

    

    
  }

  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        title: Text("Readings"),
        backgroundColor: Colors.redAccent),
      
      
        body: Container(
            alignment: Alignment.topCenter, //inner widget alignment to center
            padding: EdgeInsets.all(20),
            child: Column(
              children:<Widget> [




                     Expanded(child:FutureBuilder(
                future: _futureData,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var length = snapshot.data.length;
                    data.clear();
                    for (int i = 0; i < length; ++i) {
                      data.add({
                        // 'ID': snapshot.data[i]["ID"],
                        'Temprature': snapshot.data[i]["Temprature"],
                        'Time': snapshot.data[i]["Time"]
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
                              // title: Text(snapshot.data[index]["Temprature"].toString()),
                              title: Text(snapshot.data[index]['Temperature']),
                          subtitle: Text(snapshot.data[index]['Time']),
                            ),
                          );
                        });
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),),


                Expanded(
                  child: Scaffold(
                body: SfCartesianChart(
                    series: <LineSeries<LiveData, int>>[
              LineSeries<LiveData, int>(
                onRendererCreated: (ChartSeriesController controller) {
                  _chartSeriesController = controller;
                },
                dataSource: chartData,
                color: const Color.fromRGBO(192, 108, 132, 1),
                xValueMapper: (LiveData sales, _) => sales.time,
                yValueMapper: (LiveData sales, _) => sales.speed,
              )
            ],
                    primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 3,
                        title: AxisTitle(text: 'Time (seconds)')),
                    primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(size: 0),
                        title: AxisTitle(text: 'Humidity (%)'))))),
                Expanded(
                  child: Scaffold(
                body: SfCartesianChart(
                    series: <LineSeries<LiveRead, int>>[
              LineSeries<LiveRead, int>(
                onRendererCreated: (ChartSeriesController controller) {
                  _chartReadController = controller;
                },
                dataSource: chartRead,
                color: const Color.fromRGBO(50, 20, 100, 1),
                xValueMapper: (LiveRead sales, _) => sales.time,
                yValueMapper: (LiveRead sales, _) => sales.temp,
              )
            ],
                    primaryXAxis: NumericAxis(
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        interval: 3,
                        title: AxisTitle(text: 'Time (seconds)')),
                    primaryYAxis: NumericAxis(
                        axisLine: const AxisLine(width: 0),
                        majorTickLines: const MajorTickLines(size: 0),
                        title: AxisTitle(text: 'Temp (C)'))))),


                        Container(
                    margin: EdgeInsets.only(top: 30),
                    child: FlatButton(
                        //button to start scanning
                        color: Colors.redAccent,
                        colorBrightness: Brightness.dark,
                        onPressed: () { },
                        child: Text('Button'),
                        ),),
       
              ],
              
            )
            )),
      
      );
  }

  int time = 3;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
    chartRead.add(LiveRead(time++, (math.Random().nextInt(60) + 30)));
    chartRead.removeAt(0);
    _chartReadController.updateDataSource(
        addedDataIndex: chartRead.length - 1, removedDataIndex: 0);

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
  
}


class LiveData {
  LiveData(this.time, this.speed);
  final int time;
  final num speed;
}

class LiveRead {
  LiveRead(this.time, this.temp);
  final int time;
  final num temp;
}