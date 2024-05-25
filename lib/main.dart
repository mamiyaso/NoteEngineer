import 'package:flutter/material.dart';
import 'package:note_engineer/screens/deleted_notes_screen.dart';
import 'package:note_engineer/screens/home_screen.dart';
import 'package:note_engineer/screens/note_edit_screen.dart';
import 'package:note_engineer/screens/settings_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note Engineer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/home': (context) => HomeScreen(),
        '/settings': (context) => SettingsScreen(),
        '/login': (context) => LoginScreen(),
        '/deleted_notes': (context) => DeletedNotesScreen(),
        '/note_edit': (context) => NoteEditScreen(onSave: (){} ),
      },
    );
  }
}
