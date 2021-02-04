import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';


class AppBarNoButton extends StatefulWidget implements PreferredSizeWidget {
  AppBarNoButton({Key key}) : preferredSize = Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _AppBarNoButtonState createState() => _AppBarNoButtonState();
}

class _AppBarNoButtonState extends State<AppBarNoButton>{
  String name='';
  String img='';
  Future loadData()async{
    var nm = await UserHelper().getDataUser("full_name");
    var im = await UserHelper().getDataUser("picture");
    print(im);
    setState(() {
      name=nm;
      img=im;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return  AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white, // status bar color

      elevation: 0,
      title:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WidgetHelper().textQ("Hai, SangQu",16,Colors.black,FontWeight.bold,letterSpacing: 3.0),
          WidgetHelper().textQ("MB5711868825",12,Colors.black,FontWeight.normal,letterSpacing: 2.0),
        ],
      ),
      leading:Padding(
        padding: EdgeInsets.only(left:20.0,top:10.0,bottom:10.0),
        child:  WidgetHelper().myPress((){},CircleAvatar(
          backgroundImage:NetworkImage('https://img.pngio.com/avatar-icon-png-105-images-in-collection-page-3-avatarpng-512_512.png',scale: 1.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(AntDesign.cloudupload,size: 15,color: Colors.grey),
          ),
        )),
      ),
      actions: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(0.0),
          highlightColor:Colors.black38,
          splashColor:Colors.black38,
          onPressed: (){
            WidgetHelper().myModal(context,ModalQr());

          },
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.only(right: 0.0,top:0),
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Icon(
                      AntDesign.qrcode,
                      color:Constant().mainColor,
                      size: 28,
                    ),
                  ),

                ],
              ),
            )
        )
      ],
    );
  }
}


class ModalQr extends StatefulWidget {
  @override
  _ModalQrState createState() => _ModalQrState();
}

class _ModalQrState extends State<ModalQr> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.7,
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
      ),
      // color: Colors.white,
      child: Column(
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
          // https://pngimg.com/uploads/qr_code/qr_code_PNG26.png
          Expanded(
            child: ListView(
              children: [
                Image.network('https://pngimg.com/uploads/qr_code/qr_code_PNG26.png')
              ],
            ),
          )
        ],
      ),
    );

  }
}
