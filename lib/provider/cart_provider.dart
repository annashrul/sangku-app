import 'package:flutter/cupertino.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/cart_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider{
  Future postCart(id,qty,tipe,BuildContext context,Function callback)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("packageType", tipe);
    final data={
      "id_paket":id,
      "type":qty,
      "qty":"-"
    };
    print(data);
    var res = await BaseProvider().postProvider('transaction/cart', data,context: context,callback: callback);
    if(res!=null){
      return 'success';
    }


  }
  Future deleteCart(id)async{
    final data={};
    var res = await BaseProvider().deleteProvider('transaction/cart/$id', generalFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else{
      return 'success';
    }
  }
  Future getCart()async{
    CartModel cartModel;
    var res = await BaseProvider().getProvider("transaction/cart", cartModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else if(res==Constant().errNoData){
      return Constant().errNoData;
    }
    else if(res is General){
      General result=res;
      return General.fromJson(result.toJson());
    }
    else{
      if(res is CartModel){
        CartModel result=res;
        if(result.status=='success'){
          print("RESPONSE CART ${result.toJson()}");
          cartModel = CartModel.fromJson(result.toJson());
          return cartModel;
        }
        else{
         return 'failed';
        }
      }
    }
  }
}