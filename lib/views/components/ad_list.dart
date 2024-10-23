// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import '../../models/ad.dart';

class AdList extends StatelessWidget {
  final List<Ad> ads;

  const AdList({Key? key, required this.ads}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ads.length,
      itemBuilder: (context, index) {
        final ad = ads[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(ad.imageUrl),
            ),
            title: Text(ad.name),
            subtitle: Text('\$${ad.price.toStringAsFixed(2)}'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to ad detail view
            },
          ),
        );
      },
    );
  }
}
