
import 'package:flutter/material.dart';
import 'package:flutter_loginpage/palatte.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/widgets.dart';

/// Add the third screen //Patient viewer 
 class ThirdPage extends StatefulWidget {
   const ThirdPage({Key key}) : super(key: key);
   @override
   _ThirdPageState createState() => _ThirdPageState();
 }

 class _ThirdPageState extends State<ThirdPage> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Patient Rooms"),
       ),
       body: Center(
         child: ElevatedButton(
             child: Text("Go back to Rooms"),
             onPressed: () {
               Navigator.pop(context, '/second');
             }
         ),
       ),
     );
   }
 }