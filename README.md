### Graduation_Project
# Testing Paymob Payment Integration

To test the Paymob payment integration in the application, use the following test credentials to simulate a transaction. These credentials are intended for use in a non-production environment on the Paymob test server only.

## Test Card Details
- **Cardholder Name**: TEST ACCOUNT
- **Card Number**: 521111111111111111111111
- **Expiry Date**: 12/25
- **CVV**: 123

## Test Phone Number
- **Phone Number**: +201114341924 (Contact this number for customer service if the test server is down)

## Steps to Test Payment
1. Go to the payment section of the application, which will load the Paymob payment page via the provided URL.
2. Enter the test card details and phone number listed above.
3. Submit the payment to simulate a transaction.
4. On successful payment, the application will redirect to a "payment-success" URL, and the "Proceed to My Ads" button will become active.
5. If an error occurs, a retry option will appear to reload the payment page.

## Important Notes
- These credentials are strictly for testing and must not be used in a live environment.
- Ensure connection to the Paymob test server when using these details.
- For issues, consult the Paymob documentation or contact their support team. If the test server is unavailable, reach out to customer service at the provided phone number.
