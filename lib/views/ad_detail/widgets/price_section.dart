import 'package:flutter/material.dart';

class PriceSection extends StatelessWidget {
  final double price;
  final double potentialRevenue;

  const PriceSection({
    Key? key,
    required this.price,
    required this.potentialRevenue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildPriceColumn('Price', price),
        _buildPriceColumn('Potential Revenue', potentialRevenue),
      ],
    );
  }

  Widget _buildPriceColumn(String label, double amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
