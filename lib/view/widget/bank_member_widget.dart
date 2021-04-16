import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/member/bank_member_model.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/screen/profile/bank/bank_screen.dart';
import 'package:sangkuy/view/widget/card_widget.dart';

class BankMemberWidget extends StatefulWidget {
  Function(dynamic data) callback;
  String id;
  BankMemberWidget({this.callback,this.id});
  @override
  _BankMemberWidgetState createState() => _BankMemberWidgetState();
}

class _BankMemberWidgetState extends State<BankMemberWidget> {
  BankMemberModel bankModel;
  List bank=[];
  bool  isLoadingBank=false;
  int total=0;
  Future loadBank()async{
    var res=await MemberProvider().getBankMember("page=1",context,(){
      Navigator.pop(context);
    });

    if(res==Constant().errNoData){
      setState(() {
        total=0;
        isLoadingBank=false;
      });
    }
    else{
      if(this.mounted){
        total=1;
        isLoadingBank=false;
        bankModel = res;
        widget.callback(bankModel.result.data[0]);
        widget.id=bankModel.result.data[0].id;
        setState(() { });
      }
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoadingBank=true;
    loadBank();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingBank?WidgetHelper().baseLoading(context,Container(
      height: 50,
      width: double.infinity,
      color: Colors.white,
    )): total<1?Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetHelper().textQ("Anda belum mempunyai akun bank",12, Constant().darkMode,FontWeight.bold),
        SizedBox(height: 10),
        InkWell(
          onTap: (){
            WidgetHelper().myModal(context,ModalFormBank(val: null,callback: (param){
              setState(() {
                isLoadingBank=true;
              });
              loadBank();
            }));
          },
          child: WidgetHelper().textQ("Buat Akun Bank",12, Constant().mainColor,FontWeight.bold,textDecoration: TextDecoration.underline),
        )
      ],
    ):ListView.separated(
      addRepaintBoundaries: true,
      primary: false,
      shrinkWrap: true,
      itemCount: bankModel.result.data.length,
      itemBuilder: (context,index){
        var val=bankModel.result.data[index];
        return CardWidget(
          onTap:(){
            widget.callback(val);
          },
          titleColor: Constant().darkMode,
          prefixBadge:Constant().darkMode,
          title: '${val.bankName}',
          description: '${val.accName}  ( ${val.accNo} )',
          descriptionColor: Constant().darkMode,
          suffixIcon:AntDesign.checkcircleo,
          suffixIconColor: widget.id==val.id?Constant().darkMode:Colors.transparent,
          backgroundColor: Constant().greyColor,
        );
      },
      separatorBuilder: (_,i){return(Text(''));},
    );
  }
}
