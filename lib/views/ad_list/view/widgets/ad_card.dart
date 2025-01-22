import 'package:flutter/material.dart';
import '../../animations/fade_scale_animation.dart';
import 'image_carousel.dart';
import 'header_section.dart';
import 'details_section.dart';
import 'footer_section.dart';

class AdCard extends StatelessWidget {
  final Map<String, dynamic> ad;
  final int index;
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;
  final Animation<Offset> slideAnimation;
  final Function(int) onImageChanged;
  final Function(Map<String, dynamic>, int) onViewDetails;

  const AdCard({
    Key? key,
    required this.ad,
    required this.index,
    required this.fadeAnimation,
    required this.scaleAnimation,
    required this.slideAnimation,
    required this.onImageChanged,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeScaleAnimation(
      fadeAnimation: fadeAnimation,
      scaleAnimation: scaleAnimation,
      slideAnimation: slideAnimation,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.purple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade900.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageCarousel(
              images: ad['images'],
              onPageChanged: onImageChanged,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(
                    name: ad['name'],
                    availablePlaces: ad['availablePlaces'],
                  ),
                  const SizedBox(height: 8),
                  DetailsSection(details: ad['details']),
                  const SizedBox(height: 16),
                  FooterSection(
                    potentialRevenue: ad['potentialRevenue'],
                    onViewDetails: () => onViewDetails(ad, index),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
