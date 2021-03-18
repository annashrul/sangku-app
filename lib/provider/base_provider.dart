import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' show Client;
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/function_helper.dart';
import 'package:sangkuy/helper/generated_route.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';

class BaseProvider{
  Client client = Client();
  final userRepository = UserHelper();
  Future getProvider(url,param,{BuildContext context,Function callback})async{
    int onRetry=0;
    if(onRetry>2){
      return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
        Navigator.pop(context);
        await FunctionHelper().logout(context);
      });
    }
    else{
      try{
        final token= await userRepository.getDataUser('token');
        Map<String, String> head={
          'Authorization':token,
          'username': Constant().username,
          'password': Constant().password,
          'myconnection':Constant().connection,
          "HttpHeaders.contentTypeHeader": "application/json"
        };
        final response = await client.get("${Constant().baseUrl}$url", headers:head).timeout(Duration(seconds: Constant().timeout));
        final jsonResponse = json.decode(response.body);
        if (response.statusCode == 200) {
          print("=================== SUCCESS $url = ${response.statusCode} ==========================");
          if(jsonResponse['result'].length>0){
            return param(response.body);
          }else{
            print("=================== GET DATA $url = NODATA ============================");
            return Constant().errNoData;
          }
        }
        else if(response.statusCode == 400){
          if(jsonResponse['msg']=='Invalid Token.'){
            if(context==null){
              return Constant().errExpToken;
            }else{
              return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
                Navigator.pop(context);
                await FunctionHelper().logout(context);
              });
            }
          }
          return General.fromJson(jsonResponse);
        }
      }on TimeoutException catch (_) {
        print("###################################### GET TimeoutException $url ");
        if(context==null){
          return Constant().errTimeout;
        }
        else{
          return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){
            callback();
            onRetry+=1;
          });
        }
      } on SocketException catch (_) {
        print("###################################### GET SocketException $url ");
        if(context==null){
          return Constant().errTimeout;
        }
        else{
          return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){
            callback();
            onRetry+=1;
          });
        }
      }
    }
  }
  Future postProvider(url,Map<String, Object> data,{BuildContext context,Function callback}) async {
    try {
      final token= await userRepository.getDataUser('token');
      Map<String, String> head={
        'Authorization':token,
        'username': Constant().username,
        'password': Constant().password,
        'myconnection':Constant().connection,
        // "HttpHeaders.contentTypeHeader": "application/json"
      };
      final request = await client.post(
          "${Constant().baseUrl}$url",
          headers: head,
          body:data
      ).timeout(Duration(seconds: Constant().timeout));
      if(request.statusCode==200){
        print("=================== POST DATA 200 $url = ${json.decode(request.body)} ============================");
        return json.decode(request.body);
      }
      else if(request.statusCode==400){
        final jsonResponse = json.decode(request.body);
        Navigator.pop(context);
        print(jsonResponse['msg']);
        if(jsonResponse['msg']=='PIN Tidak Sesuai.'||jsonResponse['msg']=='PIN anda tidak sesuai.'|| jsonResponse['msg']=='PIN tidak valid'){
          return WidgetHelper().notifOneBtnDialog(context,"Terjadi Kesalahan",jsonResponse['msg'],()=>Navigator.pop(context));
        }
        else{
          print("error bukan pin");
          return WidgetHelper().notifOneBtnDialog(context,"Terjadi Kesalahan",jsonResponse['msg'],(){callback();});
        }
      }
      else if(request.statusCode==404){
        return WidgetHelper().notifOneBtnDialog(context,"Informasi !","url not found",(){Navigator.pop(context);});
      }
    } on TimeoutException catch (_) {
      print("=================== TimeoutException $url = $TimeoutException ============================");
      if(context!=null){
        return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){Navigator.pop(context);});
      }else{
        return Constant().errTimeout;
      }

    } on SocketException catch (_) {
      print("=================== SocketException $url = $SocketException ============================");
      if(context!=null){
        return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){Navigator.pop(context);});
      }else{
        return Constant().errSocket;
      }
    }
  }
  Future putProvider(url,Map<String, Object> data,{BuildContext context}) async {
    try {
      final token= await userRepository.getDataUser('token');
      Map<String, String> head={
        'Authorization':token,
        'username': Constant().username,
        'password': Constant().password,
        'myconnection':Constant().connection,
        "HttpHeaders.contentTypeHeader": "application/json"
      };
      final request = await client.put(
          "${Constant().baseUrl}$url",
          headers:head,
          body:data
      ).timeout(Duration(seconds: Constant().timeout));
      print("=================== PUT DATA $url = ${request.statusCode} ============================");
      if(request.statusCode==200){
        return {"statusCode":request.statusCode,"data":jsonDecode(request.body)};
      }
      else if(request.statusCode==400){
        final jsonResponse = json.decode(request.body);
        return WidgetHelper().notifOneBtnDialog(context,"Terjadi Kesalahan",jsonResponse['msg'],(){Navigator.pop(context);});
      }
      else if(request.statusCode==413){
        Navigator.pop(context);
        // final jsonResponse = json.decode(request.body);
        print("jsonResponse");
        return WidgetHelper().notifOneBtnDialog(context,"Terjadi Kesalahan","Silahkan hubungi admin kami",(){Navigator.pop(context);});
      }
    } on TimeoutException catch (_) {
      print("=================== TimeoutException $url = $TimeoutException ============================");
      if(context!=null){
        return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){Navigator.pop(context);});
      }else{
        return Constant().errTimeout;
      }

    } on SocketException catch (_) {
      print("=================== SocketException $url = $SocketException ============================");
      if(context!=null){
        return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){Navigator.pop(context);});
      }else{
        return Constant().errSocket;
      }
    }
  }

  Future deleteProvider(url,param,{BuildContext context}) async {
    try {
      final token= await userRepository.getDataUser('token');
      Map<String, String> head={
        'Authorization':token,
        'username': Constant().username,
        'password': Constant().password,
        'myconnection':Constant().connection,
        // "HttpHeaders.contentTypeHeader": "application/json"
      };
      String baseUrl = "${Constant().baseUrl}$url";
      final request = await client.delete(
        baseUrl,
        headers: head,
      ).timeout(Duration(seconds: Constant().timeout));
      if(request.statusCode==200){
        return param(request.body);
      }
      else{
        return General.fromJson(jsonDecode(request.body));
      }
    } on TimeoutException catch (_) {
      if(context!=null){
        return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){Navigator.pop(context);});
      }else{
        return Constant().errTimeout;
      }
    } on SocketException catch (_) {
      if(context!=null){
        return WidgetHelper().notifOneBtnDialog(context,Constant().titleErrTimeout,Constant().descErrTimeout,(){Navigator.pop(context);});
      }else{
        return Constant().errSocket;
      }

    }

  }

}