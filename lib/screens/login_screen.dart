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
  bool _isLoading = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final session = _supabaseClient.auth.currentSession;
    if (session != null) {
      final user = await _supabaseClient.auth.getUser();
      if (user.user != null && user.user!.emailConfirmedAt != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        await _supabaseClient.auth.signOut();
        _showError('loginScreen.emailNotVerified'.tr());
      }
    }
  }

  Future<void> _signIn() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user != null) {
        if (response.user!.emailConfirmedAt != null) {
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          await _supabaseClient.auth.signOut();
          _showError('loginScreen.emailNotVerified'.tr());
          setState(() => _isVerifying = true);
        }
      }
    } on AuthException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('loginScreen.unexpectedError'.tr());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signUp() async {
    if (_passwordController.text != _passwordConfirmController.text) {
      _showError('loginScreen.passwordsNotMatch'.tr());
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _supabaseClient.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user != null) {
        _showMessage('loginScreen.verificationEmailSent'.tr());
        setState(() => _isVerifying = true);
      } else {
        _showError('loginScreen.registrationFailed'.tr());
      }
    } catch (e) {
      _showError('loginScreen.registrationFailed'.tr() + ': $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resendVerificationEmail() async {
    setState(() => _isLoading = true);
    try {
      await _supabaseClient.auth.resend(
        type: OtpType.signup,
        email: _emailController.text,
      );
      _showMessage('loginScreen.verificationEmailResent'.tr());
    } catch (e) {
      _showError('loginScreen.resendFailed'.tr() + ': $e');
    } finally {
      setState(() => _isLoading = false);
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
        child: _isVerifying ? _buildVerificationForm() : _buildLoginForm(),
      ),
    );
  }

  Widget _buildLoginForm() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
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
          onPressed: _isLoading ? null : (_isLogin ? _signIn : _signUp),
          style: ElevatedButton.styleFrom(
            backgroundColor: themeProvider.accentColor,
            foregroundColor: themeProvider.textColor,
          ),
          child: Text(_isLogin
              ? 'loginScreen.login'.tr()
              : 'loginScreen.signUp'.tr()),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
              _isVerifying = false;
            });
          },
          child: Text(
            _isLogin
                ? 'loginScreen.noAccount'.tr()
                : 'loginScreen.haveAccount'.tr(),
            style: TextStyle(color: themeProvider.accentColor),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/forgot_password');
          },
          child: Text(
            'loginScreen.forgotPassword'.tr(),
            style: TextStyle(color: themeProvider.accentColor),
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationForm() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'loginScreen.checkEmailForVerification'.tr(),
          style: TextStyle(color: themeProvider.textColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _resendVerificationEmail,
          style: ElevatedButton.styleFrom(
            backgroundColor: themeProvider.accentColor,
            foregroundColor: themeProvider.textColor,
          ),
          child: Text('loginScreen.resendVerificationEmail'.tr()),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              _isVerifying = false;
              _isLogin = true;
            });
          },
          child: Text(
            'loginScreen.backToLogin'.tr(),
            style: TextStyle(color: themeProvider.accentColor),
          ),
        ),
      ],
    );
  }
}