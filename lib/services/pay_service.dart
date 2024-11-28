import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easypku/services/payment_config.dart';

class PayService {

  Widget getGooglePayButton(BuildContext context, double amount) {
    return GooglePayButton(
      paymentConfiguration:
          PaymentConfiguration.fromJsonString(defaultGooglePay),
      paymentItems: [
        PaymentItem(
          label: 'Total',
          amount: amount.toStringAsFixed(2),
          status: PaymentItemStatus.final_price,
        ),
      ],
      width: 400,
      type: GooglePayButtonType.pay,
      margin: const EdgeInsets.only(top: 15.0),
      onPaymentResult: (result) async {
        try {
          if (result['paymentMethodData'] != null && result['paymentMethodData']['tokenizationData'] != null) {     
            final String uid = FirebaseAuth.instance.currentUser!.uid;
            final String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
            var paymentDetails = result['paymentMethodData'];

            await FirebaseFirestore.instance.collection('transactions').doc(transactionId).set({
                  'userId': uid,
                  'transactionId': transactionId,
                  'amount': amount,
                  'timestamp': FieldValue.serverTimestamp(),
                  'paymentDetails': paymentDetails,
                });

            await FirebaseFirestore.instance.collection('users').doc(uid).update({'bill': 0.00});

            Navigator.pop(context, true); 

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment successful! Bill has been cleared.'),
                backgroundColor: Colors.green,
              ),
            );
          } 
          else {            
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment failed. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('An error occurred: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      loadingIndicator: const Center(child: CircularProgressIndicator()),
    );
  }
}
