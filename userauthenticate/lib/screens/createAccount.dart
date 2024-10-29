import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';
import '../styles/gradientBackground.dart';


class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  bool _isPasswordValid(String password) {
    final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9]).{8,}$');
    return passwordRegExp.hasMatch(password);
  }

  void _register() async {
    setState(() => _isLoading = true);
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (!_isPasswordValid(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula y un número.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    User newUser = User(username: username, password: password);
    try {
      bool success = await _userService.registerUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Usuario registrado exitosamente.' : 'Error: El usuario ya existe.')),
      );

      if (success) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/login'); 
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocurrió un error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildUsernameField() {
    return TextField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Nombre de Usuario',
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.person, color: Colors.white70),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        labelStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white24,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.lock, color: Colors.white70),
      ),
      obscureText: true,
      style: TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: GradientBackground(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Crear cuenta',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                _buildUsernameField(),
                SizedBox(height: 20),
                _buildPasswordField(),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: const Color.fromARGB(255, 74, 144, 226),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : _register,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Color.fromARGB(255, 74, 144, 226))
                      : Text('Registrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
