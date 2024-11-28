import 'package:easypku/pages/record.dart';
import 'package:easypku/pages/userhome.dart';
import 'package:easypku/pages/profilepage.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Dashboard extends StatefulWidget {
const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    UserHome(),
    const RecordPage(),
    ProfilePage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color:Colors.blue[50],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 20),
          child: GNav(
            backgroundColor: Colors.blue[50]??Colors.blue,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blue[150]??Colors.blue,
            gap: 8,
            iconSize: 24,
            padding: const EdgeInsets.all(14),
            tabs: const [
              GButton(
              icon:Icons.home,
              text: 'Home'
              ),
              GButton(
                icon:Icons.calendar_today,
                text:'Appointments'
              ),
              GButton(
                icon:Icons.person,
                text:'Profile'
                ),
            ],
            onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
            },
          ),
        ),
      ),
      );
  }
}