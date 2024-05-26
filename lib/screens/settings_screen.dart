import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
      ),
      body: ListView(
        children: [
          const ListTile(
            title: Text('Hesap Ayarları'),
          ),
          ListTile(
            title: const Text('Parolayı Değiştir'),
            trailing: const Icon(Icons.lock),
            onTap: () {
              Navigator.pushNamed(context, '/reset_password');
            },
          ),
          ListTile(
            title: const Text('Çıkış Yap'),
            trailing: const Icon(Icons.logout),
            onTap: () {
              Supabase.instance.client.auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Çöp Kutusu'),
          ),
          ListTile(
            title: const Text('Silinen Notlar'),
            trailing: const Icon(Icons.restore_from_trash),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/deleted_notes');
            },
          ),
          const Divider(),
          const ListTile(
            title: Text('Dosya Kaydetme Konumu'),
          ),
          ListTile(
            title: Text(
              _selectedDirectory != null ? _selectedDirectory! : 'Seçilmedi',
            ),
            trailing: const Icon(Icons.folder),
            onTap: _selectDirectory,
          ),
        ],
      ),
    );
  }
}
