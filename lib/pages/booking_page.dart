import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/appointment_model.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  static const Color customBlue = Color(0xFF84C7E7);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime _currentDay = DateTime.now();
  int? _currentIndex;
  bool _dateSelected = false;
  bool _timeSelected = false;
  bool _skipDoctorSelection = false;
  bool _isLoading = false;

  final Map<String, List<String>> serviceTimeSlots = {
    'General': [
      '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
      '11:00 AM', '11:30 AM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM', 
      '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM',
      '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM'
    ],
    'Emergency': [
      '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
      '11:00 AM', '11:30 AM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
      '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM', 
      '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM'
    ],
    'Dental': [
      '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
      '11:00 AM', '11:30 AM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
      '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM'
    ],
    'Physiotherapy': [
      '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
      '11:00 AM', '11:30 AM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
      '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM',
      '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM'
    ],
    'Mental Health': [
      '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
      '11:00 AM', '11:30 AM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
      '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM',
      '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM', '8:00 PM', '8:30 PM', '9:00 PM', '9:30 PM'
    ],
    'Pharmacy': [
      '8:00 AM', '8:30 AM', '9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM',
      '11:00 AM', '11:30 AM', '1:00 PM', '1:30 PM', '2:00 PM', '2:30 PM',
      '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM', '5:30 PM',
      '6:00 PM', '6:30 PM', '7:00 PM', '7:30 PM'
    ],
  };

  DateTime _parseTimeString(String timeStr) {
    final now = DateTime.now();
    final time = timeStr.toUpperCase();
    final hour = int.parse(time.split(':')[0]);
    final minute = int.parse(time.split(':')[1].split(' ')[0]);
    final isPM = time.contains('PM');
    
    var compareHour = hour;
    if (isPM && hour != 12) {
      compareHour += 12;
    } else if (!isPM && hour == 12) {
      compareHour = 0;
    }

    return DateTime(
      now.year,
      now.month,
      now.day,
      compareHour,
      minute,
    );
  }

bool isTimeSlotAvailable(String timeSlot) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final selectedDate = DateTime(_currentDay.year, _currentDay.month, _currentDay.day);

  if (selectedDate.isAfter(today)) {
    return true;
  }

  if (selectedDate.isAtSameMomentAs(today)) {
    final slotTime = _parseTimeString(timeSlot);
    return slotTime.isAfter(now);
  }

  return false;
}

  Future<void> _saveAppointment(Map<String, dynamic> doctor) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final appointment = Appointment.create(
        doctorName: doctor['name'],
        doctorId: doctor['id'],
        userId: user.uid,
        category: selectedService,
        date: _currentDay,
        day: DateFormat('EEEE').format(_currentDay),
        time: timeSlots[_currentIndex!],
        doctorProfile: doctor['image'],
      );

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toMap());

      if (mounted) {
        Navigator.pushNamed(
          context,
          'success_booking',
          arguments: {
            'doctor': doctor,
            'date': _currentDay,
            'time': timeSlots[_currentIndex!],
            'service': selectedService,
            'appointmentId': appointment.id,
          },
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving appointment: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  late List<String> timeSlots = [];
  late String selectedService = 'General';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (timeSlots.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      selectedService = args?['service'] ?? 'General';
      _skipDoctorSelection = args?['skipDoctorSelection'] ?? false;
      timeSlots = serviceTimeSlots[selectedService] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
        backgroundColor: BookingPage.customBlue,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: <Widget>[
                    TableCalendar(
                      focusedDay: _focusDay,
                      firstDay: DateTime.now(),
                      lastDay: DateTime(2025, 12, 31),
                      calendarFormat: _format,
                      currentDay: _currentDay,
                      rowHeight: 48,
                      calendarStyle: const CalendarStyle(
                        todayDecoration: BoxDecoration(
                          color: BookingPage.customBlue,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: BookingPage.customBlue,
                          shape: BoxShape.circle,
                        ),
                      ),
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      onFormatChanged: (format) {
                        setState(() {
                          _format = format;
                        });
                      },
                      onDaySelected: ((selectedDay, focusedDay) {
                        setState(() {
                          _currentDay = selectedDay;
                          _focusDay = focusedDay;
                          _dateSelected = true;
                          _currentIndex = null;
                          _timeSelected = false;
                        });
                      }),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                      child: Text(
                        'Select Consultation Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final bool isAvailable = isTimeSlotAvailable(timeSlots[index]);
                      return InkWell(
                        splashColor: Colors.transparent,
                        onTap: isAvailable
                            ? () {
                                setState(() {
                                  _currentIndex = index;
                                  _timeSelected = true;
                                });
                              }
                            : null,
                        child: Container(
                          margin: const EdgeInsets.all(2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _currentIndex == index
                                  ? Colors.white
                                  : isAvailable
                                      ? Colors.black
                                      : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: _currentIndex == index
                                ? BookingPage.customBlue
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            timeSlots[index],
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _currentIndex == index
                                  ? Colors.white
                                  : isAvailable
                                      ? Colors.black
                                      : Colors.grey.shade400,
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: timeSlots.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 2.0,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF84C7E7).withOpacity(0.1),
                      foregroundColor: const Color.fromARGB(255, 23, 107, 146),
                      elevation: 0,
                      side: const BorderSide(color: BookingPage.customBlue),
                    ),
                    onPressed: (_timeSelected && _dateSelected && !_isLoading)
                        ? () async {
                            if (_skipDoctorSelection) {
                              await _saveAppointment({
                                'name': 'Pharmacy Service',
                                'id': 'PHARMACY',
                                'specialty': 'Pharmacy',
                                'experience': 'N/A',
                                'rating': 'N/A',
                                'image': 'assets/pharmacy.png',
                              });
                            } else {
                              Navigator.pushNamed(
                                context,
                                'doctor_selection',
                                arguments: {
                                  'date': _currentDay,
                                  'time': timeSlots[_currentIndex!],
                                  'service': selectedService,
                                },
                              );
                            }
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color.fromARGB(255, 23, 107, 146),
                                ),
                              ),
                            )
                          : Text(
                              _skipDoctorSelection
                                  ? 'Confirm Booking'
                                  : 'Continue to Select Doctor',
                              style: const TextStyle(fontSize: 18),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}