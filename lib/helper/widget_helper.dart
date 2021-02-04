import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/user_helper.dart';

class WidgetHelper{

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
                  SpinKitCubeGrid(size: 80.0, color: Constant().mainColor),
                  textQ(title,14,Constant().mainColor,FontWeight.bold,letterSpacing: 5.0)
                ],
              ),
            )
        );
      },
    );
  }

  loadingWidget(BuildContext context,{Color color=Colors.black, String title='Loading ...'}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitCubeGrid(size: 51.0, color: Constant().mainColor),
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
      backgroundColor: brightness.index==1?Colors.white:Color(0xFF2C2C2C), // status bar color
      brightness: brightness,
      title:textQ(title,16,Colors.black,FontWeight.bold),
      leading: IconButton(
        icon: new Icon(Icons.arrow_back_ios),
        onPressed: (){
          callback();
        },
      ),
      actions:widget,// status bar brightness
    );
  }
  appBarNoButton(BuildContext context,String title,List<Widget> widget,{Brightness brightness=Brightness.light}){
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white, // status bar color
      brightness: brightness,
      title:textQ(title,16,Colors.black,FontWeight.bold),
      elevation: 0,
      leading:Padding(
        padding: EdgeInsets.only(left:20.0,top:10.0,bottom:10.0),
        child:  CircleAvatar(
          backgroundImage:NetworkImage('https://www.pngkey.com/png/full/114-1149878_setting-user-avatar-in-specific-size-without-breaking.png',scale: 10.0),
        ),
      ),
      actions:widget,
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
  myPress(Function callback,Widget child,{Color color=Colors.black38}){
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
              content:textQ(desc,12,Colors.black,FontWeight.bold),
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
}