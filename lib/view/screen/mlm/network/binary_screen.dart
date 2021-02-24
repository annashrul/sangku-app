import 'dart:math';

// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
// import 'package:graphview/GraphView.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

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
