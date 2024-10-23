// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../../models/ad.dart';

class AdCarousel extends StatelessWidget {
  final List<Ad> ads;

  const AdCarousel({Key? key, required this.ads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(ad.imageUrl,
                    height: 120, width: 200, fit: BoxFit.cover),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ad.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(ad.description,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
