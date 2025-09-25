// screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'citizen/citizen_home.dart';
import 'security/security_home.dart';
import '../models/user.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _pageController = PageController();
  final int _numPages = 2;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Start a timer to navigate after the last slide
    _startNavigationTimer();
  }

  void _startNavigationTimer() async {
    await Future.delayed(Duration(seconds: 4));
    // Check if the user is still on the splash screen
    if (mounted) {
      if (_currentPage == _numPages - 1) {
        _navigateToNextScreen();
      } else {
        _pageController.nextPage(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeIn,
        );
      }
    }
  }

  void _navigateToNextScreen() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.isLoggedIn) {
      final user = authService.currentUser!;
      if (user.userType == UserType.citizen) {
        Navigator.of(context).pushReplacementNamed('/citizen-home');
      } else {
        Navigator.of(context).pushReplacementNamed('/security-home');
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPage(String title, String subtitle, String appName) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            appName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w900,
              color: Colors.red,
              fontFamily: 'Lobster', // Use your custom font family name here
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerSymbol() {
    return Text(
      '📣',
      style: TextStyle(fontSize: 40.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
          // Restart timer for the next page
          _startNavigationTimer();
        },
        children: <Widget>[
          _buildPage(
            "See Something, Shout it OUT!",
            "", // No subtitle needed here
            "📣 ShoutOUT! 📣",
          ),
          _buildPage(
            "Security is a collective responsibility,",
            "Do your part 🤝 ",
            "📣 ShoutOUT! 📣",
          ),
        ],
      ),
    );
  }
}