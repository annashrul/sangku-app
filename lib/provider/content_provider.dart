import 'package:flutter/material.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/model/content/content_model.dart';
import 'package:sangkuy/model/content/testimoni_model.dart';
import 'package:sangkuy/model/mlm/redeem/list_redeem_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class ContentProvider{
  Future loadData(String param,String where)async{
    String url = 'content/$param';
    if(where!=''){
      url+='?$where';
    }
    var res = await BaseProvider().getProvider(url,contentModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else{
      if(res is ContentModel){
        ContentModel result=res;
        return ContentModel.fromJson(result.toJson());
      }
    }
  }
  Future loadRedeem(String where)async{
    String url = 'redeem/barang';
    if(where!=''){
      url+='?$where';
    }
    var res = await BaseProvider().getProvider(url,listRedeemModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else{
      if(res is ListRedeemModel){
        ListRedeemModel result=res;
        if(result.status=='success'){
          return ListRedeemModel.fromJson(result.toJson());
        }
        else{
          return 'failed';
        }
      }
    }
  }

  Future loadTestimoni(String where)async{
    String url='content/testimoni';
    if(where!=''){
      url+='?$where';
    }
    var res = await BaseProvider().getProvider(url,testimoniModelFromJson);
    if(res is TestimoniModel){
      TestimoniModel result=res;
      return TestimoniModel.fromJson(result.toJson());
    }
  }
}