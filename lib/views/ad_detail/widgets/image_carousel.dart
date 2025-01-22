import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageCarousel extends StatelessWidget {
  final List<String>? images;
  final CarouselOptions options;

  const ImageCarousel({
    Key? key,
    required this.images,
    required this.options,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: options,
      items: images?.map((imageUrl) {
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[900],
          ),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child:
                    Icon(Icons.error_outline, color: Colors.white60, size: 50),
              );
            },
          ),
        );
      }).toList(),
    );
  }
}
