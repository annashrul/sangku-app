import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/main.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/address/address_model.dart';
import 'package:sangkuy/model/member/address/detail_address_model.dart';
import 'package:sangkuy/model/member/address/kecamatan_model.dart';
import 'package:sangkuy/model/member/address/kota_model.dart';
import 'package:sangkuy/model/member/address/provinsi_model.dart';
import 'package:sangkuy/provider/address_provider.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AddressScreen extends StatefulWidget {
  final String title;
  int idx;
  final Function(dynamic val,int idx) callback;
  AddressScreen({this.title,this.idx,this.callback});
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> with SingleTickerProviderStateMixin,AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  ScrollController controller;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  AddressModel listAddressModel;
  bool isLoading=false,isLoadmore=false,isError=false,isErrToken=false,isNodata=false;
  int total=0,perpage=10;
  DatabaseConfig db = DatabaseConfig();

  Future loadData()async{
    var res = await AddressProvider().getAddress(perpage);
    if(res=='error'){
      setState(() {
        isError=true;
        isLoading=false;
        isLoadmore=false;
        isNodata=false;
      });
    }
    else if(res=='failed'){
      setState(() {
        isError=true;
        isLoading=false;
        isLoadmore=false;
        isNodata=false;
      });
      WidgetHelper().showFloatingFlushbar(context,"failed",'gagal mengambil data');
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isError=false;
        isLoading=false;
        isLoadmore=false;
        isErrToken=true;
        isNodata=false;
      });
      WidgetHelper().notifOneBtnDialog(context,"Terjadi Kesalahan","Sesi anda sudah habis, silahkan login ulang.",()async{
        await FunctionHelper().logout(context);
      },titleBtn1: "Login");
    }
    else if(res==Constant().errNoData){
      isLoading=false;
      isError=false;
      isErrToken=false;
      isNodata=true;
      total=0;
      setState(() {});
    }
    else if(res is General){
      isLoading=false;
      isError=false;
      isErrToken=false;
      isNodata=true;
      total=0;
      setState(() {});
    }
    else{
      if (this.mounted) {
        setState(() {
          listAddressModel = res;
          isError = false;
          isLoading = false;
          isNodata=false;
          total = listAddressModel.result.total;
        });
      }
    }
  }
  Future deleteAddress(id)async{
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().deleteProvider("alamat/$id", generalFromJson);
    if(res==Constant().errTimeout||res==Constant().errSocket){
      Navigator.pop(context);
      WidgetHelper().showFloatingFlushbar(context,"failed","terjadi kesalahan koneksi");
    }
    else{
      Navigator.pop(context);
      WidgetHelper().showFloatingFlushbar(context,"success","data berhasil dihapus");
      loadData();
    }
  }
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print('fetch data');
        if(perpage<total){
          setState((){
            perpage = perpage+perpage;
            isLoadmore=true;
          });
          loadData();
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.mounted) { // check whether the state object is in tree
        isLoading=true;
        controller = new ScrollController()..addListener(_scrollListener);
        loadData();
        print(widget.idx);
    }

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
    super.build(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,widget.title==null?"Daftar Alamat":widget.title,(){Navigator.pop(context);},<Widget>[
        IconButton(icon: Icon(AntDesign.pluscircleo), onPressed: (){
          WidgetHelper().myModal(context, ModalForm(total:total,id:"",callback:(String par){
            if(par=='berhasil'){
              loadData();
              WidgetHelper().showFloatingFlushbar(context,"success","data berhasil dikirim");
            }
            else{
              WidgetHelper().showFloatingFlushbar(context,"success","terjadi kesalahan koneksi");
            }
          },));
        })
      ],brightness: Brightness.light),
      body: isLoading?AddressLoading():isError?ErrWidget(callback: (){loadData();}):isErrToken?Text(''):!isNodata?RefreshWidget(
        widget: Column(
          children: [
            Expanded(
                flex:16,
                child: buildContent()
            ),
            isLoadmore?Expanded(flex:4,child: AddressLoading()):Text('')
          ],
        ),
        callback: (){
          setState(() {
            isLoading=true;
          });
          loadData();
        },
      ):WidgetHelper().noDataWidget(context),
    );
  }
  Widget buildContent(){
    return ListView.separated(
        itemBuilder: (context,index){
          final val=listAddressModel.result.data[index];
          return FlatButton(
              onPressed: (){
                if(widget.idx!=null){
                  setState(() {
                    widget.idx=index;
                  });
                  print(widget.idx);
                  widget.callback(val,index);
                }
              },
              padding:EdgeInsets.only(bottom:10.0,top:10.0,left:15.0,right:15.0),
              color:  widget.idx==index?Color(0xFFEEEEEE):Colors.transparent,
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
                            Icon(Entypo.location,size: 20,color:Constant().darkMode),
                            SizedBox(width:5.0),
                            WidgetHelper().textQ(val.title,12,Constant().darkMode, FontWeight.bold),
                          ],
                        ),
                        InkWell(
                          onTap: (){
                            WidgetHelper().notifDialog(context, "Perhatian !!","anda yakin akan menghapus data ini ??", (){Navigator.pop(context);},()async{
                              Navigator.pop(context);
                              await deleteAddress(val.id);
                            });
                          },
                          child:Icon(AntDesign.delete,color:Constant().moneyColor),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height:5.0),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("${val.penerima} ( ${val.noHp} )",12,Constant().darkMode, FontWeight.bold),
                        SizedBox(height:5.0),
                        WidgetHelper().textQ("${val.mainAddress}",12,Constant().darkMode, FontWeight.bold),
                      ],
                    ),
                  ),
                  SizedBox(height:10),
                  InkWell(
                    onTap: (){
                      WidgetHelper().myModal(context, ModalForm(total:listAddressModel.result.data.length,id:"${val.id}",callback:(String par){
                        if(par=='berhasil'){
                          loadData();
                          WidgetHelper().showFloatingFlushbar(context,"success","data berhasil disimpan");
                        }
                        else{
                          WidgetHelper().showFloatingFlushbar(context,"failed","terjadi kesalahan koneksi");
                        }
                      },));
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(color: Constant().mainColor),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      child: WidgetHelper().textQ("Ubah Alamat",14,Constant().mainColor,FontWeight.bold,textAlign: TextAlign.center),
                    ),
                  )
                ],
              )
          );
        },
        separatorBuilder: (context,index){
          return Divider(thickness: 5);
        },
        itemCount: listAddressModel.result.data.length
    );
  }
}

class ModalForm extends StatefulWidget {
  final int total;
  String id;
  Function(String param) callback;
  ModalForm({this.total,this.id,this.callback});
  @override
  _ModalFormState createState() => _ModalFormState();
}

class _ModalFormState extends State<ModalForm> {
  var titleController = TextEditingController();
  final FocusNode titleFocus = FocusNode();
  var receiverController = TextEditingController();
  final FocusNode receiverFocus = FocusNode();
  var mainAddressController = TextEditingController();
  final FocusNode mainAddressFocus = FocusNode();
  var telpController = TextEditingController();
  final FocusNode telpFocus = FocusNode();
  var provController = TextEditingController();
  final FocusNode provFocus = FocusNode();
  var kotaController = TextEditingController();
  final FocusNode kotaFocus = FocusNode();
  var kecController = TextEditingController();
  final FocusNode kecFocus = FocusNode();
  var detailAddressController = TextEditingController();
  bool isLoading=false,isError=false,isErrorProv=false,isErrorCity=false,isErrorDistrcit=false;
  String prov='',provName='';int idxProv=0;
  String city='',cityName='';int idxCity=0;
  String district='',districtName='';int idxDistrict=0;
  List expAddress=[];
  String hintMainAddress = "nama jalan, rt,rw,keluarahan,kode pos";
  Future<bool> validate()async{
    if(titleController.text==''){
      titleFocus.requestFocus();
      return false;
    }
    else if(receiverController.text==''){
      receiverFocus.requestFocus();
      return false;
    }
    else if(telpController.text==''){
      telpFocus.requestFocus();
      return false;
    }
    else if(prov==''){
      setState(() {isErrorProv=true;});
      Timer(Duration(seconds:1), (){
        setState(() {isErrorProv=false;});
      });
      return false;
    }
    else if(city==''){
      setState(() {isErrorCity=true;});
      Timer(Duration(seconds:1), (){
        setState(() {isErrorCity=false;});
      });
      return false;
    }
    else if(district==''){
      setState(() {isErrorDistrcit=true;});
      Timer(Duration(seconds:1), (){
        setState(() {isErrorDistrcit=false;});
      });
      return false;
    }
    else if(mainAddressController.text==''){
      mainAddressFocus.requestFocus();
      return false;
    }

    else{
      return true;
    }
  }
  Future storeAddress()async{
    var valid = await validate();
    if(valid==true){
      WidgetHelper().loadingDialog(context);
      final data={
        "title":"${titleController.text}",
        "penerima":"${receiverController.text}",
        "main_address":"${mainAddressController.text}",
        "kd_prov":"$prov",
        "kd_kota":"$city",
        "kd_kec":"$district",
        "no_hp":"${telpController.text}",
        "ismain":widget.total>0?'0':'1'
      };
      var res;
      if(widget.id!=''){
        res = await BaseProvider().putProvider("alamat/${widget.id}", data,context: context);
      }
      else{
        res = await BaseProvider().postProvider("alamat",data,context: context,callback: (){Navigator.pop(context);});
      }
      if(res!=null){
        Navigator.pop(context);
        Navigator.pop(context);
        widget.callback('berhasil');
      }
    }
  }

  DetailAddressModel detailAddressModel;
  Future getDetail()async{
    var res = await BaseProvider().getProvider("alamat/${widget.id}", detailAddressModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      setState(() {
        isLoading=false;
        isError=true;
      });
    }
    else{
      if(res is DetailAddressModel){
        DetailAddressModel result=res;
        List mainAdd=result.result.mainAddress.split(",");
        detailAddressModel = DetailAddressModel.fromJson(result.toJson());
        isLoading=false;
        isError=false;
        titleController.text = result.result.title;
        receiverController.text = result.result.penerima;
        telpController.text=result.result.noHp;
        prov=result.result.kdProv;
        city=result.result.kdKota;
        district=result.result.kdKec;
        // if(mainAdd.length>3){
        //
        // }
        provController.text = mainAdd[mainAdd.length-1];
        kotaController.text = mainAdd[mainAdd.length-2];
        kecController.text=mainAdd[mainAdd.length-3];
        expAddress = mainAddressController.text.split(",");
        mainAddressController.text =result.result.mainAddress;

        // print("########################## ${mainAdd.split(",").length}");
        // if(mainAdd.split(",").length>3){
        //   namaJalan=mainAdd.split(",")[0];
        //   rt=mainAdd.split(",")[1];
        //   rw=mainAdd.split(",")[2];
        //   keluarahan=mainAdd.split(",")[3];
        //   kecController.text=result.result.kdKec;
        //   kotaController.text=mainAdd.split(",")[5].toLowerCase();
        //   provController.text=mainAdd.split(",")[6].toLowerCase();
        //   // kodePos=mainAdd.split(",")[7];
        //   mainAddressController.text =result.result.mainAddress;
        // }


        // city=result.result.kdKota;
        // district=result.result.kdKec;

        setState(() {});
      }
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.id!=''){
      isLoading=true;
      getDetail();
    }
  }
  String namaJalan="",rt='',rw='',keluarahan='',kodePos='';

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    List findProv = mainAddressController.text.split(",");
    return Container(
      height: scaler.getHeight(90),
      child: WidgetHelper().wrapperModal(context,"${widget.id==''?'Tambah':'Ubah'} Alamat", isLoading?WidgetHelper().loadingWidget(context):ListView(
        children: [
          Container(
              padding:scaler.getPadding(0,2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetHelper().myForm(
                      context,
                      "Simpan Alamat Sebagai (Contoh:Alamat rumah, Alamat kantor, Alamat pacar)",
                      titleController,
                      focusNode: titleFocus,
                      onSubmit: (e){WidgetHelper().fieldFocusChange(context, titleFocus,receiverFocus);}
                  ),
                  SizedBox(height:scaler.getHeight(0.5)),
                  WidgetHelper().myForm(
                      context,
                      "Penerima",
                      receiverController,
                      focusNode: receiverFocus,
                      onSubmit: (e){WidgetHelper().fieldFocusChange(context, receiverFocus,telpFocus);}
                  ),
                  SizedBox(height:scaler.getHeight(0.5)),
                  WidgetHelper().myForm(
                    context,
                    "No.Telepon",
                    telpController,
                    focusNode: telpFocus,
                    textInputType:TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                  SizedBox(height:scaler.getHeight(0.5)),
                  WidgetHelper().animShakeWidget(context,WidgetHelper().myForm(
                      context,
                      "Provinsi",
                      provController,
                      focusNode: provFocus,
                      onTap:(){
                        FocusScope.of(context).unfocus();
                        WidgetHelper().myModal(context,ModalProvinsi(
                          callback:(id,name,idx){
                            findProv[findProv.length-1] = name;
                            mainAddressController.text = findProv.join(",");
                            prov=id;
                            provName=name;
                            idxProv=idx;
                            kotaController.text='';kecController.text='';provController.text=name;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          id: prov,idx: idxProv,
                        ));
                      },
                      isRead: true
                  ),enable: isErrorProv),
                  SizedBox(height:scaler.getHeight(0.5)),
                  WidgetHelper().animShakeWidget(context,WidgetHelper().myForm(
                      context,
                      "Kota",
                      kotaController,
                      focusNode: kotaFocus,
                      onTap:(){
                        print(prov);
                        if(provController.text!=''){
                          WidgetHelper().myModal(context,ModalCity(
                            callback:(id,name,idx){
                              findProv[findProv.length-2] = name;
                              mainAddressController.text = findProv.join(",");
                              city=id;cityName=name;idxCity=idx;kecController.text='';kotaController.text=name;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            id:city,idProv: prov,idx: idxCity,
                          ));
                        }
                        else{
                          setState(() {isErrorProv=true;});
                          Timer(Duration(seconds:1), (){
                            setState(() {isErrorProv=false;});
                          });
                        }
                      },
                      isRead: true
                  ),enable: isErrorCity),
                  SizedBox(height:scaler.getHeight(0.5)),
                  WidgetHelper().myForm(
                      context,
                      "Kecamatan",
                      kecController,
                      focusNode: kecFocus,
                      onTap:(){
                        if(provController.text!=''&&kotaController.text!=''){
                          WidgetHelper().myModal(context,ModalDisctrict(
                            callback:(id,name,idx){
                              findProv[findProv.length-3] = name;
                              mainAddressController.text = findProv.join(",");
                              district=id;districtName=name;idxDistrict=idx;kecController.text=name;
                              setState(() {});
                              Navigator.pop(context);
                            },
                            id:district,idCity: city,idx: idxDistrict,
                          ));
                        }
                        else{
                          if(provController.text==''){
                            setState(() {isErrorProv=true;});
                            Timer(Duration(seconds:1), (){
                              setState(() {isErrorProv=false;});
                            });
                          }
                          else{
                            setState(() {isErrorCity=true;});
                            Timer(Duration(seconds:1), (){
                              setState(() {isErrorCity=false;});
                            });
                          }
                        }
                      },
                      isRead: true
                  ),
                  SizedBox(height:scaler.getHeight(0.5)),
                  WidgetHelper().myForm(
                      context,
                      "Detail Alamat (format penulisan : nama jalan,rt,rw,kelurahan,kode pos)",
                      mainAddressController,
                      focusNode: mainAddressFocus,
                      onChange: (_){setState(() {});},
                      maxLine: 5
                  ),
                  SizedBox(height:scaler.getHeight(0.5)),
                  WidgetHelper().textQ("Alamat ini digunakan untuk pengiriman",scaler.getTextSize(9),Constant().darkMode, FontWeight.normal),
                  SizedBox(height:5.0),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0)
                        ),
                      ),
                      padding:scaler.getPadding(0.5,2),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.id!=''?WidgetHelper().textQ(""
                              "${mainAddressController.text!=''?"${mainAddressController.text},":''}",
                              // "${kecController.text!=''?"${kecController.text}, ":''}"
                              // "${kotaController.text!=''?"${kotaController.text}, ":''}"
                              // "${provController.text!=''?"${provController.text}":''}",
                              scaler.getTextSize(9),Constant().darkMode,FontWeight.bold,maxLines: 5
                          ):WidgetHelper().textQ(""
                              "${mainAddressController.text!=''?"${mainAddressController.text},":''}",
                              // "${kecController.text!=''?"${kecController.text}, ":''}"
                              // "${kotaController.text!=''?"${kotaController.text}, ":''}"
                              // "${provController.text!=''?"${provController.text}":''}",
                              scaler.getTextSize(9),Constant().darkMode,FontWeight.bold,maxLines: 5
                          ),

                        ],
                      )

                  ),
                ],
              )
          ),
        ],
      ),isCallack: true,callack: (){
        storeAddress();
      }),
    );
  }

}

class ModalProvinsi extends StatefulWidget {
  ModalProvinsi({
    Key key,
    @required this.callback,
    @required this.id,
    @required this.idx,
  }) : super(key: key);
  Function(String id,String name,int idx) callback;
  final String id;
  int idx;
  @override
  _ModalProvinsiState createState() => _ModalProvinsiState();
}

class _ModalProvinsiState extends State<ModalProvinsi> {
  ProvinsiModel provinsiModel;
  bool isLoadingProv=false;
  ItemScrollController _scrollController = ItemScrollController();
  ItemPositionsListener itemPositionListener = ItemPositionsListener.create();
  int idx=0;
  String id='';
  Future getProv()async{
    var res = await BaseProvider().getProvider("transaction/kurir/provinsi",provinsiModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      setState(() {
        isLoadingProv=false;
      });
    }
    else{
      if(res is ProvinsiModel){
        ProvinsiModel resullt = res;
        setState(() {
          provinsiModel = ProvinsiModel.fromJson(resullt.toJson());
          isLoadingProv=false;
          id = widget.id==""?resullt.result[0].id:widget.id;
          idx = widget.idx;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("ID PROVINSI ${widget.id}");
    isLoadingProv=true;
    getProv();
    // _scrollController.scrollTo(index: widget.idx, duration: Duration(milliseconds: 1000),curve: Curves.easeOut,);

  }
  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(90),
      child: WidgetHelper().wrapperModal(context,"Daftar Provinsi", Scrollbar(
          child: isLoadingProv?WidgetHelper().loadingWidget(context):ScrollablePositionedList.separated(
            padding: EdgeInsets.zero,
            itemScrollController: _scrollController,
            itemCount: provinsiModel.result.length,
            initialScrollIndex: idx,
            itemBuilder: (context,index){
              return FlatButton(
                  color: index%2==0?Color(0xFFEEEEEE):Colors.white,
                  padding: scaler.getPadding(0,0),
                  onPressed: (){
                    setState(() {
                      idx = index;
                      id = provinsiModel.result[index].id;
                    });
                    widget.callback(provinsiModel.result[index].id,provinsiModel.result[index].name,index);
                  },
                  child: ListTile(
                    contentPadding: scaler.getPadding(0,2),
                    title: WidgetHelper().textQ("${provinsiModel.result[index].name}",scaler.getTextSize(9),Constant().darkMode, FontWeight.bold),
                    trailing: widget.id==provinsiModel.result[index].id?Icon(AntDesign.checkcircleo,size:20,color:Constant().darkMode):Text(''),
                  )
              );
            },
            separatorBuilder: (context, index) {
              return Divider(height: 0,color: id==provinsiModel.result[index].id?Colors.grey:Colors.grey);
            },
          )
      ),isCallack: false),
    );
  }
}

class ModalCity extends StatefulWidget {
  ModalCity({
    Key key,
    @required this.callback,
    @required this.id,
    @required this.idProv,
    @required this.idx,
  }) : super(key: key);
  Function(String id,String name,int idx) callback;
  final String id;
  final String idProv;
  int idx;
  @override
  _ModalCityState createState() => _ModalCityState();
}

class _ModalCityState extends State<ModalCity> {
  KotaModel kotaModel;
  bool isLoading=false;
  ItemScrollController _scrollController = ItemScrollController();
  ItemPositionsListener itemPositionListener = ItemPositionsListener.create();
  int idx=0;
  String id='';
  int no=0;
  Widget child;
  Future getData()async{
    var res = await BaseProvider().getProvider("transaction/kurir/kota?id=${widget.idProv}",kotaModelFromJson,context: context,callback: (){
      Navigator.pop(context);
    });
    print(res);
    if(res==Constant().errNoData){
      setState(() {
        isLoading=false;
      });
    }
    else if(res is KotaModel){
      setState(() {
        KotaModel resullt = res;
        kotaModel = KotaModel.fromJson(resullt.toJson());
        id = widget.id==""?kotaModel.result[0].id:widget.id;
        idx = widget.idx;
        isLoading=false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    getData();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      height: scaler.getHeight(90),
      child: WidgetHelper().wrapperModal(context,"Daftar Kota", Scrollbar(
          child: isLoading?WidgetHelper().loadingWidget(context):buildContent(context)
      ),isCallack: false),
    );
  }

  Widget buildContent(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return ScrollablePositionedList.separated(
      padding: EdgeInsets.zero,
      itemScrollController: _scrollController,
      itemCount: kotaModel.result.length,
      // initialScrollIndex: idx,
      itemBuilder: (context,index){
        return FlatButton(
          onPressed: (){
            setState(() {
              idx = index;
              id = kotaModel.result[index].id;
            });
            widget.callback(kotaModel.result[index].id,kotaModel.result[index].name,index);
          },
          color: index%2==0?Color(0xFFEEEEEE):Colors.white,
          padding: scaler.getPadding(0,0),
          child: ListTile(
            contentPadding: scaler.getPadding(0,2),
            title: WidgetHelper().textQ("${kotaModel.result[index].name}", scaler.getTextSize(9),Constant().darkMode, FontWeight.bold),
            trailing: id==kotaModel.result[index].id?Icon(AntDesign.checkcircleo,size:20,color:Constant().darkMode):Text(''),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider(height: 0,color:Colors.grey);
      },
    );
  }
}


class ModalDisctrict extends StatefulWidget {
  ModalDisctrict({
    Key key,
    @required this.callback,
    @required this.id,
    @required this.idCity,
    @required this.idx,
  }) : super(key: key);
  Function(String id,String name,int idx) callback;
  final String id;
  final String idCity;
  int idx;
  @override
  _ModalDisctrictState createState() => _ModalDisctrictState();
}

class _ModalDisctrictState extends State<ModalDisctrict> {
  KecamatanModel kecamatanModel;
  bool isLoading=false;
  ItemScrollController _scrollController = ItemScrollController();
  ItemPositionsListener itemPositionListener = ItemPositionsListener.create();
  int idx=0;
  String id='';
  int no=0;
  Widget child;
  Future getData()async{
    var res = await BaseProvider().getProvider("transaction/kurir/kecamatan?id=${widget.idCity}",kecamatanModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      setState(() {
        isLoading=false;
      });
    }
    else{
      if(res is KecamatanModel){
        KecamatanModel resullt = res;
        setState(() {
          kecamatanModel = KecamatanModel.fromJson(resullt.toJson());
          isLoading=false;
          id = widget.id==""?resullt.result[0].id:widget.id;
          idx = widget.idx;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    getData();
    print("HALAMAN KECAMATAM");
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      height: scaler.getHeight(90),
      child: WidgetHelper().wrapperModal(context,"Daftar Kecamatan", Scrollbar(
          child: isLoading?WidgetHelper().loadingWidget(context):ScrollablePositionedList.separated(
            padding: EdgeInsets.zero,
            itemScrollController: _scrollController,
            itemCount: kecamatanModel.result.length,
            initialScrollIndex: idx,
            itemBuilder: (context,index){
              return FlatButton(
                onPressed: (){
                  setState(() {
                    idx = index;
                    id = kecamatanModel.result[index].id;
                  });
                  widget.callback(kecamatanModel.result[index].id,kecamatanModel.result[index].kecamatan,index);
                },
                color: index%2==0?Color(0xFFEEEEEE):Colors.white,
                padding: scaler.getPadding(0,0),
                child: ListTile(
                  contentPadding: scaler.getPadding(0,2),
                  title: WidgetHelper().textQ("${kecamatanModel.result[index].kecamatan}", scaler.getTextSize(9),Constant().darkMode, FontWeight.bold),
                  trailing: id==kecamatanModel.result[index].id?Icon(AntDesign.checkcircleo,size:20,color:Constant().darkMode):Text(''),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(height: 0,color: id==kecamatanModel.result[index].id?Colors.grey:Colors.grey);
            },
          )
      ),isCallack: false),
    );

  }
}
