import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/address/address_model.dart' as Prefix1;
import 'package:sangkuy/model/member/address/address_model.dart' as Prefix2;
import 'package:sangkuy/model/mlm/bank_model.dart';
import 'package:sangkuy/model/mlm/cart_model.dart';
import 'package:sangkuy/model/mlm/kurir_model.dart';
import 'package:sangkuy/model/mlm/ongkir_model.dart';
import 'package:sangkuy/provider/address_provider.dart';
import 'package:sangkuy/provider/bank_provider.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/cart_provider.dart';
import 'package:sangkuy/view/screen/profile/address/address_screen.dart';
import 'package:sangkuy/view/widget/card_widget.dart';

class ChaeckoutScreen extends StatefulWidget {
  @override
  _ChaeckoutScreenState createState() => _ChaeckoutScreenState();
}

class _ChaeckoutScreenState extends State<ChaeckoutScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool  isLoadingBank=false,isLoadingCart=false,isLoadingKurir=false,isLoadingAddress=false,isError=true,isSelectedKurir=false,isPostLoading=false;
  int idxKurir=0,idxLayanan=0;
  String kurirTitle='';
  String kurirDeskripsi='',service='';
  int grandTotal=0,subTotal=0,cost=0;
  int idxAddress=0;
  int isMainAddress=0;
  String title='',penerima='',noHp='',mainAddress='';
  String idBank='';
  KurirModel kurirModel;
  CartModel cartModel;
  OngkirModel ongkirModel;
  Prefix1.AddressModel addressModel;
  BankModel bankModel;
  List bank=[];
  Future loadBank()async{
    var res=await BankProvider().getBank("page=1");
    if(res=='error'){
      isLoadingBank=false;
      isError=true;
      setState(() {});
    }
    else if(res=='failed'){
      isLoadingBank=false;
      isError=true;
      setState(() {});
    }
    else{
      isLoadingBank=false;
      isError=false;
      bank.add({
        "totalrecords": "2",
        "id": "",
        "bank_name": "SALDO UTAMA",
        "logo": "http://ptnetindo.com:6694/images/bank/BCA.png",
        "acc_name": "100000",
        "acc_no": "",
        "tf_code": 0,
        "created_at": "2020-12-22T03:50:55.000Z",
        "updated_at": "2020-12-22T03:50:55.000Z"
      });
      res['result']['data'].forEach((element) {
        bank.add(element);
      });
      setState(() {});
    }
  }
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
      getSubtotal();
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
  Future loadAddress()async{
    var res = await AddressProvider().getAddress(1);
    if(res=='error'){
      setState(() {
        isError=true;
        isLoadingAddress=false;
      });
    }
    else if(res=='failed'){
      setState(() {
        isError=true;
        isLoadingAddress=false;

      });
      WidgetHelper().showFloatingFlushbar(context,"failed",'gagal mengambil data');
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoadingAddress=false;
      });
      WidgetHelper().notifOneBtnDialog(context,"Terjadi Kesalahan","Sesi anda sudah habis, silahkan login ulang.",()async{
        await FunctionHelper().logout(context);
      },titleBtn1: "Login");
    }
    else{
      addressModel = res;
      isError=false;
      isLoadingAddress=false;
      title = addressModel.result.data[0].title;
      penerima = addressModel.result.data[0].penerima;
      noHp = addressModel.result.data[0].noHp;
      mainAddress = addressModel.result.data[0].mainAddress;
      isMainAddress = addressModel.result.data[0].ismain;
      setState(() {});
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
  void selectedLayanan(idx){
    setState(() {
      service = ongkirModel.result.ongkir[idx].service;
      kurirDeskripsi = "${ongkirModel.result.ongkir[idx].service} | ${FunctionHelper().formatter.format(ongkirModel.result.ongkir[idx].cost)} | ${ongkirModel.result.ongkir[idx].estimasi}";
      cost = ongkirModel.result.ongkir[idx].cost;
    });
    getGrandTotal();
    Navigator.pop(context);
  }
  void getGrandTotal(){
    int st = 0;
    for(var i=0;i<cartModel.result.length;i++){
      st = st+int.parse(cartModel.result[i].harga)*cartModel.result[i].qty;
    }
    grandTotal = st+cost;
  }
  void getSubtotal(){
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
    isLoadingBank=true;
    isLoadingAddress=true;
    isLoadingCart=true;
    isLoadingKurir=true;
    loadBank();
    loadKurir();
    loadCart();
    loadAddress();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar:WidgetHelper().appBarWithButton(context,"Checkout",(){Navigator.pop(context);},<Widget>[]),
      body:  isLoadingBank||isLoadingKurir||isLoadingCart||isLoadingAddress?WidgetHelper().loadingWidget(context):RefreshWidget(
        widget: ListView(
          padding: EdgeInsets.only(bottom: 10.0),
          children: [
            address(),
            expedisi(),
            produk(),
            metode(context),
          ],
        ),
        callback: (){
          setState(() {
            isLoadingCart=true;
          });
          loadCart();
        },
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
                      Icon(AntDesign.home,size: 30,color:Constant().mainColor),
                      SizedBox(width:5.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetHelper().textQ("Alamat Pengiriman",12,Constant().mainColor, FontWeight.bold),
                          WidgetHelper().textQ("$title",12,Constant().darkMode, FontWeight.bold),
                        ],
                      )
                    ],
                  ),
                  WidgetHelper().myPress((){
                    WidgetHelper().myModal(context, Container(
                      height: MediaQuery.of(context).size.height/1.2,
                      child: AddressScreen(idx: idxAddress,callback: (val,idx){
                        Prefix2.Datum datum;
                        datum = val;
                        title = datum.title;
                        penerima = datum.penerima;
                        noHp = datum.noHp;
                        mainAddress = datum.mainAddress;
                        isMainAddress = datum.ismain;
                        idxAddress=idx;
                        Navigator.of(context).pop();
                        setState(() {});
                      },),
                    ));
                  }, Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Constant().secondColor,
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
                  WidgetHelper().textQ("$penerima ( $noHp )",10,Colors.black87, FontWeight.normal),
                  SizedBox(height:5.0),
                  WidgetHelper().textQ("$mainAddress",10,Colors.black87, FontWeight.normal),
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
          Row(
            children: [
              Icon(AntDesign.car,size: 30,color:Constant().mainColor),
              SizedBox(width:5.0),
              WidgetHelper().textQ("Jasa Pengiriman",12,Constant().mainColor, FontWeight.bold),
            ],
          ),
          Divider(),
          CardWidget(
            onTap:(){
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
            } ,
            prefixBadge: Constant().secondColor,
            title: 'Pilih Kurir',
            description: '$kurirTitle',
            descriptionColor: Constant().darkMode,
            suffixIcon: Icons.arrow_right,
            backgroundColor: Theme.of(context).focusColor.withOpacity(0.0)

          ),
          SizedBox(height: 5.0),
          CardWidget(
            onTap:(){
              if(kurirTitle!=''){
                WidgetHelper().myModal(
                    context,
                    ModalLayanan(
                      ongkirModel: ongkirModel,
                      callback: (idx){
                        setState(() {
                          idxLayanan = idx;
                        });
                        selectedLayanan(idx);
                      },
                      index: idxLayanan,
                    )
                );
              }
            } ,
            prefixBadge: Constant().secondColor,
            title: 'Pilih Layanan',
            description: '$kurirDeskripsi',
            descriptionColor: Constant().darkMode,
            suffixIcon: Icons.arrow_right,
            backgroundColor: Colors.transparent,

          ),

        ],
      ),
    );
  }
  Widget produk(){
    return ClipPath(
      clipper: WaveClipperOne(flip: true),
      child: Container(
        padding: EdgeInsets.only(bottom:50.0,top:10.0,left:10.0,right:15.0),
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
                      Icon(AntDesign.shoppingcart,size: 30,color:Constant().mainColor),
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
                    child:WidgetHelper().textQ("${cartModel.result.length}",10,Constant().secondDarkColor, FontWeight.bold),
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
                itemCount: cartModel.result.length,
                itemBuilder: (context,index){
                  print(cartModel.result[index]);
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
                                  Row(
                                    children: [
                                      CachedNetworkImage(
                                        height: 50,
                                        imageUrl: cartModel.result[index].foto,
                                        fit:BoxFit.fill,
                                        placeholder: (context, url) => Image.network(Constant().noImage, fit:BoxFit.fill,width: 50),
                                        errorWidget: (context, url, error) => Image.network(Constant().noImage, fit:BoxFit.fill,width:50),
                                      ),
                                      SizedBox(width: 10.0),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          WidgetHelper().textQ("${cartModel.result[index].title}",12,Constant().darkMode,FontWeight.normal),
                                          WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(int.parse("${cartModel.result[index].harga}"))} .-",12,Constant().moneyColor,FontWeight.normal),
                                        ],
                                      ),
                                    ],

                                  ),

                                ],
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      WidgetHelper().textQ("Rp ${FunctionHelper().formatter.format(cost)} .-",12,Constant().moneyColor, FontWeight.normal),
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
  Widget metode(BuildContext context){
    return Container(
      padding: EdgeInsets.only(left:15.0,right:15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(AntDesign.wallet,size: 30,color:Constant().mainColor),
              SizedBox(width:5.0),
              WidgetHelper().textQ("Metode Pembayaran",12,Constant().mainColor, FontWeight.bold),
            ],
          ),
          Divider(),
          Container(
            child: new ListView.separated(
              addRepaintBoundaries: true,
              primary: false,
              shrinkWrap: true,
              itemCount: bank.length,
              itemBuilder: (context,index){
                var val=bank[index];
                return CardWidget(
                  onTap:(){
                    setState(() {
                      idBank=val['id'];
                    });
                  },
                  prefixBadge: Constant().secondColor,
                  title: '${val['bank_name']} ${val['id']==''?'':'( ${val['acc_no']} )'}',
                  description: '${val['id']==''?'Rp '+FunctionHelper().formatter.format(int.parse(val['acc_name']))+' .-':val['acc_name']}',
                  descriptionColor: val['id']==''?Constant().moneyColor:Constant().darkMode,
                  suffixIcon:AntDesign.checkcircleo,
                  suffixIconColor: idBank==val['id']?Colors.black:Colors.transparent,
                  backgroundColor: Colors.transparent,
                );
              },
              separatorBuilder: (_,i){return(Divider());},
            ),
          ),
        ],
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




class ModalLayanan extends StatefulWidget {
  ModalLayanan({
    Key key,
    @required this.ongkirModel,
    @required this.callback,
    @required this.index,
  }) : super(key: key);

  final OngkirModel ongkirModel;
  Function(int idx) callback;
  final int index;
  @override
  _ModalLayananState createState() => _ModalLayananState();
}

class _ModalLayananState extends State<ModalLayanan> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var height=MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      height: widget.ongkirModel.result.ongkir.length>3?height/2.5:height/3.0,
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
                  itemCount: widget.ongkirModel.result.ongkir.length,
                  itemBuilder: (context,index){
                    return InkWell(
                        onTap: (){
                          widget.callback(index);
                        },
                        child: ListTile(
                            contentPadding: EdgeInsets.only(left:10,right:10,top:0,bottom:0),
                            title: WidgetHelper().textQ("${widget.ongkirModel.result.ongkir[index].service} | ${widget.ongkirModel.result.ongkir[index].cost} | ${widget.ongkirModel.result.ongkir[index].estimasi}", 12,Colors.black, FontWeight.bold),
                            trailing: widget.index==index?Icon(AntDesign.checkcircleo,color:Constant().darkMode):Text('')
                        )
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

