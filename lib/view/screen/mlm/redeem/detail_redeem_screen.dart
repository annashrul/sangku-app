import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/address/address_model.dart';
import 'package:sangkuy/provider/address_provider.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/card_widget.dart';


class DetailRedeem extends StatefulWidget {
  dynamic val;
  DetailRedeem({this.val});
  @override
  _DetailRedeemState createState() => _DetailRedeemState();
}

class _DetailRedeemState extends State<DetailRedeem> {
  bool isLoading=false,isNodata=false;
  AddressModel listAddressModel;
  String idAddress='';
  Future loadData()async{
    var res = await AddressProvider().getAddress(10);
    if(res==Constant().errNoData){
      isLoading=false;
      isNodata=true;
      setState(() {});
    }
    else if(res is General){
      isLoading=false;
      isNodata=true;
      setState(() {});
    }
    else{
      if (this.mounted) {
        setState(() {
          listAddressModel = res;
          isLoading = false;
          isNodata=false;
        });
      }
    }
  }
  Future postRedeem()async{
    if(idAddress==''){
      WidgetHelper().showFloatingFlushbar(context,"failed","silahkan pilih alamat anda");
    }
    else{
      WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
        final data={
          "ongkir":"0",
          "layanan_pengiriman":"-",
          "alamat":idAddress,
          "id_barang":widget.val['id'].toString(),
          "pin_member":pin.toString()
        };
        WidgetHelper().loadingDialog(context);
        var res=await BaseProvider().postProvider('transaction/redeem', data,context: context,callback:(){
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });

        if(res!=null){
          Navigator.pop(context);
          WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx, ()async{
            WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          });
        }
      }));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(90),
      child: isLoading?WidgetHelper().loadingWidget(context):Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            padding: EdgeInsets.only(left:10,bottom: 10),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Redeem Poin',color: Constant().mainColor1),
          ),
          Container(
            // color: Theme.of(context).focusColor.withOpacity(0.1),
            padding: scaler.getPadding(0.5,1.7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        height: scaler.getHeight(5),
                        width: scaler.getWidth(10),
                        imageUrl: widget.val['gambar'],
                        fit:BoxFit.contain,
                        placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                        errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetHelper().textQ(widget.val['title'],scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                          WidgetHelper().textQ(FunctionHelper().formatter.format(int.parse(widget.val['harga'])),scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),
                        ],
                      )
                    ],
                  ),
                ),


              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(left:10.0,right:10.0),
              child: Container(
                color:Theme.of(context).focusColor.withOpacity(0.1),
                padding: EdgeInsets.all(10.0),
                child: WidgetHelper().textQ(widget.val['deskripsi'],scaler.getTextSize(9),Constant().darkMode,FontWeight.normal,maxLines: 100),
              )
          ),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                desc(context,"Poin Anda",FunctionHelper().formatter.format(int.parse(widget.val['my_poin'])),color: Constant().moneyColor),
                Divider(),
                desc(context,"Poin Yang Digunakan",FunctionHelper().formatter.format(int.parse(widget.val['harga'])),color: Constant().moneyColor),
                Divider(thickness: 2.0),
                desc(context,"Sisa Poin Anda","${FunctionHelper().formatter.format(int.parse(widget.val['my_poin'])-int.parse(widget.val['harga']))}",color: Constant().moneyColor),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left:10,bottom: 10,top:10),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Pilih Alamat',color: Constant().mainColor1),
          ),
          Expanded(
              flex: 1,
              child: ListView.separated(
                padding: EdgeInsets.all(10.0),
                addRepaintBoundaries: true,
                primary: false,
                shrinkWrap: true,
                itemCount: listAddressModel.result.data.length,
                itemBuilder: (context,index){
                  var val=listAddressModel.result.data[index];
                  return CardWidget(
                    onTap:(){
                      setState(() {
                        idAddress=val.id;
                      });
                    },
                    titleColor: Constant().darkMode,
                    prefixBadge: Constant().mainColor,
                    // title: val.title,
                    description: val.mainAddress,
                    descriptionColor: Constant().darkMode,
                    suffixIcon:AntDesign.checkcircleo,
                    suffixIconColor: idAddress==val.id?Constant().mainColor:Colors.transparent,
                    backgroundColor:Constant().greyColor,
                  );
                },
                separatorBuilder: (_,i){return(Text(''));},
              )
          ),
          FlatButton(
              padding: scaler.getPadding(1.3,0),
              color: Constant().moneyColor,
              onPressed: (){
                postRedeem();
                // handleSubmit();
                // checkingAccount();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(AntDesign.checkcircleo,color: Colors.white,size: scaler.getTextSize(12),),
                  SizedBox(width: 10.0),
                  WidgetHelper().textQ("CHECKOUT", scaler.getTextSize(10),Colors.white,FontWeight.bold)
                ],
              )
          )
        ],
      ),
    );
  }
  Widget desc(BuildContext context,title,desc,{Color color=Colors.black,Color colorttl=Colors.black}){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Padding(
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetHelper().textQ(title,scaler.getTextSize(9),colorttl,FontWeight.normal),
          WidgetHelper().textQ(desc,scaler.getTextSize(9),color,FontWeight.bold)
        ],
      ),
    );
  }

}
