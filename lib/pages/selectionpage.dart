import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  static const Color customBlue = Color(0xFF84C7E7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Service'),
        backgroundColor: customBlue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              _buildServiceCard(
                context,
                'General',
                FontAwesomeIcons.stethoscope,
              ),
              _buildServiceCard(
                context,
                'Emergency',
                FontAwesomeIcons.truckMedical,
              ),
              _buildServiceCard(
                context,
                'Dental',
                FontAwesomeIcons.tooth,
              ),
              _buildServiceCard(
                context,
                'Physiotherapy',
                FontAwesomeIcons.personWalking,
              ),
              _buildServiceCard(
                context,
                'Mental Health',
                FontAwesomeIcons.brain,
              ),
              _buildServiceCard(
                context,
                'Pharmacy',
                FontAwesomeIcons.pills,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        if (title == 'Pharmacy') {
          Navigator.pushNamed(context, 'booking_page', arguments: {
            'service': title,
            'skipDoctorSelection': true
          });
        } else if (title == 'Emergency') {
          // Go directly to doctor selection page which shows emergency contacts
          Navigator.pushNamed(
            context, 
            'doctor_selection',
            arguments: {
              'service': title,
              'date': DateTime.now(), // Pass default date
              'time': '00:00', // Pass default time
            },
          );
        } else {
          Navigator.pushNamed(context, 'booking_page', arguments: {
            'service': title,
            'skipDoctorSelection': false
          });
        }
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 40,
              color: title == 'Emergency' ? Colors.red : customBlue,
            ),
            const SizedBox(height: 15),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: title == 'Emergency' ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}