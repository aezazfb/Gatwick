import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';

class StripeTransactionResponse {
  String message;
  bool success;
  //var body;
  StripeTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com/v1';
  static String paymentApiUrl = '${StripeService.apiBase}/payment_intents';
  static String secret =
      'sk_test_51I4TrXIxU4GBTGuBvNZkcianxeVOFPmXWsrsUndR7BqA5S2hQJmBPzWfFfMmVcivuu1FNd8bmxpkOJvKv8dR8C9M00E8FePqQP';
  static Map<String, String> headers = {
    'Authorization': 'Bearer ${StripeService.secret}',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  static init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51I4TrXIxU4GBTGuBBOu5Bj4GWY8g8ajnIPQj4G0XySt5NMHAmDZktchMjnpshRiEJMFuhcy0rskOaus2YL04KmhX00B8r2iE1k",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  static Future<StripeTransactionResponse> payWithCard(
      {String amount, String currency}) async {
    try {
      var paymentMethod = await StripePayment.paymentRequestWithCardForm(
          CardFormPaymentRequest());

      //print("--------------------------------------------------------------------------------------");
      //print("this is payment Method: ${paymentMethod.toString()}");

      var paymentIntent =
          await StripeService.createPaymentIntent(amount, currency);

      var response = await StripePayment.confirmPaymentIntent(
          PaymentIntent(clientSecret: paymentIntent['client_secret'],
          paymentMethodId: paymentMethod.id
          )
      );

      print("--------------------------------------------------------------------------------------");
      print("Encoded Response: $response");
      var decodeResponse = response.toJson();
      print("this is decoded Response: $decodeResponse");

      if(response.status == 'succeeded'){
        return new StripeTransactionResponse(
            message: 'Transaction Successful', success: true);
      }else{
        return new StripeTransactionResponse(
            message: 'Transaction Unsuccessful', success: false);

      }
      } catch (e) {
      print("-----------------------------------------Reached Here------------------------------------");
      return new StripeTransactionResponse(
          message: 'Transaction Failed ${e.toString()}', success: false);
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(StripeService.paymentApiUrl,
          body: body, headers: StripeService.headers);
      return jsonDecode(response.body);

    } catch (err) {
      print("error caught: ${err.toString()}");
    }
    return null;
  }
}
