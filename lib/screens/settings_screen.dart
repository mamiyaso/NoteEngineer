import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
        ],
      ),
    );
  }
}
