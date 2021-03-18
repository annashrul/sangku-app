import 'package:flutter/cupertino.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/member/bank_member_model.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/model/notif_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberProvider{
  Future getDataMember()async{
    final idMember = await UserHelper().getDataUser("id_user");
    String url = 'member/get/$idMember';
    var res = await BaseProvider().getProvider(url,dataMemberModelFromJson);
    print("###################################### MEMBER ###############################");
    print(res);
    print("###################################### MEMBER ###############################");

    if(res is DataMemberModel){
      DataMemberModel result=res;
      if(result.status=='success'){
        return DataMemberModel.fromJson(result.toJson());
      }
      else{
        return 'failed';
      }
    }
  }
  
  Future updateMember(data,BuildContext context)async{
    final id=await UserHelper().getDataUser("id_user");
    var res=await BaseProvider().putProvider('member/$id', data,context: context);
    if(res!=null){
      return 'success';
    }

  }

  Future getBankMember(where,BuildContext context,Function callback)async{
    String url='bank_member';
    if(where!=''){
      url+='?$where';
    }
    BankMemberModel bankMemberModel;
    var res = await BaseProvider().getProvider(url, bankMemberModelFromJson,context: context,callback: callback);
    if(res==Constant().errNoData){
      return Constant().errNoData;
    }
    else{
      if(res is BankMemberModel){
        BankMemberModel result=res;
        bankMemberModel = BankMemberModel.fromJson(result.toJson());
        return bankMemberModel;
      }
    }
  }

  Future getDataNotif(String where)async{
    String url = 'site/notif';
    if(where!=''){
      url+='?$where';
    }
    print("URL $url");
    var res = await BaseProvider().getProvider(url,notifModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      print("######################## error LOAD NOTIF #########################");
      return 'error';
    }
    else if(res==Constant().errExpToken){
      print("######################## errExpToken LOAD NOTIF #########################");
      return Constant().errExpToken;
    }
    else if(res==Constant().errNoData){
      print("######################## errNoData LOAD NOTIF #########################");
      return Constant().errNoData;
    }
    else{
      if(res is NotifModel){
        NotifModel result=res;

        // NotifModel notifModel;
        if(result.status=='success'){
          // notifModel = BankMemberModel.fromJson(result.toJson());
          // return bankMemberModel;
          return NotifModel.fromJson(result.toJson());
        }
        else{
          print("######################## FAILED LOAD NOTIF #########################");
          return 'failed';
        }
      }
    }
  }

  Future countNotif()async{
    var res = await getDataNotif('');
    if(res is NotifModel){
      NotifModel result=res;
      return result.result.data.length;
    }
    else{
      return 0;
    }
  }


}