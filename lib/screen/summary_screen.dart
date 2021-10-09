
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>{

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Text(
          'Coming Soon',
          style: TextStyle(
            fontSize: 30
          ),
        ),
      )
    );
  }
}