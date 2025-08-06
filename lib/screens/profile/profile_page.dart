import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryBlue = const Color(0xFF0057FF);
    final Color lightGrey = const Color(0xFFF5F5F5);
    final Color textGrey = const Color(0xFF707070);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 35,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 12,
                          child: Icon(Icons.camera_alt, size: 14),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Aisha Al-Mansouri",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text("Member since January 2024",
                            style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            _InfoItem(title: "1250", subtitle: "Loyalty Points"),
                            _InfoItem(title: "6", subtitle: "Treatments"),
                            _InfoItem(title: "4.9", subtitle: "Experience Rating"),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Next Visit & Medical Records
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoCard(
                  icon: Icons.calendar_today,
                  title: "Next Visit",
                  subtitle: "Aug 2, 2025",
                ),
                _InfoCard(
                  icon: Icons.verified_user,
                  title: "Medical Records",
                  subtitle: "Secure & Private",
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Achievements
            const Text("Your Achievements",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const _AchievementItem(
                title: "First Treatment",
                description: "Completed your first aesthetic treatment",
                earned: true),
            const _AchievementItem(
                title: "Loyal Client",
                description: "Completed 5 treatments with us",
                earned: true),
            const _AchievementItem(
                title: "Wellness Journey",
                description: "Maintained consistent treatment schedule",
                earned: false),

            const SizedBox(height: 24),

            // Dark Mode Toggle
            SwitchListTile(
              title: const Text("Dark Mode"),
              subtitle: const Text("Switch between light and dark theme"),
              value: false,
              onChanged: (value) {},
            ),

            const SizedBox(height: 8),

            // Support & Information
            const Text("Support & Information",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _SupportItem(icon: Icons.help_outline, title: "Help & FAQ"),
            _SupportItem(icon: Icons.support_agent, title: "Contact Support"),
            _SupportItem(icon: Icons.privacy_tip, title: "Terms & Privacy"),
            _SupportItem(icon: Icons.info_outline, title: "About Bato Clinic"),

            const SizedBox(height: 24),

            // Sign out
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Sign Out",
                    style: TextStyle(color: Colors.red, fontSize: 16)),
              ),
            ),

            const SizedBox(height: 24),

            // Footer
            const Center(
              child: Text(
                "Bato Clinic App v2.0.0\nMade with ❤️ for your beauty journey",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: primaryBlue,
        unselectedItemColor: textGrey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.spa), label: "Services"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Bookings"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Records"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle,
                style: const TextStyle(color: Colors.black54, fontSize: 12),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final String title;
  final String description;
  final bool earned;

  const _AchievementItem({
    required this.title,
    required this.description,
    required this.earned,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.emoji_events,
          color: earned ? Colors.orange : Colors.grey),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: earned ? Colors.black : Colors.grey)),
      subtitle: Text(description,
          style: TextStyle(color: earned ? Colors.black54 : Colors.grey)),
      trailing: earned
          ? const Chip(label: Text("Earned", style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange)
          : null,
    );
  }
}

class _SupportItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SupportItem({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}
