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
  final String url; // Add a url parameter to the constructor
  const PaymentPage({Key? key, required this.url}) : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool isPaymentCompleted = false;

  bool hasError = false; // Track if there's an error

  InAppWebViewController? _webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Payment'),
      ),
      body: Column(
        children: [
          Expanded(
            child: hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load payment page. Please try again.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              hasError = false; // Reset error state
                            });
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  )
                : InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
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
              duration: Duration(milliseconds: 500),
              child: ElevatedButton(
                onPressed: isPaymentCompleted
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyAdsPage()),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
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
