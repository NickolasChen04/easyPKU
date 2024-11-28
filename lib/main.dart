import 'package:easypku/pages/authpage.dart';
import 'package:easypku/pages/booking_page.dart';
import 'package:easypku/pages/dashboard.dart';
import 'package:easypku/pages/doctor_selection_page.dart';
import 'package:easypku/pages/selectionpage.dart';
import 'package:easypku/pages/success_booked.dart';
import 'package:flutter/material.dart'; 
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // Ensure binding is initialized
  await Firebase.initializeApp();  // Initialize Firebase

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthPage(),
        'user_home': (context) => const Dashboard(),
        'selection_page': (context) => const SelectionScreen(),
        'booking_page': (context) => const BookingPage(),
        'doctor_selection': (context) => const DoctorSelectionPage(),
        'success_booking': (context) => const AppointmentBooked(),
      },
    ),
  );
}
