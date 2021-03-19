import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/address/address_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class AddressProvider{
  Future getAddress(limit)async{
    AddressModel addressModel;
    var res = await BaseProvider().getProvider("alamat?page=1&perpage=$limit", addressModelFromJson);
    print("ADREESS sdsdsds $res");
    if(res==Constant().errNoData){
      return Constant().errNoData;
    }
    else if(res is AddressModel) {
      AddressModel result = res;
      addressModel = AddressModel.fromJson(result.toJson());
      return addressModel;
    }
  }
}