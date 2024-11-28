import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easypku/pages/transactionrecord.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:easypku/services/pay_service.dart';

class Billpage extends StatelessWidget {
  const Billpage({super.key});

  Future<double> getBill() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot userDoc =await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists && userDoc.data() != null && userDoc['bill'] != null) {
      // Ensure the 'bill' value is always returned as a double
      return (userDoc['bill'] is double)? userDoc['bill'] as double: (userDoc['bill'] as num).toDouble();
    }
    return 0.00;
  }

  @override
  Widget build(BuildContext context) {
    final payService = PayService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bill'),
        backgroundColor: Colors.grey[100],
        actions: [
          IconButton(
            onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TransactionPage()),
                    );
                  },
            icon: const Icon(Icons.receipt),
          )
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Colors.grey,
            thickness: 1,
            height: 0,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: Column(
            children: [
              Container(
                width: 400,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 7,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: FutureBuilder<double>(
                    future: getBill(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Bill = RM 0.00',
                            style: TextStyle(
                              fontSize: 40, 
                              color: Colors.black,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasData) {
                        double bill = snapshot.data ?? 0.00;
                        return Center(
                            child: Text(
                              'Bill: RM ${bill.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 40, 
                                color: Colors.black, 
                              ),
                            ),
                          );                        
                      }

                      return const Center(
                        child: Text(
                          'Bill: RM 0.00',
                          style: TextStyle(
                            fontSize: 40, 
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30), 

              FutureBuilder<double>(
                future: getBill(),
                builder: (context, snapshot) {
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('');
                  }
                  double billAmount = snapshot.data!;
                  if (billAmount == 0.00) {
                    return const Text('No payment required.',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    );
                  }

                  return payService.getGooglePayButton(context, billAmount);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

