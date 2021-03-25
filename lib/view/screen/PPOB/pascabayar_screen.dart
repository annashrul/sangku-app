import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/PPOB/cek_tagihan_model.dart';
import 'package:sangkuy/model/PPOB/product_ppob_pra_model.dart';
import 'package:sangkuy/model/auth/otp_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/card_widget.dart';

class PascabayarScreen extends StatefulWidget {
  dynamic val;
  PascabayarScreen({this.val});
  @override
  _PascabayarScreenState createState() => _PascabayarScreenState();
}

class _PascabayarScreenState extends State<PascabayarScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode idPelangganFocus = FocusNode();
  var idPelangganController = TextEditingController();
  final FocusNode nohpFocus = FocusNode();
  var nohpController = TextEditingController();
  ProductPpobPraModel productPpobPraModel;
  int perpage=10,total=0;
  bool isLoading=false,isLoadingProduct=false,isLoadmore=false;
  String code='';
  CekTagihanModel cekTagihanModel;
  Future loadProduct()async{
    var res=await BaseProvider().getProvider("transaction/produk/list?kategori=${widget.val['code']}&perpage=$perpage",productPpobPraModelFromJson);
    if(res is ProductPpobPraModel){
      ProductPpobPraModel result=res;
      print(result.toJson());
      if(this.mounted){
        setState(() {
          isLoadmore=false;
          productPpobPraModel=result;
          isLoadingProduct=false;
          total = productPpobPraModel.result.total;
        });
      }
    }else if(res==Constant().errNoData){
      setState(() {
        isLoadingProduct=false;
        total=0;
      });
    }
  }
  Future handleProses()async{
    if(nohpController.text==''){
      return WidgetHelper().showFloatingFlushbar(context,"failed","No. Telepon tidak boleh kosong");
    }
    if(idPelangganController.text==''){
      return WidgetHelper().showFloatingFlushbar(context,"failed","ID Pelanggan tidak boleh kosong");
    }
    if(code==''){
      return WidgetHelper().showFloatingFlushbar(context,"failed","Silahkan pilih jenis tagihan");
    }
    final data={
      "code":code.toString(),
      "nohp":nohpController.text,
      "nopel":idPelangganController.text
    };
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().postProvider('transaction/pascabayar/tagihan', data,context: context,callback: (){
      Navigator.pop(context);
      Navigator.pop(context);
    });

    if(res!=null){
      Navigator.pop(context);
      WidgetHelper().myModal(context,ModalDetailPascabayar(val: res));

    }
    // if(res==Constant().errTimeout||res==Constant().errSocket){
    //   WidgetHelper().notifDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout, (){}, (){},titleBtn1: 'Kembali',titleBtn2: 'Cobalagi');
    // }
    // else if(res is General){
    //   General result=res;
    //   WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    // }
    // else{
    //   WidgetHelper().myModal(context,ModalDetailPascabayar(val: res));
    // }
  }
  ScrollController controller;

  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print('fetch data');
        if(perpage<total){
          setState((){
            perpage+=10;
            isLoadmore=true;
          });
          loadProduct();
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    isLoadingProduct=true;
    loadProduct();
  }
  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    isLoading=false;
    isLoadmore=false;
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    print(widget.val);
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,widget.val['title'],(){Navigator.pop(context);},<Widget>[]),
      body: isLoadingProduct?WidgetHelper().loadingWidget(context):ListView(
        // padding: EdgeInsets.all(10.0),
        controller: controller,
        children: [
          Container(
            margin: scaler.getMargin(1,0),
            padding:scaler.getPadding(0,2),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("No. Telepon", scaler.getTextSize(9), Constant().darkMode,FontWeight.bold),
                SizedBox(height:scaler.getHeight(1)),
                Container(
                  width: double.infinity,
                  padding: scaler.getPadding(0,2),
                  // width: double.infinity,
                  // padding: EdgeInsets.only(left:10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:Constant().greyColor,
                  ),
                  child: TextFormField(
                    style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
                    controller: nohpController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon:Icon(AntDesign.phone,color:Constant().mainColor1,size: scaler.getTextSize(12),),
                      contentPadding: const EdgeInsets.only(top: 19.0, right: 10.0, bottom: 0.0, left: 0.0),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    focusNode: nohpFocus ,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(14),

                      WhitelistingTextInputFormatter.digitsOnly
                    ],

                    onFieldSubmitted: (e){
                      WidgetHelper().fieldFocusChange(context,nohpFocus,idPelangganFocus);
                      // handleChange(e);
                    },
                  ),
                ),
                SizedBox(height:scaler.getHeight(1)),
                WidgetHelper().textQ("ID Pelanggan", scaler.getTextSize(9), Constant().darkMode,FontWeight.bold),
                SizedBox(height:scaler.getHeight(1)),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left:10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color:Constant().greyColor
                  ),
                  child: TextFormField(
                    style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
                    controller: idPelangganController,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon:Icon(AntDesign.link,color:Constant().mainColor1,size: scaler.getTextSize(12),),
                      contentPadding: const EdgeInsets.only(top: 19.0, right: 10.0, bottom: 0.0, left: 0.0),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    focusNode: idPelangganFocus ,
                  ),
                ),
                SizedBox(height:scaler.getHeight(1)),
                WidgetHelper().textQ("Jenis Tagihan", scaler.getTextSize(9), Constant().darkMode,FontWeight.bold),
                SizedBox(height:scaler.getHeight(1)),
                Container(
                    child: ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemCount: productPpobPraModel.result.data.length,
                        itemBuilder: (context,index){
                          var val=productPpobPraModel.result.data[index];

                          return Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: CardWidget(
                                onTap:(){
                                  setState(() {
                                    code = val.code;
                                  });
                                  print(code);
                                },
                                titleColor:  Constant().darkMode,
                                prefixBadge: Constant().darkMode,
                                title: val.note.toLowerCase(),
                                suffixIcon:AntDesign.checkcircleo,
                                suffixIconColor: code==val.code?Constant().mainColor1:Colors.transparent,
                                backgroundColor:Constant().greyColor
                            ),
                          );
                        }
                    )
                ),
                if(isLoadmore)Container(
                  alignment: Alignment.center,
                  child: CupertinoActivityIndicator(),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child: FlatButton(
            // shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
            onPressed: () {
              handleProses();
            },
            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
            color: Constant().moneyColor,
            child:Container(
              padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                  SizedBox(width:10.0),
                  WidgetHelper().textQ("PROSES", 14, Constant().secondDarkColor, FontWeight.bold),
                ],
              ),
            )
          // child:Text("abus")
        ),
      ),
    );
  }
}


class ModalDetailPascabayar extends StatefulWidget {
  dynamic val;
  ModalDetailPascabayar({this.val});
  @override
  _ModalDetailPascabayarState createState() => _ModalDetailPascabayarState();
}

class _ModalDetailPascabayarState extends State<ModalDetailPascabayar> {

  Future handleSubmit()async{
    final nomor=await UserHelper().getDataUser('mobile_no');
    final nama=await UserHelper().getDataUser('full_name');
    final data={
      "nomor":nomor,
      "type":"-",
      "nama":nama,
      "islogin":'true'
    };
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().postProvider('auth/otp', data,context: context,callback: (){
      Navigator.pop(context);
      Navigator.pop(context);
    });
    if(res!=null){
      Navigator.pop(context);
      var result = OtpModel.fromJson(res);
      WidgetHelper().myPush(context,SecureCodeScreen(
        callback:(context,isTrue)async{
          WidgetHelper().myPush(context,PinScreen(callback: (BuildContext context,isTrue,pin)async{
            checkout(pin);
          }));
        },
        code:result.result.otpAnying,
        desc: 'WhatsApp',
        data: data,
      ));
    }
    // Navigator.pop(context);
    // if(res==Constant().errSocket||res==Constant().errTimeout){
    //   WidgetHelper().notifDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout, (){
    //     Navigator.pop(context);
    //   }, (){
    //     Navigator.pop(context);
    //     handleSubmit();
    //   },titleBtn1: 'Kembali',titleBtn2: 'Cobalagi');
    //
    // }
    // else if(res is General){
    //   General result=res;
    //   WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    // }
    // else{
    //   print(res);
    //   var result = OtpModel.fromJson(res);
    //   WidgetHelper().myPush(context,SecureCodeScreen(
    //     callback:(context,isTrue)async{
    //       WidgetHelper().myPush(context,PinScreen(callback: (BuildContext context,isTrue,pin)async{
    //         checkout(pin);
    //       }));
    //     },
    //     code:result.result.otpAnying,
    //     desc: 'WhatsApp',
    //     data: data,
    //   ));
    // }
    // WidgetHelper().myPush(context,SecureCodeScreen());
  }

  Future checkout(pin)async{
    WidgetHelper().loadingDialog(context);
    var res=await BaseProvider().postProvider('transaction/pascabayar/checkout',{
      "kd_trx":widget.val['result']['kd_trx'],
      "pin":pin.toString()
    },context: context,callback: (){
      print("bus");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
    if(res!=null){
      Navigator.pop(context);
      WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      });
    }
    // Navigator.pop(context);
    // if(res==Constant().errSocket||res==Constant().errTimeout){
    //   WidgetHelper().notifDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout, (){
    //     Navigator.pop(context);
    //   }, (){
    //     Navigator.pop(context);
    //     checkout(pin);
    //   },titleBtn1: 'Kembali',titleBtn2: 'Cobalagi');
    //
    // }
    // else if(res is General){
    //   General result=res;
    //   WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    // }
    // else{
    //   WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
    //     WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
    //   });
    //   print(res);
    // }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.val);
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      // padding: EdgeInsets.only(bottom:50.0,top:0.0,left:0.0,right:0.0),
      decoration: BoxDecoration(
          // color: Constant().secondColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[

          Padding(
            padding:scaler.getPadding(1,2),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Konfirmasi Pembayaran',color: Constant().mainColor1,iconSize: scaler.getTextSize(10)),
          ),
          desc(context,'Jenis Tagihan', widget.val['result']['produk']),
          Divider(),
          desc(context,'No. Pelanggan / No. Rekening', widget.val['result']['no_pelanggan']),
          Divider(),
          desc(context,'Biaya Admin', 'Rp ${FunctionHelper().formatter.format(widget.val['result']['admin'])} .-'),
          Divider(),
          desc(context,'Tagihan', 'Rp ${FunctionHelper().formatter.format(widget.val['result']['tagihan'])} .-'),
          Divider(thickness: 2.0),
          desc(context,'Total Bayar', 'Rp ${FunctionHelper().formatter.format(widget.val['result']['total_bayar'])} .-'),
          SizedBox(height:20.0),
          Padding(
            padding: EdgeInsets.only(left:10,right:10),
            child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                padding: EdgeInsets.all(15.0),
                color: Constant().mainColor,
                onPressed: (){
                  handleSubmit();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(AntDesign.checkcircleo,color: Colors.white),
                    SizedBox(width: 10.0),
                    WidgetHelper().textQ("BAYAR", 14,Colors.white,FontWeight.bold)
                  ],
                )
            ),
          )
        ],
      ),
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
