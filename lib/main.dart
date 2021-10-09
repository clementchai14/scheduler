
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduler/screen/splash_screen.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.lightBlue[100],
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme
        ),
        appBarTheme: AppBarTheme(
          textTheme: GoogleFonts.nunitoTextTheme(
              Theme.of(context).textTheme
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white
        )
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
