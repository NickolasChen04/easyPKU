import 'package:easypku/pages/billpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserHome extends StatefulWidget {
  UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  User? user;
   @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    }
  }

    void signUserOut() {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<String> getName() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data() != null && userDoc['name'] != null) {
      return userDoc['name'] as String;
    }
    return '';
  }

  Future<double> getBill() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc.data() != null && userDoc['bill'] != null) {
      return (userDoc['bill'] is double)? userDoc['bill'] as double: (userDoc['bill'] as num).toDouble();
    }
    return 0.00;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text(
          'easyPKU',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: const Icon(Icons.logout),
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Hello,',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              FutureBuilder<String>(
                future: getName(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    return Text(
                      'Welcome ' + snapshot.data! + '!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                  return const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('selection_page'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Make an Appointment',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final bool? paymentCompleted = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Billpage()),
                    );

                    if (paymentCompleted == true) {
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[200],
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.payment,
                        color: Colors.white,
                        size: 30,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Bill',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 130),
                      FutureBuilder<double>(
                        future: getBill(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text(
                              'RM 0.00',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            return Text(
                              'RM ${snapshot.data?.toStringAsFixed(2) ?? '0.00'}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }
                          return const Text(
                            'RM ',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
