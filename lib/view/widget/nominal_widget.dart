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
        return FlatButton(
            shape: RoundedRectangleBorder(side: BorderSide(
                color: widget.idx==index?Constant().mainColor:Constant().greyColor,
                width: 2,
                style: BorderStyle.solid
            ), borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(left:5.0,right: 5.0,top:15,bottom: 15),
            onPressed: (){
              setState(() {
                widget.idx=index;
              });
              widget.callback(FunctionHelper.dataNominal[index],index);
            },
            // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
            child: WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(FunctionHelper.dataNominal[index]))} .-",10,Constant().moneyColor, FontWeight.bold,textAlign: TextAlign.center),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 10.0,
    );
  }
}