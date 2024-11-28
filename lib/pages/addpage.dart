import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make an appointment'),
      ),
      body: const Center(
        child: Text(
          'Add Page',
          style: TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}



