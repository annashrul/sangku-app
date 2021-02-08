import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/cart_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider{
  Future postCart(id,qty,tipe)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("packageType", tipe);
    print("PACKAGE TYPE ${prefs.getString("packageType")}");
    final data={
      "id_paket":id,
      "qty":qty
    };
    var res = await BaseProvider().postProvider('transaction/cart', data);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else{
      if(res is General){
        General result=res;
        return '${result.msg}';
      }else{
        return 'success';
      }
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
    else{
      if(res is CartModel){
        CartModel result=res;
        if(result.status=='success'){
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