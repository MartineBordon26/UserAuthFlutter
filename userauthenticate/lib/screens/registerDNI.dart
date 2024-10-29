import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../styles/gradientBackground.dart';
class CrearCuentaScreen extends StatefulWidget {
  @override
  _CrearCuentaScreenState createState() => _CrearCuentaScreenState();
}

class _CrearCuentaScreenState extends State<CrearCuentaScreen> {
  final TextEditingController _dniController = TextEditingController();
  bool _isDniValid = false;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();
    _dniController.addListener(() {
      String dni = _dniController.text.replaceAll('.', '');
      if (dni.length <= 9 && int.tryParse(dni) != null) {
        setState(() {
          _isDniValid = dni.length >= 7;
          _dniController.value = _dniController.value.copyWith(
            text: _formatDni(dni),
            selection: TextSelection.collapsed(offset: _formatDni(dni).length),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  String _formatDni(String dni) {
    return NumberFormat('#,###', 'es_AR').format(int.parse(dni));
  }

  void _onContinue() {
    setState(() {
      _progressValue = 1.0;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NextScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'),
        backgroundColor: Color(0xFF4A90E2),
      ),
      body: GradientBackground(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingrese su DNI',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _dniController,
              decoration: InputDecoration(
                labelText: 'DNI',
                labelStyle: TextStyle(color: Color(0xFF4A90E2)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(8),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isDniValid ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDniValid ? Color(0xFF4A90E2) : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Spacer(),
            LinearProgressIndicator(
              value: _progressValue,
              backgroundColor: Colors.grey[300],
              color: Color(0xFF4A90E2),
              minHeight: 5,
            ),
          ],
        ),
      ),
      )
    );
  }
}

class NextScreen extends StatefulWidget {
  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      String phone = _phoneController.text;
      setState(() {
        _isPhoneValid = phone.length == 10;
      });
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _onContinue() {
    print("Número de celular ingresado: ${_phoneController.text}");
    Navigator.pushNamed(context, '/otpValidation');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar celular'),
        backgroundColor: Color(0xFF4A90E2),
      ),
      body: GradientBackground(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingrese su número de celular',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Número de celular',
                labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF4A90E2), width: 2),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isPhoneValid ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPhoneValid ? Color(0xFF4A90E2) : Colors.grey,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Continuar',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      )
    );
  }
}
