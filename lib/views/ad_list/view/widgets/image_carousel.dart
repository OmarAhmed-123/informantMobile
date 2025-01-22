import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'rating_badge.dart';

class ImageCarousel extends StatelessWidget {
  final List<dynamic> images;
  final Function(int) onPageChanged;

  const ImageCarousel({
    Key? key,
    required this.images,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 200,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              onPageChanged: (index, _) => onPageChanged(index),
            ),
            items:
                images.map((imageUrl) => _buildCarouselItem(imageUrl)).toList(),
          ),
        ),
        const Positioned(
          bottom: 8,
          right: 8,
          child: RatingBadge(rating: 4.5),
        ),
      ],
    );
  }

  Widget _buildCarouselItem(String imageUrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.grey[900]),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.error_outline, color: Colors.white60, size: 50),
        ),
      ),
    );
  }
}
