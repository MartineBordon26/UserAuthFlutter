import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../styles/gradientBackground.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  String _loginMessage = '';
  bool _useBiometrics = false; 

  Future<void> _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    bool success = await _userService.loginUser(username, password);

    setState(() {
      _loginMessage = success ? 'Inicio de sesión exitoso' : 'Usuario o contraseña incorrectos';
    });

    if (success) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clever Business',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4A90E2),
        elevation: 4,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Usuario",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Contraseña",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              CheckboxListTile(
                title: Text(
                  'Activar autenticación biométrica',
                  style: TextStyle(color: Colors.white),
                ),
                value: _useBiometrics,
                onChanged: (bool? value) {
                  setState(() {
                    _useBiometrics = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Color.fromARGB(255, 74, 144, 226),
                checkColor: Colors.white,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4A90E2),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  "Iniciar Sesión",
                  style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 252, 252, 252)),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  _loginMessage,
                  style: TextStyle(color: _loginMessage == 'Inicio de sesión exitoso' ? Colors.green : Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
