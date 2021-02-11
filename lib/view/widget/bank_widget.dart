import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/mlm/bank_model.dart';
import 'package:sangkuy/provider/bank_provider.dart';
import 'package:sangkuy/view/widget/card_widget.dart';

class BankWidget extends StatefulWidget {
  Function(dynamic data) callback;
  String id;
  bool isSaldo;
  BankWidget({this.callback,this.id,this.isSaldo});
  @override
  _BankWidgetState createState() => _BankWidgetState();
}

class _BankWidgetState extends State<BankWidget> {
  BankModel bankModel;
  List bank=[];
  bool  isLoadingBank=false,isError=false;
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
      if(this.mounted){
        isLoadingBank=false;
        isError=false;
        if(widget.isSaldo){
          bank.add({
            "totalrecords": "2",
            "id": "-",
            "bank_name": "SALDO UTAMA",
            "logo": "http://ptnetindo.com:6694/images/bank/BCA.png",
            "acc_name": "100000",
            "acc_no": "",
            "tf_code": 0,
            "created_at": "2020-12-22T03:50:55.000Z",
            "updated_at": "2020-12-22T03:50:55.000Z"
          });
        }
        res['result']['data'].forEach((element) {
          bank.add(element);
        });
        setState(() {
          widget.callback(bank[0]);
          widget.id=bank[0]['id'];
        });
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
      itemCount: bank.length,
      itemBuilder: (context,index){
        var val=bank[index];
        return CardWidget(
          onTap:(){
            print(val['id']);
            widget.callback(bank[index]);
          },
          titleColor: widget.isSaldo?Constant().darkMode:Constant().secondDarkColor,
          prefixBadge: widget.isSaldo?Constant().secondColor:Theme.of(context).focusColor.withOpacity(0.3),
          title: '${val['bank_name']} ${val['id']=='-'?'':'( ${val['acc_no']} )'}',
          description: '${val['id']=='-'?'Rp '+FunctionHelper().formatter.format(int.parse(val['acc_name']))+' .-':val['acc_name']}',
          descriptionColor: val['id']=='-'?Constant().moneyColor:Colors.grey[400],
          suffixIcon:AntDesign.checkcircleo,
          suffixIconColor: widget.id==val['id']?!widget.isSaldo?Colors.grey[400]:Colors.black:Colors.transparent,
          backgroundColor: widget.isSaldo?Colors.transparent:Theme.of(context).focusColor.withOpacity(0.3),
        );
      },
      separatorBuilder: (_,i){return(Text(''));},
    );
  }
}
