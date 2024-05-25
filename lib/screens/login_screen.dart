import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _supabaseClient = Supabase.instance.client;

  Future<void> _signIn() async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  Future<void> _signUp() async {
    final response = await _supabaseClient.auth.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response.user != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Kayıt başarılı! Lütfen giriş yapın.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Giriş Yap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Giriş Yap'),
            ),
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
