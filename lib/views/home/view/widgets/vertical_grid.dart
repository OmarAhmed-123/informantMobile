import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'grid_item.dart';

class VerticalGrid extends StatelessWidget {
  final List<Map<String, dynamic>> ads;

  const VerticalGrid({
    Key? key,
    required this.ads,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: AnimationLimiter(
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: List.generate(ads.length, (index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: 3,
              child: ScaleAnimation(
                scale: 0.9,
                child: FadeInAnimation(
                  child: GridItem(ad: ads[index]),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
