import 'package:flutter/material.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class MemberLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: <Widget>[
          WidgetHelper().baseLoading(context,ClipRRect(
            borderRadius: BorderRadius.circular((50.0 + 0.0) / 2),
            child: Container(
              height: 50.0,
              width: 50.0,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(0.0),
              ),
            ),
          )),
          SizedBox(
            width: 16,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WidgetHelper().baseLoading(context,Container(
                height: 10.0,
                width: 100.0,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                ),
              )),
              const SizedBox(
                height: 2,
              ),
              WidgetHelper().baseLoading(context,Container(
                height: 10.0,
                width: 100.0,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                ),
              )),
              const SizedBox(
                height: 4,
              ),
              WidgetHelper().baseLoading(context,Container(
                height: 10.0,
                width: 100.0,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(0.0),
                ),
              )),
            ],
          ),
          Flexible(
            flex: 1,
            child: Container(),
          ),
          WidgetHelper().baseLoading(context,Container(
            height: 20.0,
            width: 50.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(0.0),
            ),
          ))
        ],
      ),
    );
  }
}
