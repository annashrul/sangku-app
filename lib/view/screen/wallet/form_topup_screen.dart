import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/money_format_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/wallet/config_wallet_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/mlm/history/success_pembelian_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/bank_widget.dart';
import 'package:sangkuy/view/widget/confirm_widget.dart';
import 'package:sangkuy/view/widget/detail_scaffold.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/loading/member_loading.dart';
import 'package:sangkuy/view/widget/nominal_widget.dart';
import 'package:sangkuy/view/widget/wrapper_page_widget.dart';

class FormTopupScreen extends StatefulWidget {
  @override
  _FormTopupScreenState createState() => _FormTopupScreenState();
}

class _FormTopupScreenState extends State<FormTopupScreen> {
  final FocusNode nominalFocus = FocusNode();
  var nominalController = MoneyMaskedTextControllerQ(decimalSeparator: '', thousandSeparator: ',');
  String idBank='';
  int saldo=0;
  int idx=10;
  dynamic dataBank;
  dynamic data;
  ConfigWalletModel configWalletModel;

  Future handleNext()async{
    String msg='';
    if(nominalController.text==''){
      msg='nominal tidak boleh kosong';
      nominalFocus.requestFocus();
    }
    else if(nominalController.text=='0'){
      msg='nominal harus lebih dari 0';
      nominalFocus.requestFocus();
    }
    else if(int.parse(nominalController.text.replaceAll(",",""))<saldo){
      msg='Deposit minimal Rp ${FunctionHelper().formatter.format(saldo)}';
      nominalFocus.requestFocus();
    }
    if(msg==''){
      nominalFocus.unfocus();
      data={
        "nominal":nominalController.text.replaceAll(",",""),
        "admin":"0",
        "total":int.parse(nominalController.text.replaceAll(",",""))+0,
        "bankTujuan":dataBank['bank_name'],
        "atasNama":dataBank['acc_name'],
      };
      setState(() {
        // data={"data1":""};
      });
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

  bool isPending=false;

  Future checkout(pin)async{
    print(pin);
    print(dataBank['id']);
    final val={
      "id_bank_destination":dataBank['id'],
      "amount":data['nominal'],
      "member_pin":pin
    };
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().postProvider("transaction/deposit", val);
    Navigator.pop(context);
    if(res==Constant().errTimeout||res==Constant().errSocket){
      WidgetHelper().showFloatingFlushbar(context,"failed","Terjadi Kesalahan Koneksi");
    }
    else if(res==Constant().errExpToken){
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        FunctionHelper().logout(context);
      });
    }
    else{
      if(res is General){
        General result = res;
        WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
      }
      else{
        if(res['status']=='failed'){
          print("RESPONSE CHECKOUT ${res['result']}");
          WidgetHelper().notifDialog(context,"Informasi",res['msg'], (){
            WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          }, (){
            WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          },titleBtn1: "Kembali",titleBtn2: "Detail Transksi");
          // WidgetHelper().showFloatingFlushbar(context,"failed",res['msg']);
        }else{
          print("RESPONSE CHECKOUT ${res['result']}");
          WidgetHelper().showFloatingFlushbar(context,"success",Constant().descMsgSuccessTrx);
          await Future.delayed(Duration(seconds: 2));
          WidgetHelper().myPushRemove(context, SuccessPembelianScreen(kdTrx: base64.encode(utf8.encode(res['result']['kd_trx']))));
        }
      }
    }

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WrapperPageWidget(children: [
        ClipPath(
          clipper: WaveClipperOne(flip: true),
          child: Container(
              padding: EdgeInsets.only(bottom:50.0,top:10.0,left:10.0),
              width: double.infinity,
              color: Constant().secondColor,
              child:Padding(
                padding: EdgeInsets.only(left:10,right:10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetHelper().titleNoButton(context,AntDesign.wallet,"Pilih Nominal Cepat",color: Colors.grey[200]),
                    SizedBox(height: 10.0),
                    NominalWidget(callback: (amount,index){
                      setState(() {
                        nominalController.text=amount;
                        idx=index;
                      });
                    },idx:idx),
                    SizedBox(height: 20.0),
                    WidgetHelper().titleNoButton(context,AntDesign.wallet,"Masukan Nominal",color: Colors.grey[200]),
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).focusColor.withOpacity(0.3),
                      ),
                      child: TextFormField(
                        style: TextStyle(letterSpacing:2.0,fontSize:14,fontWeight: FontWeight.normal,fontFamily: Constant().fontStyle,color:Constant().secondDarkColor),
                        controller: nominalController,
                        maxLines: 1,
                        autofocus: false,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1)),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          prefixText: 'Rp.',
                          hintStyle: TextStyle(color:Constant().secondDarkColor, fontSize:12,fontFamily:Constant().fontStyle),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        focusNode: nominalFocus,
                        onFieldSubmitted: (term){
                        },
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(13),
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
                    SizedBox(height: 20.0),
                    WidgetHelper().titleNoButton(context,AntDesign.bank,"Pilih Bank Tujuan",color: Colors.grey[200]),
                    Divider(),
                    BankWidget(callback: (val){
                      print(val);
                      setState(() {
                        idBank=val['id'];
                        dataBank=val;
                      });
                    },id: idBank,isSaldo: false),
                    SizedBox(height: 70.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      child: FlatButton(
                          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
                          onPressed: () {
                            handleNext();
                          },
                          padding: EdgeInsets.symmetric(vertical: 0,horizontal: 20),
                          color: Constant().mainColor,
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
                    )
                  ],
                ),
              )
          ),
        ),
      ],callback:(val){
        if(val['trx_dp']!='-'){
          setState(() {
            isPending=true;
          });
        }
        setState(() {
          saldo=int.parse(val['dp_min']);
        });
      }),
    );
  }

}


