import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
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
  bool isLoading=false,isLoadingProduct=false,isNodata=false;
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
    // await handleChange(no);
    setState(() {
      nohpController.text=no;
    });
  }
  Future loadProduct(String where)async{
    // nohp=$nohp&kategori=${widget.val['code']}
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
    if(!this.checkParam()){
      await handleChange(nohpController.text);
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

  checkParam(){
    if(title!='VOUCHER GAME' || title!='E-MONEY'||title!='VOUCHER WIFI.ID'||title=='E-TOLL'){
      return true;
    }else{
      return false;
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
    Widget child=this.checkParam()?buildContent2(context):buildContent1(context);
    return Scaffold(
        key: _scaffoldKey,
        appBar: WidgetHelper().appBarWithButton(context,title,(){Navigator.pop(context);},<Widget>[]),
        body: child,
    );
  }


  Widget buildContent1(BuildContext context){
    return isLoading?WidgetHelper().loadingWidget(context):ListView(
      shrinkWrap: true,
      primary: true,
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: WidgetHelper().textQ("No. Telepon",12,Constant().darkMode,FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.only(left:10,right:10),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFFEEEEEE),
            ),
            child: TextFormField(
              style: TextStyle(letterSpacing:2.0,fontSize:18,fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
              controller: nohpController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                suffixIcon:provider!=null?Image.network(provider['icon'],width: 20,fit: BoxFit.contain):Image.asset(Constant().localAssets+"logo.png",width: 20,fit: BoxFit.contain,),
                contentPadding: const EdgeInsets.only(top: 17.0, right: 30.0, bottom: 0.0, left: 5.0),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              focusNode: nohpFocus ,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(14),

                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: (e){
                handleChange(e);
              },
            ),
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
                color:Colors.white
            ));
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ):isNodata?WidgetHelper().noDataWidget(context):StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(10.0),
          shrinkWrap: true,
          primary: false,
          crossAxisCount: 2,
          itemCount:  productPpobPraModel.result.data.length,
          itemBuilder: (BuildContext context, int index) {
            var val=productPpobPraModel.result.data[index];
            return FlatButton(
                padding: EdgeInsets.all(10.0),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                color: idx==index?Constant().mainColor:Color(0xFFEEEEEE),
                onPressed: (){
                  handleNext(val.toJson()..addAll({"param":"1","index":index,"nohp":nohpController.text,"page":title}));
                },
                child: Column(
                  children: [
                    WidgetHelper().textQ('Rp ${FunctionHelper().formatter.format(int.parse(val.price))} .-',10,Constant().moneyColor, FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
                    SizedBox(height:5.0),
                    WidgetHelper().textQ(val.note,10,idx==index?Constant().secondDarkColor:Constant().darkMode, FontWeight.bold,textAlign: TextAlign.center,maxLines: 10),
                  ],
                )
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        )
      ],
    );
  }
  Widget buildContent2(BuildContext context){
    return isLoading?WidgetHelper().loadingWidget(context):ListView(
      shrinkWrap: true,
      primary: true,
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: WidgetHelper().textQ("No. Telepon",12,Constant().darkMode,FontWeight.bold),
        ),
        Padding(
          padding: EdgeInsets.only(left:10,right:10),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Color(0xFFEEEEEE),
            ),
            child: TextFormField(
              style: TextStyle(letterSpacing:2.0,fontSize:18,fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
              controller: nohpController,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                suffixIcon:provider!=null?Image.network(provider['icon'],width: 20,fit: BoxFit.contain):Image.asset(Constant().localAssets+"logo.png",width: 20,fit: BoxFit.contain,),
                contentPadding: const EdgeInsets.only(top: 17.0, right: 30.0, bottom: 0.0, left: 5.0),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              focusNode: nohpFocus ,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(14),

                WhitelistingTextInputFormatter.digitsOnly
              ],
              onChanged: (e){
                handleChange(e);
              },
            ),
          ),
        ),
        StaggeredGridView.countBuilder(
          padding: EdgeInsets.all(10.0),
          shrinkWrap: true,
          primary: false,
          crossAxisCount: 2,
          itemCount:  categoryPpobModel.result.data.length,
          itemBuilder: (BuildContext context, int index) {
            var val=categoryPpobModel.result.data[index];
            var logo=val.logo.split("/");
            return FlatButton(
                padding: EdgeInsets.all(10.0),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                color: idx==index?Constant().mainColor:Color(0xFFEEEEEE),
                onPressed: ()async{
                  handleNext(val.toJson()..addAll({"param":"2","index":index,"nohp":nohpController.text,"page":title}));
                },
                child:ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: CachedNetworkImage(
                      imageUrl:val.logo,
                      fit:BoxFit.contain,
                      placeholder: (context, url) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.fitWidth),
                      errorWidget: (context, url, error) => Image.asset(Constant().localAssets+'logo.png',fit:BoxFit.fitWidth),
                    ),
                  ),
                  title:WidgetHelper().textQ(val.title,10,idx==index?Constant().secondDarkColor:Constant().darkMode, FontWeight.bold,textAlign: TextAlign.left,maxLines: 10),
                )
            );
          },
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
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
    return Container(
      height: MediaQuery.of(context).size.height/1.5,
      // padding: EdgeInsets.only(bottom:50.0,top:0.0,left:0.0,right:0.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
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
            padding: EdgeInsets.only(left:10,bottom: 10),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Daftar Layanan ${widget.val['title']}'.toUpperCase(),fontSize:14,color: Constant().mainColor,img: widget.val['logo']),
          ),
          Expanded(
              flex: 18,
              child: ListView.separated(
                padding: EdgeInsets.all(10.0),
                addRepaintBoundaries: true,
                primary: false,
                shrinkWrap: true,
                itemCount: widget.productPpobPraModel.result.data.length,
                itemBuilder: (context,index){
                  var val=widget.productPpobPraModel.result.data[index];
                  return FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: (){
                      setState(() {
                        idx=index;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetHelper().textQ(val.note,12,Constant().darkMode,FontWeight.bold),
                        Icon(AntDesign.checkcircleo,color: idx==index?Colors.grey:Colors.transparent)
                      ],
                    ),
                  );
                },
                separatorBuilder: (_,i){return(Divider());},
              )
          ),
          Expanded(
            flex:2,
            child:Padding(
              padding: EdgeInsets.only(left:0,right:0),
              child: FlatButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),

                  padding: EdgeInsets.all(15.0),
                  color: Constant().mainColor,
                  onPressed: (){
                    var val = widget.productPpobPraModel.result.data[idx].toJson();
                    WidgetHelper().myModal(context,ModalDetailPrabayar(val:val..addAll({"nohp":widget.val['nohp'],"page":widget.val['title']})));

                    // handleSubmit();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(AntDesign.checkcircleo,color: Colors.white),
                      SizedBox(width: 10.0),
                      WidgetHelper().textQ("LANJUT", 14,Colors.white,FontWeight.bold)
                    ],
                  )
              ),
            )
          )

        ],
      ),
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
      var res=await BaseProvider().postProvider("transaction/prabayar/checkout", data);
      Navigator.pop(context);
      if(res is General){

        General result=res;
        if(result.msg=='PIN anda tidak sesuai.'){

        }else{
          Navigator.pop(context);
        }
        WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
      }
      else{
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        });
      }
    }));
  }
  @override
  Widget build(BuildContext context) {
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
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Konfirmasi Pembayaran',color: Constant().mainColor),
          ),
          desc(context,"Jenis Layanan",widget.val['provider']),
          Divider(),
          if(widget.val['page']=='PULSA ALL OPERATOR')desc(context,"Nominal","Rp ${widget.val['note'].split(" ")[1]} .-",color: Constant().moneyColor),
          if(widget.val['page']=='PULSA ALL OPERATOR')Divider(),
          desc(context,"Nomor",widget.val['nohp']),
          Divider(),
          desc(context,"Harga","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),
          Divider(),
          // if(widget.val['page']!='PULSA ALL OPERATOR')desc(context,"Keterangan",''),
          // if(widget.val['page']!='PULSA ALL OPERATOR')desc(context,widget.val['note'],'',colorttl: Colors.black),
          // if(widget.val['page']!='PULSA ALL OPERATOR')Divider(),
          Padding(
            padding: EdgeInsets.only(left:10,bottom: 10),
            child: WidgetHelper().titleNoButton(context, AntDesign.infocirlceo, 'Ringkasan Pembayaran',color: Constant().mainColor),
          ),
          desc(context,"Metode Pembayaran",'Saldo',color: Colors.black),
          // Divider(),
          // desc(context,"Subtotal","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),
          Divider(color: Colors.grey),
          desc(context,"Total Tagihan","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),
          SizedBox(height:30.0),
          Padding(
            padding: EdgeInsets.only(left:0,right:0),
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

