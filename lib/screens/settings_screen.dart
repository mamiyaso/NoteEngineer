import 'package:flutter/material.dart';
import 'package:note_engineer/screens/theme_settings_screen.dart';
import 'package:note_engineer/theme_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  String? _selectedDirectory;

  @override
  void initState() {
    super.initState();
    _loadSelectedDirectory();
  }

  Future<void> _loadSelectedDirectory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedDirectory = prefs.getString('selected_directory');
    });
  }

  Future<void> _selectDirectory() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    if (selectedDirectory != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_directory', selectedDirectory);
      setState(() {
        _selectedDirectory = selectedDirectory;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.backgroundColor,
      appBar: AppBar(
        title: Text('Ayarlar', style: TextStyle(color: themeProvider.textColor)),
        backgroundColor: themeProvider.accentColor,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Hesap Ayarları', style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text('Parolayı Değiştir', style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.lock, color: themeProvider.accentColor),
            onTap: () {
              Navigator.pushNamed(context, '/reset_password');
            },
          ),
          ListTile(
            title: Text('Çıkış Yap', style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.logout, color: themeProvider.accentColor),
            onTap: () {
              Supabase.instance.client.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const Divider(),
          ListTile(
            title: Text('Çöp Kutusu', style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text('Silinen Notlar', style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.restore_from_trash, color: themeProvider.accentColor),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/deleted_notes');
            },
          ),
          const Divider(),
          ListTile(
            title: Text('Dosya Kaydetme Konumu', style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text(
              _selectedDirectory != null ? _selectedDirectory! : 'Seçilmedi',
              style: TextStyle(color: themeProvider.textColor),
            ),
            trailing: Icon(Icons.folder, color: themeProvider.accentColor),
            onTap: _selectDirectory,
          ),
          const Divider(),
          ListTile(
            title: Text('Tema Ayarları', style: TextStyle(color: themeProvider.textColor)),
          ),
          ListTile(
            title: Text('Tema Seç', style: TextStyle(color: themeProvider.textColor)),
            trailing: Icon(Icons.color_lens, color: themeProvider.accentColor),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ThemeSettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}