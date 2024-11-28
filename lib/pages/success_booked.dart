import 'package:easypku/components/button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppointmentBooked extends StatelessWidget {
  const AppointmentBooked({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the arguments passed from booking page
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final String appointmentId = args['appointmentId'] ?? '';

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Lottie.asset('assets/success.json'),
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: Column(
                children: [
                  const Text(
                    'Successfully Booked',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF84C7E7),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Appointment ID: $appointmentId',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2B7A9E),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Text(
                'Please save this appointment ID for future reference',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Button(
                    width: double.infinity,
                    title: 'Back to Home Page',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                      context, 
                      'user_home', 
                       (Route<dynamic> route) => false,  // This removes all routes before 'user_home'
                       );
                        },
                    disable: false,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.settings.name == 'selection_page');
                    },
                    child: const Text(
                      'Book Another Appointment',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF84C7E7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}