import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../components/logo_section.dart';
import 'config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController mobileOrFileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String error = '';

  Future<void> loginUser() async {
    print('🔁 loginUser() called');
    final mobileOrFile = mobileOrFileController.text.trim();
    final password = passwordController.text.trim();

    print('📲 mobileOrFile: $mobileOrFile');
    print('🔐 password: $password');

    if (mobileOrFile.isEmpty || password.isEmpty) {
      setState(() {
        error = 'Mobile/File No and password are required';
      });
      print('❌ Fields are empty');
      return;
    }

    final loginUrl = Uri.parse(AppConfig.loginUrl);
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'mobileOrFile': mobileOrFile,
      'password': password,
    });

    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      print('📤 Sending POST request to $url');
      final response = await http.post(url, headers: headers, body: body);
      print('📥 Response received: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final userData = data['user'];
        final tokenString = data['token'];
        print('✅ Login success: $data');

        // Example: Save token with shared_preferences if needed

       Navigator.pushReplacementNamed(
        context, 
        '/home',
        arguments: {
        'user': userData,
        'token': tokenString,
         'user': userData, 
            },
         );



      } else {
        final data = jsonDecode(response.body);
        final userData = data['user'];
        final tokenString = data['token'];
        print('❌ Login failed: $data');
        setState(() {
          error = data['message'] ?? 'Login failed';
        });
      }
    } catch (e) {
      print('❗ Exception during login: $e');
      setState(() {
        error = 'Something went wrong. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              const SizedBox(height: 8),
              const LogoSection(),
              const SizedBox(height: 16),
              TextField(
                controller: mobileOrFileController,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number or File No',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 20),
              if (error.isNotEmpty)
                Text(error, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login'),
              ),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  children: [
                    const Text("Don’t have an account yet?"),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/appointment');
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        side: const BorderSide(color: Colors.black),
                      ),
                      child: const Text(
                        'BOOK AN APPOINTMENT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
