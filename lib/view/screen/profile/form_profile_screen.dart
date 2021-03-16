import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screen_scaler/flutter_screen_scaler.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class FormProfileScreen extends StatefulWidget {

  @override
  _FormProfileScreenState createState() => _FormProfileScreenState();
}

class _FormProfileScreenState extends State<FormProfileScreen> {
  var nameController = TextEditingController();
  final FocusNode nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);

    return Scaffold(
      appBar: WidgetHelper().appBarWithButton(context,"Ubah Data Diri",(){Navigator.pop(context);},<Widget>[]),
      body: ListView(
        children: [
          Container(
            child:Column(
            mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().textQ("Nama Lengkap", scaler.getTextSize(9),Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                SizedBox(height: scaler.getHeight(1)),
                Container(
                  width: double.infinity,
                  padding: scaler.getPadding(0,2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                  ),
                  child: TextFormField(
                    style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color: Constant().darkMode),
                    controller: nameController,
                    maxLines: 1,
                    autofocus: false,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: nameFocus,
                    onFieldSubmitted: (term){
                      // UserRepository().fieldFocusChange(context, nameFocus, nohpFocus);
                    },

                  ),
                ),
                WidgetHelper().textQ("Nama Lengkap", scaler.getTextSize(9),Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                SizedBox(height: scaler.getHeight(1)),
                Container(
                  width: double.infinity,
                  padding: scaler.getPadding(0,2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).focusColor.withOpacity(0.1),
                  ),
                  child: TextFormField(
                    style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color: Constant().darkMode),
                    controller: nameController,
                    maxLines: 1,
                    autofocus: false,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    focusNode: nameFocus,
                    onFieldSubmitted: (term){
                      // UserRepository().fieldFocusChange(context, nameFocus, nohpFocus);
                    },

                  ),
                ),

              ]
            )
          )
        ],
      ),
    );
  }
}

class CreatePinScreen extends StatefulWidget {
  Function(String pin) callback;
  CreatePinScreen({this.callback});

  @override
  _CreatePinScreenState createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  var pinController = TextEditingController();
  final FocusNode pinFocus = FocusNode();
  var confPinController = TextEditingController();
  final FocusNode confPinFocus = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future store()async{
    print(pinController.text.length);
    print(confPinController.text.length);
    if(pinController.text==''){
      pinFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed","pin tidak boleh kosong");

    }
    if(pinController.text.length<6){
      pinFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed","pin tidak boleh kurang dari 6 angka");
    }
    if(confPinController.text==''){
      confPinFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed","konfirmasi pin tidak boleh kosong");
    }
    if(confPinController.text.length<6){
      confPinFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed","konfirmasi pin tidak boleh kurang dari 6 angka");
    }
    if(pinController.text!=confPinController.text){
      confPinFocus.requestFocus();
      return WidgetHelper().showFloatingFlushbar(context,"failed","konfirmasi pin tidak sesuai");
    }
    widget.callback(pinController.text);
  }

  @override
  Widget build(BuildContext context) {
    ScreenScaler scaler = ScreenScaler()..init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: WidgetHelper().appBarNoButton(context,"Buat Pin",<Widget>[]),
      body: Container(
        height: scaler.getHeight(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: scaler.getHeight(25),
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://www.divineit.net/media/original_images/Cyber-Security_C20hr7G.png'),
                    fit: BoxFit.contain,
                  )
              ),
            ),
            SizedBox(height: scaler.getHeight(1)),
            Expanded(
              child: ListView(
                padding:scaler.getPadding(0,2),
                children: <Widget>[
                  Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("Pin", scaler.getTextSize(9),Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                        SizedBox(height: scaler.getHeight(1)),
                        Container(
                          width: double.infinity,
                          padding: scaler.getPadding(0,2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).focusColor.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color: Constant().darkMode),
                            controller: pinController,
                            maxLines: 1,
                            obscureText: true,
                            autofocus: false,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            focusNode: pinFocus,
                            onFieldSubmitted: (term){
                              WidgetHelper().fieldFocusChange(context, pinFocus,confPinFocus);
                            },
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(6),
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  Container(
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WidgetHelper().textQ("Konfirmasi Pin", scaler.getTextSize(9),Constant().darkMode, FontWeight.bold,letterSpacing: 2.0),
                        SizedBox(height: scaler.getHeight(1)),
                        Container(
                          width: double.infinity,
                          padding: scaler.getPadding(0,2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).focusColor.withOpacity(0.1),
                          ),
                          child: TextFormField(
                            style: TextStyle(letterSpacing:2.0,fontSize:scaler.getTextSize(10),fontWeight: FontWeight.bold,fontFamily: Constant().fontStyle,color: Constant().darkMode),
                            controller: confPinController,
                            maxLines: 1,
                            autofocus: false,
                            obscureText: true,

                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            focusNode: confPinFocus,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(6),
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  Container(
                    child: MaterialButton(
                      onPressed: (){
                        store();
                      },
                      child: WidgetHelper().textQ("Simpan",scaler.getTextSize(10),Colors.grey[200],FontWeight.bold),
                      color: Constant().mainColor,
                      elevation: 0,
                      // minWidth: 400,
                      height: scaler.getHeight(4),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      ),
                    ),
                  ),
                  SizedBox(height: scaler.getHeight(1)),
                  WidgetHelper().textQ("* Pastikan handphone anda terkoneksi dengan internet", scaler.getTextSize(10),Constant().moneyColor, FontWeight.bold)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}



