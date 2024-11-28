import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Record'),
        backgroundColor: Colors.grey[100],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(
            color: Colors.grey,
            thickness: 1,
            height: 0,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('transactions')
            .where('userId', isEqualTo: uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No transactions found.',
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            );
          }

          var transactions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              var transaction = transactions[index];
              var amount = transaction['amount'].toStringAsFixed(2);
              var timestamp = transaction['timestamp'] as Timestamp;

              return ListTile(
                title: Text('Amount: RM $amount'),
                subtitle: Text('Date: ${timestamp.toDate()}'),
                leading: const Icon(Icons.payment, color: Colors.blue),
              );
            },
          );
        },
      ),
    );
  }
}