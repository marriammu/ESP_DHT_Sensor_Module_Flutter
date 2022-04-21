
import 'package:flutter/material.dart';
import 'package:flutter_loginpage/palatte.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/widgets.dart';

/// Add the second screen
 class SecondPage extends StatefulWidget {
   const SecondPage({Key key}) : super(key: key);
   @override
   _SecondPageState createState() => _SecondPageState();
 }

 class _SecondPageState extends State<SecondPage> {
   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Flutter Demo Second Page"),
       ),
       body: Center(
         child: ElevatedButton(
             child: Text("Go back"),
             onPressed: () {
               Navigator.pop(context);
             }
         ),
       ),
     );
   }
 }