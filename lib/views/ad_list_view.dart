import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/ad_view_model.dart';
import 'ad_detail_view.dart';

class AdListView extends StatelessWidget {
  const AdListView({super.key});

  @override
  Widget build(BuildContext context) {
    final adViewModel = Provider.of<AdViewModel>(context);

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
        child: ListView.builder(
          itemCount: adViewModel.ads.length,
          itemBuilder: (context, index) {
            final ad = adViewModel.ads[index];
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
        ),
      ),
    );
  }
}
