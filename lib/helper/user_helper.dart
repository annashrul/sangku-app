import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/table_helper.dart';

class UserHelper{
  final DatabaseConfig _helper = new DatabaseConfig();
  Future getDataUser(param) async{
    // final countTable = await _helper.queryRowCount(UserQuery.TABLE_NAME);
    final users = await _helper.readData(UserTable.SELECT);
    if(users.length>0){
      if(param=='id'){return users[0]['id'];}
      if(param=='id_user'){return users[0]['id_user'];}
      if(param=='full_name'){return users[0]['full_name'];}
      if(param=='token'){return users[0]['token'];}
      // if(param=='token'){return Constant().token;}
      if(param=='mobile_no'){return users[0]['mobile_no'];}
      if(param=='membership'){return users[0]['membership'];}
      if(param=='referral_code'){return users[0]['referral_code'];}
      if(param=='device_id'){return users[0]['device_id'];}
      if(param=='status'){return users[0]['status'];}
      if(param=='picture'){return users[0]['picture'];}
      if(param=='biografi'){return users[0]['biografi'];}
      if(param=='is_login'){return users[0]['is_login'];}
      if(param=='onboarding'){return users[0]['onboarding'];}
      if(param=='exit_app'){return users[0]['exit_app'];}
    }



  }
}