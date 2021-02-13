import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/model/member/bank_member_model.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberProvider{
  Future getDataMember()async{
    final idMember = await UserHelper().getDataUser("id_user");
    String url = 'member/get/$idMember';
    print("URL $url");
    var res = await BaseProvider().getProvider(url,dataMemberModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      print("######################## error LOAD MEMBER #########################");
      return 'error';
    }
    else if(res==Constant().errExpToken){
      print("######################## errExpToken LOAD MEMBER #########################");
      return Constant().errExpToken;
    }
    else{
      if(res is DataMemberModel){
        DataMemberModel result=res;
        // SharedPreferences preferences = await SharedPreferences.getInstance();
        // List<String> val=['${result.result.toJson()}'];
        // print("######################## SUCCESS LOAD MEMBER $val #########################");
        // preferences.setStringList("member",val);
        if(result.status=='success'){
          return DataMemberModel.fromJson(result.toJson());
        }
        else{
          print("######################## FAILED LOAD MEMBER #########################");
          return 'failed';
        }
      }
    }
  }

  Future getBankMember(where)async{
    String url='bank_member';
    if(where!=''){
      url+='?$where';
    }
    BankMemberModel bankMemberModel;
    var res = await BaseProvider().getProvider(url, bankMemberModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else{
      if(res is BankMemberModel){
        BankMemberModel result=res;
        print('result');
        if(result.status=='success'){
          bankMemberModel = BankMemberModel.fromJson(result.toJson());
          return bankMemberModel;
        }
        else{
          return 'failed';
        }
      }
    }
  }



}