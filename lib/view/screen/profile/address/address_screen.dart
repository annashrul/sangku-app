import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/address/address_model.dart';
import 'package:sangkuy/model/member/address/detail_address_model.dart';
import 'package:sangkuy/model/member/address/kecamatan_model.dart';
import 'package:sangkuy/model/member/address/kota_model.dart';
import 'package:sangkuy/model/member/address/provinsi_model.dart';
import 'package:sangkuy/provider/address_provider.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class AddressScreen extends StatefulWidget {
  int idx;
  final Function(dynamic val,int idx) callback;
  AddressScreen({this.idx,this.callback});
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
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
    return Scaffold(
      key: scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,"Daftar Alamat",(){Navigator.pop(context);},<Widget>[
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(right: 0.0,top:5),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: FlatButton(
                    onPressed: (){
                      WidgetHelper().myModal(context, ModalForm(total:total,id:"",callback:(String par){
                        if(par=='berhasil'){
                          loadData();
                          WidgetHelper().showFloatingFlushbar(context,"success","data berhasil dikirim");
                        }
                        else{
                          WidgetHelper().showFloatingFlushbar(context,"success","terjadi kesalahan koneksi");
                        }
                      },));
                    },
                    child:Icon(AntDesign.addfile)
                ),
              ),
            ],
          ),
        )
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
          return WidgetHelper().myPress((){
            if(widget.idx!=null){
              setState(() {
                widget.idx=index;
              });
              print(widget.idx);
              widget.callback(val,index);
            }

          }, ClipPath(
            clipper: WaveClipperOne(flip: true),
            child: Container(
              padding: EdgeInsets.only(bottom:50.0,top:10.0,left:15.0,right:15.0),
              width: double.infinity,
              color: widget.idx==index?Constant().darkMode:Constant().secondColor,
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
                            WidgetHelper().textQ(val.title,12,Constant().mainColor, FontWeight.bold),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FlatButton(
                              onPressed: (){
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
                              child: Icon(AntDesign.edit,color:Constant().secondDarkColor),
                              color: Constant().moneyColor,
                              padding: EdgeInsets.all(0.0),
                            ),
                            SizedBox(width: 10.0),
                            FlatButton(
                              color: Constant().moneyColor,
                              onPressed: (){
                                WidgetHelper().notifDialog(context, "Perhatian !!","anda yakin akan menghapus data ini ??", (){Navigator.pop(context);},()async{
                                  Navigator.pop(context);
                                  await deleteAddress(val.id);
                                });
                              },
                              child: Icon(AntDesign.delete,color:Constant().secondDarkColor),
                              padding: EdgeInsets.all(0.0),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                  Divider(color: Colors.black38),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("${val.penerima} ( ${val.noHp} )",10,Constant().secondDarkColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        WidgetHelper().textQ("${val.mainAddress}",10,Constant().secondDarkColor, FontWeight.normal),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        },
        separatorBuilder: (context,index){
          return SizedBox(height:0.0);
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
  var detailAddressController = TextEditingController();
  bool isLoading=false,isError=false,isErrorProv=false,isErrorCity=false,isErrorDistrcit=false;
  String prov='',provName='';int idxProv=0;
  String city='',cityName='';int idxCity=0;
  String district='',districtName='';int idxDistrict=0;
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
    else if(namaJalan==''||rt==''||rw==''||kodePos==''){
      WidgetHelper().showFloatingFlushbar(context,"failed","sesuaikan format pengisian detail alamat dengan contoh");
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
        "main_address":"$namaJalan,$rt,$rw,$keluarahan,$districtName,$cityName,$provName,$kodePos".toLowerCase(),
        "kd_prov":"$prov",
        "kd_kota":"$city",
        "kd_kec":"$district",
        "no_hp":"${telpController.text}",
        "ismain":widget.total>0?'0':'1'
      };
      var res;
      if(widget.id!=''){
        res = await BaseProvider().putProvider("alamat/${widget.id}", data);
      }
      else{
        res = await BaseProvider().postProvider("alamat",data);
      }
      if(res==Constant().errTimeout||res==Constant().errSocket){
        Navigator.pop(context);
        Navigator.pop(context);
        widget.callback('gagal');
      }
      else{
        if(res is General){
          Navigator.pop(context);
          Navigator.pop(context);
          widget.callback('gagal');
        }else{
          Navigator.pop(context);
          Navigator.pop(context);
          widget.callback('berhasil');
        }
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
        String mainAdd=result.result.mainAddress;
        print(mainAdd);
        print(mainAdd.split(","));
        print(result.toJson());
        setState(() {
          detailAddressModel = DetailAddressModel.fromJson(result.toJson());
          isLoading=false;
          isError=false;
          titleController.text = result.result.title;
          receiverController.text = result.result.penerima;
          telpController.text=result.result.noHp;
          prov = result.result.kdProv;
          provName=mainAdd.split(",")[6].toLowerCase();
          city=result.result.kdKota;
          cityName=mainAdd.split(",")[5].toLowerCase();
          district=result.result.kdKec;
          districtName=mainAdd.split(",")[4].toLowerCase();
          mainAddressController.text = "${mainAdd.split(",")[0]},${mainAdd.split(",")[1]},${mainAdd.split(",")[2]},${mainAdd.split(",")[3]},${mainAdd.split(",")[4]},${mainAdd.split(",")[5]},${mainAdd.split(",")[6]},${mainAdd.split(",")[7]}".toLowerCase();
          namaJalan=mainAdd.split(",")[0];
          rt=mainAdd.split(",")[1];
          rw=mainAdd.split(",")[2];
          keluarahan=mainAdd.split(",")[3];
          kodePos=mainAdd.split(",")[7];
        });
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
    return Container(
      height: MediaQuery.of(context).size.height/1.2,
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
      ),
      // color: Colors.white,
      child: isLoading?WidgetHelper().loadingWidget(context):Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top:0.0),
              width: 50,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            dense:true,
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: Icon(AntDesign.back, color:Theme.of(context).hintColor),),
              ),
            ),
            title: WidgetHelper().textQ("${widget.id==''?'Tambah':'Ubah'} Alamat",14, Theme.of(context).hintColor, FontWeight.bold),
            trailing: InkWell(
                onTap: ()async{
                  storeAddress();
                },
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Constant().secondColor,Constant().secondColor]),
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [BoxShadow(color: Color(0xFF6078ea).withOpacity(.3),offset: Offset(0.0, 8.0),blurRadius: 8.0)]
                  ),
                  child: WidgetHelper().textQ("Simpan",14,Colors.white,FontWeight.bold),
                )
            ),
          ),
          Divider(),
          SizedBox(height:10.0),
          Expanded(
            child: ListView(
              children: [
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("Simpan Alamat Sebagai (Contoh:Alamat rumah, Alamat kantor, Alamat pacar)",8,Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor.withOpacity(0.1),

                            // border: Border.all(color: Colors.grey[200]),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: TextStyle(color:Colors.grey,fontSize:12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                            controller: titleController,
                            focusNode: titleFocus,
                            autofocus: false,
                            decoration: InputDecoration.collapsed(
                                hintStyle: TextStyle(color:Colors.grey,fontSize: 12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                            ),
                            onFieldSubmitted: (_){
                              WidgetHelper().fieldFocusChange(context, titleFocus,receiverFocus);
                            },


                          ),
                        ),
                        SizedBox(height:10.0),
                        WidgetHelper().textQ("Penerima",8,Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor.withOpacity(0.1),

                            // border: Border.all(color: Colors.grey[200]),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color:Colors.grey,fontSize:12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                            controller: receiverController,
                            focusNode: receiverFocus,
                            autofocus: false,
                            decoration: InputDecoration.collapsed(
                                hintStyle: TextStyle(color:Colors.grey,fontSize: 12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                            ),
                            onFieldSubmitted: (_){
                              WidgetHelper().fieldFocusChange(context, receiverFocus,telpFocus);
                            },
                          ),
                        ),
                        SizedBox(height:10.0),
                        WidgetHelper().textQ("No.Telepon",8, Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: TextFormField(
                            textInputAction: TextInputAction.next,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            style: TextStyle(color:Colors.grey,fontSize:12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                            controller: telpController,
                            focusNode: telpFocus,
                            decoration: InputDecoration.collapsed(
                                hintText: "",
                                hintStyle: TextStyle(color:Colors.grey,fontSize: 12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                            ),
                            onFieldSubmitted: (_){
                              FocusScope.of(context).unfocus();
                              WidgetHelper().myModal(context,ModalProvinsi(
                                callback:(id,name,idx){
                                  setState(() {prov=id;provName=name;idxProv=idx;city='';});
                                  Navigator.pop(context);
                                },
                                id: prov,idx: idxProv,
                              ));
                            },
                          ),
                        ),
                        SizedBox(height:10.0),
                        WidgetHelper().textQ("Provinsi",8,Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        tempAdd("${prov!=''?provName:'Pilih Provinsi'}",isErrorProv,(){
                          WidgetHelper().myModal(context,ModalProvinsi(
                            callback:(id,name,idx){
                              setState(() {prov=id;provName=name;idxProv=idx;city='';});
                              Navigator.pop(context);
                              WidgetHelper().myModal(context,ModalCity(
                                callback:(id,name,idx){
                                  setState(() {city=id;cityName=name;idxCity=idx;district='';});
                                  WidgetHelper().myModal(context,ModalDisctrict(
                                    callback:(id,name,idx){
                                      setState(() {district=id;districtName=name;idxDistrict=idx;});
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      // Navigator.pop(context);
                                    },
                                    id:district,idCity: city,idx: idxDistrict,
                                  ));
                                  // Navigator.pop(context);
                                },
                                id:city,idProv: prov,idx: idxCity,
                              ));
                            },
                            id: prov,idx: idxProv,
                          ));
                        }),
                        SizedBox(height: 10),
                        WidgetHelper().textQ("Kota",8,Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        tempAdd("${city!=''?cityName:'Pilih Kota'}",isErrorCity,(){
                          if(prov!=''){
                            WidgetHelper().myModal(context,ModalCity(
                              callback:(id,name,idx){
                                print('bus');
                                setState(() {city=id;cityName=name;idxCity=idx;district='';});
                                // Navigator.pop(context);
                                WidgetHelper().myModal(context,ModalDisctrict(
                                  callback:(id,name,idx){
                                    setState(() {district=id;districtName=name;idxDistrict=idx;});
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  id:district,idCity: city,idx: idxDistrict,
                                ));
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
                        }),
                        SizedBox(height: 10),
                        WidgetHelper().textQ("Kecamatan",8,Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        tempAdd("${district!=''?districtName:'Pilih Kecamatan'}",isErrorDistrcit,(){
                          if(prov!=''&&city!=''){
                            WidgetHelper().myModal(context,ModalDisctrict(
                              callback:(id,name,idx){
                                setState(() {district=id;districtName=name;idxDistrict=idx;});
                                // Navigator.pop(context);
                                Navigator.pop(context);
                                // mainAddressFocus.requestFocus();
                              },
                              id:district,idCity: city,idx: idxDistrict,
                            ));
                          }
                          else{
                            if(prov==''){
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
                        }),
                        SizedBox(height: 10),
                        WidgetHelper().textQ("Detail Alamat (format penulisan : nama jalan,rt,rw,kelurahan,kode pos)",8,Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor.withOpacity(0.1),

                            // border: Border.all(color: Colors.grey[200]),
                            borderRadius: BorderRadius.all(
                                Radius.circular(10.0)
                            ),
                          ),
                          padding: EdgeInsets.all(10.0),
                          child: TextField(
                            textInputAction: TextInputAction.done,
                            maxLines: 5,
                            style: TextStyle(color:Colors.grey,fontSize:12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                            controller: mainAddressController,
                            focusNode: mainAddressFocus,
                            decoration: InputDecoration.collapsed(
                                hintText: hintMainAddress,
                                hintStyle: TextStyle(color:Colors.grey,fontSize: 12,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                            ),
                            onChanged: (_){
                              if(_!=''){
                                if(mainAddressController.text.split(",").length>4){
                                  setState(() {
                                    namaJalan=mainAddressController.text.split(",")[0];
                                    rt=mainAddressController.text.split(",")[1];
                                    rw=mainAddressController.text.split(",")[2];
                                    keluarahan=mainAddressController.text.split(",")[3];
                                    kodePos=mainAddressController.text.split(",")[4];
                                  });
                                }
                              }
                              else{
                                setState(() {
                                  mainAddressController.text='';
                                  namaJalan="";
                                  rt="";
                                  rw="";
                                  kodePos="";
                                });
                              }

                            },
                          ),
                        ),
                        SizedBox(height: 10),
                        WidgetHelper().textQ("Alamat ini digunakan untuk pengiriman",8,Theme.of(context).hintColor, FontWeight.normal),
                        SizedBox(height:5.0),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor.withOpacity(0.1),

                              // border: Border.all(color: Colors.grey[200]),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10.0)
                              ),
                            ),
                            padding: EdgeInsets.all(10.0),
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("JALAN".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$namaJalan".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("RT".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$rt".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("RW".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$rw".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("KELURAHAN".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$keluarahan".toLowerCase(), 10,Constant().darkMode,FontWeight.normal),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("KECAMATAN".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$districtName".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("KOTA".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$cityName".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("PROVINSI".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$provName".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    WidgetHelper().textQ("KODE POS".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                    WidgetHelper().textQ("$kodePos".toLowerCase(), 10, Constant().darkMode,FontWeight.normal),
                                  ],
                                )

                              ],
                            )
                          // child: WidgetHelper().textQ(
                          //     "nama jalan : ${mainAddressController.text==""?"":mainAddressController.text.split(",")[0]}\nrt : ${mainAddressController.text==""?"":mainAddressController.text.split(",")[1]}\nrw : ${mainAddressController.text==""?"":mainAddressController.text.split(",")[2]}\nKelurahan : ${mainAddressController.text==""?"":mainAddressController.text.split(",")[3]}\nKecamatan : $districtName\Kota : $cityName\Provinsi : $provName\n",
                          //     10,
                          //     Colors.grey,
                          //     FontWeight.bold
                          // ),
                        ),
                      ],
                    )
                ),


              ],
            ),
          )
        ],
      ),
    );
  }

  Widget tempAdd(String title,bool isErr,Function callback){
    return WidgetHelper().myPress(callback,WidgetHelper().animShakeWidget(
        context,
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          padding: EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetHelper().textQ("$title",10,Colors.grey,FontWeight.bold),
              Icon(Icons.arrow_right,size: 15,color: Colors.grey),
            ],
          ),
        ),
        enable: isErr
    ));
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
    return Container(
      height: MediaQuery.of(context).size.height/1,
      decoration: BoxDecoration(
          color: Colors.transparent,
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
          ListTile(
            dense:true,
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: Icon(AntDesign.back, color:Theme.of(context).hintColor),),
              ),
            ),
            title: WidgetHelper().textQ("Pilih Provinsi",12, Theme.of(context).hintColor, FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Scrollbar(
                child: isLoadingProv?WidgetHelper().loadingWidget(context):ScrollablePositionedList.separated(
                  padding: EdgeInsets.zero,
                  itemScrollController: _scrollController,
                  itemCount: provinsiModel.result.length,
                  initialScrollIndex: idx,
                  itemBuilder: (context,index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          idx = index;
                          id = provinsiModel.result[index].id;
                        });
                        widget.callback(provinsiModel.result[index].id,provinsiModel.result[index].name,index);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left:10,right:10,top:0,bottom:0),
                        title: WidgetHelper().textQ("${provinsiModel.result[index].name}", 10,Constant().darkMode, FontWeight.bold),
                        trailing: widget.id==provinsiModel.result[index].id?Icon(AntDesign.checkcircleo,size:20,color:Constant().darkMode):Text(''),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 1,color: id==provinsiModel.result[index].id?Colors.grey:Colors.grey);
                  },
                )
            ),
          ),

        ],
      ),
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
    var res = await BaseProvider().getProvider("transaction/kurir/kota?id=${widget.idProv}",kotaModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      setState(() {
        isLoading=false;
      });
    }
    else{
      if(res is KotaModel){
        KotaModel resullt = res;
        setState(() {
          kotaModel = KotaModel.fromJson(resullt.toJson());
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1,
      decoration: BoxDecoration(
          color:Colors.transparent,
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
          ListTile(
            dense:true,
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: Icon(AntDesign.back, color: Theme.of(context).hintColor),),
              ),
            ),
            title: WidgetHelper().textQ("Pilih Kota",12,Theme.of(context).hintColor, FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Scrollbar(
                child: isLoading?WidgetHelper().loadingWidget(context):ScrollablePositionedList.separated(
                  padding: EdgeInsets.zero,
                  itemScrollController: _scrollController,
                  itemCount: kotaModel.result.length,
                  initialScrollIndex: idx,
                  itemBuilder: (context,index){

                    return InkWell(
                      onTap: (){
                        setState(() {
                          idx = index;
                          id = kotaModel.result[index].id;
                        });
                        widget.callback(kotaModel.result[index].id,kotaModel.result[index].name,index);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left:10,right:10,top:0,bottom:0),
                        title: WidgetHelper().textQ("${kotaModel.result[index].name}", 10,Constant().darkMode, FontWeight.bold),
                        trailing: id==kotaModel.result[index].id?Icon(AntDesign.checkcircleo,size:20,color:Constant().darkMode):Text(''),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 1,color: id==kotaModel.result[index].id?Colors.grey:Colors.grey);
                  },
                )
            ),
          ),

        ],
      ),
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
    return Container(
      height: MediaQuery.of(context).size.height/1,
      decoration: BoxDecoration(
          color:Colors.transparent,
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
          ListTile(
            dense:true,
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: Icon(AntDesign.back, color:Theme.of(context).hintColor),),
              ),
            ),
            title: WidgetHelper().textQ("Pilih Kecamatan",12,Theme.of(context).hintColor, FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Scrollbar(
                child: isLoading?WidgetHelper().loadingWidget(context):ScrollablePositionedList.separated(
                  padding: EdgeInsets.zero,
                  itemScrollController: _scrollController,
                  itemCount: kecamatanModel.result.length,
                  initialScrollIndex: idx,
                  itemBuilder: (context,index){

                    return InkWell(
                      onTap: (){
                        setState(() {
                          idx = index;
                          id = kecamatanModel.result[index].id;
                        });
                        widget.callback(kecamatanModel.result[index].id,kecamatanModel.result[index].kecamatan,index);
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.only(left:10,right:10,top:0,bottom:0),
                        title: WidgetHelper().textQ("${kecamatanModel.result[index].kecamatan}", 10,Constant().darkMode, FontWeight.bold),
                        trailing: id==kecamatanModel.result[index].id?Icon(AntDesign.checkcircleo,size:20,color:Constant().darkMode):Text(''),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(height: 1,color: id==kecamatanModel.result[index].id?Colors.grey:Colors.grey);
                  },
                )
            ),
          ),

        ],
      ),
    );
  }
}
