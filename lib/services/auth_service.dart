// services/auth_service.dart
import 'package:flutter/foundation.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Mock authentication - replace with real authentication
  Future<bool> login(String email, String password, UserType userType) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    // Mock user creation based on user type
    if (userType == UserType.citizen) {
      _currentUser = User(
        id: 'citizen_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: 'John Citizen',
        userType: UserType.citizen,
      );
    } else {
      _currentUser = User(
        id: 'officer_${DateTime.now().millisecondsSinceEpoch}',
        email: email,
        name: 'Officer Smith',
        userType: UserType.security,
        badgeNumber: 'BADGE001',
        agency: 'City Police Department',
      );
    }

    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> register(
      String name,
      String email,
      String password,
      UserType userType, {
        String? badgeNumber,
        String? agency,
      }) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 2)); // Simulate network delay

    _currentUser = User(
      id: '${userType.toString()}_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      userType: userType,
      badgeNumber: badgeNumber,
      agency: agency,
    );

    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}