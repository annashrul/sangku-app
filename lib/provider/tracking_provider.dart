import 'package:sangkuy/config/constant.dart';
import 'package:sangkuy/model/general_model.dart';
import 'package:sangkuy/model/mlm/resi_model.dart';
import 'package:sangkuy/provider/base_provider.dart';

class TrackingProvider{
  Future checkResi(resi,kurir,kd_trx)async{
    var res = await BaseProvider().postProvider("transaction/kurir/cek/resi",{
      "resi":resi,
      "kurir":kurir,
      "kd_trx": kd_trx
    });
    if(res == '${Constant().errTimeout}'|| res=='${Constant().errSocket}'){
      return 'error';
    }
    else{
      if(res is General){
        return 'failed';

      }
      else{
        return ResiModel.fromJson(res);
        // Navigator.pop(context);
        // setState(() {
        //   resiModel = ResiModel.fromJson(res);
        // });
        // WidgetHelper().myPush(context,ResiScreen(resiModel: resiModel));
      }
    }
  }
}