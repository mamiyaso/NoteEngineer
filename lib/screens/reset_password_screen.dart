import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

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

    void _showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: themeProvider.accentColor,
        ),
      );
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showSnackBar('resetPasswordScreen.passwordsDoNotMatch'.tr());
      return;
    }

    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      _showSnackBar('resetPasswordScreen.userSessionNotFound'.tr());
      return;
    }

    try {
      await _supabaseClient.auth.updateUser(UserAttributes(
        password: _newPasswordController.text,
      ));
      _showSnackBar('resetPasswordScreen.passwordChangedSuccessfully'.tr());
      Navigator.pushReplacementNamed(context, '/settings');
    } on AuthException catch (e) {
      if (e.message.contains('Invalid old password')) {
        _showSnackBar('resetPasswordScreen.invalidOldPassword'.tr());
      } else {
        _showSnackBar('resetPasswordScreen.errorChangingPassword'.tr());
      }
    } catch (e) {
      _showSnackBar('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('resetPasswordScreen.title'.tr(),
            style: TextStyle(color: themeProvider.textColor)
        ),
        backgroundColor: themeProvider.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _oldPasswordController,
              decoration: InputDecoration(
                  labelText: 'resetPasswordScreen.oldPassword'.tr(),
                  labelStyle: TextStyle(color: themeProvider.textColor)
              ),
              obscureText: true,
              style: TextStyle(color: themeProvider.textColor),
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                  labelText: 'resetPasswordScreen.newPassword'.tr(),
                  labelStyle: TextStyle(color: themeProvider.textColor)
              ),
              obscureText: true,
              style: TextStyle(color: themeProvider.textColor),
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                  labelText: 'resetPasswordScreen.confirmPassword'.tr(),
                  labelStyle: TextStyle(color: themeProvider.textColor)
              ),
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
              child: Text('resetPasswordScreen.changePassword'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}