// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/ad_view_model.dart';
import 'ad_detail_view.dart';

class AdListView extends StatefulWidget {
  const AdListView({Key? key}) : super(key: key);

  @override
  _AdListViewState createState() => _AdListViewState();
}

class _AdListViewState extends State<AdListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdViewModel>(context, listen: false).fetchAds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ad List'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[900]!, Colors.black],
          ),
        ),
        child: Consumer<AdViewModel>(
          builder: (context, adViewModel, child) {
            if (adViewModel.ads.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              itemCount: adViewModel.ads.length,
              itemBuilder: (context, index) {
                final ad = adViewModel.ads[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(ad.imageUrl),
                    ),
                    title: Text(ad.name),
                    subtitle: Text('\$${ad.price.toStringAsFixed(2)}'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdDetailView(ad: ad),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
