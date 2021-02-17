import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class NominalWidget extends StatefulWidget {
  Function(String amount,int index) callback;
  int idx;
  NominalWidget({this.callback,this.idx});
  @override
  _NominalWidgetState createState() => _NominalWidgetState();
}

class _NominalWidgetState extends State<NominalWidget> {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: EdgeInsets.all(0.0),
      shrinkWrap: true,
      primary: false,
      crossAxisCount: 3,
      itemCount:  FunctionHelper.dataNominal.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          child: FlatButton(
            padding: EdgeInsets.all(10.0),
            onPressed: (){
              setState(() {
                widget.idx=index;
              });
              widget.callback(FunctionHelper.dataNominal[index],index);
            },
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
            color: widget.idx==index?Color(0xFFEEEEEE):Theme.of(context).focusColor.withOpacity(0.3),
            child: WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(FunctionHelper.dataNominal[index]))} .-",10,widget.idx==index?Constant().darkMode:Constant().secondDarkColor, FontWeight.normal,textAlign: TextAlign.center),
          ),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 10.0,
    );
  }
}