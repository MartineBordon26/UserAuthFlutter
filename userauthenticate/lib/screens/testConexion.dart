import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestConnectionScreen extends StatefulWidget {
  @override
  _TestConnectionScreenState createState() => _TestConnectionScreenState();
}

class _TestConnectionScreenState extends State<TestConnectionScreen> {
  String message = 'Sin respuesta aún';

  // Función para probar la conexión
  Future<void> testConnection() async {
    final url = Uri.parse('http://192.168.0.10:3001/api/test'); 
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          message = data['message']; 
        });
      } else {
        setState(() {
          message = 'Error en la conexión: ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        message = 'Error: $error';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    testConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test de Conexión')),
      body: Center(
        child: Text(message),
      ),
    );
  }
}
