import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/address/address_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class AddressProvider{
  Future getAddress(limit)async{
    AddressModel addressModel;
    var res = await BaseProvider().getProvider("alamat?page=1&perpage=$limit", addressModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else{
      if(res is AddressModel){
        AddressModel result=res;
        print('result');
        if(result.status=='success'){
          addressModel = AddressModel.fromJson(result.toJson());
          return addressModel;
        }
        else{
          return 'failed';
        }
      }
    }
  }
}