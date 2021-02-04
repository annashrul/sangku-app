
class UserTable {
  static const String TABLE_NAME = "user";
  static const String CREATE_TABLE =
      " CREATE TABLE IF NOT EXISTS $TABLE_NAME ( id INTEGER PRIMARY KEY AUTOINCREMENT, id_user TEXT , token TEXT, full_name TEXT, mobile_no TEXT, membership TEXT, referral_code TEXT,device_id TEXT,  status TEXT, picture TEXT, is_login TEXT, onboarding TEXT, exit_app TEXT) ";
  static const String SELECT = "select * from $TABLE_NAME";
}