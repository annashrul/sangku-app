import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/cart_model.dart';
import 'package:sangkuy/provider/cart_provider.dart';
import 'package:sangkuy/view/screen/mlm/checkout_screen.dart';
import 'package:sangkuy/view/screen/mlm/detail_package_screen.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  CartModel cartModel;
  bool isLoading=false,isError=false,isErrToken=false,isNodata=false;
  String tipe='';
  int total=0;
  Future loadPackageType()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final packageType=prefs.getString("packageType");
    setState(() {
      tipe=packageType;
    });
  }
  Future loadCart()async{
    var res=await CartProvider().getCart();
    if(res=='error'){
      isLoading=false;
      isError=true;
      isNodata=false;
      setState(() {});
    }
    else if(res=='failed'){
      isLoading=false;
      isError=true;
      isNodata=false;
      setState(() {});
    }
    else if(res==Constant().errExpToken){
      isLoading=false;
      isError=false;
      isErrToken=true;
      isNodata=false;
      setState(() {});
    }
    else if(res==Constant().errNoData){
      isLoading=false;
      isError=false;
      isErrToken=false;
      isNodata=true;
      setState(() {});
    }
    else if(res is General){
      isLoading=false;
      isError=false;
      isErrToken=false;
      isNodata=true;
      setState(() {});
    }
    else{
      if(this.mounted)
      setState(() {
        isLoading=false;
        isError=false;
        isErrToken=false;
        isNodata=false;
        // isLoading=false;
        // isError=false;
        cartModel = res;
      });
      if(cartModel.result.length<1){
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove("packageType");
      }
      getSubtotal();
    }
  }
  Future postCart(id,qty)async{
    WidgetHelper().loadingDialog(context);
    var res = await CartProvider().postCart(id,qty.toString(),tipe,context,(){
      Navigator.pop(context);
    });
    if(res!=null){
      Navigator.pop(context);
      await loadCart();
    }

  }
  Future deleteCart(id)async{
    WidgetHelper().loadingDialog(context);
    var res = await CartProvider().deleteCart(id);
    Navigator.pop(context);
    if(res=='error'){
      WidgetHelper().notifBar(context,"failed",Constant().msgConnection);
    }
    else{
      await loadCart();
      WidgetHelper().notifBar(context,"success","barang berhasil dihapus");
    }
  }

  getSubtotal(){
    int st = 0;
    for(var i=0;i<cartModel.result.length;i++){
      st = st+int.parse(cartModel.result[i].harga)*cartModel.result[i].qty;
    }
    total = st;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadCart();
    loadPackageType();
  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,"Ringkasan Belanja", (){
        Navigator.pop(context);
      }, <Widget>[]),
      body: isLoading?WidgetHelper().loadingWidget(context):isError?ErrWidget(callback: (){
        setState(() {
          isLoading=true;
        });
        loadCart();
      }):!isNodata?RefreshWidget(
        widget: SingleChildScrollView(
          child: Column(
            children: [
              ListView.separated(
                primary: true,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.all(0.0),
                itemCount: cartModel.result.length,
                itemBuilder: (context,index){
                  var val=cartModel.result[index];
                  print("tipe ${val.type}");
                  return buildContent(context, index,val.id,val.idPaket,val.foto,val.title,val.harga,val.berat,val.qty);
                },
                separatorBuilder: (context,index){return Divider();},
              ),

            ],
          ),
        ),
        callback: (){
          setState(() {
            isLoading=true;
          });
          loadCart();
        },
      ):WidgetHelper().noDataWidget(context),
      bottomNavigationBar:isLoading?Text(''):!isNodata?Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          color: Constant().moneyColor,
          child: FlatButton(
              onPressed: () {
                WidgetHelper().myPushAndLoad(context,ChaeckoutScreen(), (){loadCart();});
              },
              padding: EdgeInsets.only(left:scaler.getWidth(2)),
              color: Constant().moneyColor,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(total)} .-", scaler.getTextSize(10), Constant().secondDarkColor, FontWeight.normal),
                  Container(
                    padding:scaler.getPadding(1,2),
                    decoration: BoxDecoration(
                      color: Constant().secondColor
                    ),
                    child: Row(
                      children: [
                        Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                        SizedBox(width:scaler.getWidth(2)),
                        WidgetHelper().textQ("Checkout",  scaler.getTextSize(10), Constant().secondDarkColor, FontWeight.normal),
                      ],
                    ),
                  )
                ],
              )
            // child:Text("abus")
          ),
        ):Text('')
    );
  }
  Widget buildContent(BuildContext context,index,id,idPaket,image,name,price,berat,qty) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    int jumlah=qty;
    return WidgetHelper().myPress((){
        WidgetHelper().myPushAndLoad(context,DetailPackageScreen(id: idPaket,tipe:tipe), ()=>loadCart());
      },
      Container(
          color: Theme.of(context).focusColor.withOpacity(0.1),
          padding:scaler.getPadding(1,0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: ()async{
                  WidgetHelper().notifDialog(context,"Informasi !", "Anda yakin akan menghapus data ini ?", (){
                    Navigator.pop(context);
                  },(){
                    Navigator.pop(context);
                    deleteCart(id);
                  });
                },
                iconSize: scaler.getTextSize(12),
                padding: EdgeInsets.symmetric(horizontal: 0),
                icon: Icon(AntDesign.delete),
                color:Constant().mainColor,
              ),
              Expanded(
                child: Row(
                  children: [
                    WidgetHelper().baseImage(image,height: scaler.getHeight(5), width:  scaler.getWidth(10)),
                    SizedBox(width: scaler.getWidth(2)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ(name,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                        WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse(price))} .-",scaler.getTextSize(9),Constant().moneyColor,FontWeight.bold),
                      ],
                    )
                  ],
                ),
              ),

              IconButton(
                onPressed: ()async{
                  setState(() {
                    jumlah+=1;
                  });
                  await postCart(idPaket, 'plus');
                },
                iconSize: scaler.getTextSize(12),
                padding: EdgeInsets.symmetric(horizontal: 5),
                icon: Icon(AntDesign.pluscircleo),
                color: Constant().mainColor,
              ),
              WidgetHelper().textQ('$jumlah',scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
              IconButton(
                onPressed: ()async{
                  if(jumlah>1){
                    setState(() {
                      jumlah-=1;
                    });
                    await postCart(idPaket, 'min');
                  }

                },
                iconSize: scaler.getTextSize(12),
                padding: EdgeInsets.symmetric(horizontal: 5),
                icon: Icon(AntDesign.minuscircleo),
                color: Constant().mainColor,
              ),
            ],
          ),
        ),
      color: Colors.black38
    );
  }

}
