import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signInWithGoogle() async {
    try {
      await GoogleSignIn().signOut();
      
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        return "Sign-in canceled by user.";
      }

      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final String email = userCredential.user?.email ?? '';

      // Check if the email ends with '@graduate.utm.my'
      if (!email.endsWith('@graduate.utm.my')) {
        await FirebaseAuth.instance.signOut();
        return "You must use a valid @graduate.utm.my email address to sign in.";
      }

      await saveUserToFirestore(userCredential.user);
      return null;
    } catch (e) {
      return "An error occurred during sign-in. Please try again.";
    }
  }

  Future<void> saveUserToFirestore(User? user) async {
    if (user == null) return;

  final userRef = _firestore.collection('users').doc(user.uid);
  final docSnapshot = await userRef.get();
  String? customName = docSnapshot.exists? (docSnapshot.data() as Map<String, dynamic>)['name']: null;
  String nameToSave = customName ?? user.displayName ?? 'Unknown';
  double? billexist = docSnapshot.exists? (docSnapshot.data() as Map<String, dynamic>)['bill']: null;
  double billNow = billexist ?? 0.00;
    
    await userRef.set({
      'name': nameToSave,
      'email': user.email,
      'photoURL': user.photoURL,
      'lastSignIn': FieldValue.serverTimestamp(),
      'bill': billNow, 
    }, SetOptions(merge: true));
  }
}


