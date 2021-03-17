import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/resi_model.dart';

class ResiScreen extends StatefulWidget {
  ResiModel resiModel;
  ResiScreen({this.resiModel});
  @override
  _ResiScreenState createState() => _ResiScreenState();
}

class _ResiScreenState extends State<ResiScreen> {
  final GlobalKey<AnimatedListState> _listKey = new GlobalKey<AnimatedListState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context, "Lacak Resi ${widget.resiModel.result.resi}", (){Navigator.pop(context);},<Widget>[]),
      body: Stack(
        children: <Widget>[
          BuildTimeLine(),
          buildContent(context),
        ],
      ),
    );
  }

  Widget buildContent(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      child: Padding(
        padding: new EdgeInsets.only(top: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color:Colors.white),
              padding:scaler.getPadding(1,2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: <Widget>[
                  WidgetHelper().textQ("Tanggal Pengiriman",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                  WidgetHelper().textQ("${DateFormat.yMMMMd().format(widget.resiModel.result.ongkir.details.waybillDate)} ${widget.resiModel.result.ongkir.details.waybillTime}",scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      WidgetHelper().textQ("No.Resi",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                      WidgetHelper().textQ(widget.resiModel.result.resi,scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      WidgetHelper().textQ("Service Code",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                      WidgetHelper().textQ(widget.resiModel.result.ongkir.summary.courierName,scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      WidgetHelper().textQ("Pembeli",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                      WidgetHelper().textQ(widget.resiModel.result.ongkir.deliveryStatus.podReceiver,scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      WidgetHelper().textQ("Status",scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                      WidgetHelper().textQ(widget.resiModel.result.ongkir.deliveryStatus.status,scaler.getTextSize(9),Colors.grey,FontWeight.normal),
                    ],
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),

            _buildTasksList(context)
          ],
        ),
      ),
    );
  }



  Widget _buildTasksList(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return new Expanded(
      child: Scrollbar(
          child: new AnimatedList(
            initialItemCount: widget.resiModel.result.ongkir.manifest.length,
            key: _listKey,
            itemBuilder: (context, index, animation) {
              var val = widget.resiModel.result.ongkir.manifest[index];
              return new FadeTransition(
                opacity: animation,
                child: new SizeTransition(
                  sizeFactor: animation,
                  child: new Padding(
                    padding:scaler.getPadding(1, 0),
                    child: new Row(
                      children: <Widget>[
                        new Padding(
                          padding:scaler.getPadding(1, 2),
                          child: new Container(
                            height:scaler.getHeight(1),
                            width: scaler.getWidth(2),
                            decoration: new BoxDecoration(shape: BoxShape.circle, color:Constant().mainColor),
                          ),
                        ),
                        new Expanded(
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              WidgetHelper().textQ(DateFormat.yMMMMd().format(val.manifestDate.toLocal()), scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                              WidgetHelper().textQ(val.manifestDescription.toLowerCase(), scaler.getTextSize(9),Constant().mainColor,FontWeight.bold),
                            ],
                          ),
                        ),
                        new Padding(
                          padding:EdgeInsets.only(right: scaler.getWidth(2)),
                          child:WidgetHelper().textQ(val.manifestTime, scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          )
      ),
    );
  }



}

class BuildTimeLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return new Positioned(
      top: 0.0,
      bottom: 0.0,
      left: scaler.getWidth(3),
      child: new Container(
        width: 1.0,
        color: Colors.grey[300],
      ),
    );

  }
}



