import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
ProfilePage({super.key});
final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut, 
            icon:  const Icon(Icons.logout)
            )
          ],
        ),

      );
  }
}
 