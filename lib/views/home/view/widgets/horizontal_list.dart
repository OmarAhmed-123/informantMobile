import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'ad_card.dart';

class HorizontalList extends StatelessWidget {
  final double itemWidth;
  final double itemHeight;
  final List<Map<String, dynamic>> ads;

  const HorizontalList({
    Key? key,
    required this.itemWidth,
    required this.itemHeight,
    required this.ads,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    return SizedBox(
      height: itemHeight,
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: ads.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 600),
              child: SlideAnimation(
                horizontalOffset: 50.0,
                child: FadeInAnimation(
                  child: AdCard(
                    imageUrl: ads[index]['images'][0],
                    ad: ads[index],
                    width: itemWidth * 0.9,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
