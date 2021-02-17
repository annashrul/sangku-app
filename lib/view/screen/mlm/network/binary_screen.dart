import 'dart:math';

import 'package:flutter/material.dart';
// import 'package:graphview/GraphView.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class BinaryScreen extends StatefulWidget {
  @override
  _BinaryScreenState createState() => _BinaryScreenState();
}

class _BinaryScreenState extends State<BinaryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().appBarNoButton(context,"BINARY",<Widget>[]),
        body: Text('')
    );
  }


}
