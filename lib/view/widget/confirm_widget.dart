import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class ConfirmWidget extends StatefulWidget {
  dynamic data;
  Function callback;
  ConfirmWidget({this.data,this.callback});

  @override
  _ConfirmWidgetState createState() => _ConfirmWidgetState();
}

class _ConfirmWidgetState extends State<ConfirmWidget> {
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
        ),
        height: height/1.5,
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height:10.0),
            Center(
              child: Container(
                padding: EdgeInsets.only(top:10.0),
                width: 50,
                height: 10.0,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius:  BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Constant().mainColor,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,color: Colors.white),
                      SizedBox(width: 5),
                      WidgetHelper().textQ("Konfirmasi Transaksi",12,Colors.white, FontWeight.bold)
                    ],
                  )
              ),
            ),
            Expanded(
                child: Scrollbar(
                    child: ListView(
                      children: [
                        if(widget.data['param']=='transfer')transfer(),
                        if(widget.data['param']=='topup-penarikan')topup(),
                      ],
                    )
                )
            )
          ],
        ),
      ),
      bottomNavigationBar:Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: FlatButton(
            onPressed:widget.callback,
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
            color: Constant().moneyColor,
            child:Container(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                  SizedBox(width:10.0),
                  WidgetHelper().textQ("LANJUT", 14, Constant().secondDarkColor, FontWeight.bold),
                ],
              ),
            )
          // child:Text("abus")
        ),
      )
    );
  }

  Widget transfer(){
    return Padding(
      padding: EdgeInsets.only(left:10,right:10),
      child: Column(
        children: [
          content(context,'Penerima',widget.data['penerima'],Constant().darkMode),
          Divider(),
          content(context,'Jumlah',"Rp "+FunctionHelper().formatter.format(int.parse('${widget.data['nominal']}'))+' .-',Constant().moneyColor),
          Divider(),
          content(context,'Biaya Admin',"Rp "+FunctionHelper().formatter.format(int.parse('${widget.data['admin']}'))+' .-',Constant().moneyColor),
          Divider(),
          content(context,'Total Pembayaran',"Rp "+FunctionHelper().formatter.format(int.parse('${widget.data['total']}'))+' .-',Constant().moneyColor),
        ],
      ),
    );
  }

  Widget topup(){
    return Padding(
      padding: EdgeInsets.only(left:10,right:10),
      child: Column(
        children: [
          content(context,'Bank Tujuan',widget.data['bankTujuan'],Constant().darkMode),
          Divider(),
          content(context,'Atas Nama',widget.data['atasNama'],Constant().darkMode),
          Divider(),
          content(context,'Jumlah Transfer',"Rp "+FunctionHelper().formatter.format(int.parse('${widget.data['nominal']}'))+' .-',Constant().moneyColor),
          Divider(),
          content(context,'Biaya Admin',"Rp "+FunctionHelper().formatter.format(int.parse('${widget.data['admin']}'))+' .-',Constant().moneyColor),
          Divider(),
          content(context,'Total Pembayaran',"Rp "+FunctionHelper().formatter.format(int.parse('${widget.data['total']}'))+' .-',Constant().moneyColor)
        ],
      ),
    );
  }

  Widget content(BuildContext context, title,desc,Color color){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      onTap: (){},
      // leading: Icon(AntDesign.checkcircleo,color:Constant().mainColor,),
      title:WidgetHelper().textQ(title,scaler.getTextSize(9),Constant().darkMode, FontWeight.bold),
      trailing: WidgetHelper().textQ(desc,scaler.getTextSize(9),color, FontWeight.normal)
    );
  }
}
