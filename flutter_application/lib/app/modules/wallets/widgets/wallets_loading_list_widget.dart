import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WalletsLoadingListWidget extends StatelessWidget {
  const WalletsLoadingListWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: 2,
        itemBuilder: (_, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.grey[200].withOpacity(0.1),
            child: Container(
              width: 260,
              height: 190,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          );
        });
  }
}
