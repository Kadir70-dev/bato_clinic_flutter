import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bato_clinic_app/config.dart';

class RecordsPage extends StatefulWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> user;

  const RecordsPage({
    Key? key,
    required this.patientId,
    required this.token,
    required this.user,
  }) : super(key: key);

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  int selectedTab = 0;
  final List<String> tabs = ["Medical reports", "Prescriptions","Invoices"];
  final Map<int, String> doctorNames = {
    1: "Ouhoud amer kawas",
    2: "Sherry susan philip",
    3: "Kadir",
    4: "Treesa jose bbin",
  };
  List<dynamic> appointments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments() async {
    final patientAppointmentsUrl = Uri.parse(AppConfig.patientAppointmentsUrl(widget.patientId.toString()));
    print("🔄 Fetching appointments for patient ID: ${widget.patientId}");
    try {
      final response = await http.get(
        patientAppointmentsUrl,
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("✅ Appointments fetched: $data");
        setState(() {
          appointments = data;
          isLoading = false;
        });
      } else {
        print("❌ Failed: ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Records"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "View your health records and documents",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 12),
          _buildTabs(),
          const SizedBox(height: 12),
          Expanded(child: _buildTabContent()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Records"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          bool isSelected = index == selectedTab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    print("🔄 Currently selected tab: ${tabs[selectedTab]}");
    switch (selectedTab) {
      case 0:
        if (isLoading) {
          print("⏳ Loading appointments...");
          return const Center(child: CircularProgressIndicator());
        } else if (appointments.isEmpty) {
          print("⚠️ No appointments found.");
          return const Center(child: Text("No reports found"));
        } else {
          print("📋 Rendering ${appointments.length} appointments");
          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appt = appointments[index];
              print("📄 Appointment[$index]: $appt");
              return _buildReportCard(
                title: appt['description'] ?? 'Appointment',
                subtitle: "Service ID: ${appt['service_id']}",
                date: appt['date'] ?? '',
                doctor: "Doctor: ${doctorNames[appt['doctor_id']]}",
                status: appt['appointment_status'] ?? 'Unknown',
                statusColor: _getStatusColor(appt['appointment_status']),
                paymentStatus: appt['payment_status'] ?? 'N/A',
                paymentType: appt['payment_type'] ?? 'N/A',
                appointmentNumber: appt['appointment_number'] ?? 'N/A',
                fileNumber: appt['file_number'] ?? 'N/A',
              );
            },
          );
        }

      case 1:
        print("📝 Viewing Prescriptions tab");
        return const Center(child: Text("Prescriptions tab placeholder"));

      case 2:
        print("🗒️ Viewing Notes tab");
        return const Center(child: Text("Notes tab placeholder"));

      default:
        return const SizedBox.shrink();
    }
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'scheduled':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildReportCard({
    required String title,
    required String subtitle,
    required String date,
    required String doctor,
    required String status,
    required Color statusColor,
    required String paymentStatus,
    required String paymentType,
    required String appointmentNumber,
    required String fileNumber,
  }) {
    print("🧾 Building report card: title=$title, status=$status, date=$date");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Icon(Icons.insert_drive_file, size: 30, color: Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.calendar_today, "Date: $date"),
        _buildInfoRow(Icons.person, doctor),
        // _buildInfoRow(Icons.payment, "Payment: $paymentType ($paymentStatus)"), // 💬 Payment row commented out
        _buildInfoRow(Icons.confirmation_number, "Appointment #: $appointmentNumber"),
        _buildInfoRow(Icons.folder_copy_outlined, "File #: $fileNumber"),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.remove_red_eye), label: const Text("View")),
            OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.download), label: const Text("Download")),
          ],
        ),
      ]),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 6),
        Expanded(child: Text(text)),
      ]),
    );
  }
}
