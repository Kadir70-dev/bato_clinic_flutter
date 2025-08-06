import 'package:flutter/material.dart';

// Screens
import 'screens/welcome_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/signup_page.dart';
import 'screens/home/home_page.dart';
import 'screens/services/services_page.dart';
import 'screens/bookings/book_new_page.dart';
import 'screens/records/records_page.dart';
import 'screens/profile/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BATO Clinic App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        // ✅ Handle dynamic route to BookNewPage with full arguments
        if (settings.name == '/book_appointment') {
          final args = settings.arguments as Map<String, dynamic>;

          return MaterialPageRoute(
            builder: (context) => BookNewPage(
              patientId: args['patientId'],
              token: args['token'],
              user: args['user'],
            ),
          );
        }

        // ✅ Handle other routes here
        if (settings.name == '/records') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => RecordsPage(
              patientId: args['patientId'],
              token: args['token'],
              user: args['user'],
            ),
          );
        }

        // Let the static routes map handle other routes
        return null;
      },
      routes: {
        '/': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(),
        '/services': (context) => const ServicesPage(),

        // ✅ Provide dummy/default values if needed
        '/bookings': (context) => const BookNewPage(
              patientId: 0,
              token: '',
              user: {
                'civil_id': '',
                'full_name': '',
                'mobile': '',
                'fileNo': '',
              },
            ),

        // '/records': (context) => const RecordsPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
