import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentPage extends StatefulWidget {
  final String url; // Add a url parameter to the constructor
  const PaymentPage({super.key, required this.url});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isPaymentCompleted = false;

  bool hasError = false; // Track if there's an error

  late InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load payment page. Please try again.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hasError = false; // Reset error state
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : InAppWebView(
                    initialUrlRequest: URLRequest(url: WebUri(widget.url)),
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStop: (controller, url) async {
                      if (url.toString().contains("payment-success")) {
                        setState(() {
                          isPaymentCompleted = true;
                        });
                      }
                    },
                    onLoadError: (controller, url, code, message) {
                      // Handle loading errors

                      setState(() {
                        hasError = true;
                      });
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedOpacity(
              opacity: isPaymentCompleted ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: isPaymentCompleted ? () {} : null,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Proceed to My Ads',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
