import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/model/member/data_member_model.dart';
import 'package:sangkuy/provider/base_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberProvider{
  Future getDataMember()async{
    final idMember = await UserHelper().getDataUser("id_user");
    String url = 'member/get/$idMember';
    var res = await BaseProvider().getProvider(url,dataMemberModelFromJson);
    if(res==Constant().errSocket||res==Constant().errTimeout){
      return 'error';
    }
    else if(res==Constant().errExpToken){
      return Constant().errExpToken;
    }
    else{
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
  }
}