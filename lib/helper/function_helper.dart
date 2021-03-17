import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FunctionHelper{
  final formatter = new NumberFormat("#,###");
  DatabaseConfig db = DatabaseConfig();
  static var dataNominal=["100000","200000","300000","400000","500000","1000000"];
  toRp(val){
    return formatter.format(val);
  }
  percentToRp(var disc,var price){
    double diskon =  (disc/100)*price;
    var exp = diskon.toString().split('.');
    print("############################### VOUCHER ${int.parse(exp[0])} ####################################");
    return int.parse(exp[0]);
  }
  rmTitik(val,idx){
    return val.split(".")[idx];
  }

  // static var arrStatus=[
  //   "Menunggu Pembayaran",
  //   "Dikemas",
  //   "Dikirim",
  //   "Selesai",
  //   "Dibatalkan",
  //   "Semua status",
  // ];
  formatReportDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.year}-${dateParse.month.toString().padLeft(2, '0')}-${dateParse.day.toString().padLeft(2, '0')}";
    String dateFrom = "${DateFormat('yyyy-MM-dd').format(DateTime(dateParse.year, dateParse.month - 1, dateParse.day))}";
    String dateTo = formattedDate;
    return {"dateFrom":dateFrom,"dateTo":dateTo};
  }
  formateDate(val,param){
    initializeDateFormatting('id');
    if(param=='ymd'){
      return DateFormat.yMMMMEEEEd('id').format(val);
    }
    else{
      return '${DateFormat.yMMMMEEEEd('id').format(val)} ${DateFormat.Hms().format(val)}';
    }

  }
  Future getImage(param) async {
    ImageSource imageSource;
    if(param == 'kamera'){
      imageSource = ImageSource.camera;
    }
    else{
      imageSource = ImageSource.gallery;
    }
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: imageSource,imageQuality: 50);
    return File(pickedFile.path);
  }
  fieldFocusChange(BuildContext context, FocusNode currentFocus,FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
  decode(val){
    return base64.encode(utf8.encode(val));
  }
  Future removePackage()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("packageType");
  }
  Future removeSaldo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("saldo");
  }
  Future isPackage()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final packageType=prefs.getString("packageType");
    return packageType;
  }
  Future isSaldo()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final saldo=prefs.getString("saldo");
    return saldo;
  }
  Future removeBackHome()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("isBackHome");
  }
  Future setBackHome()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString("isBackHome", "1");
  }
  Future isBackHome()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final home=prefs.getString("isBackHome");
    return home;
  }
  Future logout(BuildContext context)async{
    final id=await UserHelper().getDataUser("id");
    await db.update(UserTable.TABLE_NAME, {'id':"${id.toString()}","is_login":"0","onboarding":"1"});
    WidgetHelper().myPushRemove(context,SignInScreen());
  }
}