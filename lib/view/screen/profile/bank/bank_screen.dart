import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/data_bank_model.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/bank_member_model.dart';
import 'package:sangkuy/provider/bank_provider.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/member_provider.dart';
import 'package:sangkuy/view/widget/error_widget.dart';
import 'package:sangkuy/view/widget/loading/package_loading.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class BankScreen extends StatefulWidget {
  @override
  _BankScreenState createState() => _BankScreenState();
}

class _BankScreenState extends State<BankScreen> {
  BankMemberModel bankMemberModel;
  bool isLoading=false,isError=false,isLoadmore=false;
  int perpage=10,total=0;
  Future loadData()async{
    var res = await MemberProvider().getBankMember("page=1&limit$perpage");
    if(res=='error'){
      isLoading=false;isError=true;
      if(this.mounted)setState((){});
    }
    else if(res==Constant().errExpToken){
      isLoading=true;isError=false;
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        await FunctionHelper().logout(context);
      });
      if(this.mounted)setState((){});
    }
    else{
      isLoading=false;isError=false;
      bankMemberModel = res;
      if(this.mounted)setState((){});
    }

  }

  Future deleteBank(id)async{
    WidgetHelper().loadingDialog(context);
    var res = await BaseProvider().deleteProvider("bank_member/$id", generalFromJson);
    Navigator.pop(context);
    if(res==Constant().errTimeout||res==Constant().errSocket){
      WidgetHelper().showFloatingFlushbar(context,"failed","terjadi kesalahan koneksi");
    }

    else{
      WidgetHelper().showFloatingFlushbar(context,"success","data berhasil dihapus");
      loadData();
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,"Bank",(){Navigator.pop(context);},<Widget>[
        IconButton(icon: Icon(AntDesign.pluscircleo), onPressed: (){
          WidgetHelper().myModal(context,ModalFormBank(val:null,callback: (param){
            loadData();
          }));
        })
      ]),
      body: isLoading?AddressLoading(tot: 5,):isError?ErrWidget(callback: (){loadData();}):RefreshWidget(
        widget: Column(
          children: [
            Expanded(
                flex:16,
                child: ListView.separated(
                    itemBuilder: (context,index){
                      var val=bankMemberModel.result.data[index];
                      return Container(
                          padding: EdgeInsets.only(bottom:10.0,top:10.0,left:15.0,right:15.0),
                          width: double.infinity,
                          color: Colors.transparent,
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
                                        Icon(AntDesign.bank,size: 20,color:Constant().darkMode),
                                        SizedBox(width:5.0),
                                        WidgetHelper().textQ(val.bankName,12,Constant().darkMode, FontWeight.bold),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: (){
                                        WidgetHelper().notifDialog(context, "Perhatian !!","anda yakin akan menghapus data ini ??", (){Navigator.pop(context);},()async{
                                          Navigator.pop(context);
                                          deleteBank(val.id);
                                          // await deleteAddress(val.id);
                                        });
                                      },
                                      child:Icon(AntDesign.delete,color:Constant().moneyColor),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        WidgetHelper().textQ(val.accNo,12,Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                                        SizedBox(height:5.0),
                                        WidgetHelper().textQ(val.accName,12,Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                                      ],
                                    ),
                                    WidgetHelper().baseImage('https://upload.wikimedia.org/wikipedia/commons/7/72/MasterCard_early_1990s_logo.png',width: 20,height: 20,fit: BoxFit.contain)
                                  ],
                                ),
                              ),
                              SizedBox(height:10),
                              InkWell(
                                onTap: (){
                                  WidgetHelper().myModal(context,ModalFormBank(val: val.toJson(),callback: (param){
                                    print(param);
                                    // WidgetHelper().showFloatingFlushbar(context,"success","ubah data bank berhasil dilakukan");
                                    loadData();
                                  }));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Constant().mainColor),
                                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                                  ),
                                  child: WidgetHelper().textQ("Ubah Bank",14,Constant().mainColor,FontWeight.bold,textAlign: TextAlign.center),
                                ),
                              )
                            ],
                          )
                      );
                    },
                    separatorBuilder: (context,index){
                      return Divider(thickness: 5);
                    },
                    itemCount: bankMemberModel.result.data.length
                )
            ),
            isLoadmore?Expanded(flex:4,child: AddressLoading(tot: 1)):Text('')
          ],
        ),
        callback: (){
          isLoading=true;
          setState(() {});
          loadData();
        },
      ),
    );
  }
}

class ModalFormBank extends StatefulWidget {
  dynamic val;
  Function(int param) callback;
  ModalFormBank({this.val,this.callback});
  @override
  _ModalFormBankState createState() => _ModalFormBankState();
}

class _ModalFormBankState extends State<ModalFormBank> {
  var bankNameController = TextEditingController();
  final FocusNode bankNameFocus = FocusNode();
  var accNameController = TextEditingController();
  final FocusNode accNameFocus = FocusNode();
  var accNoController = TextEditingController();
  final FocusNode accNoFocus = FocusNode();
  
  Future checkData()async{
    if(widget.val!=null){
      setState(() {
        bankNameController.text=widget.val['bank_name'];
        accNameController.text=widget.val['acc_name'];
        accNoController.text=widget.val['acc_no'];
      });
    }
  }

  Future storeBank()async{
    final data={
      "bank_name":bankNameController.text,
      "acc_name":accNameController.text,
      "acc_no":accNoController.text
    };
    WidgetHelper().loadingDialog(context);
    var res;
    if(widget.val==null){
      res = await BaseProvider().postProvider("bank_member", data);
    }else{
      res = await BaseProvider().putProvider("bank_member/${widget.val['id']}", data);
    }

    Navigator.pop(context);
    if(res!=null){
      widget.callback(1);
      // Navigator.pop(context);
      Navigator.pop(context);
      WidgetHelper().showFloatingFlushbar(context,"success","data berhasil disimpan");
    }
    // if(res==Constant().errTimeout||res==Constant().errSocket){
    //   WidgetHelper().notifDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){
    //     Navigator.pop(context);
    //   },(){
    //     Navigator.pop(context);
    //     storeBank();
    //   },titleBtn1: 'Kembali',titleBtn2: 'Coba lagi');
    // }
    // else if(res is General){
    //   General result=res;
    //   WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    // }
    // else{
    //   widget.callback(1);
    //   // Navigator.pop(context);
    //   Navigator.pop(context);
    //   WidgetHelper().showFloatingFlushbar(context,"success","data berhasil disimpan");
    //   // WidgetHelper().notifOneBtnDialog(context,"Berhasil !","Tambah data bank berhasil dilakukan",(){
    //   //   WidgetHelper().myPush(context,BankScreen());
    //   // });
    // }
  }

  int idxBank=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
      ),
      // color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
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
            title: WidgetHelper().textQ("${widget.val==null?'Tambah':'Ubah'} Bank",14, Theme.of(context).hintColor, FontWeight.bold),
            trailing: InkWell(
                onTap: ()async{
                  storeBank();
                  // storeAddress();
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
          Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetHelper().textQ("Bank",12,Constant().darkMode, FontWeight.bold),
                  SizedBox(height:5.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)
                      ),
                    ),
                    padding: EdgeInsets.only(left:10.0,right:10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color:Constant().darkMode,fontSize:14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                      controller: bankNameController,
                      focusNode: bankNameFocus,
                      autofocus: false,
                      readOnly: true,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          hintStyle: TextStyle(color:Constant().darkMode,fontSize: 14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                      ),
                      onTap: (){
                        WidgetHelper().myModal(context,DataBank(callback: (val,idx){
                          setState(() {
                            bankNameController.text = val['name'];
                            idxBank=idx;
                          });
                          FunctionHelper().fieldFocusChange(context,bankNameFocus,accNameFocus);
                        },name:bankNameController.text,idx: idxBank));
                      },
                      onFieldSubmitted: (_){

                        // WidgetHelper().fieldFocusChange(context, titleFocus,receiverFocus);
                      },
                    ),
                  ),
                  SizedBox(height:10.0),
                  WidgetHelper().textQ("Atas Nama",12,Constant().darkMode, FontWeight.bold),
                  SizedBox(height:5.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)
                      ),
                    ),
                    padding: EdgeInsets.only(left:10.0,right:10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color:Constant().darkMode,fontSize:14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                      controller: accNameController,
                      focusNode: accNameFocus,
                      autofocus: false,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          hintStyle: TextStyle(color:Constant().darkMode,fontSize: 14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                      ),
                      onFieldSubmitted: (_){
                        FunctionHelper().fieldFocusChange(context,accNameFocus,accNoFocus);
                        // WidgetHelper().
                        // WidgetHelper().fieldFocusChange(context, titleFocus,receiverFocus);
                      },
                    ),
                  ),
                  SizedBox(height:10.0),
                  WidgetHelper().textQ("No.Rekening",12,Constant().darkMode, FontWeight.bold),
                  SizedBox(height:5.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.all(
                          Radius.circular(10.0)
                      ),
                    ),
                    padding: EdgeInsets.only(left:10.0,right:10.0),
                    child: TextFormField(
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color:Constant().darkMode,fontSize:14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                      controller: accNoController,
                      focusNode: accNoFocus,
                      autofocus: false,
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none,),
                          hintStyle: TextStyle(color:Constant().darkMode,fontSize: 14,fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold)
                      ),
                      onFieldSubmitted: (_){
                        // WidgetHelper().fieldFocusChange(context, titleFocus,receiverFocus);
                      },
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

}


class DataBank extends StatefulWidget {
  Function(dynamic id,int idx) callback;
  String name;
  int idx;
  DataBank({this.callback,this.name,this.idx});
  @override
  _DataBankState createState() => _DataBankState();
}

class _DataBankState extends State<DataBank> {
  DataBankModel dataBankModel;
  bool isLoading=false,isError=false,isLoadmore=false;
  int perpage=10,total=0;
  String name='';
  int idx=0;
  List data=[];
  ItemScrollController _scrollController = ItemScrollController();
  ItemPositionsListener itemPositionListener = ItemPositionsListener.create();
  Future loadData()async{
    var res = await BankProvider().getDataBank();
    if(res=='error'){
      isLoading=false;isError=true;
      if(this.mounted)setState((){});
    }
    else if(res==Constant().errExpToken){
      isLoading=true;isError=false;
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        await FunctionHelper().logout(context);
      });
      if(this.mounted)setState((){});
    }
    else{
      isLoading=false;isError=false;
      dataBankModel = res;
      dataBankModel.result.forEach((element) {
        data.add({
          "id": element.id,
          "name":element.name,
          "code": element.code
        },);
      });
      // data.add(dataBankModel.toJson());
      if(this.mounted)setState((){});
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading=true;
    name = widget.name;
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      height: MediaQuery.of(context).size.height/1.2,
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
      ),
      // color: Colors.white,
      child: isLoading?WidgetHelper().loadingWidget(context):Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
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
            title: WidgetHelper().textQ("Daftar Bank",14, Theme.of(context).hintColor, FontWeight.bold),
          ),
          Divider(),
          SizedBox(height:10.0),

          Expanded(
            child: Scrollbar(
                child: ScrollablePositionedList.separated(
                    padding: EdgeInsets.zero,
                    itemScrollController: _scrollController,
                    itemCount: data.length,
                    initialScrollIndex: widget.idx,
                    itemBuilder: (context,index){
                      var val=data[index];
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
                        onTap: (){
                          widget.callback(val,index);
                          setState(() {
                            idx = index;
                            widget.idx=index;
                            name=val['name'];
                          });
                          Navigator.pop(context);
                        },
                        title: WidgetHelper().textQ(val['name'], 12, Constant().darkMode,FontWeight.bold),
                        trailing: Icon(AntDesign.checkcircleo,color: name==val['name']?Constant().mainColor:Colors.transparent),
                      );
                    },
                    separatorBuilder: (context,index){return Divider();},
                    // itemCount: data.length
                )
            ),
          )
        ],
      ),
    );
  }
}



