// config.dart

class AppConfig {
  // Toggle this to switch between local and production
  static const bool isProduction = true;

  // Local and production base URLs
  static const String localBaseUrl = 'http://192.168.1.112:3000';
  static const String productionBaseUrl = 'https://batobackend-production.up.railway.app';

  // Getter to return the active base URL
  static String get baseUrl => isProduction ? productionBaseUrl : localBaseUrl;

  // API Endpoints
  static String get loginUrl => '$baseUrl/api/auth/login';
  static String get signupUrl => '$baseUrl/api/auth/signup';
  static String get appointmentsUrl => '$baseUrl/api/appointments';
  static String patientAppointmentsUrl(String patientId) => '$baseUrl/api/appointments/patient/$patientId';
}
