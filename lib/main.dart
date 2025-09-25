// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'models/crime_report.dart';
import 'services/auth_service.dart';
import 'services/report_service.dart';
import 'services/notification_service.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/citizen/citizen_home.dart';
import 'screens/security/security_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ReportService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
      ],
      child: MaterialApp(
        title: 'Crime Alert',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/citizen-home': (context) => CitizenHome(),
          '/security-home': (context) => SecurityHome(),
        },
      ),
    );
  }
}