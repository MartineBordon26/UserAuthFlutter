import 'package:flutter/material.dart';
import 'screens/home.dart'; 
import 'screens/createAccount.dart'; 
import 'screens/login.dart'; 
import 'screens/registrationStepper.dart';
import 'screens/testConexion.dart';
import 'screens/registerDNI.dart';
import 'screens/otpValidation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clever Business',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),  
      routes: { 
        '/createAccount': (context) => CreateAccountScreen(),
        '/login': (context) => LoginScreen(),
        '/registrationStepper': (context) => RegistrationStepper(),
        '/home': (context) => HomeScreen(),
        '/testConnection': (context) => TestConnectionScreen(),
        '/registerDNI': (context) => CrearCuentaScreen(),
        '/otpValidation': (context) => OtpValidationScreen(phoneNumber: "1234567890"),
      },
    );
  }
}
