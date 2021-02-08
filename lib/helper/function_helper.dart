import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:sangkuy/config/database_config.dart';
import 'package:sangkuy/helper/table_helper.dart';
import 'package:sangkuy/helper/user_helper.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/view/screen/auth/sign_in_screen.dart';

class FunctionHelper{
  final formatter = new NumberFormat("#,###");
  DatabaseConfig db = DatabaseConfig();

  Future logout(BuildContext context)async{
    final id=await UserHelper().getDataUser("id");
    final res = await db.update(UserTable.TABLE_NAME, {'id':"${id.toString()}","is_login":"0"});
    WidgetHelper().myPushRemove(context,SignInScreen());
  }
}