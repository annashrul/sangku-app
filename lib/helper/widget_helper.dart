import 'dart:ui';

import 'package:animated_widgets/widgets/rotation_animated.dart';
import 'package:animated_widgets/widgets/scale_animated.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:animated_widgets/widgets/shake_animated_widget.dart';
import 'package:shimmer/shimmer.dart';

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
          WidgetHelper().textQ(Constant().errNoData, 14, Constant().mainColor, FontWeight.bold)
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


  appBarWithButton(BuildContext context, title,Function callback,List<Widget> widget,{Brightness brightness=Brightness.light}){
    return  AppBar(
      elevation: 1.0,
      backgroundColor: Colors.white, // status bar color
      brightness: brightness,
      title:textQ(title,14,Constant().darkMode,FontWeight.bold),
      leading: IconButton(
        icon: new Icon(AntDesign.back,color: Colors.grey),
        onPressed: (){
          callback();
        },
      ),
      actions:widget,// status bar brightness
    );
  }
  appBarNoButton(BuildContext context,String title,List<Widget> widget){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white, // status bar color
      title:textQ(title,14,Constant().darkMode,FontWeight.bold),
      elevation: 0,
      leading:Padding(
        padding: EdgeInsets.only(left:20.0,top:10.0,bottom:10.0),
        child:  CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage:AssetImage(Constant().localAssets+"logo.png"),
        ),
      ),
      actions:widget,
    );
  }
  appBarWithTab(BuildContext context,TabController tabController, title,Map<String,dynamic> lbl,String label,Function(String lbl) callback,{Widget leading,String description='', List<Widget> widget, ImageProvider<dynamic> imageProvider}){
    List<Tab> tab = new List();
    lbl.forEach((key, value) {
      tab.add(Tab(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(0), color:label==key?Constant().mainColor:Constant().secondColor),
            child: Align(
              alignment: Alignment.center,
              child: WidgetHelper().myText(value,12,color:Colors.white,fontWeight: FontWeight.bold),
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
          WidgetHelper().textQ("$title",14,Colors.grey,FontWeight.bold),
          if(description!='')WidgetHelper().textQ("$description",12,Colors.black,FontWeight.normal),
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
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              title:textQ(title,14,Colors.black,FontWeight.bold),
              content:textQ(desc,12,Colors.black,FontWeight.bold,maxLines:100),
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
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              title:textQ(title,14,Colors.black,FontWeight.bold),
              content:textQ(desc,12,Colors.black,FontWeight.bold),
              // content:RichText(overflow: TextOverflow.ellipsis, text: TextSpan(style: Theme.of(context).textTheme.caption, children: [TextSpan(text:widget.wrongPassContent),],),),
              actions: <Widget>[
                FlatButton(
                  onPressed:callback1,
                  child:textQ(titleBtn1,12,Colors.black,FontWeight.bold),
                ),
                FlatButton(
                  onPressed:callback2,
                  child:textQ(titleBtn2,12,Colors.black,FontWeight.bold),
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

  myNotif(BuildContext context,Function callback,Color color){
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
                child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Bell_font_awesome.svg/1200px-Bell_font_awesome.svg.png',
                  width: 28,
                  height: 28,
                  color:Colors.white,
                  // colorBlendMode:BlendMode.color,
                ),
                // child: Icon(AntDesign.bells, color:Constant().mainColor, size: 28,),
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
  titleNoButton(BuildContext context,IconData icon,String title,{Color color=Colors.white,double iconSize=20.0,FontWeight fontWeight=FontWeight.bold}){
    return  Row(
      children: [
        Icon(icon,color:color,size: iconSize),
        SizedBox(width:5.0),
        WidgetHelper().textQ(title,12,color,fontWeight),
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

    return ListView.builder(
      padding: EdgeInsets.only(top:10),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                decoration: BoxDecoration(
                  color: filterStatus==data[index]['kode']?Constant().mainColor:Constant().secondColor,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WidgetHelper().textQ("${data[index]['value']}", 10,Constant().secondDarkColor, FontWeight.bold),
                  ],
                ),
              )
          ),
        );
      },
    );
  }

}