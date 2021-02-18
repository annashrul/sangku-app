import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/address/address_model.dart';
import 'package:sangkuy/provider/address_provider.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.val);
    return isLoading?WidgetHelper().loadingWidget(context):Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.start,
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
          padding: EdgeInsets.only(top:10.0,bottom: 10.0,left:10,right:10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    CachedNetworkImage(
                      height: 50,
                      width: 50,
                      imageUrl: widget.val['gambar'],
                      fit:BoxFit.contain,
                      placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                      errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width: double.infinity,),
                    ),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ(widget.val['title'],12,Constant().darkMode,FontWeight.bold),
                        WidgetHelper().textQ(widget.val['harga'],12,Constant().moneyColor,FontWeight.bold),
                      ],
                    )
                  ],
                ),
              ),


            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              desc(context,"Poin Anda",FunctionHelper().formatter.format(int.parse(widget.val['my_poin']))),
              Divider(),
              desc(context,"Poin Yang Digunakan",FunctionHelper().formatter.format(int.parse(widget.val['harga']))),
              Divider(thickness: 2.0),
              desc(context,"Sisa Poin Anda","${FunctionHelper().formatter.format(int.parse(widget.val['my_poin'])-int.parse(widget.val['harga']))}"),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left:10,bottom: 10,top:10),
          child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Pilih Alamat',color: Constant().mainColor1),
        ),
        Expanded(
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

                  },
                  titleColor: Constant().darkMode,
                  prefixBadge: Constant().mainColor,
                  // title: val.title,
                  description: val.mainAddress,
                  descriptionColor: Constant().darkMode,
                  suffixIcon:AntDesign.checkcircleo,
                  suffixIconColor: Constant().mainColor,
                  backgroundColor:Constant().greyColor,
                );
              },
              separatorBuilder: (_,i){return(Text(''));},
            )
        )
      ],
    );
  }
  Widget desc(BuildContext context,title,desc,{Color color=Colors.black,Color colorttl=Colors.black}){
    return Padding(
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetHelper().textQ(title,12,colorttl,FontWeight.normal),
          WidgetHelper().textQ(desc,12,color,FontWeight.bold)
        ],
      ),
    );
  }

}
