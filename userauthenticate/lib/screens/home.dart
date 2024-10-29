import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); 
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username'); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido a Clever Business'),
      ),
      body: Container(
       decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF4A90E2), 
            Color(0xFFD0E8FF), 
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: FutureBuilder<String?>(
        
        future: getToken(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final token = snapshot.data;
          return token != null ? _buildLoggedInView(context) : _buildLoggedOutView(context);
        },
      ),
      )
    );
  }

  Widget _buildLoggedInView(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUsername(),
      builder: (context, snapshot) {
        print('snapshot.data---------- ${snapshot.data}');
        String username = snapshot.data ?? 'Usuario'; 
         print('username---------- ${username}');
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logoUserAuth.png',
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text('Hola, $username!', style: TextStyle(fontSize: 24)),
              ElevatedButton(
                onPressed: () {
                  _logout(context);
                },
                child: Text('Cerrar Sesión'),
              ),
              SizedBox(height: 20),
        
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/logoUserAuth.png',
            width: 250,
            height: 250,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/registerDNI');
                },
                child: Text('Crear Cuenta'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 18, 116, 229),
                foregroundColor: Colors.white,
                ),
                child: Text('Iniciar Sesión'),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTermsAndConditionsText(),
          // SizedBox(height: 20),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/testConnection');
          //   },
          //   child: Text('Test conexión'),
          // ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); 
    await prefs.remove('username'); 
    Navigator.pushReplacementNamed(context, '/home'); 
  }
}


Widget _buildTermsAndConditionsText() {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
          text: 'A continuación, acepte los ',
          style: TextStyle(color: Colors.black), 
        ),
        TextSpan(
          text: 'términos y condiciones',
          style: TextStyle(
            color: Colors.blue, 
            decoration: TextDecoration.underline, 
          ),
        ),
      ],
    ),
  );
}
