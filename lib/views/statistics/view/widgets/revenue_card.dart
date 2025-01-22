import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../view_model/profit_view_model.dart';
import 'package:provider/provider.dart';

class RevenueCard extends StatelessWidget {
  final Animation<double> slideAnimation;

  const RevenueCard({Key? key, required this.slideAnimation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfitViewModel>(
      builder: (context, viewModel, child) {
        return AnimatedBuilder(
          animation: slideAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, slideAnimation.value),
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(24),
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
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Revenue',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${NumberFormat('#,##0.00').format(viewModel.totalRevenue)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
