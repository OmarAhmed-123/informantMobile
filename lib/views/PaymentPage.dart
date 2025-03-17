// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:graduation___part1/views/MyAdsPage.dart';

// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   final String payUrl =
//       "https://accept.paymob.com/api/ecommerce/payment-links/unrestricted?token=LRR2dG5XVkdoQ3FZblhnT3kvQmREVFZqZz09X0YwZllZbXRwV09ROHBOamdmZ0VvTnc9PQ";
//   bool isPaymentCompleted = false;
//   InAppWebViewController? _webViewController;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Complete Payment'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: InAppWebView(
//             initialUrlRequest: URLRequest(url: Uri.parse(payUrl)),
//             onWebViewCreated: (controller) {
//               _webViewController = controller;
//             },
//             onLoadStop: (controller, url) async {
//               // Check if the payment is completed by inspecting the URL or page content
//               // This is a placeholder logic; replace it with actual backend validation
//               if (url.toString().contains("payment-success")) {
//                 setState(() {
//                   isPaymentCompleted = true;
//                 });
//               }
//             },
//           )),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: AnimatedOpacity(
//               opacity: isPaymentCompleted ? 1.0 : 0.5,
//               duration: Duration(milliseconds: 500),
//               child: ElevatedButton(
//                 onPressed: isPaymentCompleted
//                     ? () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => MyAdsPage()),
//                         );
//                       }
//                     : null,
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   'Proceed to My Ads',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:graduation___part1/views/MyAdsPage.dart';

class PaymentPage extends StatefulWidget {
  final String url; // URL for the payment page
  const PaymentPage({super.key, required this.url});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isPaymentCompleted = false; // Track if payment is completed
  bool hasError = false; // Track if there's an error
  InAppWebViewController? _webViewController; // Controller for the web view

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Payment'),
      ),
      body: Column(
        children: [
          // WebView to load the payment page
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
                    initialUrlRequest: URLRequest(
                        url: WebUri(widget.url)), // Changed Uri.parse to WebUri
                    onWebViewCreated: (controller) {
                      _webViewController = controller;
                    },
                    onLoadStop: (controller, url) async {
                      // Check if the payment is completed
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
          // Button to proceed to My Ads page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedOpacity(
              opacity: isPaymentCompleted ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: isPaymentCompleted
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyAdsPage()),
                        );
                      }
                    : null,
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
