import 'package:flutter/material.dart';

class Response extends StatefulWidget {
  @override
  _ResponseState createState() => _ResponseState();

}

class _ResponseState extends State<Response>{
  String aiFeedback = "";

  void _updateAiFeedback(){
    setState(() {
      aiFeedback += "Just Ran. ";

    });
  }

  @override
  Widget build(BuildContext context){


  }
}