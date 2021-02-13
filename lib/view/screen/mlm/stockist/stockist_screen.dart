import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/data_helper.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/stockist/pin_available_model.dart';
import 'package:sangkuy/model/mlm/stockist/pin_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:sangkuy/provider/stockist_provider.dart';
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
      body:Scrollbar(
          child: Container(
            padding: EdgeInsets.only(left:0.0,right: 0.0),
            child: Column(
              children: [
                Expanded(
                  flex: 19,
                  child: isLoading?loading(context,10):!isNodata?ListView.separated(
                      shrinkWrap: true,
                      controller: controller,
                      itemBuilder: (context,index){
                        return Container(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:new BorderRadius.circular(10.0),
                            onTap: (){},
                            child: Card(
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
                                        color:Constant().mainColor,
                                        borderRadius: new BorderRadius.circular(10.0)
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
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
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      WidgetHelper().myPress((){},Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        color: Constant().mainColor,
                                        padding: EdgeInsets.all(5.0),
                                        child:  WidgetHelper().textQ("Transfer", 10, Constant().secondDarkColor,FontWeight.bold),
                                      )),
                                      if(widget.type=='ro')SizedBox(height:5.0),
                                      if(widget.type=='ro')WidgetHelper().myPress((){},Container(
                                        margin: EdgeInsets.only(right: 10.0),
                                        color: Constant().blueColor,
                                        padding: EdgeInsets.all(5.0),
                                        child:  WidgetHelper().textQ("Aktivasi", 10, Constant().secondDarkColor,FontWeight.bold),
                                      )),
                                      // WidgetHelper().textQ("Transfer", 10, Constant().secondColor,FontWeight.bold),

                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context,index){return Divider();},
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
      bottomNavigationBar:widget.type=='1'?Container(
        color: Constant().moneyColor,
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        child:  FlatButton(
            padding: EdgeInsets.all(15.0),
            onPressed: (){
              WidgetHelper().myModal(context, ModalReaktivasiPin());
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

class ModalReaktivasiPin extends StatefulWidget {
  @override
  _ModalReaktivasiPinState createState() => _ModalReaktivasiPinState();
}

class _ModalReaktivasiPinState extends State<ModalReaktivasiPin> {
  PinAvailableModel pinAvailableModel;
  bool isLoading=false,isNodata=false,isNext=false;
  String gambar='';
  String title='';
  String id='';
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
                      setState(() {
                        id=val.id;
                        isNext=true;
                        gambar=val.badge;
                        title=val.title;
                      });
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
    return Container(
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
                          placeholder: (context, url) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                          errorWidget: (context, url, error) => Image.network('https://allrelease.id/wp-content/uploads/2020/03/Telkomsel-Tanggap-Covid-19.jpg', fit:BoxFit.fill,width: double.infinity,),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WidgetHelper().textQ('Keuntungan Yang Akan Didapatkan', 10,Constant().darkMode,FontWeight.bold,textAlign: TextAlign.center),
                          SizedBox(height: 14),
                          desc('Eu nostrud qui eiusmod excepteur aute.'),
                          Divider(),
                          desc('Ex adipisicing occaecat ut.'),
                          Divider(),
                          desc('Reprehenderit occaecat Lorem.'),
                          Divider(),
                          desc('Aliquip voluptate sunt magna.'),
                          Divider(),
                          desc('Occaecat enim qui laborum.'),

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
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(AntDesign.checkcircleo,color: Constant().secondDarkColor),
                            SizedBox(width:10.0),
                            WidgetHelper().textQ("Reaktivasi", 12, Constant().secondDarkColor, FontWeight.normal),
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
        ),
      ],
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

