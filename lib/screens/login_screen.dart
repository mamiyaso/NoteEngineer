import 'package:flutter/material.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() async {
    final session = _supabaseClient.auth.currentSession;
    if (session != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      _handleSignInResponse(response);
    } on AuthException catch (e) {
      if (e.message.contains('Invalid login credentials')) {
        _showError('loginScreen.invalidEmailOrPassword'.tr());
      } else if (e.message.contains('User not found')) {
        _showError('loginScreen.userNotFound'.tr());
      } else {
        _showError('loginScreen.loginFailed'.tr());
      }
      setState(() {
        _isLogin = false;
      });
    } catch (e) {
      _showError('Error: $e');
    }
  }

  void _handleSignInResponse(response) {
    if (!mounted) return;
    if (response.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      _showError('loginScreen.registrationFailed'.tr());
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: themeProvider.accentColor,
      ),
    );
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      _showError('loginScreen.passwordsNotMatch'.tr());
      return;
    }

    try {
      final response = await _supabaseClient.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user != null) {
        _showMessage('loginScreen.registrationSuccessful'.tr());
        setState(() {
          _isLogin = true;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        _showError('loginScreen.registrationFailed'.tr());
      }
    } catch (e) {
      _showError('Error: $e');
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          _isLogin ? 'loginScreen.login'.tr() : 'loginScreen.signUp'.tr(),
          style: TextStyle(color: themeProvider.textColor),
        ),
        backgroundColor: themeProvider.accentColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'loginScreen.email'.tr(),
                labelStyle: TextStyle(color: themeProvider.textColor),
              ),
              style: TextStyle(color: themeProvider.textColor),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'loginScreen.password'.tr(),
                labelStyle: TextStyle(color: themeProvider.textColor),
              ),
              obscureText: true,
              style: TextStyle(color: themeProvider.textColor),
            ),
            if (!_isLogin)
              TextField(
                controller: _passwordConfirmController,
                decoration: InputDecoration(
                  labelText: 'loginScreen.passwordConfirmation'.tr(),
                  labelStyle: TextStyle(color: themeProvider.textColor),
                ),
                obscureText: true,
                style: TextStyle(color: themeProvider.textColor),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLogin ? _signIn : _signUp,
              style: ElevatedButton.styleFrom(
                backgroundColor: themeProvider.accentColor,
                foregroundColor: themeProvider.textColor,
              ),
              child: Text(_isLogin
                  ? 'loginScreen.login'.tr()
                  : 'loginScreen.signUp'.tr()
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin
                    ? 'loginScreen.noAccount'.tr()
                    : 'loginScreen.haveAccount'.tr(),
                style: TextStyle(color: themeProvider.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
