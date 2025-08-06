// lib/screens/components/logo_section.dart
import 'package:flutter/material.dart';

class LogoSection extends StatelessWidget {
  const LogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Image(
          image: AssetImage('assets/images/logo.png'),
          height: 150,
        ),
        SizedBox(height: 30),
        Text(
          "Welcome to BATO –",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          "Where beauty and health meet\n\n"
          "BATO is a haven for those seeking clinical solutions for their struggles. "
          "We take you on a medical journey, supervised by our experts to ensure you reach your health, "
          "wellness and optimum beauty destination.",
          style: TextStyle(fontSize: 16, color: Colors.black87),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
