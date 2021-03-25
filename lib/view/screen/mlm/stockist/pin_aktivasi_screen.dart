import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:html/parser.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/available_member_model.dart';
import 'package:sangkuy/model/mlm/package/site_package_model.dart';
import 'package:sangkuy/model/mlm/stockist/pin_available_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/mlm/stockist/stockist_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';

class PinAktivasiScreen extends StatefulWidget {
  final String type;
  PinAktivasiScreen({this.type});
  @override
  _PinAktivasiScreenState createState() => _PinAktivasiScreenState();
}

class _PinAktivasiScreenState extends State<PinAktivasiScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PinAvailableModel pinAvailableModel;
  bool isLoading=true;
  int perpage=15,total=0;
  Future loadPin()async{
    var res=await BaseProvider().getProvider('transaction/pin_available?type=${widget.type}', pinAvailableModelFromJson,context: context,callback: (){

    });
    print(res);
    if(res is PinAvailableModel){
      PinAvailableModel result=res;
      setState(() {
        isLoading=false;
        pinAvailableModel=result;
        // total=pinAvailableModel.result
      });
    }
    else{
      setState(() {
        isLoading=false;
        // pinAvailableModel=result;
      });
    }
  }

  Future handleAktivasi(dynamic val)async{
    print(val['id']);
    if(int.parse(val['jumlah'])>0){
      WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
        final data={
          "pin_member":pin.toString(),
          "id_membership":val['id']
        };
        WidgetHelper().loadingDialog(context);
        var res=await BaseProvider().postProvider('pin/aktivasi/ro', data,context: context,callback: (){
          Navigator.pop(context);
          Navigator.pop(context);
        });
        if(res!=null){
          Navigator.pop(context);
          WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
            WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          });
        }
      }));
    }
    else{
      // Navigator.pop(context);
      WidgetHelper().showFloatingFlushbar(context,"failed","Maaf, anda tidak memiliki pin");
    }
  }

  Future handleReaktivasi(dynamic val)async{
    if(int.parse(val['jumlah'])>0){
      WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
        WidgetHelper().loadingDialog(context);
        final data={
          "pin_member":pin.toString(),
          "pin_reaktivasi":val['id']
        };
        var res=await BaseProvider().postProvider('pin/reaktivasi', data,context: context);
        if(res!=null){
          Navigator.pop(context);
          WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
            WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
          });
        }
      }));
    }
    else{
      WidgetHelper().showFloatingFlushbar(context,"failed","Maaf, anda tidak memiliki pin");
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadPin();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,'Pin ${widget.type=='ro'?'Repeat Order':'Aktivasi'}',(){Navigator.pop(context);},<Widget>[]),
      body: isLoading?WidgetHelper().loadingWidget(context):ListView.separated(
          itemBuilder: (context,index){
            var val=pinAvailableModel.result[index];
            return FlatButton(
              // color: Constant().mainColor,
                onPressed: (){
                  WidgetHelper().myPush(context,StockistScreen(type: val.title));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: WidgetHelper().baseImage(val.badge),
                      title: WidgetHelper().textQ(val.title, scaler.getTextSize(10),Constant().mainColor2,FontWeight.bold),
                      subtitle: WidgetHelper().textQ("Jumlah Pin : ${val.jumlah}", scaler.getTextSize(10),Constant().mainColor1,FontWeight.bold),
                    ),
                    Row(
                      children: [
                        widget.type=='ro'?WidgetHelper().myBtnBorder(context,'Aktivasi',(){
                          WidgetHelper().notifDialog(context,"Aktivasi Pin RO","Aktivasi Pin Repeat Order ( RO ) paket ${val.title}", (){
                            Navigator.pop(context);
                          }, (){
                            Navigator.pop(context);
                            handleAktivasi(val.toJson());
                          }, titleBtn1: "Batal",titleBtn2: "Oke, Aktivasi");
                          // WidgetHelper().myModal(context,ReaktivasiPin(title: "Paket ${val.title}",id: val.id,pin: val.jumlah));
                        },Constant().mainColor):WidgetHelper().myBtnBorder(context,'Reaktivasi',(){
                          WidgetHelper().notifDialog(context,"Reaktivasi Pin","Reaktivasi Pin paket ${val.title}", (){
                            Navigator.pop(context);
                          }, (){
                            Navigator.pop(context);
                            handleReaktivasi(val.toJson());
                          }, titleBtn1: "Batal",titleBtn2: "Oke, Reaktivasi");

                          // WidgetHelper().myModal(context,ReaktivasiPin(title: "Paket ${val.title}",id: val.id,pin: val.jumlah));
                        },Constant().mainColor),
                        SizedBox(width: scaler.getWidth(1)),
                        WidgetHelper().myBtnBorder(context,'Transfer',(){
                          WidgetHelper().myModal(context,TransferPinAkivasi(val:val.toJson()));
                        },Constant().moneyColor),
                      ],
                    )
                  ],
                )
            );
          },
          separatorBuilder: (context,index){return Container(
            margin: EdgeInsets.only(top: 10),
            child: Divider(thickness: 5),
          );},
          itemCount: pinAvailableModel.result.length
      ),
    );
  }
}





class TransferPinAkivasi extends StatefulWidget {
  final dynamic val;
  TransferPinAkivasi({this.val});

  @override
  _TransferPinAkivasiState createState() => _TransferPinAkivasiState();
}

class _TransferPinAkivasiState extends State<TransferPinAkivasi> {
  final FocusNode penerimaFocus = FocusNode();
  var penerimaController = TextEditingController();
  AvailableMemberModel availableMemberModel;
  bool isNext=false;
  Future checkingAccount()async{
    if(penerimaController.text==''){
      penerimaFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed","silahkan masukan id penerima");
    }
    else{
      WidgetHelper().loadingDialog(context);
      var checkingMember=await BaseProvider().getProvider('member/data/${penerimaController.text}', availableMemberModelFromJson,context: context,callback: (){
        Navigator.pop(context);
        WidgetHelper().loadingDialog(context);
        checkingAccount();
      });
      Navigator.pop(context);
      if(checkingMember is General){
        General result=checkingMember;
        return WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);

      }
      else{
        availableMemberModel = checkingMember;
        penerimaFocus.unfocus();
        isNext=true;
        setState(() {});
        // WidgetHelper().showFloatingFlushbar(context,"success","Akun terdaftar sebagai member kami");
        // print(checkingMember.toJson());
        // setState(() {
        //   msg='';
        //   availableMemberModel = checkingMember;
        // });
      }
    }


  }

  Future handleTransfer()async{
    if(int.parse(widget.val['jumlah'])>0){
      WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
        WidgetHelper().loadingDialog(context);
        final data={
          "pin_member":pin,
          "id_membership":widget.val['id'],
          "uid":availableMemberModel.result.referralCode
        };
        var res = await BaseProvider().postProvider("pin/transfer", data,context: context,callback: (){
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        });
        print(res);
        if(res!=null){
          Navigator.pop(context);
          WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));});
        }


      }));
    }
    else{
      WidgetHelper().showFloatingFlushbar(context,"failed","Maaf, anda tidak memiliki pin");
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(availableMemberModel.result==null?'null':'ada');
    penerimaFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
      ),
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height:scaler.getHeight(1)),
          Center(
            child: Container(
              padding:scaler.getPaddingByHeight(1),
              width: scaler.getWidth(10),
              height: scaler.getHeight(1),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          SizedBox(height:scaler.getHeight(1)),
          ListTile(
            leading: WidgetHelper().baseImage(widget.val['badge']),
            title: WidgetHelper().textQ("Transfer Pin Paket ${widget.val['title']}", scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
          ),
          SizedBox(height:scaler.getHeight(1)),
          Container(
            margin: scaler.getMargin(0,2),
            child:WidgetHelper().textQ("Masukan ID penerima yang akan di transfer", scaler.getTextSize(9),Constant().darkMode,FontWeight.normal),
          ),
          SizedBox(height:scaler.getHeight(0.5)),
          Container(
            margin: scaler.getMargin(0,2),
            width: double.infinity,
            padding: EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              color: Color(0xFFEEEEEE),
            ),
            child: TextFormField(
              style: TextStyle(letterSpacing:2.0,fontSize:14,fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color:Constant().darkMode),
              controller: penerimaController,
              maxLines: 1,
              autofocus: false,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                suffixIcon:InkWell(
                  onTap: ()async{
                    penerimaFocus.unfocus();
                    final qr = await FunctionHelper().scanQR();
                    penerimaController.text = qr;
                    setState(() {});
                    // penerimaFocus.unfocus();
                    // checkingAccount();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Constant().mainColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                    ),
                    child: Icon(AntDesign.scan1,color:Colors.white),
                  ),
                ),
                contentPadding: const EdgeInsets.only(top: 19.0, right: 0.0, bottom: 0.0, left: 0.0),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              focusNode: penerimaFocus,
              // textCapitalization: TextCapitalization.sentences,
              textCapitalization: TextCapitalization.characters,
              onFieldSubmitted: (e){
                penerimaFocus.unfocus();
                checkingAccount();
              },

            ),
          ),
          isNext?ListTile(
            onTap: (){},
            leading: WidgetHelper().baseImage(availableMemberModel.result.picture),
            title: WidgetHelper().textQ(availableMemberModel.result.fullName, scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
            subtitle: WidgetHelper().textQ(availableMemberModel.result.referralCode, scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
            trailing: WidgetHelper().baseImage(availableMemberModel.result.badge),
          ):Text(''),
          Divider(thickness: 10),
          SizedBox(height:scaler.getHeight(1)),
          Container(
            margin: scaler.getMargin(0,2),
            alignment: Alignment.bottomCenter,
            color: Constant().moneyColor,
            child:  FlatButton(
                padding: EdgeInsets.all(15.0),
                onPressed: (){
                  isNext?handleTransfer():checkingAccount();
                  // checkingAccount();
                  // handleSubmit();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(AntDesign.checkcircleo,color: Colors.white),
                    SizedBox(width: 10.0),
                    WidgetHelper().textQ(isNext?"TRANSFER PIN":"PERIKSA AKUN", 14,Colors.white,FontWeight.bold)
                  ],
                )
            ),
          ),
          SizedBox(height:scaler.getHeight(1)),

        ],
      ),
    );
  }
}


