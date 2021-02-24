import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/view/screen/redeem/detail_redeem_screen.dart';

class RedeemWidget extends StatelessWidget {
  dynamic data;
  RedeemWidget({this.data});
  @override
  Widget build(BuildContext context) {
    int stock = int.parse(this.data['stock']);
    int points=int.parse(this.data['harga']);
    String status='Poin Mencukupi';
    bool isTrue=true;
    if(int.parse(this.data['point_ro'].split(".")[0])<points){
      // if(int.parse('0')<points){
      status='Tidak Mencukupi';
      isTrue=false;
    }
    if(stock<1){
      status='Stock Tidak Tersedia';
      isTrue=false;
    }
    return Container(
      child: FlatButton(
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
        padding: EdgeInsets.all(0.0),
        // color: Color(0xFFEEEEEE),
        onPressed: (){
          WidgetHelper().myModal(context,Container(
            height: MediaQuery.of(context).size.height/1.2,
            child: DetailRedeem(val: this.data..addAll({'my_poin':int.parse(this.data['point_ro'].split(".")[0]).toString()})),
          ));
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              width: (MediaQuery.of(context).size.width - 57) * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: this.data['gambar'],
                        width: double.infinity ,
                        fit:BoxFit.fill,
                        placeholder: (context, url) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                        errorWidget: (context, url, error) => Image.asset(Constant().localAssets+"logo.png", fit:BoxFit.cover),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 5, 5, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ('Stok barang ${FunctionHelper().formatter.format(stock)}', 10,Color(0xFF757575),FontWeight.bold),
                        SizedBox(height: 5),
                        WidgetHelper().textQ(this.data['title'], 12,Colors.black,FontWeight.bold),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(AntDesign.chrome,size: 10,color: Constant().mainColor2,),
                            SizedBox(width: 5.0,),
                            WidgetHelper().textQ('$status', 10,Constant().mainColor2,FontWeight.bold),
                          ],
                        )

                        // Container(
                        //   padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        //   child: WidgetHelper().textQ('$status', 12,Constant().secondDarkColor,FontWeight.bold,maxLines:3,textAlign: TextAlign.center),
                        //   color: colorBadge,
                        //   width: double.infinity,
                        // ),
                        // SizedBox(height: 14),
                        // WidgetHelper().textQ('${listRedeemModel.result.data[index].deskripsi}', 12,Constant().darkMode,FontWeight.normal,maxLines:3 ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 6,
              right: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color:Constant().mainColor),
                alignment: AlignmentDirectional.center,
                child: WidgetHelper().textQ('${FunctionHelper().formatter.format(points)} POIN', 10,Constant().secondDarkColor,FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
