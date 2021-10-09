
import 'dart:async';

import 'package:flutter/material.dart';
import '../home.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final splashDuration = 2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loading();
  }

  _loading() async {
    return Timer(Duration(seconds: splashDuration),navigationPage);
  }

  void navigationPage(){
    Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Home(),
            transitionDuration: Duration(milliseconds: 1500),
            transitionsBuilder: (context, animation, secondaryAnimation, child){
             animation = CurvedAnimation(
                 parent: animation,
                 curve: Curves.ease
             );
             return FadeTransition(opacity: animation,child: child);
            }
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Scheduler',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ),
              flex: 1,
            ),
            Flexible(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                    '2020 \u00a9 Clement Chai Li Wei',
                    style: TextStyle(
                        color: Colors.white
                    )
                )
              ),
            )
          ],
        ),
      ),
    );
  }

}