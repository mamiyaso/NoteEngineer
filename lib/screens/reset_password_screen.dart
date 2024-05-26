import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Girilen parolalar uyuşmuyor!')));
      return;
    }

    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Kullanıcı oturumu bulunamadı!')));
      return;
    }

    try {
      final UserResponse res = await _supabaseClient.auth.updateUser(
        UserAttributes(
          email: user.email,
          password: _newPasswordController.text,
        ),
      );

      if (res != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Parola başarıyla değiştirildi!')));
        Navigator.pushReplacementNamed(context, '/settings');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: ${res}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Hata: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parola Değiştir'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: 'Eski Parola'),
              obscureText: true,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Yeni Parola'),
              obscureText: true,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Yeni Parola (Tekrar)'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              child: Text('Parolayı Değiştir'),
            ),
          ],
        ),
      ),
    );
  }
}
