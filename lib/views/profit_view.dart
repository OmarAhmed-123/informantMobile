import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_models/ad_view_model.dart';

class ProfitView extends StatelessWidget {
  const ProfitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profit'),
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
            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Income',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${adViewModel.totalIncome.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    child: ListView.builder(
                      itemCount: adViewModel.ads.length,
                      itemBuilder: (context, index) {
                        final ad = adViewModel.ads[index];
                        return ListTile(
                          title: Text(ad.name),
                          subtitle: Text(
                              'Date: ${DateFormat('yyyy-MM-dd').format(ad.createdAt)}'),
                          trailing: Text('\$${ad.earnings.toStringAsFixed(2)}'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
