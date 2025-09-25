// screens/auth/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _badgeController = TextEditingController();
  final _agencyController = TextEditingController();
  UserType _selectedUserType = UserType.citizen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),

                // User Type Selection
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Register as', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile<UserType>(
                                title: Text('Citizen'),
                                value: UserType.citizen,
                                groupValue: _selectedUserType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUserType = value!;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile<UserType>(
                                title: Text('Security Personnel'),
                                value: UserType.security,
                                groupValue: _selectedUserType,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedUserType = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 16),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),

                // Security Personnel Additional Fields
                if (_selectedUserType == UserType.security) ...[
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _badgeController,
                    decoration: InputDecoration(
                      labelText: 'Badge Number',
                      prefixIcon: Icon(Icons.badge),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_selectedUserType == UserType.security && (value == null || value.isEmpty)) {
                        return 'Please enter your badge number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _agencyController,
                    decoration: InputDecoration(
                      labelText: 'Agency/Department',
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (_selectedUserType == UserType.security && (value == null || value.isEmpty)) {
                        return 'Please enter your agency or department';
                      }
                      return null;
                    },
                  ),
                ],

                SizedBox(height: 24),

                // Register Button
                Consumer<AuthService>(
                  builder: (context, authService, child) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: authService.isLoading ? null : _register,
                        child: authService.isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Register', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 16),

                // Login Link
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);

      bool success = await authService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
        _selectedUserType,
        badgeNumber: _selectedUserType == UserType.security ? _badgeController.text : null,
        agency: _selectedUserType == UserType.security ? _agencyController.text : null,
      );

      if (success) {
        if (_selectedUserType == UserType.citizen) {
          Navigator.of(context).pushReplacementNamed('/citizen-home');
        } else {
          Navigator.of(context).pushReplacementNamed('/security-home');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _badgeController.dispose();
    _agencyController.dispose();
    super.dispose();
  }
}