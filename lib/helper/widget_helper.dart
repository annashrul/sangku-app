import 'dart:ui';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/scale_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/filter_date_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:sangkuy/view/screen/mlm/history/history_transaction_screen.dart';
import 'package:sangkuy/view/screen/profile/notif_screen.dart';
import 'package:sangkuy/view/widget/header_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:qr/qr.dart';

class WidgetHelper{
  myStatus(BuildContext context, int param){
    Color color;
    String txt="";
    if(param==0){
      color = Color(0xFF475F7B);
      txt = "Menunggu Pembayaran";
    }
    if(param==1){
      color = Color(0xFFF7AD17);
      txt = "Dikemas";
    }
    if(param==2){
      color = Color(0xFF1cbac8);
      txt = "Dikirim";
    }
    if(param==3){
      color = Colors.green;
      txt = "Selesai";
    }
    if(param==4){
      color = Colors.red;
      txt = "Dibatalkan";
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(0)), color:color),
      child: WidgetHelper().textQ(txt, 10,Colors.white,FontWeight.bold),
    );
  }

  animShakeWidget(BuildContext context,Widget child,{bool enable=true}){
    return ShakeAnimatedWidget(
        enabled: enable,
        duration: Duration(milliseconds: 1500),
        shakeAngle: Rotation.deg(z: 10),
        curve: Curves.linear,
        child:child
    );
  }
  animScaleWidget(BuildContext context,Widget child,{bool enable=true}){
    return ScaleAnimatedWidget.tween(
      enabled: true,
      duration: Duration(milliseconds: 600),
      scaleDisabled: 0.5,
      scaleEnabled: 1,
      //your widget
      child: child,
    );
  }
  fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  myPushRemove(BuildContext context, Widget widget){
    return  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        new CupertinoPageRoute(builder: (BuildContext context)=>widget), (Route<dynamic> route) => false
    );
  }
  myPush(BuildContext context, Widget widget){
    return Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
  }
  myPushAndLoad(BuildContext context, Widget widget,Function callback){
    return Navigator.push(context, CupertinoPageRoute(builder: (context) => widget)).whenComplete(callback);
  }
  loadingDialog(BuildContext context,{title='SangQu'}){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100.0),
            child: AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SpinKitFadingGrid(color:Constant().mainColor, shape: BoxShape.rectangle),
                  // SpinKitCubeGrid(size: 80.0, color: Constant().mainColor),
                  // textQ(title,14,Constant().mainColor,FontWeight.bold,letterSpacing: 5.0)
                ],
              ),
            )
        );
      },
    );
  }

  loadingWidget(BuildContext context,{Color color=Colors.black, String title='SangQu'}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitFadingGrid(color:Constant().mainColor, shape: BoxShape.rectangle),

          // SpinKitCubeGrid(size: 85.0, color: Constant().mainColor),
          // textQ(title,14,Constant().mainColor,FontWeight.bold,letterSpacing: 5.0)
        ],
      ),
    );
  }
  noDataWidget(BuildContext context){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(AntDesign.unknowfile1,size: 70),
          SizedBox(height:10),
          WidgetHelper().textQ(Constant().errNoData, 14, Constant().darkMode, FontWeight.bold)
          // Image.network('https://lh3.googleusercontent.com/proxy/27oZlO859yameGqB3FjTaLHzJ2yYh-bATvQuVhVlmYWYiMiQzcNSKBLNAuDP6EL-v7KE7r5tUUteyqNTw_lqB_EqFEwitIqWTzIfW_E')
        ],
      ),
    );
  }
  textQ(String txt,double size,Color color,FontWeight fontWeight,{double letterSpacing=1.0,TextDecoration textDecoration,TextAlign textAlign = TextAlign.left,int maxLines=2}){
    return RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        text: TextSpan(
          text:txt,
          style: TextStyle(letterSpacing:letterSpacing,decoration: textDecoration, fontSize:size,color: color,fontFamily:Constant().fontStyle,fontWeight:fontWeight,),
        )
    );
  }
  myText(String txt,double size,{Color color,FontWeight fontWeight,double letterSpacing=1.0,TextDecoration textDecoration,TextAlign textAlign = TextAlign.left,int maxLines=2}){
    return RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        text: TextSpan(
          text:txt,
          style: TextStyle(letterSpacing:letterSpacing,decoration: textDecoration, fontSize:size,color: color,fontFamily:Constant().fontStyle,fontWeight:fontWeight,),
        )
    );
  }

  void notifBar(BuildContext context,String param, String desc) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      padding: EdgeInsets.all(10),
      borderRadius: 0,
      backgroundGradient: LinearGradient(
        colors: param=='success'?[Constant().mainColor, Constant().mainColor]:[Colors.red, Colors.red],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      icon: Icon(
        param=='success'?Icons.check_circle_outline:Icons.info_outline,
        size: 28.0,
        color: Colors.white,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: param=='success'?Colors.blue[300]:Colors.red[300],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: textQ(desc,12,Colors.white, FontWeight.normal),
    )..show(context);
  }


  appBarWithButton(BuildContext context, title,Function callback,List<Widget> widget,{double sizeTitle=14.0,Brightness brightness=Brightness.light}){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return  AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 1.0,
      backgroundColor: Colors.white, // status bar color
      brightness: brightness,
      title: Padding(
        padding: scaler.getPadding(0,1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: callback,
              child: Icon(Ionicons.ios_arrow_back, color: Constant().darkMode),
            ),
            SizedBox(width: scaler.getWidth(2)),
            Expanded(
              child: textQ(title,scaler.getTextSize(10),Constant().darkMode,FontWeight.bold),
            ),
            // Your widgets here
          ],
        ),
      ),
      actions:widget,// status bar brightness
    );
  }
  appBarNoButton(BuildContext context,String title,List<Widget> widget){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white, // status bar color
      title:textQ(title,scaler.getTextSize(10),Constant().darkMode,FontWeight.bold),
      elevation: 0,
      leading:Padding(
        padding: scaler.getPadding(1,1),
        child:  CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage:AssetImage(Constant().localAssets+"logo.png"),
        ),
      ),
      actions:widget,
    );
  }
  appBarWithTab(BuildContext context,TabController tabController, title,Map<String,dynamic> lbl,String label,Function(String lbl) callback,{Widget leading,String description='', List<Widget> widget, ImageProvider<dynamic> imageProvider}){
    ScreenScaler scaler = ScreenScaler()..init(context);

    List<Tab> tab = new List();
    lbl.forEach((key, value) {
      tab.add(Tab(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color:label==key?Constant().mainColor:Constant().secondColor),
            child: Align(
              alignment: Alignment.center,
              child: WidgetHelper().myText(value,scaler.getTextSize(9),color:Colors.white,fontWeight: FontWeight.bold),
            ),
          ),
        ));
    });

    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white, // status bar color
      brightness: Brightness.light,
      title:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetHelper().textQ("$title",scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
          if(description!='')WidgetHelper().textQ("$description",scaler.getTextSize(9),Colors.black,FontWeight.normal),
        ],
      ),
      // title:textQ(title,18,Colors.black,FontWeight.bold),
      leading: leading,
      bottom: TabBar(
          onTap:callback(label),
          controller: tabController,
          indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color:Colors.transparent),
          indicatorColor: Colors.green,
          indicatorSize: TabBarIndicatorSize.label,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.grey[400],
          indicatorWeight: 2,
          labelPadding: EdgeInsets.symmetric(horizontal: 0),
          labelStyle: TextStyle(fontWeight:FontWeight.bold,color: Colors.white, fontFamily:Constant().fontStyle,fontSize:14),
          tabs: tab
      ),
      actions:widget,// status bar brightness
    );


  }

  appBarWithFilter(
      BuildContext context,
      title,
      Function callback,
      Function(String param) filterQ,
      Function(String dateFrom, String dateTo)
      filterDate,{double sizeTitle=14.0,Function detail, bool isDetail=false}
    ){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return  AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 1.0,
      backgroundColor: Colors.white, // status bar color
      title: Padding(
        padding: scaler.getPadding(0,1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: callback,
              child: Icon(Ionicons.ios_arrow_back, color: Constant().darkMode),
            ),
            SizedBox(width: scaler.getWidth(2)),
            textQ(title,scaler.getTextSize(10),Constant().darkMode,FontWeight.bold),
            // Your widgets here
          ],
        ),
      ),
      actions:<Widget>[
        if(isDetail)Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(300),
              onTap:detail,
              child: Icon(Ionicons.ios_arrow_down,size: scaler.getTextSize(12),),
            )
        ),

        Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 0),
            child: InkWell(
              borderRadius: BorderRadius.circular(300),
              onTap: () {
                DateTimeRangePicker(
                    startText: "Dari",
                    endText: "Sampai",
                    doneText: "Simpan",
                    cancelText: "Batal",
                    interval: 5,
                    initialStartTime: DateTime.now(),
                    initialEndTime: DateTime.now(),
                    mode: DateTimeRangePickerMode.date,
                    maximumTime: DateTime.now(),
                    onConfirm: (start, end) {
                      String dateFrom = '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
                      String dateTo = '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';
                      filterDate(dateFrom,dateTo);
                    }).showPicker(context);
              },
              child: Icon(Ionicons.ios_calendar,size: scaler.getTextSize(12),),
            )
        ),
        Container(
            width: 30,
            height: 30,
            margin: EdgeInsets.only(top: 12.5, bottom: 12.5, right: 10),
            child: InkWell(
              borderRadius: BorderRadius.circular(300),
              onTap: () {
                WidgetHelper().myModal(context,FilterSearch(callback: (param){
                  filterQ(param);
                }));
              },
              child: Icon(Ionicons.ios_search,size: scaler.getTextSize(12),),
            )
        ),
      ],// status bar brightness
    );
  }

  myModal(BuildContext context,Widget child){
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: child,
        )
    );
  }
  myPress(Function callback,Widget child,{Color color=Colors.black12}){
    return InkWell(
      highlightColor:color,
      splashColor:color,
      borderRadius: BorderRadius.circular(10),
      onTap: ()async{
        await Future.delayed(Duration(milliseconds: 90));
        callback();
      },
      child: child,
    );
  }
  notifOneBtnDialog(BuildContext context,title,desc,Function callback1,{titleBtn1='Oke'}){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              title:textQ(title,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
              content:textQ(desc,scaler.getTextSize(9),Constant().darkMode,FontWeight.normal,maxLines:100),
              // content:RichText(overflow: TextOverflow.ellipsis, text: TextSpan(style: Theme.of(context).textTheme.caption, children: [TextSpan(text:widget.wrongPassContent),],),),
              actions: <Widget>[
                FlatButton(
                  onPressed:callback1,
                  child:textQ(titleBtn1,12,Constant().mainColor,FontWeight.bold),
                ),
              ],
            ),
          );
        }
    );
  }
  notifDialog(BuildContext context,title,desc,Function callback1, Function callback2,{titleBtn1='Batal',titleBtn2='Oke'}){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              title:textQ(title,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
              content:textQ(desc,scaler.getTextSize(9),Constant().darkMode,FontWeight.normal,maxLines:100),
              // content:RichText(overflow: TextOverflow.ellipsis, text: TextSpan(style: Theme.of(context).textTheme.caption, children: [TextSpan(text:widget.wrongPassContent),],),),
              actions: <Widget>[
                FlatButton(
                  onPressed:callback1,
                  child:textQ(titleBtn1,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                ),
                FlatButton(
                  onPressed:callback2,
                  child:textQ(titleBtn2,scaler.getTextSize(9),Constant().darkMode,FontWeight.bold),
                )
              ],
            ),
          );
        }
    );
  }
  void showFloatingFlushbar(BuildContext context,String param, String desc) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      padding: EdgeInsets.all(10),
      borderRadius: 0,
      backgroundGradient: LinearGradient(
        colors: param=='success'?[Constant().mainColor, Constant().mainColor]:[Colors.red, Colors.red],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      icon: Icon(
        param=='success'?Icons.check_circle_outline:Icons.info_outline,
        size: 28.0,
        color: Constant().secondDarkColor,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: param=='success'?Colors.blue[300]:Colors.red[300],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: textQ(desc,12,Constant().secondDarkColor, FontWeight.bold),
    )..show(context);
  }
  myNotif(BuildContext context,String title,int total,reff){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return HeaderWidget(title: title,action: [
      InkWell(
        onTap: (){
          print(reff);
          myModal(context, Center(
              child: PrettyQr(
                elementColor: Constant().mainColor,
                image: AssetImage(Constant().localAssets+'logo.png'),
                typeNumber: 3,
                size: scaler.getHeight(30),
                data: reff,
                errorCorrectLevel: QrErrorCorrectLevel.M,
                roundEdges: true
              )
            )
          );
        },
        child:Container(
          margin: EdgeInsets.only(right:10,top:0),
          child:  Icon(AntDesign.qrcode,color: Colors.white,size: scaler.getTextSize(14)),
        ),
      ),
      InkWell(
        onTap: (){
          if(total>0) myPush(context,NotifScreen());
        },
        child: Container(
          margin: EdgeInsets.only(right: 10,top:0),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Icon(Ionicons.ios_notifications, color:Colors.white,size: scaler.getTextSize(14)),
              Container(
                decoration: BoxDecoration(color:total>0?Colors.redAccent:Colors.transparent, borderRadius: BorderRadius.all(Radius.circular(10))),
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10),
              ),
            ],
          ),
        ),
      ),

    ]);

  }
  myCart(BuildContext context,Function callback,Color color,{IconData iconData=AntDesign.shoppingcart}){
    return FlatButton(
        padding: EdgeInsets.all(0.0),
        highlightColor:Colors.black38,
        splashColor:Colors.black38,
        onPressed:callback,
        child: Container(
          padding: EdgeInsets.only(right: 0.0,top:0),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Icon(iconData, color:Constant().mainColor, size: 28,),
              ),
              Container(
                decoration: BoxDecoration(color:color, borderRadius: BorderRadius.all(Radius.circular(10))),
                constraints: BoxConstraints(minWidth: 10, maxWidth: 10, minHeight: 10, maxHeight: 10),
              ),
            ],
          ),
        )
    );
  }
  baseLoading(BuildContext context,Widget widget){
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: widget,
    );
  }
  titleNoButton(BuildContext context,IconData icon,String title,{double fontSize=9,String img='',Color color=Colors.white,double iconSize=15.0,FontWeight fontWeight=FontWeight.bold}){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return  Row(
      children: [
        img==''?Icon(icon,color:color,size: scaler.getTextSize(iconSize)):Image.network(img,height: 30,fit: BoxFit.contain),
        SizedBox(width:scaler.getWidth(2)),
        WidgetHelper().textQ(title,scaler.getTextSize(fontSize),color,fontWeight),
      ],
    );
  }
  myFilter(Function callback,{IconData icon,Color bg, Color iconColor=Colors.grey}){
    return FlatButton(
        padding: EdgeInsets.all(10.0),
        highlightColor:Colors.black38,
        splashColor:Colors.black38,
        onPressed:callback,
        color: bg,
        child: Icon(icon,color: iconColor)
    );
  }
  Future showDatePickerQ(BuildContext context,title,Function(DateTime dateTime,List<int> index) callback) async {
    String _format = 'yyyy-MM-dd';
    DateTime _dateTime = DateTime.now();
    DateTimePickerLocale _locale = DateTimePickerLocale.id;
    DatePicker.showDatePicker(
      context,
      onMonthChangeStartWithFirstDate: true,
      pickerTheme: DateTimePickerTheme(
        cancel:Text(title, style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
        showTitle: true,
        confirm: Text('Selesai', style: TextStyle(color:Constant().mainColor,fontWeight: FontWeight.bold)),
      ),
      minDateTime: DateTime.parse("2010-05-12"),
      maxDateTime: DateTime.parse('3000-01-01'),
      initialDateTime: _dateTime,
      dateFormat: _format,
      locale: _locale,
      onClose: () => print("----- onClose -----"),
      onCancel: () => print('onCancel'),
      onChange: (dateTime, List<int> index) {
        dateTime = dateTime;
      },
      onConfirm: callback,
    );
  }
  filterStatus(BuildContext context,List data,Function(dynamic val) callback,filterStatus){
    ScreenScaler scaler = ScreenScaler()..init(context);

    return ListView.builder(
      padding: EdgeInsets.only(top:0),
      scrollDirection: Axis.horizontal,
      itemCount: data.length,
      itemBuilder: (context,index){
        return  Container(
          padding: EdgeInsets.only(right:5),
          child: WidgetHelper().myPress((){
            callback(data[index]);
            filterStatus=data[index]['kode'];
          },
              Container(
                padding: scaler.getPadding(0.5,2),
                decoration: BoxDecoration(
                  color: filterStatus==data[index]['kode']?Constant().mainColor:Constant().secondColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetHelper().textQ("${data[index]['value']}", scaler.getTextSize(9),Constant().secondDarkColor, FontWeight.bold),
                  ],
                ),
              )
          ),
        );
      },
    );
  }
  baseImage(String img,{double width, double height,BoxFit fit = BoxFit.contain}){
    return CachedNetworkImage(
      imageUrl:img,
      width: width,
      height: height,
      fit:fit,
      placeholder: (context, url) => Image.asset(
        Constant().localAssets+'logo.png',
        width: width,
        height: height,
        fit:fit,
      ),
      errorWidget: (context, url, error) => Image.asset(
        Constant().localAssets+'logo.png',
        width: width,
        height: height,
        fit:fit,
      ),
    );
  }

  titleQ(BuildContext context,String title,desc,{
    Color colorTitle=Colors.black,
    Color colorDesc=Colors.black,
    double sizeTitle=9,
    double sizeDesc=9,
    Function callback,
    IconData icon,
    TextAlign textAlign=TextAlign.left,
    String param='',
    FontWeight fontWeight = FontWeight.normal
  }){
    ScreenScaler scaler = ScreenScaler()..init(context);


    return InkWell(
      onTap:callback,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Constant().mainColor,
                  size: scaler.getTextSize(15),
                ),
                SizedBox(width: scaler.getWidth(1)),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WidgetHelper().textQ(title, scaler.getTextSize(sizeTitle),colorTitle,FontWeight.bold,textAlign: textAlign),
                    WidgetHelper().textQ(desc, scaler.getTextSize(sizeDesc),colorDesc,fontWeight,textAlign: textAlign),
                  ],
                )
              ],
            ),
          ),
          param==''?Text(''):Align(
            alignment: Alignment.centerRight,
            child: Icon(Ionicons.md_arrow_dropright_circle,color: Constant().mainColor,size: scaler.getTextSize(12)),
          )
        ],
      ),
    );

  }

  desc(BuildContext context,title,desc,{Color color=Colors.black,Color colorttl=Colors.black}){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Padding(
      padding: scaler.getPadding(0,2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // WidgetHelper().textQ(title,scaler.getTextSize(9),colorttl,FontWeight.normal),
          Expanded(
            flex: 1,
            child: WidgetHelper().textQ(title,scaler.getTextSize(9),colorttl,FontWeight.normal),
          ),
          Expanded(
            flex: 1,
            child: WidgetHelper().textQ(desc,scaler.getTextSize(9),color,FontWeight.normal,textAlign: TextAlign.end),
          )
        ],
      ),
    );
  }


  myBtnBorder(BuildContext context,title,callback,Color color){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child: Container(
        padding: scaler.getPadding(0.5,2),
        decoration: BoxDecoration(
            border: Border.all(color:color),
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        child: Padding(
          padding: EdgeInsets.all(0.0),
          child: WidgetHelper().textQ(title, scaler.getTextSize(9),color,FontWeight.bold),
        ),

      ),
      onTap:callback,
    );
  }

  wrapperModal(BuildContext context,String title,Widget children,{bool isCallack=false,Function callack,String txtBtn="Simpan"}){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Container(
      padding: scaler.getMarginLTRB(0,1, 0,0),
      decoration: BoxDecoration(
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
              width: scaler.getWidth(20),
              height: scaler.getHeight(1),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            dense:true,
            contentPadding:scaler.getPadding(0,2),
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child:Icon(AntDesign.close, color:Constant().darkMode),
            ),
            title: WidgetHelper().textQ(title,scaler.getTextSize(9), Constant().darkMode, FontWeight.bold),
            trailing: isCallack?InkWell(
                onTap:callack,
                child: Container(
                  padding:scaler.getPadding(0.5,2),
                  decoration: BoxDecoration(
                    color: Constant().moneyColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: WidgetHelper().textQ(txtBtn,scaler.getTextSize(10),Colors.white,FontWeight.bold),
                )
            ):Text(''),
          ),
          Divider(),
          // children,
          Expanded(
            child: children,
          )
        ],
      ),
    );
  }


  Widget myForm(BuildContext context,String label,TextEditingController controller,{
    FocusNode focusNode,
    Function(String e) onSubmit,
    Function onTap,
    Function(String e) onChange,
    TextInputType textInputType= TextInputType.text,
    TextInputAction textInputAction= TextInputAction.next,
    List<TextInputFormatter> inputFormatters,
    bool isRead=false,
    int maxLine=1,
    Color titleColor=Colors.black,
    FontWeight fontWeight=FontWeight.normal
  }){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetHelper().textQ(label,scaler.getTextSize(9),titleColor,fontWeight),
        SizedBox(height:scaler.getHeight(0.5)),
        Container(
          decoration: BoxDecoration(
            color: Color(0xFFEEEEEE),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          padding:scaler.getPadding(0,2),
          child: TextFormField(
            maxLines: maxLine,
            readOnly: isRead,
            textInputAction:textInputAction,
            keyboardType:textInputType,
            style: TextStyle(color:Constant().darkMode,fontSize:scaler.getTextSize(10),fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintStyle: TextStyle(color:Constant().darkMode,fontSize: scaler.getTextSize(10),fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
            ),
            onFieldSubmitted: (_)=>onSubmit(_),
            onTap: onTap,
            onChanged: onChange,
            inputFormatters:inputFormatters
          ),
        ),
      ],
    );
  }



  myFormWithAct(BuildContext context,String label,TextEditingController controller,Function callbackAct,IconData icon,{
    FocusNode focusNode,
    Function(String e) onSubmit,
    Function onTap,
    Function(String e) onChange,
    TextInputType textInputType= TextInputType.text,
    TextInputAction textInputAction= TextInputAction.next,
    List<TextInputFormatter> inputFormatters,
    bool isRead=false,
    int maxLine=1,
    TextCapitalization textCapitalization=TextCapitalization.none
  }){
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WidgetHelper().textQ(label,scaler.getTextSize(9),Constant().darkMode, FontWeight.normal),
        SizedBox(height:scaler.getHeight(0.5)),
        Container(

          width: double.infinity,
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).focusColor.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          // padding:scaler.getPadding(0,2),
          child: TextFormField(
              maxLines: maxLine,
              readOnly: isRead,
              textInputAction:textInputAction,
              keyboardType:textInputType,
              style: TextStyle(color:Constant().darkMode,fontSize:scaler.getTextSize(10),fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintStyle: TextStyle(color:Constant().darkMode,fontSize: scaler.getTextSize(10),fontFamily: Constant().fontStyle,fontWeight: FontWeight.bold),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide.none),
                suffixIcon:InkWell(
                  onTap:callbackAct,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Constant().mainColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10)),
                    ),
                    child: Icon(icon,color:Colors.white),
                  ),
                ),
                contentPadding: const EdgeInsets.only(top: 19.0, right: 0.0, bottom: 0.0, left: 0.0),
              ),
              textCapitalization: textCapitalization,
              onFieldSubmitted: (_)=>onSubmit(_),
              onTap: onTap,
              onChanged: onChange,
              inputFormatters:inputFormatters
          ),
        ),
      ],
    );
  }

}