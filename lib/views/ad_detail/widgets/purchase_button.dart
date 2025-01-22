import 'package:flutter/material.dart';
import 'package:graduation___part1/views/ad_detail/view_model/ad_detail_view_model.dart';
import 'package:provider/provider.dart';

class PurchaseButton extends StatelessWidget {
  const PurchaseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdDetailViewModel>(context);

    return FloatingActionButton.extended(
      onPressed: () => viewModel.purchaseAd(context),
      icon: const Icon(Icons.shopping_cart),
      label: const Text('Purchase Ad'),
      backgroundColor: Colors.green,
    );
  }
}
