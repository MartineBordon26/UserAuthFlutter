// lib/services/user_service.dart
import '/db_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';



class UserService {
  final String baseUrl = 'http://192.168.0.10:3001/api'; // url server node

  Future<bool> registerUser(User user) async {
    
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/registro'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': user.username,
        'password': user.password,
      }),
    );

    print('Response status--------: ${response.statusCode}');
    print('Response bodys--------: ${response.body}');

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 409) {
      print('Error: El usuario ya existe.');
      return false;
    } else if (response.statusCode == 500) {
      print('Error del servidor.');
      return false;
    } else {
        print('Error inesperado: ${response.body}');
        return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}



  Future<bool> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'), 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'password': password,
        }),
      );

       print('Response status--------: ${response.statusCode}');
        print('Response bodys--------: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _saveToken(data['token'], username);
        return true;
    } else {
      return false;
    }
    } catch (e) {
      print('Error: $e');
      return false; 
    }
  }

   Future<void> _saveToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('username', username);
  }
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}


