import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' show Client;
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/generated_route.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';

class BaseProvider{
  Client client = Client();
  final userRepository = UserHelper();
  Future getProvider(url,param)async{
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
      print("=================== GET DATA $url = ${response.statusCode} ============================");
      final jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        if(jsonResponse['result'].length>0){
          return param(response.body);
        }else{
          print("=================== GET DATA $url = NODATA ============================");
          return Constant().errNoData;
        }
      }
      else if(response.statusCode == 400){
        if(jsonResponse['name']==Constant().errExpToken){
          return Constant().errExpToken;
        }
        return General.fromJson(jsonResponse);
      }
    }on TimeoutException catch (_) {
      return Constant().errTimeout;
    } on SocketException catch (_) {
      return Constant().errSocket;
    }
  }
  Future postProvider(url,Map<String, Object> data,{BuildContext context}) async {
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
      print("=================== POST DATA $url = ${request.statusCode} ============================");
      if(request.statusCode==200){
        return jsonDecode(request.body);
      }
      else if(request.statusCode==400){
        return General.fromJson(jsonDecode(request.body));
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
  Future putProvider(url,Map<String, Object> data) async {
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
        return jsonDecode(request.body);
      }
      else if(request.statusCode==400){
        return General.fromJson(jsonDecode(request.body));
      }
    } on TimeoutException catch (_) {
      return Constant().errTimeout;
    } on SocketException catch (_) {
      return Constant().errSocket;
    }
  }

  Future deleteProvider(url,param) async {
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
      return Constant().errTimeout;
    } on SocketException catch (_) {
      return Constant().errSocket;
    }

  }

}