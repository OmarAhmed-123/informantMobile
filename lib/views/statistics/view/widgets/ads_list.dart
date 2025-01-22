import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../view_model/profit_view_model.dart';
import 'package:provider/provider.dart';

class AdsList extends StatelessWidget {
  final Animation<double> fadeAnimation;

  const AdsList({Key? key, required this.fadeAnimation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfitViewModel>(
      builder: (context, viewModel, child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.ads.length,
          itemBuilder: (context, index) {
            final ad = viewModel.ads[index];
            return AnimatedBuilder(
              animation: fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: fadeAnimation.value,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.grey.shade900, Colors.black87],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(ad['images'][0]),
                        backgroundColor: Colors.grey[850],
                      ),
                      title: Text(
                        ad['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              ad['stars'] as int,
                              (index) => const Icon(Icons.star,
                                  color: Colors.amber, size: 14),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${ad['availablePlaces']} places available',
                            style: TextStyle(color: Colors.green.shade400),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '\$${NumberFormat('#,##0').format(ad['potentialRevenue'])}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
