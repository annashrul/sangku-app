import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/model/data_bank_model.dart';
import 'package:sangkuy/model/mlm/bank_model.dart';

import 'base_provider.dart';

class BankProvider{
  Future getBank(where)async{
    String url='bank';
    if(where!=''){
      url+="?$where";
    }
    BankModel bankModel;
    var res = await BaseProvider().getProvider(url, bankModelFromJson);
    print(res);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else{
      if(res is BankModel){
        BankModel result=res;
        if(result.status=='success'){
          // print(res.result.data);
          // bankModel = BankModel.fromJson(result.toJson());
          return result.toJson();
        }
        else{
          return 'failed';
        }
      }
    }
  }
  Future getDataBank()async{
    var res = await BaseProvider().getProvider('bank/data', dataBankModelFromJson);
    print(res);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else{
      if(res is DataBankModel){
        DataBankModel result=res;
        if(result.status=='success'){
          return result;
        }
        else{
          return 'failed';
        }
      }
    }
  }
}