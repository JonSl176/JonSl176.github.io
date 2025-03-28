import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  String _statusMessage = '';
  Color _statusColor = Colors.transparent;

  int _attempts = 0;
  int _lockDuration = 30;
  bool _isLocked = false;
  late Timer _lockTimer;

  void _login() {
    if (_isLocked) {
      setState(() {
        _statusMessage = 'Tentativas excedidas. Tente novamente em $_lockDuration segundos.';
        _statusColor = Colors.orange;
      });
      return;
    }

    String enteredPassword = _passwordController.text;

    if (enteredPassword == '41376mae') {
      setState(() {
        _statusMessage = 'Acesso Permitido';
        _statusColor = Colors.green;
      });

      // Espera 4 segundos antes de redirecionar para a tela principal
      Timer(Duration(seconds: 4), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DesktopScreen()),
        );
      });

      _attempts = 0; // Reset de tentativas após login bem-sucedido
    } else {
      setState(() {
        _statusMessage = 'Acesso Negado';
        _statusColor = Colors.red;
      });

      _attempts++;
      if (_attempts >= 3) {
        _startLockTimer();
      }
    }
  }

  void _startLockTimer() {
    setState(() {
      _isLocked = true;
      _lockDuration = 30 + _attempts * 60; // Aumenta o tempo de bloqueio a cada 3 tentativas
      if (_lockDuration > 360) {
        _lockDuration = 360; // Limita o tempo de bloqueio a 6 minutos
      }
    });

    _lockTimer = Timer(Duration(seconds: _lockDuration), () {
      setState(() {
        _isLocked = false;
        _statusMessage = '';
        _statusColor = Colors.transparent;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Digite a senha:',
              style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontFamily: 'RobotoMono'),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(color: Colors.greenAccent, fontFamily: 'RobotoMono'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black,
                  border: OutlineInputBorder(),
                ),
                enabled: !_isLocked,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Entrar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(color: _statusColor, fontSize: 18, fontFamily: 'RobotoMono'),
            ),
          ],
        ),
      ),
    );
  }
}

class DesktopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 1.5,  // Ajustando a relação do tamanho dos ícones
          crossAxisSpacing: 15,  // Ajustando o espaço entre os ícones
          mainAxisSpacing: 15,  // Ajustando o espaço entre as linhas
          children: [
            _buildIcon('Pastas', Icons.folder),
            _buildIcon('Configurações', Icons.settings),
            _buildIcon('Usuário', Icons.person),
            _buildIcon('Arquivos', Icons.insert_drive_file),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String label, IconData icon) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 50, color: Colors.greenAccent),
        SizedBox(height: 10),
        Text(label, style: TextStyle(color: Colors.greenAccent, fontSize: 16, fontFamily: 'RobotoMono')),
      ],
    );
  }
}
