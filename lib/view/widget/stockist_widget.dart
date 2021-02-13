// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:sangkuy/config/constant.dart';
// import 'package:sangkuy/helper/data_helper.dart';
// import 'package:sangkuy/helper/function_helper.dart';
// import 'package:sangkuy/helper/widget_helper.dart';
// import 'package:sangkuy/model/general_model.dart';
// import 'package:sangkuy/model/mlm/stockist/pin_model.dart';
// import 'package:sangkuy/provider/stockist_provider.dart';
//
// class StockistWidget extends StatefulWidget {
//   final String tipe;
//   final String status;
//   StockistWidget({this.tipe,this.status});
//
//   @override
//   _StockistWidgetState createState() => _StockistWidgetState();
// }
//
// class _StockistWidgetState extends State<StockistWidget> with SingleTickerProviderStateMixin {
//   int filterStatus=0;
//   PinModel pinModel;
//   bool isLoading=false,isError=false,isLoadmore=false;
//   ScrollController controller;
//   int total=0,perpage=10;
//   Future loadData()async{
//     print(perpage);
//     String url='type=${widget.tipe}&page=1&perpage=$perpage';
//     if(widget.status!=''){
//       setState(() {
//         isLoading=true;
//       });
//       url+='status=${widget.status}';
//       print(url);
//     }
//     var res = await StockistProvider().getPin(url);
//     if(res=='error'){
//       setState(() {
//         isLoading=false;
//         isError=true;
//       });
//     }
//     else if(res==Constant().errExpToken){
//       setState(() {
//         isLoading=false;
//         isError=false;
//       });
//       WidgetHelper().notifOneBtnDialog(context,Constant().titleErrToken,Constant().descErrToken,()async{
//         await FunctionHelper().logout(context);
//       });
//     }
//     else if(res is General){
//       General result=res;
//       setState(() {
//         isLoading=false;
//         isError=false;
//       });
//       WidgetHelper().showFloatingFlushbar(context,"failed",result.msg);
//     }
//     else{
//       if(this.mounted){
//         setState(() {
//           pinModel = PinModel.fromJson(res.toJson());
//           isLoading=false;
//           isError=false;
//           isLoadmore=false;
//           total=pinModel.result.total;
//         });
//       }
//     }
//     return;
//   }
//   void _scrollListener() {
//     if (!isLoading) {
//       if (controller.position.pixels == controller.position.maxScrollExtent) {
//         print('fetch data');
//         if(perpage<total){
//           setState((){
//             perpage+=10;
//             isLoadmore=true;
//           });
//           loadData();
//         }
//       }
//     }
//   }
//   @override
//   void dispose() {
//     controller.removeListener(_scrollListener);
//     isLoading=false;
//     isLoadmore=false;
//     super.dispose();
//
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("STATUS"+widget.status);
//     controller = new ScrollController()..addListener(_scrollListener);
//     isLoading=true;
//     loadData();
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     return Scrollbar(
//         child: Container(
//           padding: EdgeInsets.only(left:0.0,right: 0.0),
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 19,
//                 child: isLoading?loading(context,10):ListView.separated(
//                     shrinkWrap: true,
//                     controller: controller,
//                     itemBuilder: (context,index){
//                       return Container(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius:new BorderRadius.circular(10.0),
//                           onTap: (){},
//                           child: Card(
//                             shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
//                             elevation: 0.0,
//                             color: Colors.transparent,
//                             margin: const EdgeInsets.all(0.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Container(
//                                   margin: EdgeInsets.only(right:10.0),
//                                   width: 10.0,
//                                   height: 60.0,
//                                   decoration: BoxDecoration(
//                                       color:Constant().mainColor,
//                                       borderRadius: new BorderRadius.circular(10.0)
//                                   ),
//                                 ),
//                                 Expanded(
//                                   flex: 1,
//                                   child: Container(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: <Widget>[
//                                         Container(child:WidgetHelper().textQ(pinModel.result.data[index].kode+" ${widget.status}", 12, Colors.black, FontWeight.bold)),
//                                         SizedBox(height:10.0),
//                                         Container(
//                                             child:Row(
//                                               children: [
//                                                 SvgPicture.asset(
//                                                   Constant().localIcon+'lainnya_icon.svg',
//                                                   height: 20,
//                                                   width: 10,
//                                                 ),
//                                                 SizedBox(width:10.0),
//                                                 WidgetHelper().textQ(pinModel.result.data[index].status, 12, Colors.grey, FontWeight.normal)
//                                               ],
//                                             )
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     separatorBuilder: (context,index){return Divider();},
//                     itemCount: pinModel.result.data.length
//                 ),
//               ),
//               isLoadmore?Expanded(
//                 flex: 2,
//                 child: loading(context,1),
//               ):Text('')
//             ],
//           ),
//         )
//     );
//   }
//
//   Widget loading(BuildContext context,int idx){
//     return ListView.separated(
//         itemBuilder: (context,index){
//           return WidgetHelper().baseLoading(context,Card(
//             shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(10.0)),
//             elevation: 0.0,
//             color: Colors.transparent,
//             margin: const EdgeInsets.all(0.0),
//             child: Row(
//               children: <Widget>[
//                 Container(
//                   margin: EdgeInsets.only(right:10.0),
//                   width: 10.0,
//                   height: 60.0,
//                   decoration: BoxDecoration(
//                       color:Colors.white,
//                       borderRadius: new BorderRadius.circular(10.0)
//                   ),
//                 ),
//                 Expanded(
//                   flex: 1,
//                   child: Container(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Container(
//                           height: 10,
//                           width: MediaQuery.of(context).size.width/2,
//                           color:Colors.white,
//                         ),
//                         SizedBox(height:10.0),
//                         Row(
//                           children: [
//                             Container(
//                               height: 20,
//                               width: 20,
//                               decoration: BoxDecoration(
//                                 shape:BoxShape.circle,
//                                 color:Colors.white,
//                               ),
//                             ),
//                             SizedBox(width:10.0),
//                             Container(
//                               height: 10,
//                               width: MediaQuery.of(context).size.width/2,
//                               color:Colors.white,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ));
//         },
//         separatorBuilder: (context,index){return Divider();},
//         itemCount: idx
//     );
//   }
// }
