import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorSelectionPage extends StatelessWidget {
  const DoctorSelectionPage({super.key});

  static const Color customBlue = Color(0xFF84C7E7);

  final List<Map<String, dynamic>> doctors = const [
    // Emergency Doctors
    {
      'id': 'EME001',
      'name': 'Dr. Mohd Fidaus Akmal bin Azman',
      'position': 'Medical Officer',
      'experience': '15 years',
      'rating': '4.8',
      'image': 'assets/Dr._Mohd_Fidaus_Akmal_bin_Azman.png',
      'specialty': 'Emergency',
    },
    {
      'id': 'EME002',
      'name': 'Md Hadafi Bin Suleiman @ Salman',
      'position': 'Senior Assistant Medical Officer',
      'experience': '7 years',
      'rating': '4.9',
      'image': 'assets/Md_Hadafi_Bin_Suleiman_Salman.png',
      'specialty': 'Emergency',
    },
    // Dental Doctors
    {
      'id': 'DEN001',
      'name': 'Dr. Norannieza Binti Muzlan',
      'position': 'Dental Officer',
      'experience': '9 years',
      'rating': '4.9',
      'image': 'assets/Dr._Norannieza_Binti_Muzla.png',
      'specialty': 'Dental',
    },
    {
      'id': 'DEN002',
      'name': 'Dr. Nurhazwani Binti Zakaria',
      'position': 'Dental Officer',
      'experience': '5 years',
      'rating': '4.7',
      'image': 'assets/Dr._Nurhazwani_Binti_Zakaria.png',
      'specialty': 'Dental',
    },
    {
      'id': 'DEN003',
      'name': 'Mohd Halil Bin Md Sukor',
      'position': 'Dental Technologist',
      'experience': '4 years',
      'rating': '4.8',
      'image': 'assets/Mohd_Halil_Bin_Md_Sukor.png',
      'specialty': 'Dental',
    },
    {
      'id': 'DEN004',
      'name': 'Abdul Aziz Bin Mat Yaman',
      'position': 'Dental Surgery Assistant',
      'experience': '4 years',
      'rating': '4.5',
      'image': 'assets/Abdul_Aziz_Bin_Mat_Yaman.png',
      'specialty': 'Dental',
    },
    {
      'id': 'DEN005',
      'name': 'Hafilah Binti Khamis',
      'position': 'Dental Surgery Assistant',
      'experience': '4 years',
      'rating': '4.6',
      'image': 'assets/Hafilah_Binti_Khamis.png',
      'specialty': 'Dental',
    },
    // Physiotherapy Doctors
    {
      'id': 'PHY001',
      'name': 'Dr. Tan Ri Chuan',
      'position': 'Medical Officer',
      'experience': '9 years',
      'rating': '4.9',
      'image': 'assets/Dr._Tan_Ri_Chuan.png',
      'specialty': 'Physiotherapy',
    },
    {
      'id': 'PHY002',
      'name': 'Aidaliza Binti Asmuni',
      'position': 'Medical Therapist',
      'experience': '4 years',
      'rating': '4.7',
      'image': 'assets/Aidaliza_Binti_Asmuni.png',
      'specialty': 'Physiotherapy',
    },
    {
      'id': 'PHY003',
      'name': 'Yahya Bin Dimon',
      'position': 'Healthcare Assistant',
      'experience': '3 years',
      'rating': '4.7',
      'image': 'assets/Yahya_Bin_Dimon.png',
      'specialty': 'Physiotherapy',
    },
    // Mental Health Doctors
    {
      'id': 'MEN001',
      'name': 'Dr. Noor Hafizah Zaihanah Bt Mohd Nur',
      'position': 'Medical Officer',
      'experience': '12 years',
      'rating': '4.7',
      'image': 'assets/Dr._Noor_Hafizah_Zaihanah_Bt_Mohd_Nur.png',
      'specialty': 'Mental Health',
    },
    {
      'id': 'MEN002',
      'name': 'Mazlida Binti Zakaria',
      'position': 'Nurse',
      'experience': '2 years',
      'rating': '4.9',
      'image': 'assets/Mazlida_Binti_Zakaria.png',
      'specialty': 'Mental Health',
    },
    {
      'id': 'MEN003',
      'name': 'Nur Rashidah Binti Hj Taufikul Rahman',
      'position': 'Nurse',
      'experience': '3 years',
      'rating': '4.8',
      'image': 'assets/Nur_Rashidah_Binti_Hj_Taufikul_Rahman.png',
      'specialty': 'Mental Health',
    },
    {
      'id': 'MEN004',
      'name': 'Sarimah Binti Salleh',
      'position': 'Community Nurse',
      'experience': '3 years',
      'rating': '4.7',
      'image': 'assets/Sarimah_Binti_Salleh.png',
      'specialty': 'Mental Health',
    },
    // General Doctors
    {
      'id': 'GEN001',
      'name': 'Dr. Mohd Zaki Bin Yunos',
      'position': 'Medical Officer',
      'experience': '8 years',
      'rating': '4.9',
      'image': 'assets/Dr._Mohd_Zaki_Bin_Yunos.png',
      'specialty': 'General',
    },
    {
      'id': 'GEN002',
      'name': 'Noraisah Binti Mohd Yusof',
      'position': 'Chief Nurse',
      'experience': '7 years',
      'rating': '4.9',
      'image': 'assets/Noraisah_Binti_Mohd_Yusof.png',
      'specialty': 'General',
    },
    {
      'id': 'GEN003',
      'name': 'Amiruldin Bin Abdul Aziz',
      'position': 'Senior Assistant Medical Officer',
      'experience': '8 years',
      'rating': '4.8',
      'image': 'assets/Amiruldin_Bin_Abdul_Aziz.png',
      'specialty': 'General',
    },
    {
      'id': 'GEN004',
      'name': 'Noorsuzilawati Bt. Mohamad Yahya',
      'position': 'Assistant Medical Officer',
      'experience': '4 years',
      'rating': '4.7',
      'image': 'assets/Noorsuzilawati_Bt._Mohamad_Yahya.png',
      'specialty': 'General',
    },
    {
      'id': 'GEN005',
      'name': 'Marzihan Bte Ab Karim',
      'position': 'Senior Nurse',
      'experience': '8 years',
      'rating': '4.7',
      'image': 'assets/Marzihan_Bte_Ab_Karim.png',
      'specialty': 'General',
    },
  ];

   @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    final selectedDate = args['date'] as DateTime;
    final selectedTime = args['time'] as String;
    final selectedService = args['service'] as String;

    // If Emergency service is selected, show emergency contacts page
    if (selectedService == 'Emergency') {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Emergency Contacts'),
          backgroundColor: customBlue,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  FontAwesomeIcons.truckMedical,
                  size: 100,
                  color: Colors.red,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Emergency Contact Numbers',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildEmergencyContactCard(
                  'Contact Us',
                  '+6 075530999',
                  Icons.phone,
                ),
                const SizedBox(height: 20),
                _buildEmergencyContactCard(
                  'Emergency (24 hours)',
                  '+6 0197756765',
                  Icons.emergency,
                ),
                const SizedBox(height: 40),
                const Text(
                  'In case of emergency, please call these numbers immediately',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // For other services, show doctor selection
    final filteredDoctors = doctors.where((doctor) => 
      doctor['specialty'] == selectedService
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Select $selectedService Doctor'),
        backgroundColor: customBlue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredDoctors.length,
        itemBuilder: (context, index) {
          final doctor = filteredDoctors[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(doctor['image']),
                backgroundColor: Colors.grey[200],
              ),
              title: Text(
                doctor['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    'Position: ${doctor["position"]}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Experience: ${doctor["experience"]}',
                    style: const TextStyle(fontSize: 14),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 18,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        doctor["rating"],
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(
                  context, 
                  'success_booking',
                  arguments: {
                    'doctor': doctor,
                    'date': selectedDate,
                    'time': selectedTime,
                    'service': selectedService,
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyContactCard(String title, String number, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Colors.red, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.red, size: 24),
                const SizedBox(width: 12),
                Text(
                  number,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
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