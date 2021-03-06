import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class CameraWidget extends StatefulWidget {
  final Function(String bukti,File pureImage) callback;
  CameraWidget({this.callback});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  File _image;
  String dropdownValue = 'pilih';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future upload()async{
    print("############################# $_image ####################################");
    if(_image!=null){
      String fileName;
      String base64Image;
      fileName = _image.path.split("/").last;
      var type = fileName.split('.');
      base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(_image.readAsBytesSync());
      widget.callback(base64Image,_image);
      Navigator.pop(context);
    }
  }
  @override
        Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Container(
        padding:EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0))
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

            Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(AntDesign.picture),
                      title:WidgetHelper().textQ("Album",scaler.getTextSize(10),Constant().darkMode,FontWeight.bold),
                      onTap: () async{
                        WidgetHelper().loadingDialog(context);

                        var img = await FunctionHelper().getImage('galeri');
                        setState(() {
                          _image = img;
                        });
                        upload();
                        // _imgFromGallery();
                        // Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(AntDesign.camerao),
                    title:WidgetHelper().textQ("Kamera",scaler.getTextSize(10),Constant().darkMode,FontWeight.bold),
                    onTap: () async{
                      WidgetHelper().loadingDialog(context);

                      var img = await FunctionHelper().getImage('kamera');
                      setState(() {
                        _image = img;
                      });
                      upload();
                      // _imgFromCamera();
                      // Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),

            // WidgetHelper().textQ("Ambil gambar dari ?",12,Constant().darkMode,FontWeight.bold),
            // SizedBox(height: 10.0),
            // Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            //     decoration: BoxDecoration(
            //         color: Colors.grey[200],
            //         borderRadius: BorderRadius.circular(10)
            //     ),
            //     child: DropdownButton<String>(
            //       isDense: true,
            //       isExpanded: true,
            //       value: dropdownValue,
            //       icon: Icon(Icons.arrow_drop_down),
            //       iconSize: 20,
            //       underline: SizedBox(),
            //       onChanged: (newValue) async {
            //         var img = await FunctionHelper().getImage(newValue);
            //         // Navigator.pop(context);
            //         // print(img);
            //         setState(() {
            //           dropdownValue  = newValue;
            //           _image = img;
            //         });
            //       },
            //       items: <String>['pilih','kamera', 'galeri'].map<DropdownMenuItem<String>>((String value) {
            //         return new DropdownMenuItem<String>(
            //           value: value,
            //           child: Row(
            //             children: [
            //               WidgetHelper().textQ(value,12,Colors.grey,FontWeight.bold)
            //             ],
            //           ),
            //         );
            //       }).toList(),
            //     )
            // ),
            Container(
              alignment: Alignment.center,
              padding:EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(10.0),
              ),
              child: _image == null ?Text(''): new Image.file(_image,width: MediaQuery.of(context).size.width/1,height: MediaQuery.of(context).size.height/2,filterQuality: FilterQuality.high,),
            ),
            // SizedBox(height: 10.0),
            // Container(
            //   width: double.infinity,
            //   child: FlatButton(
            //     onPressed: () {
            //       if(_image!=null){
            //         WidgetHelper().loadingDialog(context);
            //         String fileName;
            //         String base64Image;
            //         fileName = _image.path.split("/").last;
            //         var type = fileName.split('.');
            //         base64Image = 'data:image/' + type[1] + ';base64,' + base64Encode(_image.readAsBytesSync());
            //         widget.callback(base64Image,);
            //         Navigator.pop(context);
            //       }
            //     },
            //     padding: EdgeInsets.all(15.0),
            //     // padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            //     color: Constant().moneyColor,
            //     // shape: StadiumBorder(),
            //     child:WidgetHelper().textQ("UPLOAD", 12,Constant().secondDarkColor,FontWeight.bold,letterSpacing: 3.0),
            //   ),
            // ),
          ],
        )
    );
  }

}
