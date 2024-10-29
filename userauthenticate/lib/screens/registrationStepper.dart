import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'createAccount.dart';

class RegistrationStepper extends StatefulWidget {
  @override
  _RegistrationStepperState createState() => _RegistrationStepperState();
}

class _RegistrationStepperState extends State<RegistrationStepper> {
  int _currentStep = 0;
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _otp = '';
  String _sentOtp = ''; 
  final Random _random = Random();
  bool _isPhoneValid = false;

  @override
  void initState() {
    super.initState();
    
    _dniController.addListener(() {
      setState(() {}); 
    });

     _phoneController.addListener(() {
      setState(() {
        _isPhoneValid = _phoneController.text.length == 11; 
      });
    });
  }

  bool _isDniValid() {
    final dniDigitsOnly = _dniController.text.replaceAll(RegExp(r'\D'), '');
    return dniDigitsOnly.length == 8;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Container(
        height: MediaQuery.of(context).size.height,
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
        child: Stepper(
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          onStepContinue: () {
            if (_currentStep < 2) {
              setState(() => _currentStep++);
            } else {
              _validateOtp();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          steps: _getSteps(),
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            return Row(
              children: <Widget>[
                Spacer(),
                TextButton(
                  onPressed: _isDniValid() ? controls.onStepContinue : null,
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFF4A90E2),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Continuar'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Ingreso de DNI',
            style: TextStyle(color: const Color.fromARGB(255, 7, 24, 93)),
          ),
        ),
          content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _dniController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, 
              LengthLimitingTextInputFormatter(8), 
              _DniInputFormatter(), 
            ],
            decoration: InputDecoration(
              labelText: 'Ingrese su DNI',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(15),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
      ),
      Step(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Ingreso de Celular',
            style: TextStyle(color: const Color.fromARGB(255, 7, 24, 93)),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Ingrese su Celular',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(15),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10), 
      ],
          ),
        ),
        isActive: _currentStep >= 1,
        state: _currentStep >= 1 ? StepState.complete : StepState.disabled,
      ),
      Step(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.8),
          child: Text(
            'Validación',
            style: TextStyle(color: const Color.fromARGB(255, 7, 24, 93)),
          ),
        ),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Ingrese el código',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(15),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) => _otp = value,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 122, 74, 226),
                  foregroundColor: Colors.white,
                ),
                child: Text('Enviar Código'),
              ),
            )
          ],
        ),
        isActive: _currentStep >= 2,
        state: _currentStep >= 2 ? StepState.complete : StepState.disabled,
      ),
    ];
  }

  void _sendOtp() {
    _sentOtp = (_random.nextInt(9000) + 1000).toString();
    
    print('OTP enviado a ${_phoneController.text}: $_sentOtp');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP enviado a ${_phoneController.text}')),
    );
  }

  void _validateOtp() {
    if (_otp == _sentOtp) {
      print('OTP válido');
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CreateAccountScreen()),
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP válido. Registro completado.')),
      );
    } else {
      print('OTP inválido');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP inválido. Intenta nuevamente.')),
      );
    }
  }
}

class _DniInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    String formattedDni = '';
    if (digitsOnly.length > 2) {
      formattedDni = '${digitsOnly.substring(0, 2)}.';
      if (digitsOnly.length > 5) {
        formattedDni += '${digitsOnly.substring(2, 5)}.';
        formattedDni += digitsOnly.substring(5); 
      } else {
        formattedDni += digitsOnly.substring(2);
      }
    } else {
      formattedDni = digitsOnly;
    }
    
    return TextEditingValue(
      text: formattedDni,
      selection: TextSelection.collapsed(offset: formattedDni.length),
    );
  }
}
