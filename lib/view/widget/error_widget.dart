import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';



class ErrWidget extends StatefulWidget {
  final Function callback;
  ErrWidget({this.callback});
  @override
  _ErrWidgetState createState() => _ErrWidgetState();
}

class _ErrWidgetState extends State<ErrWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("${Constant().localAssets}server_down.png"),
          Padding(
            padding: EdgeInsets.only(top: 20,bottom: 10),
            child: MaterialButton(
              onPressed: widget.callback,
              child: WidgetHelper().textQ("Coba Lagi ...",14,Colors.grey[200],FontWeight.bold),
              color: Colors.black38,
              elevation: 0,
              minWidth: 400,
              height: 50,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
