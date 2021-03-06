import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/money_format_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/available_member_model.dart';
import 'package:sangkuy/model/member/bank_member_model.dart';
import 'package:sangkuy/model/wallet/config_wallet_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/mlm/history/success_pembelian_screen.dart';
import 'package:sangkuy/view/widget/bank_member_widget.dart';
import 'package:sangkuy/view/widget/bank_widget.dart';
import 'package:sangkuy/view/widget/camera_widget.dart';
import 'package:sangkuy/view/widget/confirm_widget.dart';
import 'package:sangkuy/view/widget/detail_scaffold.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/nominal_widget.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:sangkuy/view/widget/wrapper_page_widget.dart';
import 'package:showcaseview/showcaseview.dart';

import '../pages.dart';

class FormEwalletScreen extends StatefulWidget {
  // final dynamic dataMember;
  final String title;
  FormEwalletScreen({this.title});
  @override
  _FormEwalletScreenState createState() => _FormEwalletScreenState();
}

class _FormEwalletScreenState extends State<FormEwalletScreen> {
  bool isLoading=false,isError=false,isPending=false;
  ConfigWalletModel configWalletModel;
  final FocusNode nominalFocus = FocusNode();
  var nominalController = MoneyMaskedTextControllerQ(decimalSeparator: '', thousandSeparator: ',');
  final FocusNode penerimaFocus = FocusNode();
  var penerimaController = TextEditingController();
  String idBank='';
  int saldo=0;
  int idx=10;
  bool isHaveKtp=false;
  dynamic dataBank;
  dynamic data;
  String image='';
  String title='';
  String desc='';
  String kdTrx='';
  String idCard='';
  AvailableMemberModel availableMemberModel;
  Future loadConfig()async{
    final config = await BaseProvider().getProvider("transaction/wallet/config", configWalletModelFromJson);
    if(config==Constant().errSocket||config==Constant().errTimeout){
      setState(() {
        isLoading=false;
        isError=true;
      });
    }
    else if(config==Constant().errExpToken){
      setState(() {
        isLoading=false;
        isError=false;
      });
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken, ()async{
        FunctionHelper().logout(context);
      });
    }
    else{
      if(config is ConfigWalletModel){
        ConfigWalletModel result=config;
        if(this.mounted){
          setState(() {
            configWalletModel = result;
            isLoading=false;
            isError=false;
            isHaveKtp=result.result.isHaveKtp;
            idCard=result.result.idCard;
          });
          if(widget.title=='TOP UP'){
            saldo=int.parse(result.result.dpMin);
            if(result.result.trxDp!='-'){
              print("###################### TOPUP PENDING = ${result.result.trxDp} ##########################");
              setState(() {
                kdTrx=result.result.trxDp;
                isPending=true;
                title='Informasi !';
                desc = 'Silahkan selesaikan transaksi anda';
              });
              return showNotif(context);
            }
          }
          if(widget.title=='TRANSFER'){
            print("###################### TRANSFER ##########################");
            saldo=int.parse(result.result.tfMin);
            setState(() {});
          }
          if(widget.title=='PENARIKAN'){
            saldo=int.parse(result.result.wdMin);
            print("###################### PENARIKAN ${result.result.toJson()} ##########################");
            setState(() {});
            // if(!isHaveKtp&&idCard=='-'){
            //   setState(() {
            //     isPending=true;
            //     title='Informasi';
            //     desc = 'Untuk melakukan penarikan, kami harus memastikan bahwa anda bukan robot. Maka dari itu silahkan unggah foto identitas anda seperti KTP/SIM/KITAS dsb.';
            //   });
            //   print("###################### BELUM PUNYA KTP = ${result.result.isHaveKtp} ##########################");
            //   return showNotif(context);
            // }
            // if(!isHaveKtp&&idCard!='-'){
            //   setState(() {
            //     isPending=true;
            //     title='Informasi';
            //     desc = 'Silahkan tunggu konfirmasi dari admin';
            //   });
            //   return showNotif(context);
            // }
            if(result.result.trxWd!='0'){
              setState(() {
                isPending=true;
                title='Transaksi Pending';
                desc = 'Maaf, terdapat transaksi anda yang masih pending';
              });
              print("###################### WD PENDING = ${result.result.trxWd} ##########################");
              return showNotif(context);
            }
          }

        }
      }
    }
  }
  Future handleNext()async{
    String msg='';
    if(widget.title=='TRANSFER'){
      if(penerimaController.text==''){
        msg='Penerima tidak boleh kosong';
        penerimaFocus.requestFocus();
      }
      else{
        WidgetHelper().loadingDialog(context);
        var checkingMember=await BaseProvider().getProvider('member/data/${penerimaController.text}', availableMemberModelFromJson);
        Navigator.pop(context);
        if(checkingMember is General){
          General result=checkingMember;
          msg=result.msg;
        }
        else{
          availableMemberModel = checkingMember;
        }
      }
    }
    if(nominalController.text==''){
      msg='nominal tidak boleh kosong';
      nominalFocus.requestFocus();
    }
    if(nominalController.text=='0'){
      msg='nominal harus lebih dari 0';
      nominalFocus.requestFocus();
    }
    if(int.parse(nominalController.text.replaceAll(",",""))<saldo){
      msg='${widget.title.toLowerCase()} minimal Rp ${FunctionHelper().formatter.format(saldo)}';
      nominalFocus.requestFocus();
    }

    if(msg==''){
      nominalFocus.unfocus();
      double admin = int.parse(configWalletModel.result.tfCharge)/100*int.parse(nominalController.text.replaceAll(",",""));
      String charge=admin.toString().split(".")[0];
      if(widget.title=='TRANSFER'){
        data={
          "param":'transfer',
          "nominal":nominalController.text.replaceAll(",",""),
          "admin":'$charge',
          "total":'${int.parse(nominalController.text.replaceAll(",",""))+int.parse(charge)}',
          "penerima":availableMemberModel.result.fullName,
        };
      }
      if(widget.title=='TOP UP'||widget.title=='PENARIKAN'){
        data={
          "param":'topup-penarikan',
          "nominal":nominalController.text.replaceAll(",",""),
          "admin":widget.title=='PENARIKAN'?'$charge':'0',
          "total":'${widget.title=='PENARIKAN'?int.parse(nominalController.text.replaceAll(",",""))+int.parse(charge):int.parse(nominalController.text.replaceAll(",",""))+0}',
          "bankTujuan":dataBank['bank_name'],
          "atasNama":dataBank['acc_name'],
        };
      }
      setState(() {});
      WidgetHelper().myModal(context,Container(
        height: MediaQuery.of(context).size.height/1.7,
        child: ConfirmWidget(data:data,callback: (){
          WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin){
            checkout(pin);
          }));
        }),
      ));
    }
    else{
      WidgetHelper().showFloatingFlushbar(context,"failed",msg);
    }
  }
  Future checkout(pin)async{
    String url='';
    final val={
      "amount":data['nominal'],
      "member_pin":pin
    };
    if(widget.title=='TOP UP'){
      url='transaction/deposit';
      val['id_bank_destination']=dataBank['id'];
    }
    if(widget.title=='TRANSFER'){
      url='transaction/transfer';
      val['id_penerima']=penerimaController.text;
    }
    if(widget.title=='PENARIKAN'){
      url='transaction/withdrawal';
      val['id_bank']=dataBank['id'];
    }
    print(val);
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().postProvider(url, val,context: context,callback: (){
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
    });
    if(res!=null){
      Navigator.pop(context);
      String kdTrx='';
      if(widget.title=='TOP UP'){
        kdTrx = base64.encode(utf8.encode(res['result']['kd_trx']));
        WidgetHelper().showFloatingFlushbar(context,"success",Constant().descMsgSuccessTrx);
        await Future.delayed(Duration(seconds: 2));
        WidgetHelper().myPushRemove(context, SuccessPembelianScreen(kdTrx:kdTrx));
      }
      if(widget.title=='TRANSFER'){
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));

        });
      }
      if(widget.title=='PENARIKAN'){
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,res['msg'],(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        });
      }
    }
  }
  Future handleUpdate(BuildContext context)async{
    WidgetHelper().loadingDialog(context);
    var res= await MemberProvider().updateMember({"id_card":image}, context);
    Navigator.pop(context);
    if(res=='success'){
      // loadConfig();
      WidgetHelper().notifOneBtnDialog(context,"Berhasil","Permintaan anda akan segera kami proses", (){
        WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
      });
      // WidgetHelper().showFloatingFlushbar(context,"success","data berhasil disimpan");
    }else{
      WidgetHelper().showFloatingFlushbar(context,"failed", res);
    }
  }
  Future<void> scanQR() async {
    final qr = await FunctionHelper().scanQR();
    setState(() {
      penerimaController.text = qr;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadConfig();
    isLoading=true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
          FunctionHelper().firstTime("page").then((result){
            print(result);
            if(result)
              ShowCaseWidget.of(myContext).startShowCase([_one]);
          });
        }
    );
  }
  GlobalKey _one = GlobalKey();
  BuildContext myContext;

  @override
  Widget build(BuildContext context){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return ShowCaseWidget(
      // onFinish: ,
      builder: Builder(builder: (context) {
        myContext = context;
        return Scaffold(
          body: SafeArea(
            child: RefreshWidget(
              widget:WrapperPageWidget(
                // dataMember: widget.dataMember,
                children: [
                  if(isLoading)LinearProgressIndicator(),
                  Divider(thickness: 10.0),
                  Padding(
                    padding: EdgeInsets.only(left:10,right:10,top:10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().titleNoButton(context,AntDesign.wallet,"Pilih Nominal Cepat",color:Constant().darkMode,iconSize:12),
                        SizedBox(height: 10.0),
                        NominalWidget(callback: (amount,index){
                          setState(() {
                            nominalController.text=amount;
                            idx=index;
                          });
                        },idx:idx),
                        SizedBox(height: 10.0),
                        WidgetHelper().titleNoButton(context,AntDesign.wallet,"Masukan Nominal",color:Constant().darkMode,iconSize:12),
                        SizedBox(height: 10.0),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Constant().greyColor
                          ),
                          child: TextFormField(
                            style: TextStyle(letterSpacing:2.0,fontSize:14,fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
                            controller: nominalController,
                            maxLines: 1,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color:Constant().greyColor),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              prefixText: 'Rp.',
                              hintStyle: TextStyle(color:Constant().darkMode, fontSize:12,fontFamily:Constant().fontStyle),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            focusNode: nominalFocus,
                            onFieldSubmitted: (term){
                            },
                            inputFormatters: <TextInputFormatter>[
                              if(widget.title=='TRANSFER'||widget.title=='PENARIKAN')LengthLimitingTextInputFormatter(10),
                              WhitelistingTextInputFormatter.digitsOnly,
                              BlacklistingTextInputFormatter.singleLineFormatter,
                            ],
                            onChanged: (e){
                              int amount;
                              for(int i=0;i<FunctionHelper.dataNominal.length;i++){
                                if(FunctionHelper.dataNominal[i]==e){
                                  amount=i;
                                  break;
                                }
                                continue;
                              }
                              idx = amount!=null?amount:10;
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(height: 10.0),
                        if(widget.title=='TRANSFER')transfer(),
                        if(widget.title=='PENARIKAN'||widget.title=='TOP UP')WidgetHelper().titleNoButton(context,AntDesign.bank,"Pilih Bank Tujuan",color:Constant().darkMode,iconSize:12),
                        SizedBox(height: 10.0),
                        if(widget.title=='PENARIKAN')penarikan(),
                        if(widget.title=='TOP UP')topup(),
                        // SizedBox(height: 70.0),

                      ],
                    ),
                  )
                ],
                title: widget.title,
                callback: (data){

                },
              ),
              callback: (){
                setState(() {
                  isLoading=true;
                });
                loadConfig();
              },
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: FlatButton(
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(0.0)),
                onPressed: () {
                  if(!isPending){
                    handleNext();
                  }else{
                    showNotif(context);
                  }
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
                      WidgetHelper().textQ("LANJUT", 14, Constant().secondDarkColor, FontWeight.bold),
                    ],
                  ),
                )
              // child:Text("abus")
            ),
          ),
        );
      }),
      autoPlay: true,
      autoPlayDelay: Duration(seconds: 3),
      autoPlayLockEnable: true,
    );

  }

  Widget transfer(){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetHelper().titleNoButton(context,AntDesign.user,"ID Penerima",color:Constant().darkMode,iconSize: 12),
        SizedBox(height: scaler.getHeight(0.5)),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left:10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color:Constant().greyColor
          ),
          child: TextFormField(
            style: TextStyle(letterSpacing:2.0,fontSize:14,fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
            controller: penerimaController,
            maxLines: 1,
            autofocus: false,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
              suffixIcon:InkWell(
                onTap: (){
                  penerimaFocus.unfocus();
                  scanQR();
                  // checkingAccount();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Constant().mainColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                    // color:Constant().greyColor
                  ),
                  child: Showcase.withWidget(
                    shapeBorder: CircleBorder(),
                    contentPadding: scaler.getPadding(2,2),
                    key: _one,
                    child: Icon(AntDesign.scan1,color:Colors.white),
                    descTextStyle: TextStyle(fontSize: scaler.getTextSize(9),fontFamily: Constant().fontStyle),
                    description: 'gunakan fitur qr code ini untuk mempercepat proses transaksi anda',
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(top: 19.0, right: 0.0, bottom: 0.0, left: 0.0),
              hintStyle: TextStyle(color:Constant().darkMode, fontSize:12,fontFamily:Constant().fontStyle),
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            focusNode: penerimaFocus,
            // textCapitalization: TextCapitalization.sentences,
            textCapitalization: TextCapitalization.characters,

          ),
        ),
        SizedBox(height: scaler.getHeight(0.5)),
        WidgetHelper().textQ('ID Penerima bisa dilihat melalui profil penerima yang akan di transfer',10.0,Constant().moneyColor,FontWeight.bold),
      ],
    );
  }

  Widget topup(){
    return BankWidget(callback: (val){
      setState(() {
        idBank=val['id'];
        dataBank=val;
      });
    },id: idBank,isSaldo: false);
  }

  Widget penarikan(){
    return BankMemberWidget(callback: (id){
      Datum datum=id;
      setState(() {
        idBank=datum.id;
        dataBank=datum.toJson();
      });
      print(id);
    },id: idBank);
  }

  void showNotif(BuildContext context){
    WidgetHelper().notifOneBtnDialog(context,title,desc, (){
      if(widget.title=='TOP UP'){
        Navigator.pop(context);
        WidgetHelper().myPushAndLoad(context,SuccessPembelianScreen(kdTrx: FunctionHelper().decode(kdTrx),),(){
          setState(() {
            isLoading=true;
          });
          loadConfig();
        });
      }
      if(widget.title=='PENARIKAN'){
        if(!isHaveKtp&&idCard=='-'){
          WidgetHelper().myModal(context,CameraWidget(callback: (img,pureImage)async{
            setState(() {
              image=img;
            });
            await Future.delayed(Duration(seconds: 1));
            WidgetHelper().notifDialog(context, "Informasi","Gambar berhasil diambil",(){Navigator.pop(context);},(){
              handleUpdate(context);
            });
            // handleUpdate(context);
          }));
        }else if(!isHaveKtp&&idCard!='-'){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        }else{
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        }
      }
      print(isHaveKtp);


    });
  }
}
