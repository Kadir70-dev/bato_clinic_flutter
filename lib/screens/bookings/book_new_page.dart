import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bato_clinic_app/config.dart';

class BookNewPage extends StatefulWidget {
  final int patientId;
  final String token;
  final Map<String, dynamic> user;

  const BookNewPage({
    super.key,
    required this.patientId,
    required this.token,
    required this.user,
  });
  @override
  State<BookNewPage> createState() => _BookNewPageState();
}

class _BookNewPageState extends State<BookNewPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedService;
  String? _note;
  String? _time;
  DateTime? _selectedDate;

  final List<String> services = ['Botox', 'Hair PRP', 'Facial'];
  final List<String> timeSlots = [
    '12:00 PM', '12:30 PM',
    '01:00 PM', '01:30 PM',
    '02:00 PM', '02:30 PM',
    '03:00 PM', '03:30 PM',
    '04:00 PM', '04:30 PM',
    '05:00 PM', '05:30 PM',
    '06:00 PM', '06:30 PM',
    '07:00 PM',
  ];

  final List<Map<String, dynamic>> doctors = [
    {"id": 1, "name": "Ouhoud amer kawas"},
    {"id": 2, "name": "Sherry susan philip"},
    {"id": 3, "name": "Kadir"},
    {"id": 4, "name": "Treesa jose bbin"},
  ];

  int? _selectedDoctorId;

  bool isLoading = false;

  // Helper: parse 12h time string to DateTime on given date
  DateTime _parseTime(String time12, DateTime date) {
    final timeParts = time12.split(' ');
    final hm = timeParts[0].split(':');
    int hour = int.parse(hm[0]);
    final minute = int.parse(hm[1]);
    final period = timeParts[1];

    if (period == 'PM' && hour != 12) {
      hour += 12;
    } else if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  // Helper: format DateTime to hh:mm AM/PM string
  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour == 0 ? 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }

  // NEW helper: format DateTime to MySQL DATETIME string format
  String toMysqlDateTime(DateTime dt) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${dt.year}-${twoDigits(dt.month)}-${twoDigits(dt.day)} "
           "${twoDigits(dt.hour)}:${twoDigits(dt.minute)}:${twoDigits(dt.second)}";
  }

  Future<void> _bookAppointment() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null || _time == null || _selectedService == null || _selectedDoctorId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    final appointmentsUrl = Uri.parse(AppConfig.appointmentsUrl);
    final appointmentDate = _selectedDate!.toIso8601String().split('T')[0];

    final startDateTime = _parseTime(_time!, _selectedDate!);
    final endDateTime = startDateTime.add(const Duration(minutes: 30));

    final startDateTimeStr = "$appointmentDate ${_formatTime(startDateTime)}";
    final endDateTimeStr = "$appointmentDate ${_formatTime(endDateTime)}";

    print("📤 Sending appointment data...");
    print("Token: ${widget.token}");
    print("Date: $appointmentDate | Time: $_time");
    print("👤 User data: ${widget.user}");
    print("Doctor ID: $_selectedDoctorId");

    final response = await http.post(
      appointmentsUrl,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "patient_id": widget.patientId,
        "service_id": services.indexOf(_selectedService!) + 1,
        "date": appointmentDate,
        "time12": _time,
        "time24": _time,
        "note": _note ?? '',
        "doctor_id": _selectedDoctorId,
        "nurse_id": 4,
        "room_id": 5,
        "sub_total": "1000",
        "discount_amount": "100",
        "extra_amount": "50",
        "full_amount": "950",
        "due_amount": "500",
        "appointment_start_date": appointmentDate,
        "appointment_end_date": appointmentDate,
        // Use the new MySQL DATETIME format here:
        "appointment_start_time": toMysqlDateTime(startDateTime),
        "appointment_end_time": toMysqlDateTime(endDateTime),
        "appointment_start_between_end": "",
        "appointment_start_date_and_time": startDateTimeStr,
        "appointment_end_date_and_time": endDateTimeStr,
        "appointment_number": "APT123456",
        "civil_id": widget.user['civilId'],
        "full_name": widget.user['name'],
        "dob": "1990-01-01",
        "mobile_number": widget.user['mobile'],
        "note_allergy": "None",
        "note_history": "No prior history",
        "cancellation_reason": "",
        "description": _selectedService,
        "urgency_level": "Normal",
        "payment_type": "Cash",
        "payment_status": "Pending",
        "appointment_status": "Scheduled",
        "appointment_progress_status": "Not Started",
        "file_number": widget.user['fileNo'],
        "amount_freez_status": "No",
        "appointment_fees": "800",
        "appointment_extra_fees": "150",
        "clinic_id": 1,
        "appointment_course_status": 0,
        "current_status": "Active",
        "status": 1
      }),
    );

    setState(() => isLoading = false);

    print("🔁 Response status: ${response.statusCode}");
    print("📩 Response body: ${response.body}");

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment booked successfully!")),
      );
      Navigator.pop(context);
    } else {
      final responseBody = json.decode(response.body);
      final message = responseBody['message'] ?? 'Booking failed';

      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Booking Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Book New Appointment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Service"),
                items: services
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _selectedService = val),
                validator: (val) => val == null ? "Select a service" : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<int>(
                decoration: const InputDecoration(labelText: "Doctor"),
                items: doctors
                    .map((d) => DropdownMenuItem(
                        value: d['id'] as int, child: Text(d['name'])))
                    .toList(),
                onChanged: (val) => setState(() => _selectedDoctorId = val),
                validator: (val) => val == null ? "Select a doctor" : null,
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Time Slot"),
                items: timeSlots
                    .map((slot) => DropdownMenuItem(value: slot, child: Text(slot)))
                    .toList(),
                onChanged: (val) => setState(() => _time = val),
                validator: (val) => val == null ? "Select a time slot" : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                decoration: const InputDecoration(labelText: "Note"),
                maxLines: 3,
                onChanged: (val) => _note = val,
              ),
              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(_selectedDate == null
                    ? "Pick Appointment Date"
                    : "Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}"),
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _bookAppointment,
                      child: const Text("Book Appointment"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
