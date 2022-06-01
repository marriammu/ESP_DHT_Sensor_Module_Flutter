import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/screen2.dart';
import './screens/screen3.dart';
import './screens/screen4.dart';
import './screens/screen5.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter LoginPage',
      theme: ThemeData(
        textTheme:
            GoogleFonts.josefinSansTextTheme(Theme.of(context).textTheme),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SecondPage(),
      /// Define the app routes
       initialRoute: '/',
       routes: {
         '/second': (context) => const SecondPage(),
         '/third': (context) =>  RectanglePaintPage(),
         '/fourth': (context) => TrianglePaintPage(),
         '/fifth': (context) => SquarePaintPage(),
         
        //  '/third': (context) => const Alaa(),//mobile
      }
    );
  }
}
 

