import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/cart_model.dart';
import 'package:sangkuy/model/mlm/kurir_model.dart';
import 'package:sangkuy/model/mlm/ongkir_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/cart_provider.dart';

class ChaeckoutScreen extends StatefulWidget {
  @override
  _ChaeckoutScreenState createState() => _ChaeckoutScreenState();
}

class _ChaeckoutScreenState extends State<ChaeckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool  isLoadingCart=false,isLoadingKurir=false,isError=true,isSelectedKurir=false,isPostLoading=false;
  int idxKurir=0;
  String kurirTitle='';
  String kurirDeskripsi='',service='';
  int grandTotal=0,subTotal=0,cost=0;
  KurirModel kurirModel;
  CartModel cartModel;
  OngkirModel ongkirModel;
  Future loadCart()async{
    var res=await CartProvider().getCart();
    if(res=='error'){
      isLoadingCart=false;
      isError=true;
      setState(() {});
    }
    else if(res=='failed'){
      isLoadingCart=false;
      isError=true;
      setState(() {});
    }
    else{
      setState(() {
        isLoadingCart=false;
        isError=false;
        cartModel = res;
      });
    }
  }
  Future loadKurir()async{
    var res = await BaseProvider().getProvider(
        'transaction/kurir', kurirModelFromJson
    );
    if(res is KurirModel){
      kurirModel = KurirModel.fromJson(res.toJson());
      setState(() {
        isLoadingKurir=false;
      });
      selectedKurir(0,'-');
    }
  }
  Future selectedKurir(idx,param)async{
    setState(() {
      isSelectedKurir = true;
      kurirTitle = kurirModel.result[idx].kurir;
    });
    WidgetHelper().loadingDialog(context);
    await getOngkir( kurirModel.result[idx].kurir);
    if(param==''){
      Navigator.pop(context);
    }
  }
  Future getOngkir(kurir)async{
    var res = await BaseProvider().postProvider(
        'transaction/kurir/cek/ongkir',{
        "ke":"1470",
        "berat":"100",
        "kurir":"$kurir"
    }
    );
    print(res);
    if(res == 'TimeoutException'|| res=='SocketException'){
      WidgetHelper().notifDialog(context,"Terjadi Kesalahan Server","Mohon maaf server kami sedang dalam masalah", (){},(){});
    }
    else{
      Navigator.pop(context);
      setState(() {
        isPostLoading = false;
      });
      if(res is General){
        print('terjadi kesalahan');
      }
      else{
        var resLayanan = OngkirModel.fromJson(res);
        print(resLayanan.toJson());
        setState(() {
          ongkirModel = OngkirModel.fromJson(resLayanan.toJson());
          kurirDeskripsi = "${resLayanan.result.ongkir[0].service} | ${FunctionHelper().formatter.format(resLayanan.result.ongkir[0].cost)} | ${resLayanan.result.ongkir[0].estimasi}";
          service = ongkirModel.result.ongkir[0].service;
          cost = resLayanan.result.ongkir[0].cost;
        });
        getGrandTotal();
      }
    }
  }
  getGrandTotal(){
    int st = 0;
    for(var i=0;i<cartModel.result.length;i++){
      st = st+int.parse(cartModel.result[i].harga)*cartModel.result[i].qty;
    }
    grandTotal = st+cost;
  }
  getSubtotal(){
    int st = 0;
    int hrg = 0;
    for(var i=0;i<cartModel.result.length;i++){
      // hrg = hrg+
      st = st+int.parse(cartModel.result[i].harga)*cartModel.result[i].qty;
    }

    subTotal = st;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingCart=true;
    isLoadingKurir=true;
    loadKurir();
    loadCart();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:WidgetHelper().appBarWithButton(context,"Checkout",(){Navigator.pop(context);},<Widget>[]),
      body:  isLoadingKurir||isLoadingCart?WidgetHelper().loadingWidget(context):ListView(
        children: [
          address(),
          expedisi(),
          produk(),
        ],
      ),
      bottomNavigationBar:Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          color: Constant().moneyColor,
          child: FlatButton(
              onPressed: () {

              },
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
              color: Constant().moneyColor,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(grandTotal)} .-", 14, Constant().secondDarkColor, FontWeight.normal),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                    decoration: BoxDecoration(
                        color: Constant().secondColor
                    ),
                    child: Row(
                      children: [
                        Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                        SizedBox(width:10.0),
                        WidgetHelper().textQ("Bayar", 14, Constant().secondDarkColor, FontWeight.normal),
                      ],
                    ),
                  )
                ],
              )
            // child:Text("abus")
          ),
        )

    );
  }


  Widget address(){
    return ClipPath(
      clipper: WaveClipperOne(flip: true),
      child: Container(
        padding: EdgeInsets.only(bottom:50.0,top:10.0,left:15.0,right:15.0),
        width: double.infinity,
        color: Theme.of(context).focusColor.withOpacity(0.1),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Entypo.location,size: 20,color:Constant().mainColor),
                      SizedBox(width:5.0),
                      WidgetHelper().textQ("Alamat Pengiriman",12,Constant().mainColor, FontWeight.bold),
                    ],
                  ),
                  WidgetHelper().myPress((){}, Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Constant().mainColor,
                        // border: Border.all(color: Constant().secondColor),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: WidgetHelper().textQ("Pilih alamat lain",10,Constant().secondDarkColor, FontWeight.bold)
                  ))
                ],
              ),
            ),
            Divider(color: Colors.black38),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color:Colors.grey[200]),
                        alignment: AlignmentDirectional.topEnd,
                        child: WidgetHelper().textQ("Utama",12, Theme.of(context).hintColor, FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(height:10.0),
                  WidgetHelper().textQ("Annashrul Yusuf ( +62812-2316-5037 )",10,Colors.black87, FontWeight.normal),
                  SizedBox(height:5.0),
                  WidgetHelper().textQ("jalan kebon manggu, 02, 04, Kelurahan Padasuka, Kecamatan Cimahi Tengah, Kota Cimahi ",10,Colors.black87, FontWeight.normal),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget expedisi(){
    return Container(
      padding: EdgeInsets.only(left:10.0,right:10.0,top:0.0,bottom: 10.0),
      child:Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey[200])
            ),
            child: InkWell(
              onTap: (){
                WidgetHelper().myModal(context, ModalKurir(
                    kurirModel: kurirModel,
                    callback: (idx){
                      setState(() {
                        idxKurir = idx;
                      });
                      selectedKurir(idx,'');
                    },
                    index: idxKurir
                ));
                // modalKurir(context);
              },
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                padding: EdgeInsets.only(left:10.0,right: 10.0,top:5,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("Pilih Kurir",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height: 5.0),
                        WidgetHelper().textQ('$kurirTitle',10,Constant().darkMode, FontWeight.normal)
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey[200])
            ),
            child: InkWell(
              onTap: (){

              },
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                padding: EdgeInsets.only(left:10.0,right: 10.0,top:5,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("Pilih Layanan",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height: 5.0),
                        WidgetHelper().textQ("kurirDeskripsi",10,Constant().darkMode, FontWeight.normal)
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: Colors.grey[200])
            ),
            child: InkWell(
              onTap: (){

              },
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Container(
                padding: EdgeInsets.only(left:10.0,right: 10.0,top:5,bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("Gunakan Voucher",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height: 5.0),
                        WidgetHelper().textQ("Sentuh dan masukan kode voucher yang kamu punya",10,Constant().darkMode, FontWeight.normal)
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios,size: 15,color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget produk(){
    return ClipPath(
      clipper: WaveClipperOne(flip: true),
      child: Container(
        padding: EdgeInsets.only(bottom:50.0,top:10.0,left:15.0,right:15.0),
        width: double.infinity,
        color: Theme.of(context).focusColor,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Entypo.list,size: 30,color:Constant().mainColor),
                      SizedBox(width:5.0),
                      WidgetHelper().textQ("Ringkasan Belanja",12,Constant().mainColor, FontWeight.bold),
                    ],
                  ),
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      color: Constant().mainColor,
                      shape: BoxShape.circle,
                    ),
                    child:WidgetHelper().textQ("4",10,Constant().secondDarkColor, FontWeight.bold),
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            Divider(),
            Container(
              child: new ListView.separated(
                addRepaintBoundaries: true,
                primary: false,
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context,index){
                  return WidgetHelper().myPress((){
                    // WidgetHelper().myPushAndLoad(context,DetailPackageScreen(id: idPaket,tipe:tipe), ()=>loadCart());
                  },
                      Container(
                        padding: EdgeInsets.all(0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    height: 50,
                                    imageUrl: Constant().noImage,
                                    fit:BoxFit.fill,
                                    placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: 50),
                                    errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width:50),
                                  ),
                                  SizedBox(width: 10.0),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      WidgetHelper().textQ("SangQu Produk",12,Constant().darkMode,FontWeight.normal),
                                      WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse("10000"))} .-",12,Constant().moneyColor,FontWeight.normal),
                                    ],
                                  )
                                ],
                              ),
                            ),


                          ],
                        ),
                      ),
                      color: Colors.black38
                  );
                },
                separatorBuilder: (_,i){return(Divider());},
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetHelper().textQ("Total Harga",10,Constant().darkMode, FontWeight.normal),
                      WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(subTotal)} .-",12,Constant().moneyColor, FontWeight.normal),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      WidgetHelper().textQ("Total Ongkos Kirim",10,Constant().darkMode, FontWeight.normal),
                      WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(1000000)} .-",12,Constant().moneyColor, FontWeight.normal),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ModalKurir extends StatefulWidget {
  ModalKurir({
    Key key,
    @required this.kurirModel,
    @required this.callback,
    @required this.index,
  }) : super(key: key);
  final KurirModel kurirModel;
  Function(int idx) callback;
  final int index;

  @override
  _ModalKurirState createState() => _ModalKurirState();
}

class _ModalKurirState extends State<ModalKurir> {
  int idx=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idx = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.2,
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
            padding: EdgeInsets.all(10),
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Constant().mainColor,
                  // border: Border.all(color:SiteConfig().accentDarkColor)
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,color: Colors.white),
                    SizedBox(width: 5),
                    WidgetHelper().textQ("Perkiraan tiba dihitung sejak pesanan dikirim",12,Colors.white, FontWeight.bold)
                  ],
                )
            ),
          ),
          Expanded(
            child: Scrollbar(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: widget.kurirModel.result.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      onTap: (){
                        setState(() {
                          idx =index;
                        });
                        widget.callback(index);
                      },
                      contentPadding: EdgeInsets.only(left:10,right:10,top:0,bottom:0),
                      leading: Container(
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          imageUrl: widget.kurirModel.result[index].gambar,
                          fit:BoxFit.scaleDown,
                          placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width:50),
                          errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width:50),
                        ),
                      ),
                      title: WidgetHelper().textQ("${widget.kurirModel.result[index].kurir}", 14,Constant().darkMode, FontWeight.bold),
                      subtitle: WidgetHelper().textQ("${widget.kurirModel.result[index].deskripsi}", 12, Constant().darkMode, FontWeight.bold),
                      trailing: widget.index==index?Icon(AntDesign.checkcircleo,color: Constant().darkMode):Text(
                          ''
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {return Divider(height: 1);},
                )
            ),
          )
        ],
      ),
    );
  }
}


