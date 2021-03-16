import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';


class ChartWidgetHome1 extends StatefulWidget {
  dynamic data;
  ChartWidgetHome1({this.data});
  @override
  _ChartWidgetHome1State createState() => _ChartWidgetHome1State();
}

class _ChartWidgetHome1State extends State<ChartWidgetHome1> with AutomaticKeepAliveClientMixin  {
  @override
  bool get wantKeepAlive => true;
  int touchedIndex;
  int kiri=0;
  int kanan=0;
  double pvKiri=0;
  double pvKanan=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kiri = int.parse(widget.data['left_pv']);
    kanan = int.parse(widget.data['right_pv']);
    pvKiri=kiri/(kiri+kanan)*100.round();
    pvKanan=kanan/(kiri+kanan)*100.round();
  }

  @override
  Widget build(BuildContext context) {
    // print(double.parse());
    print(kiri);
    print(kanan);
    print(pvKiri);
    print(pvKanan);
    super.build(context);
    return widget.data['left_pv']=="0"?Text(''):Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        height: MediaQuery.of(context).size.height/6,
        // padding: EdgeInsets.only(right: 80,top: 0,left: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: PieChart(
                  PieChartData(
                      pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 10,
                      sections: showingSections()),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[


                Indicator(
                  color: Color(0xff0293ee),
                  text: 'PV Kiri : ${widget.data['left_pv']}',
                  isSquare: true,
                  textColor: Constant().darkMode,
                ),
                SizedBox(
                  height: 4,
                ),
                Indicator(
                  color: Color(0xfff8b250),
                  text: 'PV Kanan : ${widget.data['right_pv']}',
                  isSquare: true,
                  textColor: Constant().darkMode,
                ),
              ],
            ),
            const SizedBox(
              width: 28,
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {


    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xff0293ee),
            value: pvKiri,
            title: '${pvKiri.round()}%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xfff8b250),
            value: pvKanan,
            title: '${pvKanan.round()}%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );

        default:
          return null;
      }
    });
  }
}




class Indicator extends StatelessWidget {
  Color color;
  String text;
  bool isSquare;
  double size;
  Color textColor;

  Indicator({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor,
  }) ;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        WidgetHelper().textQ(text,12,textColor,FontWeight.bold)

      ],
    );
  }
}

