import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/PPOB/category_ppob_model.dart';
import 'package:sangkuy/model/PPOB/product_ppob_pra_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';

class PrabayarScreen extends StatefulWidget {
  dynamic val;
  PrabayarScreen({this.val});
  @override
  _PrabayarScreenState createState() => _PrabayarScreenState();
}

class _PrabayarScreenState extends State<PrabayarScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final FocusNode nohpFocus = FocusNode();
  var nohpController = TextEditingController();
  int idx=10000000;
  bool isLoading=false,isLoadingProduct=false,isNodata=false,isWidget=true;
  dynamic provider;
  String title='';
  CategoryPpobModel categoryPpobModel;
  ProductPpobPraModel productPpobPraModel;
  Future loadCategory()async{
    var res=await BaseProvider().getProvider('transaction/produk/operator?kategori=${widget.val['code']}',categoryPpobModelFromJson);
    if(res is CategoryPpobModel){
      CategoryPpobModel result=res;
      if(this.mounted){
        categoryPpobModel=result;
      }
    }
  }
  Future loadUser()async{
    final no = await UserHelper().getDataUser("mobile_no");
    await loadProduct("$no");
    setState(() {
      nohpController.text=no;
    });
  }
  Future loadProduct(String where)async{
    var res=await BaseProvider().getProvider("transaction/produk/list?$where",productPpobPraModelFromJson);
    if(res is ProductPpobPraModel){
      ProductPpobPraModel result=res;
      if(this.mounted){
        setState(() {
          productPpobPraModel=result;
          isLoadingProduct=false;
          isNodata=false;
        });
      }
    }
    else if(res==Constant().errNoData){
      setState(() {
        isLoadingProduct=false;
        isNodata=true;
      });
    }
  }
  Future handleChange(e)async{
    String no = "$e".replaceAll("62","0");
    String prefix3='';
    String prefix4='';
    if(no.length<10){
      setState(() {
        idx=1000000;
      });
    }
    if(no.length>=3){
      prefix3 = no.substring(0,3);
    }
    if(no.length>=4){
      prefix4 = no.substring(0,4);
    }
    if(no.length>=3){
      categoryPpobModel.result.data.forEach((element) {
        if(element.prefix!=null){
          List pref=element.prefix.split(",");
          pref.forEach((val) {
            if(prefix3==val||prefix4==val){
              setState(() {
                isNodata=false;
                provider = {"code":val,"value":element.title,"label":element.title,"icon":element.logo};
              });
            }
          });
        }
      });
      if(provider!=null&&no.length>=3&&no.length<=4){
        setState(() {
          isLoadingProduct=true;
        });
        loadProduct('nohp=$no&kategori=${widget.val['code']}');
      }
    }
    else{
      setState(() {
        provider=null;
        isNodata=true;
        idx=10000000;
      });
    }

  }
  Future loadData()async{
    setState(() {
      isLoading=true;
    });
    await loadCategory();
    await loadUser();
    if(checkParam()==false){
      setState(() {
        isLoadingProduct=true;
      });
      loadProduct('nohp=${nohpController.text}&kategori=${widget.val['code']}');
    }
    setState(() {
      isLoading=false;
    });
  }

  Future handleNext(val)async{
    if(nohpController.text.length<10){
      WidgetHelper().showFloatingFlushbar(context,"failed","No. Telepon minimal 10 angka");
      return;
    }
    if(nohpController.text.length>14){
      WidgetHelper().showFloatingFlushbar(context,"failed","No. Telepon maksimal 14 angka");
      return;
    }
    setState(() {
      nohpFocus.unfocus();
      idx=val['index'];
    });
    if(val['param']=='2'){
      WidgetHelper().loadingDialog(context);
      await loadProduct('operator=${val['op_id']}&perpage=100');
      Navigator.pop(context);
      if(isNodata){
        WidgetHelper().showFloatingFlushbar(context,"failed","data tidak tersedia");
      }else{
        WidgetHelper().myModal(context,ModalProduct(productPpobPraModel:productPpobPraModel,val:val));
      }
    }
    else{
      WidgetHelper().myModal(context,ModalDetailPrabayar(val:val));
    }

  }
  Widget child;

  checkParam(){
    // this.checkParam()?buildContent2(context):buildContent1(context)
    if(title=='VOUCHER GAME' || title=='E-MONEY'||title=='VOUCHER WIFI.ID'||title=='E-TOLL'){
      setState(() {
        isWidget=true;
        // child=buildContent2(context);
      });
    }
    else{
      setState(() {
        isWidget=false;
        // child=buildContent1(context);
      });
      return isWidget;
    }
  }

  @override
  void dispose() {
    super.dispose();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title=widget.val['title'];

    loadData();
    checkParam();

    provider=null;
  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: WidgetHelper().appBarWithButton(context,title.toLowerCase(),(){Navigator.pop(context);},<Widget>[]),
        body:isLoading?WidgetHelper().loadingWidget(context):Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:  Radius.circular(10)),
              child:  WidgetHelper().baseImage('https://dailypost.files.wordpress.com/2015/04/turnpike-blur.jpg',height: scaler.getHeight(6),width: scaler.getWidth(100),fit: BoxFit.cover),
            ),
            title=='VOUCHER GAME' || title=='E-MONEY'||title=='VOUCHER WIFI.ID'||title=='E-TOLL'?buildContent2(context):buildContent1(context),
          ],
        ),
    );
  }


  Widget buildContent1(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return ListView(
      shrinkWrap: true,
      primary: true,
      children: [

        Card(
          margin: scaler.getMargin(1,2),
          elevation: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: scaler.getPadding(1,2),
                child: WidgetHelper().textQ("No. Telepon",scaler.getTextSize(9),Constant().mainColor2,FontWeight.bold),
              ),
              Container(
                margin: scaler.getMargin(0,2),
                width: double.infinity,
                padding: scaler.getPadding(0,2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFEEEEEE),
                ),
                child: TextFormField(
                  style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(9),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
                  controller: nohpController,
                  maxLines: 1,
                  autofocus: false,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon:provider!=null?Image.network(provider['icon'],width: 20,fit: BoxFit.contain):Image.asset(Constant().localAssets+"logo.png",width: 20,fit: BoxFit.contain,),
                    contentPadding: const EdgeInsets.only(top: 19.0, right: 10.0, bottom: 0.0, left: 0.0),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  focusNode: nohpFocus,
                  inputFormatters: <TextInputFormatter>[
                    LengthLimitingTextInputFormatter(14),
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  onChanged: (e){
                    handleChange(e);
                  },

                ),
              ),
              SizedBox(height: scaler.getHeight(1))
            ],
          ),
        ),
        isLoadingProduct?StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(10.0),
          shrinkWrap: true,
          primary: false,
          crossAxisCount: 2,
          itemCount: 25,
          itemBuilder: (BuildContext context, int index) {
            return WidgetHelper().baseLoading(context,Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(10)
              ),
            ));
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ):isNodata?Container(
          padding: scaler.getPadding(1, 2),
          child: WidgetHelper().textQ("No data.",scaler.getTextSize(9), Constant().darkMode,FontWeight.bold),
        ):
        StaggeredGridView.countBuilder(
          padding: scaler.getPadding(1, 2),
          shrinkWrap: true,
          primary: false,
          crossAxisCount: 2,
          itemCount:  productPpobPraModel.result.data.length,
          itemBuilder: (BuildContext context, int index) {
            var val=productPpobPraModel.result.data[index];
            return FlatButton(
                padding:scaler.getPadding(1,1),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                color: idx==index?Constant().mainColor:Color(0xFFEEEEEE),
                onPressed: (){
                  handleNext(val.toJson()..addAll({"param":"1","index":index,"nohp":nohpController.text,"page":title}));
                },
                child: Column(
                  children: [
                    WidgetHelper().textQ('Rp ${FunctionHelper().formatter.format(int.parse(val.price))} .-',scaler.getTextSize(9),Constant().moneyColor, FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
                    SizedBox(height:5.0),
                    WidgetHelper().textQ(val.note,scaler.getTextSize(7),idx==index?Constant().secondDarkColor:Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center,maxLines: 10),
                  ],
                )
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
        ),
      ],
    );
  }
  Widget buildContent2(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return ListView(
      shrinkWrap: true,
      primary: true,
      children: [
        Card(
          margin: scaler.getMargin(1,2),
          elevation: 2,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: scaler.getPadding(1,2),
                  child: WidgetHelper().textQ("No. Telepon",scaler.getTextSize(9),Constant().mainColor2,FontWeight.bold),
                ),
                Container(
                  margin: scaler.getMargin(0,2),
                  width: double.infinity,
                  padding: scaler.getPadding(0,2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFEEEEEE),
                  ),
                  child: TextFormField(
                    style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(9),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
                    controller: nohpController,
                    maxLines: 1,
                    autofocus: false,
                    decoration: InputDecoration(

                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon:provider!=null?Image.network(provider['icon'],width: 20,fit: BoxFit.contain):Image.asset(Constant().localAssets+"logo.png",width: 20,fit: BoxFit.contain,),
                      contentPadding: const EdgeInsets.only(top: 19.0, right: 10.0, bottom: 0.0, left: 0.0),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    focusNode: nohpFocus,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(14),
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onChanged: (e){
                      handleChange(e);
                    },

                  ),
                ),
                SizedBox(height: scaler.getHeight(1))
              ],
            ),
          ),
        ),
        StaggeredGridView.countBuilder(
          padding: scaler.getPadding(1, 2),
          shrinkWrap: true,
          primary: false,
          crossAxisCount: 2,
          itemCount:  categoryPpobModel.result.data.length,
          itemBuilder: (BuildContext context, int index) {
            var val=categoryPpobModel.result.data[index];
            var logo=val.logo.split("/");
            return FlatButton(
                padding:scaler.getPadding(1,1),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10)),
                color: idx==index?Constant().mainColor:Color(0xFFEEEEEE),
                onPressed: ()async{
                  handleNext(val.toJson()..addAll({"param":"2","index":index,"nohp":nohpController.text,"page":title}));
                },
                child: Row(
                  children: [
                    WidgetHelper().baseImage(val.logo,height: scaler.getHeight(3),width: scaler.getWidth(7),fit: BoxFit.contain),
                    SizedBox(width: scaler.getWidth(1)),
                    Expanded(
                      child: WidgetHelper().textQ(val.title.toLowerCase(),scaler.getTextSize(9),idx==index?Constant().secondDarkColor:Constant().darkMode, FontWeight.normal,textAlign: TextAlign.left,maxLines: 10),
                    ),
                  ],
                ),
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 5,
          crossAxisSpacing: 5.0,
        )
      ],
    );
  }

}

class ModalProduct extends StatefulWidget {
  ProductPpobPraModel productPpobPraModel;
  dynamic val;
  ModalProduct({this.productPpobPraModel,this.val});
  @override
  _ModalProductState createState() => _ModalProductState();
}

class _ModalProductState extends State<ModalProduct> {
  int idx=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(80),
      child: WidgetHelper().wrapperModal(context,"", Scrollbar(
          child: ListView(
            children: [
              Expanded(
                  child: ListView.builder(
                    padding:scaler.getPadding(0,2),
                    addRepaintBoundaries: true,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: widget.productPpobPraModel.result.data.length,
                    itemBuilder: (context,index){
                      var val=widget.productPpobPraModel.result.data[index];
                      return FlatButton(
                        color: index%2==0?Color(0xFFEEEEEE):Colors.transparent,
                        padding:scaler.getPadding(1,2),
                        onPressed: (){
                          setState(() {
                            idx=index;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            WidgetHelper().textQ(val.note,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                            Icon(AntDesign.checkcircleo,color: idx==index?Constant().darkMode:Colors.transparent,size: scaler.getTextSize(12),)
                          ],
                        ),
                      );
                    },
                  )
              ),

            ],
          )
      ),isCallack: true,callack: (){
        var val = widget.productPpobPraModel.result.data[idx].toJson();
        WidgetHelper().myModal(context,ModalDetailPrabayar(val:val..addAll({"nohp":widget.val['nohp'],"page":widget.val['title']})));
      },txtBtn: "Lanjut"),
    );
  }
}



class ModalDetailPrabayar extends StatefulWidget {
  dynamic val;
  ModalDetailPrabayar({this.val});
  @override
  _ModalDetailPrabayarState createState() => _ModalDetailPrabayarState();
}

class _ModalDetailPrabayarState extends State<ModalDetailPrabayar> {
  Future handleSubmit()async{
    WidgetHelper().myPush(context,PinScreen(callback: (BuildContext context,isTrue,pin)async{
      final data={
        "code":widget.val['code'],
        "nohp":widget.val['nohp'],
        "mtr_pln":"-",
        "pin":pin.toString()
      };
      WidgetHelper().loadingDialog(context);
      var res=await BaseProvider().postProvider("transaction/prabayar/checkout", data,context: context,callback: (){
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
        // Navigator.pop(context);
      });
      if(res!=null){
        Navigator.pop(context);
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        });
      }
    }));
  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(70),
      child: WidgetHelper().wrapperModal(context,"Konfirmasi Pembayaran",ListView(
        // padding: scaler.getPadding(0,2),
        children: [
          desc(context,"Jenis Layanan",widget.val['provider']),
          Divider(),
          if(widget.val['page']=='PULSA ALL OPERATOR')desc(context,"Nominal","Rp ${widget.val['note'].split(" ")[1]} .-",color: Constant().moneyColor),
          if(widget.val['page']=='PULSA ALL OPERATOR')Divider(),
          desc(context,"Nomor",widget.val['nohp']),
          Divider(),
          desc(context,"Harga","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),
          Divider(),
          Padding(
            padding:scaler.getPadding(1,2),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Ringkasan Pembayaran',color: Constant().mainColor,iconSize: scaler.getTextSize(9)),
          ),

          desc(context,"Metode Pembayaran",'Saldo',color: Colors.black),
          Divider(color: Colors.grey),
          desc(context,"Total Tagihan","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),

        ],
      ),isCallack: true,callack: (){
        handleSubmit();
      },txtBtn: "Bayar"),
    );
  }
  Widget desc(BuildContext context,title,desc,{Color color=Colors.black,Color colorttl=Colors.black}){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Padding(
      padding:scaler.getPadding(0.5,2),
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

