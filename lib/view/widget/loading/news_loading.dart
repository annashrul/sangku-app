import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class NewsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(
      primary: false,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 4,
      itemCount: 4,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0,bottom:0.0),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/1,
                  height: MediaQuery.of(context).size.width/4,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/1,
                  height: 5.0,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  width: MediaQuery.of(context).size.width/3,
                  height: 5.0,
                  color: Colors.white,
                ),

              ],
            ),
          ),
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.fit(2),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 0.0,
    );
  }
}
