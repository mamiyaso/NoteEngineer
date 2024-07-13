import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;

  Future<void> _changePassword() async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    void _showSnackbar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: themeProvider.accentColor,
        ),
      );
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackbar('Girilen parolalar uyuşmuyor!');
      return;
    }

    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      _showSnackbar('Kullanıcı oturumu bulunamadı!');
      return;
    }

    try {
      await _supabaseClient.auth.updateUser(UserAttributes(
        password: _newPasswordController.text,
      ));
      _showSnackbar('Parola başarıyla değiştirildi!');
      Navigator.pushReplacementNamed(context, '/settings');
    } on AuthException catch (e) {
      if (e.message.contains('Invalid old password')) {
        _showSnackbar('Geçersiz eski parola!');
      } else {
        _showSnackbar('Parola değiştirilirken bir hata oluştu. Lütfen daha sonra tekrar deneyin.');
      }
    } catch (e) {
      _showSnackbar('Hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('Parola Değiştir', style: TextStyle(color: themeProvider.textColor)),
        backgroundColor: themeProvider.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(labelText: 'Eski Parola', labelStyle: TextStyle(color: themeProvider.textColor)),
              obscureText: true,
              style: TextStyle(color: themeProvider.textColor),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(labelText: 'Yeni Parola', labelStyle: TextStyle(color: themeProvider.textColor)),
              obscureText: true,
              style: TextStyle(color: themeProvider.textColor),
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(labelText: 'Yeni Parola (Tekrar)', labelStyle: TextStyle(color: themeProvider.textColor)),
              obscureText: true,
              style: TextStyle(color: themeProvider.textColor),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.accentColor,
                foregroundColor: themeProvider.textColor,
              ),
              child: const Text('Parolayı Değiştir'),
            ),
          ],
        ),
      ),
    );
  }
}