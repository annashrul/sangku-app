import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/member/bank_member_model.dart';
import 'package:sangkuy/provider/member_provider.dart';
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
  bool  isLoadingBank=false,isError=false;
  Future loadBank()async{
    var res=await MemberProvider().getBankMember("page=1");
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
      if(this.mounted){
        isLoadingBank=false;
        isError=false;
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
    )): ListView.separated(
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
          titleColor: Constant().secondDarkColor,
          prefixBadge: Theme.of(context).focusColor.withOpacity(0.3),
          title: '${val.bankName} ( ${val.accNo} )',
          description: '${val.accName}',
          descriptionColor: Colors.grey[400],
          suffixIcon:AntDesign.checkcircleo,
          suffixIconColor: widget.id==val.id?Colors.grey:Colors.transparent,
          backgroundColor: Theme.of(context).focusColor.withOpacity(0.3),
        );
      },
      separatorBuilder: (_,i){return(Text(''));},
    );
  }
}
