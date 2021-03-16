import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/stockist/pin_available_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class PinAktivasiScreen extends StatefulWidget {
  @override
  _PinAktivasiScreenState createState() => _PinAktivasiScreenState();
}

class _PinAktivasiScreenState extends State<PinAktivasiScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PinAvailableModel pinAvailableModel;
  bool isLoading=true;
  Future loadPin()async{
    var res=await BaseProvider().getProvider('transaction/pin_available', pinAvailableModelFromJson,context: context,callback: (){

    });
    print(res);
    if(res is PinAvailableModel){
      PinAvailableModel result=res;
      setState(() {
        isLoading=false;
        pinAvailableModel=result;
      });
    }
    else{
      setState(() {
        isLoading=false;
        // pinAvailableModel=result;
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPin();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,'PIN AKTIVASI',(){Navigator.pop(context);},<Widget>[]),
      body: isLoading?WidgetHelper().loadingWidget(context):ListView.separated(
          itemBuilder: (context,index){
            var val=pinAvailableModel.result[index];
            return FlatButton(
              // color: Constant().mainColor,
                onPressed: (){},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: WidgetHelper().baseImage(val.badge),
                      title: WidgetHelper().textQ(val.title, scaler.getTextSize(10),Constant().mainColor2,FontWeight.bold),
                      subtitle: WidgetHelper().textQ("Jumlah Pin : ${val.jumlah}", scaler.getTextSize(10),Constant().mainColor1,FontWeight.bold),
                    ),
                    Row(
                      children: [
                        FlatButton(
                            padding: scaler.getPadding(0,1),
                            color: Constant().moneyColor,
                            onPressed: (){},
                            child: WidgetHelper().textQ("Reaktivasi", scaler.getTextSize(10),Colors.white,FontWeight.bold,letterSpacing: 2)
                        ),
                        SizedBox(width: scaler.getWidth(1)),
                        FlatButton(
                            padding: scaler.getPadding(0,1),
                            color: Constant().moneyColor,
                            onPressed: (){},
                            child: WidgetHelper().textQ("Transfer", scaler.getTextSize(10),Colors.white,FontWeight.bold,letterSpacing: 2)
                        )
                      ],
                    )

                  ],
                )
            );
          },
          separatorBuilder: (context,index){return Divider(thickness: 5);},
          itemCount: pinAvailableModel.result.length
      ),
    );
  }
}
