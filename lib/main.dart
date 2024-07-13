import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:note_engineer/screens/deleted_notes_screen.dart';
import 'package:note_engineer/screens/home_screen.dart';
import 'package:note_engineer/screens/note_edit_screen.dart';
import 'package:note_engineer/screens/settings_screen.dart';
import 'package:note_engineer/screens/reset_password_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  await initializeDateFormatting('tr_TR', null);

  runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Note Engineer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthCheck(),
        '/home': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/login': (context) => const LoginScreen(),
        '/deleted_notes': (context) => const DeletedNotesScreen(),
        '/note_edit': (context) => NoteEditScreen(onSave: (){}),
        '/reset_password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    final session = Supabase.instance.client.auth.currentSession;
    if (session != null) {
      return const HomeScreen();
    } else {
      return const LoginScreen();
    }
  }
}