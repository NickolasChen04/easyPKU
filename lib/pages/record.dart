import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecordPage extends StatelessWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Appointment Schedule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppointmentSchedulePage(),
    );
  }
}

class AppointmentSchedulePage extends StatefulWidget {
  const AppointmentSchedulePage({super.key});

  @override
  AppointmentSchedulePageState createState() => AppointmentSchedulePageState();
}

class AppointmentSchedulePageState extends State<AppointmentSchedulePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Record',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          indicatorColor: const Color.fromARGB(255, 227, 8, 8),
          tabs: [
            _buildTab('Upcoming', Colors.black),
            _buildTab('Completed', Colors.black),
            _buildTab('Canceled', Colors.black),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAppointmentListStream('upcoming'),
          _buildAppointmentListStream('completed'),
          _buildAppointmentListStream('cancel'),
        ],
      ),
    );
  }

  Tab _buildTab(String text, Color color) {
    return Tab(
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Future<void> _updateAppointmentStatus(DocumentSnapshot appointment) async {
  final data = appointment.data() as Map<String, dynamic>;

 
  final Timestamp timestamp = data['date'];
  final DateTime appointmentDate = timestamp.toDate();

  final timeString = data['time'] as String;
  final DateTime appointmentDateTime = _combineDateAndTime(appointmentDate, timeString);

  
  if (DateTime.now().isAfter(appointmentDateTime)) {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointment.id)
        .update({'status': 'completed'});
  }
}

DateTime _combineDateAndTime(DateTime date, String time) {
  
  final DateFormat timeFormat = DateFormat('hh:mm a');
  final DateTime parsedTime = timeFormat.parse(time);

  return DateTime(
    date.year,
    date.month,
    date.day,
    parsedTime.hour,
    parsedTime.minute,
  );
}
Widget _buildAppointmentListStream(String status) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('status', isEqualTo: status)
          .where('userId', isEqualTo: userId)
          .orderBy('date', descending: false)
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No appointment found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final appointments = snapshot.data!.docs;

      
      for (var appointment in appointments) {
        _updateAppointmentStatus(appointment);
      }

      final filteredAppointments = appointments.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id;
        return data;
      }).toList();

      return AppointmentListView(
        appointments: filteredAppointments,
        formatDate: _formatDate,
        );
      },
    );
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      DateTime dateTime = date.toDate();
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } else if (date is String) {
      DateTime dateTime = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    }
    return 'Invalid Date';
  }
}

class AppointmentListView extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final String Function(dynamic) formatDate;

  const AppointmentListView({
    super.key,
    required this.appointments,
    required this.formatDate,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return const Center(
        child: Text(
          'No appointment found',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        final formattedDate = formatDate(appointment['date']);
        final docId = appointment['docId'];
        return Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Color.fromARGB(255, 68, 68, 68)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        formattedDate,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 116),
                    Expanded(
                      child: Text(
                        '${appointment['time']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Appointment ID: ${appointment['id'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Text(
                  'Doctor               : ${appointment['doctorName'] ?? 'N/A'}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Category: ${appointment['category']}',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    _getStatusChip(context, appointment['status'], docId),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getStatusChip(
      BuildContext context, String status, String appointmentId) {
    Color chipColor;
    String chipText;

    switch (status) {
      case 'completed':
        chipColor = Colors.green;
        chipText = 'Completed';
        break;
      case 'cancel':
        chipColor = Colors.red;
        chipText = 'Canceled';
        break;
      default:
        chipColor = Colors.grey;
        chipText = 'Cancel';
    }

    return GestureDetector(
      onTap: status == 'upcoming'
          ? () => _confirmCancel(context, appointmentId)
          : null,
      child: Chip(
        label: Text(
          chipText,
          style: const TextStyle(color: Colors.black, fontSize: 12),
        ),
        backgroundColor: chipColor,
      ),
    );
  }

  void _confirmCancel(BuildContext context, String appointmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content: const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _cancelAppointment(appointmentId);
              Navigator.of(context).pop();
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _cancelAppointment(String appointmentId) {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentId)
        .update({'status': 'cancel'}).then((_) {
      print('Appointment canceled successfully.');
    }).catchError((error) {
      print('Failed to cancel appointment: $error');
    });
  }
}