import 'package:flutter/material.dart';

class Treatment {
  final String name;
  final double price;
  final String currency;

  const Treatment(this.name, this.price, this.currency);
}

class FullViewTreatmentsScreen extends StatelessWidget {
  const FullViewTreatmentsScreen({super.key}); // ✅ Add const constructor

  static const List<Treatment> treatments = [  // ✅ Make it static const
    Treatment('Hair Treatment 550+2', 550.000, 'KWD'),
    Treatment('Hair Treatment-200', 200.000, 'KWD'),
    Treatment('Hair Treatment half head +1', 450.000, 'KWD'),
    Treatment('Hair Treatment full head +2', 650.000, 'KWD'),
    Treatment('Hair Treatment - Renew Half Head', 300.000, 'KWD'),
    Treatment('Hair Treatment - Renew full Head', 350.000, 'KWD'),
    Treatment('Hair Treatment - Renew full Head', 580.000, 'KWD'),
    Treatment('Plasma', 80.000, 'KWD'),
    Treatment('Plasma', 290.000, 'KWD'),
    Treatment('DERMAPEN MEZZO / PLASMA 1 SESSION', 120.000, 'KWD'),
    Treatment('DERMAPEN MEZZO / PLASMA 3 SESSION', 290.000, 'KWD'),
    Treatment('Plasma', 120.000, 'KWD'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treatment History"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: treatments.length,
        itemBuilder: (context, index) {
          final treatment = treatments[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 3,
            child: ListTile(
              leading: const Icon(Icons.local_hospital),
              title: Text(
                treatment.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text("Status: Completed"),
              trailing: Text(
                "${treatment.price.toStringAsFixed(3)} ${treatment.currency}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
