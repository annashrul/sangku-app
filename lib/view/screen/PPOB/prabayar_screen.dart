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
  CategoryPpobModel categoryPpobModel;
  ProductPpobPraModel productPpobPraModel;
  Future loadCategory()async{
    var res=await BaseProvider().getProvider('transaction/produk/operator?kategori=${widget.val['code']}',categoryPpobModelFromJson);
    if(res is CategoryPpobModel){
      CategoryPpobModel result=res;
      print(result.toJson());
      if(this.mounted){
        categoryPpobModel=result;
      }
    }
  }
  Future loadUser()async{
    print(widget.val);
    final no = await UserHelper().getDataUser("mobile_no");
    await loadProduct("$no");
    // await handleChange(no);
    setState(() {
      nohpController.text=no;
    });
  }
  Future loadProduct(nohp)async{
    var res=await BaseProvider().getProvider("transaction/produk/list?nohp=$nohp&kategori=${widget.val['code']}",productPpobPraModelFromJson);
    if(res is ProductPpobPraModel){
      ProductPpobPraModel result=res;
      if(this.mounted){
        setState(() {
          productPpobPraModel=result;
          isLoadingProduct=false;
          isNodata=false;
        });
      }
    }else if(res==Constant().errNoData){
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
    print(no);
    if(no.length>=3){
      categoryPpobModel.result.data.forEach((element) {
        if(element.prefix!=null){
          List pref=element.prefix.split(",");
          pref.forEach((val) {
            if(prefix3==val||prefix4==val){
              print("=============================== PREFIX ================================");
              print(val);
              print("=============================== PREFIX ================================");
              setState(() {
                isNodata=false;
                provider = {"code":val,"value":element.title,"label":element.title,"icon":element.logo};
              });
            }
          });
        }
      });
      if(provider!=null&&no.length>=3&&no.length<=4){
        print('bus');
        setState(() {
          isLoadingProduct=true;
        });
        loadProduct(no);
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
    await loadUser();
    await loadCategory();
    await handleChange(nohpController.text);
    setState(() {
      isLoading=false;
    });
  }
  @override
  void dispose() {
    super.dispose();

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    provider=null;
    print(widget.val);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: WidgetHelper().appBarWithButton(context,widget.val['title'],(){Navigator.pop(context);},<Widget>[]),
        body: isLoading?WidgetHelper().loadingWidget(context):ListView(
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
                  style: TextStyle(letterSpacing:2.0,fontSize:14,fontWeight: FontWeight.normal,fontFamily: Constant().fontStyle,color:Constant().darkMode),
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
                        idx=index;
                      });
                      WidgetHelper().myModal(context,ModalDetailPrabayar(val:val.toJson()..addAll({"nohp":nohpController.text,"page":widget.val['title']})));
                    },
                    child: Column(
                      children: [
                        WidgetHelper().textQ('Rp ${FunctionHelper().formatter.format(int.parse(val.price))} .-',12,Constant().moneyColor, FontWeight.bold,textAlign: TextAlign.center,maxLines: 1),
                        SizedBox(height:5.0),
                        WidgetHelper().textQ(val.note,10,idx==index?Constant().secondDarkColor:Constant().darkMode, FontWeight.normal,textAlign: TextAlign.center,maxLines: 10),
                      ],
                    )
                );
              },
              staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0,
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
        WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
      }
      else{
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        });
      }
      print(data);
    }));
  }
  @override
  Widget build(BuildContext context) {
    print(widget.val);
    return ClipPath(
      clipper: WaveClipperOne(flip: true),
      child: Container(
        padding: EdgeInsets.only(bottom:50.0,top:0.0,left:0.0,right:0.0),
        decoration: BoxDecoration(
            color: Constant().secondColor,
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
            ListTile(
                contentPadding: EdgeInsets.only(left:10),
                leading:Icon(Icons.info_outline,color:Constant().mainColor),
              title:WidgetHelper().textQ("Konfirmasi Transaksi",12,Constant().mainColor, FontWeight.bold)
            ),
            desc(context,"Jenis Layanan",widget.val['provider']),
            Divider(),
            desc(context,"Nomor",widget.val['nohp']),
            Divider(),
            desc(context,"Harga","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),
            Divider(),
            if(widget.val['page']=='PULSA ALL OPERATOR')desc(context,"Nominal","Rp ${FunctionHelper().formatter.format(int.parse('${widget.val['note'].split(" ")[1]}'.replaceAll(".","")))} .-",color: Constant().moneyColor),
            if(widget.val['page']=='PULSA ALL OPERATOR')Divider(),
            desc(context,"Keterangan",''),
            desc(context,widget.val['note'],'',colorttl: Colors.white),
            Divider(),
            ListTile(
              contentPadding: EdgeInsets.only(left:10),
                leading:Icon(Icons.info_outline,color:Constant().mainColor),
                title:WidgetHelper().textQ("Ringkasan Pembayaran",12,Constant().mainColor, FontWeight.bold)
            ),
            desc(context,"Metode Pembayaran",widget.val['saldo']),
            Divider(),
            desc(context,"Subtotal","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),
            Divider(color: Colors.grey),
            desc(context,"Total Tagihan","Rp ${FunctionHelper().formatter.format(int.parse(widget.val['price']))} .-",color: Constant().moneyColor),
            SizedBox(height:20.0),
            FlatButton(
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
            )

          ],
        ),
      ),
    );
  }
  Widget desc(BuildContext context,title,desc,{Color color=Colors.white,Color colorttl=Colors.grey}){
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

