import 'package:flutter/material.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class HistoryTransactionLoading extends StatelessWidget {
  int tot=0;
  HistoryTransactionLoading({this.tot});
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(10.0),
      itemCount: tot,
      itemBuilder: (context,index){
        return WidgetHelper().baseLoading(context,Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 10,width: MediaQuery.of(context).size.width/1,color: Colors.white),
            SizedBox(height: 5.0),
            Container(height: 10,width: MediaQuery.of(context).size.width/2,color: Colors.white),
            SizedBox(height: 5.0),
            Container(height: 10,width: MediaQuery.of(context).size.width/3,color: Colors.white),
            SizedBox(height: 5.0),
            Container(height: 10,width: MediaQuery.of(context).size.width/4,color: Colors.white),
          ],
        ));
      },
      separatorBuilder: (context,index){return Divider();},
    );
  }
}
