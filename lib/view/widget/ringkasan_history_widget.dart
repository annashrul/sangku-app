



import 'package:flutter/cupertino.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class RingkasanHistoryWidget extends StatelessWidget {
  final String title;
  final String desc;
  RingkasanHistoryWidget({this.title,this.desc});

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: scaler.getWidth(40),
          child:  WidgetHelper().textQ(title,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold,letterSpacing: 2),
        ),
        WidgetHelper().textQ(desc,scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold,textAlign: TextAlign.end),
      ],
    );
  }


}

