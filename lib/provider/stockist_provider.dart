// import 'package:sangkuy/config/constant.dart';
// import 'package:sangkuy/helper/user_helper.dart';
// import 'package:sangkuy/model/general_model.dart';
// import 'package:sangkuy/model/mlm/stockist/pin_model.dart';
// import 'package:sangkuy/provider/base_provider.dart';
//
// class StockistProvider{
//   Future getPin(String where)async{
//     // member/pin/555d0e4a-474e-41f8-8857-f68b5f092ab9?type=1&page=1&perpage=1
//     final id=await UserHelper().getDataUser("id_user");
//     String url='member/pin/$id';
//     if(where!=''){
//       url+='?$where';
//     }
//     var res = await BaseProvider().getProvider(url, pinModelFromJson);
//     print("BASE $res");
//
//     if(res==Constant().errSocket||res==Constant().errTimeout){
//       return 'error';
//     }
//     else if(res==Constant().errExpToken){
//       return Constant().errExpToken;
//     }
//     else if(res is General){
//       print('failed');
//       return 'failed';
//     }
//     else{
//       if(res is PinModel){
//
//         PinModel result=res;
//         if(result.status=='success'){
//           print("RESPONSE STOCKIS ${result.toJson()}");
//           pinModel = result;
//           return 'pinModel';
//         }
//         else{
//           return 'failed';
//         }
//       }
//     }
//   }
//
// }