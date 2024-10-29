import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class OtpValidationScreen extends StatefulWidget {
  final String phoneNumber; 

  OtpValidationScreen({required this.phoneNumber});

  @override
  _OtpValidationScreenState createState() => _OtpValidationScreenState();
}

class _OtpValidationScreenState extends State<OtpValidationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpValid = false;
  String _errorMessage = '';
  String _otp = ''; 

   @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendOtp(); 
    });
  }

  void _sendOtp() {
  do {
    _otp = (Random().nextInt(6001) + 3000).toString();
  } while (int.parse(_otp) % 2 != 0);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('OTP enviado: $_otp')),
  );
}

  void _validateOtp(String otp) {
    setState(() {
      int? otpValue = int.tryParse(otp);

  
      if (otpValue != null && otpValue.toString() == _otp && otpValue > 3000 && otpValue % 2 == 0) {
        _isOtpValid = true;
        _errorMessage = '';
      } else {
        _isOtpValid = false;
        _errorMessage = 'El código OTP debe ser un número par mayor a 3000 y coincidir con el enviado.';
      }
    });
  }

  void _changePhone() {
    Navigator.pop(context);
  }

  void _retry() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _recoverOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Código OTP: $_otp')),  
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Validación OTP SMS')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ingrese el código OTP enviado a su número:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text('Número: ${widget.phoneNumber}'),
            SizedBox(height: 10),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'Código OTP',
                border: OutlineInputBorder(),
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4), 
              ],
              onChanged: (otp) => _validateOtp(otp),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isOtpValid
                    ? () {
                        print("OTP válido: ${_otpController.text}");
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.pushReplacementNamed(context, '/createAccount');
                        });
                      }
                    : null,
                child: Text('Continuar'),
              ),
            ),
            SizedBox(height: 20),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: _recoverOtp,
                child: Text('Recuperar Código OTP'),
              ),
            ),

            Center(
              child: TextButton(
                onPressed: _changePhone,
                child: Text('Cambiar teléfono'),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: _retry,
                child: Text('Volver a Intentar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}