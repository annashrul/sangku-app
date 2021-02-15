import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:html/parser.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/data_helper.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/refresh_widget.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/available_member_model.dart';
import 'package:sangkuy/model/mlm/package/site_package_model.dart';
import 'package:sangkuy/model/mlm/stockist/pin_available_model.dart';
import 'package:sangkuy/model/mlm/stockist/pin_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/stockist_provider.dart';
import 'package:sangkuy/view/screen/auth/secure_code_screen.dart';
import 'package:sangkuy/view/screen/pages.dart';
import 'package:sangkuy/view/widget/card_widget.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:sangkuy/view/widget/stockist_widget.dart';

class StockistScreen extends StatefulWidget {
  final String type;
  StockistScreen({this.type});
  @override
  _StockistScreenState createState() => _StockistScreenState();
}

class _StockistScreenState extends State<StockistScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int filterStatus=0;
  PinModel pinModel;
  String kode='1';
  bool isLoading=false,isError=false,isLoadmore=false;
  bool isNodata=false;
  ScrollController controller;
  int total=0,perpage=15;
  Future loadData()async{
    print(perpage);
    String where='';
    final id=await UserHelper().getDataUser("id_user");
    String url='member/pin/$id?type=${widget.type}&page=1&perpage=$perpage';
    if(kode!=''){
      url+='&status=$kode';
    }
    var res = await BaseProvider().getProvider(url, pinModelFromJson);
    print(res);
    if(res is PinModel){
      PinModel result=res;
      if(result.status=='success'){
        if(this.mounted){
          setState(() {
            pinModel = PinModel.fromJson(result.toJson());
            isLoading=false;
            isError=false;
            isNodata=false;
            isLoadmore=false;
            total=pinModel.result.total;
          });
        }
      }
      else{
        setState(() {
          isLoading=false;
          isError=false;
          isNodata=false;

        });
      }
    }
    else if(res==Constant().errSocket||res==Constant().errTimeout){
      setState(() {
        isLoading=false;
        isError=true;
        isNodata=false;

      });
    }
    else if(res==Constant().errExpToken){
      setState(() {
        isLoading=false;
        isError=false;
        isNodata=false;

      });
      WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        await FunctionHelper().logout(context);
      });
    }
    else if(res is General){
      General result=res;
      setState(() {
        isLoading=false;
        isError=false;
        isNodata=false;

      });
      WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
    }
    else if(res==Constant().errNoData){
      setState(() {
        isLoading=false;
        isError=false;
        isNodata=true;
      });
    }

    // return;
  }
  void _scrollListener() {
    if (!isLoading) {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        print('fetch data');
        if(perpage<total){
          setState((){
            perpage+=10;
            isLoadmore=true;
          });
          loadData();
        }
      }
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
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new ScrollController()..addListener(_scrollListener);
    isLoading=true;
    loadData();
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarWithButton(context,widget.type=='1'?'PIN AKTIVASI':'PIN REPEAT ORDER',(){Navigator.pop(context);},<Widget>[
        FlatButton(
            padding: EdgeInsets.all(10.0),
            highlightColor:Colors.black38,
            splashColor:Colors.black38,
            onPressed:(){
              WidgetHelper().myModal(context, StatusStockistModal(index: filterStatus,callback:(code,idx){
                setState(() {
                  isLoading=true;
                  filterStatus=idx;
                  kode=code;
                });
                loadData();
                // StockistWidget(tipe: '1',status:kode).createState().loadData().then((value) => print(value));
              }));
            },
            child: Icon(AntDesign.filter,color: Colors.grey)
        )
      ]),
      body:RefreshWidget(
        widget: Scrollbar(
            child: Container(
              padding: EdgeInsets.only(left:10.0,right: 10.0,top:10),
              child: Column(
                children: [
                  Expanded(
                    flex: 19,
                    child: isLoading?loading(context,10):!isNodata?ListView.separated(
                        shrinkWrap: true,
                        controller: controller,
                        itemBuilder: (context,index){
                          print(pinModel.result.data[index].toJson());
                          return Container(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:new BorderRadius.circular(4.0),
                              onTap: (){},
                              child: Card(
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(4.0)),
                                elevation: 0.0,
                                color: Color(0xFFEEEEEE),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(child:WidgetHelper().textQ(pinModel.result.data[index].kode, 12, Colors.black, FontWeight.bold)),
                                            SizedBox(height:10.0),
                                            Container(
                                                child:Row(
                                                  children: [
                                                    SvgPicture.asset(
                                                      Constant().localIcon+'lainnya_icon.svg',
                                                      height: 20,
                                                      width: 10,
                                                    ),
                                                    SizedBox(width:10.0),
                                                    WidgetHelper().textQ(pinModel.result.data[index].status, 12, Colors.grey, FontWeight.normal)
                                                  ],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        FlatButton(
                                          color: Constant().blueColor,
                                          padding: EdgeInsets.all(0.0),
                                          child:  WidgetHelper().textQ("Transfer", 10, Constant().secondDarkColor,FontWeight.bold),
                                          onPressed: (){WidgetHelper().myModal(context,TransferPin(val: pinModel.result.data[index].toJson()));},
                                        ),
                                        if(widget.type=='ro')SizedBox(width:5.0),
                                        if(widget.type=='ro')FlatButton(
                                          color: Constant().secondColor,
                                          padding: EdgeInsets.all(0.0),
                                          child:  WidgetHelper().textQ("Aktivasi", 10, Constant().secondDarkColor,FontWeight.bold),
                                          onPressed: (){WidgetHelper().myModal(context,AktivasiRO(val:  pinModel.result.data[index].toJson(),));},
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context,index){return SizedBox(height:1);},
                        itemCount: pinModel.result.data.length
                    ):WidgetHelper().noDataWidget(context),
                  ),
                  isLoadmore?Expanded(
                    flex: 2,
                    child: loading(context,1),
                  ):Text('')
                ],
              ),
            )
        ),
        callback: (){
          setState(() {
            isLoading=true;
          });
          loadData();
        },
      ),
      bottomNavigationBar:widget.type=='1'?Container(
        color: Constant().moneyColor,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child:  FlatButton(
            padding: EdgeInsets.all(15.0),
            onPressed: (){
              WidgetHelper().myModal(context, ReaktivasiPin());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(AntDesign.checkcircleo,color: Colors.white),
                SizedBox(width: 10.0),
                WidgetHelper().textQ("REAKTIVASI", 14,Colors.white,FontWeight.bold)
              ],
            )
        ),
      ):Text(''),
    );
  }
  Widget loading(BuildContext context,int idx){
    return ListView.separated(
        itemBuilder: (context,index){
          return WidgetHelper().baseLoading(context,Card(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
            elevation: 0.0,
            color: Colors.transparent,
            margin: const EdgeInsets.all(0.0),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right:10.0),
                  width: 10.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: new BorderRadius.circular(10.0)
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: MediaQuery.of(context).size.width/2,
                          color:Colors.white,
                        ),
                        SizedBox(height:10.0),
                        Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                shape:BoxShape.circle,
                                color:Colors.white,
                              ),
                            ),
                            SizedBox(width:10.0),
                            Container(
                              height: 10,
                              width: MediaQuery.of(context).size.width/2,
                              color:Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
        },
        separatorBuilder: (context,index){return Divider();},
        itemCount: idx
    );
  }
}


class AktivasiRO extends StatefulWidget {
  dynamic val;
  AktivasiRO({this.val});
  @override
  _AktivasiROState createState() => _AktivasiROState();
}

class _AktivasiROState extends State<AktivasiRO> {
  Future handleSubmit()async{
    WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
      final data={
        "pin_member":pin.toString(),
        "pin_aktivasi":widget.val['kode']
      };
      WidgetHelper().loadingDialog(context);
      var res=await BaseProvider().postProvider('pin/aktivasi/ro', data);
      print(res);
      Navigator.pop(context);
      if(res is General){
        General result=res;
        WidgetHelper().showFloatingFlushbar(context, "failed",result.msg);
      }
      else{
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        });
      }


    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/2.5,
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
          ListTile(
            contentPadding: EdgeInsets.only(right:10.0),
            leading: IconButton(icon: Icon(AntDesign.back,color: Colors.grey), onPressed:(){
                Navigator.pop(context);
            }),
            title: WidgetHelper().textQ("AKTIVASI PIN RO",12,Colors.grey,FontWeight.bold),
          ),
          ClipPath(
            clipper: WaveClipperOne(flip: true),
            child: Container(
              width: double.infinity,
              color: Constant().secondColor,
              padding: EdgeInsets.only(bottom:50.0,top:0.0,left:10.0,right:10.0),
              child: Column(
                children: [
                  Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: WidgetHelper().textQ("${widget.val['kode']}",12,Constant().secondDarkColor,FontWeight.bold),
                      subtitle: WidgetHelper().textQ("${widget.val['full_name']}",12,Colors.grey,FontWeight.bold),
                      trailing:WidgetHelper().textQ("${widget.val['status']}",10,Constant().mainColor,FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 50.0),
                  Container(
                    color: Constant().moneyColor,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child:  FlatButton(
                        padding: EdgeInsets.all(15.0),
                        onPressed: (){
                          handleSubmit();
                          // checkingAccount();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(AntDesign.checkcircleo,color: Colors.white),
                            SizedBox(width: 10.0),
                            WidgetHelper().textQ("AKTIVASI", 14,Colors.white,FontWeight.bold)
                          ],
                        )
                    ),
                  )
                ],
              ),
            ),
          )
        ]

      ),
    );
  }
}


class ReaktivasiPin extends StatefulWidget {
  @override
  _ReaktivasiPinState createState() => _ReaktivasiPinState();
}

class _ReaktivasiPinState extends State<ReaktivasiPin> {
  PinAvailableModel pinAvailableModel;
  bool isLoading=false,isNodata=false,isNext=false;
  String gambar='';
  String title='';
  String id='';
  List<Widget> descWidget;
  List<String> toArray;
  dynamic sitePackage;
  Future loadData()async{
    var res=await BaseProvider().getProvider('transaction/pin_available', pinAvailableModelFromJson);
    if(res is PinAvailableModel){
      PinAvailableModel result=res;
      setState(() {
        isNodata=false;
        isLoading=false;
        pinAvailableModel=result;
      });
    }
    else if(res==Constant().errNoData){
      setState(() {
        isNodata=true;
        isLoading=false;
      });
    }
  }
  Future handleNext(idx)async{
    WidgetHelper().loadingDialog(context);
    var res=await BaseProvider().getProvider('site/paket', sitePackageModelFromJson);
    Navigator.pop(context);
    if(res is SitePackageModel){
      SitePackageModel result=res;
      isNext=true;
      sitePackage = result.result[idx].toJson();
      String rplc = '${sitePackage['deskripsi']}'.replaceAll("</li>","|");
      var htmlToparse=_parseHtmlString(rplc);
      toArray = htmlToparse.split("|");
      toArray.remove("");
      setState(() {});
    }
  }
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }
  Future handleSubmit()async{
    WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
      WidgetHelper().loadingDialog(context);
      final data={
        "pin_member":pin.toString(),
        "pin_reaktivasi":id
      };
      var res=await BaseProvider().postProvider('pin/reaktivasi', data);
      Navigator.pop(context);
      if(res is General){
        General result=res;
        WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
      }else{
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){
          WidgetHelper().myPushRemove(context,IndexScreen(currentTab: 2));
        });
      }
      print(data);
    }));

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
    return Container(
      height: isNext?MediaQuery.of(context).size.height/1.6:MediaQuery.of(context).size.height/2.5,
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
          ListTile(
            contentPadding: EdgeInsets.only(right:10.0),
            leading: IconButton(icon: Icon(AntDesign.back,color: Colors.grey), onPressed:(){
              if(isNext){
                setState(() {
                  isNext=false;
                });
              }else{
                Navigator.pop(context);
              }
            }),
            title: WidgetHelper().textQ(isNext?"Kembali":"REAKTIVASI MEMBERSHIP".toLowerCase(),10,Colors.grey,FontWeight.bold),
            trailing: WidgetHelper().textQ("PIN YANG ANDA MILIKI : ${isLoading?'':pinAvailableModel.result.totalPin}".toLowerCase(),10,Constant().moneyColor,FontWeight.bold),
          ),
          Expanded(
            child: isNext?step2(context):isLoading?ListView.separated(
                itemBuilder: (context,index){
                  return WidgetHelper().baseLoading(context,ListTile(
                    contentPadding: EdgeInsets.only(left:10.0,right:10.0),
                    leading: Container(
                      height: 40.0,
                      width: 40.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                      ),
                    ),
                    title: Container(color: Colors.white,width:70.0,height: 10),
                    subtitle:Container(color: Colors.white,width:100.0,height: 5),
                  ));
                },
                separatorBuilder: (context,index){return Divider();},
                itemCount: 3
            ):ListView.separated(
                itemBuilder: (context,index){
                  var val=pinAvailableModel.result.data[index];

                  return ListTile(
                    onTap: (){
                      print(val.toJson());
                      if(val.jumlah<int.parse(pinAvailableModel.result.totalPin)){
                        handleNext(index);
                        setState(() {
                          id=val.id;
                          gambar=val.badge;
                          title=val.title;
                        });
                      }
                      else{
                        WidgetHelper().showFloatingFlushbar(context,"failed","Jumlah PIN yang anda miliki masih kurang!");
                      }

                    },
                    contentPadding: EdgeInsets.only(left:10.0,right:10.0),
                    leading: Image.network(val.badge,width: 40,height: 40),
                    title: WidgetHelper().textQ(val.title,14,Constant().darkMode,FontWeight.bold),
                    subtitle: WidgetHelper().textQ('Dibutuhkan sebanyak ${val.jumlah} PIN',10,Constant().darkMode,FontWeight.normal),
                    trailing: Icon(AntDesign.checkcircleo,color: id==val.id?Constant().mainColor:Colors.transparent),
                  );
                },
                separatorBuilder: (context,index){return Divider();},
                itemCount: pinAvailableModel.result.data.length
            ),
          ),

          if(isNext)Container(
            color: Colors.redAccent,
            child: FlatButton(
              padding: EdgeInsets.all(10.0),
              child: WidgetHelper().textQ('Saat anda melakukan Reaktivasi, maka akan mempengaruhi Advantage yang akan anda peroleh kedepannya, pikirkan baik-baik jika akan melakukan reaktivasi dibawah membership anda saat ini.', 10, Colors.white, FontWeight.normal,maxLines: 100),
            ),
          )
        ],
      ),
    );
  }
  Widget step2(BuildContext context){
    return ListView(
      children: [
        Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color:Colors.grey[200])
                    ),
                    width: (MediaQuery.of(context).size.width/1.7),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0)),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: gambar,
                              width: double.infinity ,
                              fit:BoxFit.contain,
                              placeholder: (context, url) => Image.asset(Constant().localAssets+'logo.png', fit:BoxFit.fill,width: double.infinity,),
                              errorWidget: (context, url, error) => Image.asset(Constant().localAssets+'logo.png', fit:BoxFit.fill,width: double.infinity,),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetHelper().textQ('Keuntungan Yang Akan Didapatkan dari ${sitePackage['title']}', 10,Constant().darkMode,FontWeight.bold,textAlign: TextAlign.center),
                              SizedBox(height: 14),
                              for(var i=0;i<toArray.length;i++)
                                Container(
                                  margin: EdgeInsets.only(bottom:10),
                                  child: desc(toArray[i]),
                                )
                            ],
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                            padding: EdgeInsets.all(10.0),
                            color: Constant().moneyColor,
                            onPressed: (){
                              handleSubmit();
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                                SizedBox(width:10.0),
                                WidgetHelper().textQ("Aktivasi", 12, Constant().secondDarkColor, FontWeight.normal),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      // width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0)), color:Constant().mainColor),
                      alignment: AlignmentDirectional.topCenter,
                      child: WidgetHelper().textQ('$title', 14,Constant().secondDarkColor,FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
  Widget desc(String desc){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(AntDesign.checkcircleo,size: 10),
        SizedBox(width: 5.0),
        Flexible(
          child: WidgetHelper().textQ('$desc', 8,Constant().darkMode,FontWeight.normal),
          // child: Html(data: desc),
        ),
      ],
    );
  }
}

class TransferPin extends StatefulWidget {
  final dynamic val;
  TransferPin({this.val});
  @override
  _TransferPinState createState() => _TransferPinState();
}

class _TransferPinState extends State<TransferPin> {
  final FocusNode penerimaFocus = FocusNode();
  var penerimaController = TextEditingController();
  AvailableMemberModel availableMemberModel;
  String msg='';
  bool isNext=false;
  Future checkingAccount()async{
    if(penerimaController.text==''){
      setState(() {
        msg='Penerima tidak boleh kosong';
      });
    }
    else{
      WidgetHelper().loadingDialog(context);
      var checkingMember=await BaseProvider().getProvider('member/data/${penerimaController.text}', availableMemberModelFromJson);
      Navigator.pop(context);
      print(checkingMember);
      if(checkingMember is General){
        General result=checkingMember;
        setState(() {
          msg=result.msg;
        });
      }
      else{
         setState(() {
           msg='';
           availableMemberModel = checkingMember;
         });
      }
    }

    if(msg!=''){
      WidgetHelper().showFloatingFlushbar(context,"failed",msg);
      setState(() {
        isNext=false;
      });
      return;
    }
    else{
      setState(() {
        isNext=true;
        msg='';
      });
    }
    // print(checkingMember);
  }
  Future handleSubmit()async{
    WidgetHelper().myPush(context,PinScreen(callback: (context,isTrue,pin)async{
      WidgetHelper().loadingDialog(context);
      final data={
        "pin_member":pin,
        "pin_transfer":widget.val['kode'],
        "uid":availableMemberModel.result.referralCode
      };
      var res = await BaseProvider().postProvider("pin/transfer", data);
      print(res);

      Navigator.pop(context);
      if(res is General){
        General result=res;
        setState(() {
          msg = result.msg;
        });
      }
      if(msg!=''){
        WidgetHelper().showFloatingFlushbar(context,"failed",msg);
      }else{
        WidgetHelper().notifOneBtnDialog(context,Constant().titleMsgSuccessTrx,Constant().descMsgSuccessTrx,(){WidgetHelper().myPushRemove(context, IndexScreen(currentTab: 2));});
        // WidgetHelper().showFloatingFlushbar(context,"success",msg);
        print(res);
      }
    }));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.val);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height/1.5,
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
          ListTile(
            contentPadding: EdgeInsets.only(right:10.0),
            leading: IconButton(icon: Icon(AntDesign.back,color: Colors.grey), onPressed:(){
                // !isNext?Navigator.pop(context):;
              if(isNext){
                setState(() {
                  isNext=false;
                });
              }
              else{
                Navigator.pop(context);
              }
            }),
            title: WidgetHelper().textQ("${!isNext?'TRANSFER PIN':'PERINCIAN TRANSFER PIN'}",12,Colors.grey,FontWeight.bold),
          ),
          ClipPath(
            clipper: WaveClipperOne(flip: true),
            child: Container(
              width: double.infinity,
              color: Constant().secondColor,
              padding: EdgeInsets.only(bottom:50.0,top:0.0,left:10.0,right:10.0),
              child: !isNext?Column(
                children: [
                  Container(
                    child: ListTile(
                      contentPadding: EdgeInsets.all(0.0),
                      title: WidgetHelper().textQ("${widget.val['kode']}",12,Constant().secondDarkColor,FontWeight.bold),
                      subtitle: WidgetHelper().textQ("${widget.val['full_name']}",12,Colors.grey,FontWeight.bold),
                      trailing:WidgetHelper().textQ("${widget.val['status']}",10,Constant().mainColor,FontWeight.bold),
                    ),
                  ),
                  WidgetHelper().titleNoButton(context,AntDesign.user,"ID Penerima",color: Colors.grey[200]),
                  SizedBox(height: 10.0),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                      color: Theme.of(context).focusColor.withOpacity(0.3),
                    ),
                    child: TextFormField(
                      style: TextStyle(letterSpacing:2.0,fontSize:14,fontWeight: FontWeight.normal,fontFamily: Constant().fontStyle,color:Constant().secondDarkColor),
                      controller: penerimaController,
                      maxLines: 1,
                      autofocus: false,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).focusColor.withOpacity(0.1)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintStyle: TextStyle(color:Constant().secondDarkColor, fontSize:12,fontFamily:Constant().fontStyle),
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      focusNode: penerimaFocus,
                      // textCapitalization: TextCapitalization.sentences,
                      textCapitalization: TextCapitalization.characters,

                    ),
                  ),
                  WidgetHelper().textQ('ID Penerima bisa dilihat melalui profil penerima yang akan di transfer',10.0,Colors.grey[200],FontWeight.normal),
                  SizedBox(height: 50.0),
                  Container(
                    color: Constant().moneyColor,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child:  FlatButton(
                        padding: EdgeInsets.all(15.0),
                        onPressed: (){
                          checkingAccount();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(AntDesign.checkcircleo,color: Colors.white),
                            SizedBox(width: 10.0),
                            WidgetHelper().textQ("PERIKSA AKUN", 14,Colors.white,FontWeight.bold)
                          ],
                        )
                    ),
                  )
                ],
              ):Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Icon(AntDesign.checkcircleo,color:Constant().mainColor,size: 20.0),
                    title: WidgetHelper().textQ("penerima",12,Colors.grey,FontWeight.normal),
                    trailing: WidgetHelper().textQ(availableMemberModel.result.fullName,12,Colors.white,FontWeight.normal),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.all(0.0),
                    leading: Icon(AntDesign.checkcircleo,color:Constant().mainColor,size: 20.0),
                    title: WidgetHelper().textQ("Pemilik Saat Ini",12,Colors.grey,FontWeight.normal),
                    trailing: WidgetHelper().textQ(widget.val['full_name'],12,Colors.white,FontWeight.normal),
                  ),
                  Divider(),

                  ListTile(
                    contentPadding: EdgeInsets.only(right:10.0),
                    leading: Icon(AntDesign.checkcircleo,color:Constant().mainColor,size: 20.0),
                    title: WidgetHelper().textQ("PIN",12,Colors.grey,FontWeight.normal),
                    trailing: WidgetHelper().textQ(widget.val['kode'],12,Colors.white,FontWeight.normal),
                  ),
                  Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.only(right:10.0),
                    leading: Icon(AntDesign.checkcircleo,color:Constant().mainColor,size: 20.0),
                    title: WidgetHelper().textQ("Status",12,Colors.grey,FontWeight.normal),
                    trailing: WidgetHelper().textQ(widget.val['status'],12,Colors.white,FontWeight.normal),
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    color: Constant().moneyColor,
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                    child:  FlatButton(
                        padding: EdgeInsets.all(15.0),
                        onPressed: (){
                          handleSubmit();
                          // checkingAccount();
                          // WidgetHelper().myModal(context, ModalReaktivasiPin());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(AntDesign.checkcircleo,color: Colors.white),
                            SizedBox(width: 10.0),
                            WidgetHelper().textQ("TRANSFER", 14,Colors.white,FontWeight.bold)
                          ],
                        )
                    ),
                  )
                ],
              ),
            ),
          )

        ],
      ),
    );
  }
}

class StatusStockistModal extends StatefulWidget {
  int index;
  Function(String kode,int idx) callback;
  StatusStockistModal({this.index,this.callback});
  @override
  _StatusStockistModalState createState() => _StatusStockistModalState();
}

class _StatusStockistModalState extends State<StatusStockistModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/3,
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

          Expanded(
            child: Scrollbar(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: DataHelper.filterStockist.length,
                  itemBuilder: (context,index){
                    return ListTile(
                      onTap: (){
                        widget.callback(DataHelper.filterStockist[index]['kode'],index);
                        setState(() {
                          widget.index=index;
                        });
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.only(left:10,right:10,top:0,bottom:0),
                      title: WidgetHelper().textQ(DataHelper.filterStockist[index]['value'], 12,Constant().darkMode, FontWeight.bold),
                      trailing: widget.index==index?Icon(AntDesign.checkcircleo,color: Constant().darkMode):Text(''),
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

