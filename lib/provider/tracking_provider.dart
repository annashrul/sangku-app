import 'package:flutter/cupertino.dart';
import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/helper/widget_helper.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/resi_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class TrackingProvider{
  Future checkResi(resi,kurir,kd_trx,{BuildContext context})async{
    var res = await BaseProvider().postProvider("transaction/kurir/cek/resi",{
      "resi":resi,
      "kurir":kurir,
      "kd_trx": kd_trx
    },context: context);
    print(res);
    if(res!=null)
      return ResiModel.fromJson(res);
  }
}