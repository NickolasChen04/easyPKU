// appointment_page.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/appointment_model.dart';
import '../utils/config.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  Stream<List<Appointment>>? _appointmentsStream;

  @override
  void initState() {
    super.initState();
    _setupAppointmentsStream();
  }

  void _setupAppointmentsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _appointmentsStream = FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Appointment.fromMap({...doc.data(), 'id': doc.id}))
            .toList();
      });
    }
  }

  Future<void> updateAppointmentStatus(String appointmentId, String newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': newStatus});
    } catch (e) {
      print('Error updating appointment status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Appointment Schedule',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildStatusFilter(),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Appointment>>(
                stream: _appointmentsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final appointments = snapshot.data!;
                  final filteredAppointments = appointments.where((appointment) {
                    return appointment.status.toLowerCase() == status.name.toLowerCase();
                  }).toList();

                  if (filteredAppointments.isEmpty) {
                    return const Center(
                      child: Text('No appointments found'),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = filteredAppointments[index];
                      return AppointmentCard(
                        appointment: appointment,
                        onCancel: () => updateAppointmentStatus(appointment.id, 'cancel'),
                        onComplete: () => updateAppointmentStatus(appointment.id, 'complete'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: FilterStatus.values.map((filterStatus) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      status = filterStatus;
                      switch (filterStatus) {
                        case FilterStatus.upcoming:
                          _alignment = Alignment.centerLeft;
                          break;
                        case FilterStatus.complete:
                          _alignment = Alignment.center;
                          break;
                        case FilterStatus.cancel:
                          _alignment = Alignment.centerRight;
                          break;
                      }
                    });
                  },
                  child: Center(child: Text(filterStatus.name)),
                ),
              );
            }).toList(),
          ),
        ),
        AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: _alignment,
          child: Container(
            width: 100,
            height: 40,
            decoration: BoxDecoration(
              color: Config.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                status.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ScheduleCard extends StatelessWidget {
  final String date;
  final String day;
  final String time;

  const ScheduleCard({
    super.key,
    required this.date,
    required this.day,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date),
          Text(day),
          Text(time),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(appointment.doctorProfile),
                  radius: 30,
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.doctorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        appointment.category,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ScheduleCard(
              date: appointment.date.toString().split(' ')[0],
              day: appointment.day,
              time: appointment.time,
            ),
            const SizedBox(height: 15),
            if (appointment.status == 'upcoming')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onComplete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Config.primaryColor,
                      ),
                      child: const Text('Complete'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}