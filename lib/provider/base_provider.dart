import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/model/general_model.dart';

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
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return param(response.body);
      }
      else if(response.statusCode == 400){
        return Constant().errExpToken;
      }
      // else if(res.)
    }on TimeoutException catch (_) {
      return Constant().errTimeout;
    } on SocketException catch (_) {
      return Constant().errSocket;
    }
  }
  Future postProvider(url,Map<String, Object> data) async {
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
      print(request.body);
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