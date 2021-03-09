import 'package:flutter/material.dart';
import 'package:sangkuy/helper/widget_helper.dart';

class TestimoniLoading extends StatelessWidget {
  int total=5;
  TestimoniLoading({this.total});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: total,
        itemBuilder: (context,index){
          return FlatButton(
            onPressed: (){},
            child:WidgetHelper().baseLoading(context, Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.all(0.0),
                  trailing: Icon(Icons.arrow_right),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle
                    ),
                  ),
                  title: Container(width: 100,height: 15,color: Colors.white),
                  subtitle: Container(width: 200,height: 10,color: Colors.white),
                ),
                Container(width: MediaQuery.of(context).size.width/1,height: 10,color: Colors.white),
                SizedBox(height: 5.0),
                Container(width: MediaQuery.of(context).size.width/2,height: 10,color: Colors.white),
                SizedBox(height: 5.0),
                Container(width: MediaQuery.of(context).size.width/3,height: 10,color: Colors.white),
              ],
            )),
          );
        }
    );
  }
}
