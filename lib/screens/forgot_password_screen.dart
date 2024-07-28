import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    setState(() => _isLoading = true);
    try {
      await _supabaseClient.auth.resetPasswordForEmail(
        _emailController.text,
      );
      _showMessage('forgotPasswordScreen.resetEmailSent'.tr());
    } catch (e) {
      _showError('forgotPasswordScreen.resetFailed'.tr());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeProvider.accentColor,
      ),
    );
  }

  void _showError(String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeProvider.accentColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('forgotPasswordScreen.title'.tr(),
            style: TextStyle(color: themeProvider.textColor)),
        backgroundColor: themeProvider.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'forgotPasswordScreen.email'.tr(),
                labelStyle: TextStyle(color: themeProvider.textColor),
              ),
              style: TextStyle(color: themeProvider.textColor),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.accentColor,
                foregroundColor: themeProvider.textColor,
              ),
              child: Text('forgotPasswordScreen.resetPassword'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}