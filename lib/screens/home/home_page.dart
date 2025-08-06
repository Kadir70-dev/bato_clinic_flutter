import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
                _logout(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final user = args?['user'] ?? {};
    final token = args?['token'];
    final userName = user['name'] ?? 'Guest';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: Text('Welcome, $userName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.design_services), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: "Records"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Hi, $userName 👋',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text("Ready to enhance your natural beauty?", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "Welcome to Your Beauty Journey\nDiscover premium treatments designed to enhance your confidence and natural radiance.",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(Icons.favorite, color: Colors.white),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text("Quick Access", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Column(
              children: [
                InkWell(
                  onTap: () {
                    if (user['id'] != null && args?['token'] != null) {
                      Navigator.pushNamed(
                        context,
                        '/book_appointment',
                        arguments: {
                          'patientId': user['id'],
                          'token': args!['token'],
                          'user': user,
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User not logged in.")),
                      );
                    }
                  },
                  child: quickAccessCard(Icons.calendar_today, "Book Consultation", "Schedule with our specialists"),
                ),
                const SizedBox(height: 10),
                quickAccessCard(Icons.spa, "View Treatments", "Explore our services"),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    if (user['id'] != null && token != null) {
                      Navigator.pushNamed(
                        context,
                        '/records',
                        arguments: {
                          'patientId': user['id'],
                          'token': token,
                          'user': user,
                        },
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User not logged in.")),
                      );
                    }
                  },
                  child: quickAccessCard(Icons.assignment, "Medical Records", "Access your history"),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Featured This Week", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text("View All", style: TextStyle(color: Colors.blue)),
              ],
            ),
            const SizedBox(height: 10),

            SizedBox(
              height: 145,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  featuredCard("Facial Treatment", "assets/images/facial.jpg"),
                  const SizedBox(width: 10),
                  featuredCard("Laser Therapy", "assets/images/laser.jpg"),
                  const SizedBox(width: 10),
                  featuredCard("Hair Restoration", "assets/images/hair.jpg"),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text("Why Choose Bato Clinic", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
              children: const [
                StatCard(icon: Icons.people, label: "5,000+", subLabel: "Happy Clients"),
                StatCard(icon: Icons.verified_user, label: "15+", subLabel: "Years Experience"),
                StatCard(icon: Icons.star, label: "4.9", subLabel: "Average Rating"),
                StatCard(icon: Icons.show_chart, label: "98%", subLabel: "Success Rate"),
              ],
            ),

            const SizedBox(height: 30),

            const Text("Care Tips & Articles", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            articleCard(
              tag: "Skincare",
              time: "3 min read",
              title: "Post-Treatment Skincare Routine",
              description: "Essential steps to maintain your glowing skin after aesthetic treatments",
              image: "assets/images/skincare.jpg",
            ),
            const SizedBox(height: 12),
            articleCard(
              tag: "Hair Care",
              time: "4 min read",
              title: "Hair Care After PRP Treatment",
              description: "Maximize your hair restoration results with proper aftercare",
              image: "assets/images/haircare.jpg",
            ),
          ],
        ),
      ),
    );
  }
}

// ======================= QUICK ACCESS CARD =======================
Widget quickAccessCard(IconData icon, String title, String subtitle) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.blue, size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ],
    ),
  );
}

// ======================= FEATURED CARD =======================
Widget featuredCard(String title, String imagePath) {
  return Container(
    width: 160,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade300)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.asset(imagePath, height: 100, width: 160, fit: BoxFit.cover),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    ),
  );
}

// ======================= ARTICLE CARD =======================
Widget articleCard({
  required String tag,
  required String time,
  required String title,
  required String description,
  required String image,
}) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade200)],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
          child: Image.asset(image, width: 100, height: 100, fit: BoxFit.cover),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(tag, style: const TextStyle(fontSize: 10, color: Colors.blue)),
                    ),
                    const Spacer(),
                    Text(time, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// ======================= STAT CARD =======================
class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subLabel;

  const StatCard({super.key, required this.icon, required this.label, required this.subLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey.shade200)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(subLabel, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
