import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController textController = TextEditingController();
  final String uid = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseAuth auth = FirebaseAuth.instance;

  String? getUserPhotoURL(){
    User? user = auth.currentUser;
    return user?.photoURL;
  }


  void updateBox(String fieldName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update $fieldName'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: 'Enter new $fieldName'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                
                await firestore.collection('users').doc(uid).update({
                  fieldName: textController.text, 
                });
                textController.clear();
           
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("easyPKU"),
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
        body: StreamBuilder<DocumentSnapshot>(
         
          stream: firestore.collection('users').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Error loading user data."));
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No user data found."));
            }

           
            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
             String? photoURL = userData['photoURL'];
            ImageProvider backgroundImage = photoURL != null
              ? NetworkImage(photoURL)
              : const AssetImage('assets/images/placeholder.png');

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: backgroundImage,
                       
                  ),
                  const SizedBox(height: 30),

                 
                  itemProfile('name', CupertinoIcons.person, userData['name']),
                  const SizedBox(height: 20),
                  itemProfile('phone', CupertinoIcons.phone, userData['phone']),
                  const SizedBox(height: 20),
                  itemProfile(
                      'matric number', CupertinoIcons.book, userData['matric number']),
                  const SizedBox(height: 20),
                  itemProfile('email', CupertinoIcons.mail, userData['email']),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  
  Widget itemProfile(String title, IconData iconData, String? value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.blue.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value ?? 'Not set'), 
        leading: Icon(iconData),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward),
          color: Colors.grey.shade400,
          onPressed: () => updateBox(title), 
        ),
        tileColor: Colors.white,
      ),
    );
  }
}